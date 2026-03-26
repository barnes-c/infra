TALOS_VERSION   := v1.12.6
FACTORY_URL     := https://factory.talos.dev

RPI5B_SCHEMATIC := schematics/rpi5b.yaml
CM5_SCHEMATIC   := schematics/cm5.yaml
RPI5B_ID_FILE   := .schematic-id-rpi5b
CM5_ID_FILE     := .schematic-id-cm5

.PHONY: all schematics images clean help

all: schematics images

# ── Schematics ──────────────────────────────────────────────────────────────

schematics: $(RPI5B_ID_FILE) $(CM5_ID_FILE)

$(RPI5B_ID_FILE): $(RPI5B_SCHEMATIC)
	@echo "Uploading RPi5B schematic..."
	@curl -sfX POST $(FACTORY_URL)/schematics \
		-H "Content-Type: application/yaml" \
		--data-binary @$< \
	| jq -r .id > $@
	@echo "RPi5B schematic ID: $$(cat $@)"

$(CM5_ID_FILE): $(CM5_SCHEMATIC)
	@echo "Uploading CM5 schematic..."
	@curl -sfX POST $(FACTORY_URL)/schematics \
		-H "Content-Type: application/yaml" \
		--data-binary @$< \
	| jq -r .id > $@
	@echo "CM5 schematic ID: $$(cat $@)"

# ── Images ───────────────────────────────────────────────────────────────────

images: images/talos-rpi5b.raw.xz images/talos-cm5.raw.xz

images/talos-rpi5b.raw.xz: $(RPI5B_ID_FILE)
	@mkdir -p images
	@echo "Downloading RPi5B image ($(TALOS_VERSION))..."
	curl -fL "$(FACTORY_URL)/image/$$(cat $(RPI5B_ID_FILE))/$(TALOS_VERSION)/metal-arm64.raw.xz" \
		-o $@

images/talos-cm5.raw.xz: $(CM5_ID_FILE)
	@mkdir -p images
	@echo "Downloading CM5 image ($(TALOS_VERSION))..."
	curl -fL "$(FACTORY_URL)/image/$$(cat $(CM5_ID_FILE))/$(TALOS_VERSION)/metal-arm64.raw.xz" \
		-o $@

# ── Housekeeping ─────────────────────────────────────────────────────────────

clean:
	rm -f $(RPI5B_ID_FILE) $(CM5_ID_FILE)
	rm -rf images/

help:
	@echo "Targets:"
	@echo "  all         Upload schematics, download images"
	@echo "  schematics  Upload schematics to factory.talos.dev and save IDs"
	@echo "  images      Download metal-arm64 raw images for each node type"
	@echo "  clean       Remove downloaded images and schematic ID files"
