TALOS_VERSION  := v1.12.6
FACTORY_HOST   := factory.talos.dev

RPI5B_SCHEMATIC := schematics/rpi5b.yaml
RPI4B_SCHEMATIC  := schematics/rpi4b.yaml
CM5_SCHEMATIC   := schematics/cm5.yaml
RPI5B_ID_FILE   := .schematic-id-rpi5b
RPI4B_ID_FILE    := .schematic-id-rpi4b
CM5_ID_FILE     := .schematic-id-cm5

.PHONY: all schematics images clean help

all: schematics images

# ── Schematics ──────────────────────────────────────────────────────────────

schematics: $(RPI5B_ID_FILE) $(CM5_ID_FILE) $(RPI4B_ID_FILE)

$(RPI5B_ID_FILE): $(RPI5B_SCHEMATIC)
	@echo "Uploading RPi5B schematic..."
	@curl -sfX POST https://$(FACTORY_HOST)/schematics \
		-H "Content-Type: application/yaml" \
		--data-binary @$< \
	| jq -r .id > $@
	@echo "RPi5B schematic ID: $$(cat $@)"
	@sed -i '' "/talos_image_rp5b/,/default/ s|default.*=.*\".*\"|default     = \"$(FACTORY_HOST)/metal-installer/$$(cat $@):$(TALOS_VERSION)\"|" talos/variables.tf
	@echo "Updated talos/variables.tf with RPi5B image URL"

$(RPI4B_ID_FILE): $(RPI4B_SCHEMATIC)
	@echo "Uploading RPi4B schematic..."
	@curl -sfX POST https://$(FACTORY_HOST)/schematics \
		-H "Content-Type: application/yaml" \
		--data-binary @$< \
	| jq -r .id > $@
	@echo "RPi4B schematic ID: $$(cat $@)"
	@sed -i '' "/talos_image_rpi4b/,/default/ s|default.*=.*\".*\"|default     = \"$(FACTORY_HOST)/metal-installer/$$(cat $@):$(TALOS_VERSION)\"|" talos/variables.tf
	@echo "Updated talos/variables.tf with RPi4B image URL"


$(CM5_ID_FILE): $(CM5_SCHEMATIC)
	@echo "Uploading CM5 schematic..."
	@curl -sfX POST https://$(FACTORY_HOST)/schematics \
		-H "Content-Type: application/yaml" \
		--data-binary @$< \
	| jq -r .id > $@
	@echo "CM5 schematic ID: $$(cat $@)"
	@sed -i '' "/talos_image_cm5/,/default/ s|default.*=.*\".*\"|default     = \"$(FACTORY_HOST)/metal-installer/$$(cat $@):$(TALOS_VERSION)\"|" talos/variables.tf
	@echo "Updated talos/variables.tf with CM5 image URL"

# ── Images ───────────────────────────────────────────────────────────────────

images: images/talos-rpi5b.raw.xz images/talos-cm5.raw.xz images/talos-rpi4b.raw.xz

images/talos-rpi5b.raw.xz: $(RPI5B_ID_FILE)
	@mkdir -p images
	@echo "Downloading RPi5B image ($(TALOS_VERSION))..."
	curl -fL "https://$(FACTORY_HOST)/image/$$(cat $(RPI5B_ID_FILE))/$(TALOS_VERSION)/metal-arm64.raw.xz" \
		-o $@

images/talos-rpi4b.raw.xz: $(RPI4B_ID_FILE)
	@mkdir -p images
	@echo "Downloading RPi4B image ($(TALOS_VERSION))..."
	curl -fL "https://$(FACTORY_HOST)/image/$$(cat $(RPI4B_ID_FILE))/$(TALOS_VERSION)/metal-arm64.raw.xz" \
		-o $@

images/talos-cm5.raw.xz: $(CM5_ID_FILE)
	@mkdir -p images
	@echo "Downloading CM5 image ($(TALOS_VERSION))..."
	curl -fL "https://$(FACTORY_HOST)/image/$$(cat $(CM5_ID_FILE))/$(TALOS_VERSION)/metal-arm64.raw.xz" \
		-o $@

# ── Housekeeping ─────────────────────────────────────────────────────────────

clean:
	rm -f .schematic-id-*
	rm -rf images/

help:
	@echo "Targets:"
	@echo "  all         Upload schematics, download images"
	@echo "  schematics  Upload schematics to factory.talos.dev and save IDs"
	@echo "  images      Download metal-arm64 raw images for each node type"
	@echo "  clean       Remove downloaded images and schematic ID files"
