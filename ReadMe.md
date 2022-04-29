# Raspberry Pi - Master/Worker Setup

Fist of all, we need to install and configure **Raspbian Linux Operating System** on each node of the future Kubernetes cluster. Our goal is it to build an architecture that looks something like this.

We are adding an SSD because Micro SD cards are not reliable and the bunch of Read/Write Requests from Kubernetes would pretty quick destroy a Micro SD card. We are using a Portable SSD connected to the master node and exposed to the worker via NFS to store the volume data.

![Architecture](/images/architecture.jpeg)

## OS Configuration

We are using Raspberry Pi OS Lite (formerly Raspbian) for all of the RaspberryPi’s. In the RaspberryPi Imager software you can enable SSH and change the hostname, thus you can make the setup without a screen. Make sure you add `arm_64bit=1` to the end of `/boot/config.txt`.

### Setting up a static IP

By default, the router assigns an arbitrary IP address to the device which means it is highly possible that the router will assign a new different IP address after a reboot. To avoid to recheck our router, it is possible to assign a static IP to the machine.

Edit the file `/etc/dhcpcd.conf` and add the four lines below:

```bash
interface eth0
static ip_address=192.168.0.<X>/24
static routers=192.168.0.1
static domain_name_servers=1.1.1.1
```

or this if you are using Wi-fi

```bash
interface wlan0
static ip_address=192.168.0.<X>/24
static routers=192.168.0.1
static domain_name_servers=1.1.1.1
```

### Enable container features

We need to enable *container features* in the kernel in order to run containers.

Edit the file `/boot/cmdline.txt` and add the following properties at the end of the line:

```bash
cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```

## Enabling legacy iptables on Raspberry Pi OS

Raspberry Pi OS defaults to using **`nftables`** instead of **`iptables`**.  **K3S** networking features require **`iptables`** and do not work with **`nftables`**. Follow the steps below to switch configure **Buster** to use **`legacy iptables`**:

```bash
sudo apt-get install -y iptables arptables ebtables
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
```

### Configure the SSD disk share

As explained during the introduction, I made the choice to connect a portable SSD to the Master node and gave access via NFS to each worker.

**====== Master node only - Mount the disk and expose a NFS share ======**

**Find the disk name (drive)**

Run the command `fdisk -l` to list all the connected disks to the system (includes the RAM) and try to identify the SSD. Output:

```bash
Disk /dev/ram0: 4 MiB, 4194304bytes, 8192 sectors
Units: sectors of 1 * 512 = 512bytes
Sector size (logical/physical): 512bytes / 4096bytes
I/O size (minimum/optimal): 4096bytes / 4096bytes
(...)
Disk /dev/sda: 465.76 GiB, 500107862016 bytes, 976773168 sectors
Disk model: PSSD T7
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 33553920 bytes
```

**Create a partition**

If your disk is new and freshly out of the package, you will need to create a partition with `sudo mkfs.ext4 /dev/sda`.

```bash
mke2fs 1.44.5 (15-Dec-2018)
/dev/sda contains a ext4 filesystemlast mountedon /mnt/ssdonMonSep921:06:472019
Proceed anyway? (y,N) y
Creating filesystem with 58609664 4k blocks and 14655488 inodes
Filesystem UUID: 5c3a8481-682c-4834-9814-17dba166f591
Superblock backups storedonblocks:
    32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
    4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks):
done
Writing superblocks and filesystem accounting information: done
```

**Manually mount the disk**

You can manually mount the disk to the directory `/mnt/ssd`.

```bash
sudo mkdir /mnt/ssd
sudo chown -R pi:pi /mnt/ssd/
sudo mount /dev/sda /mnt/ssd
```

**Automatically mount the disk on startup**

Next step consists to configure `fstab` to automatically mount the disk when the system starts.

You first need to find the Unique ID of the disk using the command `blkid`.

```bash
/dev/mmcblk0p1: LABEL_FATBOOT="boot" LABEL="boot" UUID="F021-066F" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="fb9cde7a-01"
/dev/mmcblk0p2: LABEL="rootfs" UUID="99f9cf68-e6fa-4b90-aeee-7fa3e9ed5c2d" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="fb9cde7a-02"
/dev/sda: UUID="4f0ee438-771d-44b9-98b4-a2fe92c49080" BLOCK_SIZE="4096" TYPE="ext4"
```

Our SSD located in `/dev/sda` has a unique ID `4f0ee438-771d-44b9-98b4-a2fe92c49080`.

Edit the file `/etc/fstab` and add the following line to configure auto-mount of the disk on startup. After that reboot the system.

```bash
4f0ee438-771d-44b9-98b4-a2fe92c49080 /mnt/ssd ext4 defaults 0 0
```

You can verify the disk is correctly mounted on startup with the following command: `df -ha /dev/sda`

```bash
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda        458G   73M  435G   1% /mnt/ssd
```

**Share via NFS Server**

We now gonna make the directory `/mnt/ssd` of master accessible to other machines via NFS

**Install the required dependencies**

```bash
sudo apt-getinstall nfs-kernel-server -y
```

**Configure the NFS server**

Edit the file `/etc/exports` and add the following line

```bash
/mnt/ssd *(rw,no_root_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)
```

**Start the NFS Server**

```bash
sudo exportfs -ra
```

**====== Worker nodes only - Mount the NFS share ======**

I**nstall the necessary dependencies**

```bash
sudo apt-get install nfs-common -y
```

**Create the directory to mounty the NFS Share**

Create the directory `/mnt/ssd` and set the ownership to your user

```bash
sudo mkdir /mnt/ssd
sudo chown -R user:user /mnt/ssd/
```

**Configure auto-mount of the NFS Share**

In this step, we will edit `/etc/fstab` to tell the OS to automatically mount the NFS share into the directory `/mnt/ssd` when the machine starts.

Add the following line where `192.168.0.<x>:/mnt/ssd` is the IP of `kube-master` and the NFS share path.

```bash
192.168.0.63:/mnt/ssd   /mnt/ssd   nfs    rw  0  0
```

**Reboot the system**

```bash
sudo reboot
```
