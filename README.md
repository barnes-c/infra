# Cluster

setting up cluster:
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none --disable-network-policy" sh -

sudo fdisk /dev/sda

Command (m for help): o
Created a new DOS (MBR) disklabel with disk identifier 0x7debbbc9.
The device contains 'gpt' signature and it will be removed by a write command. See fdisk(8) man page and --wipe option for more details.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-976773167, default 2048): +50G
Value out of range.
First sector (2048-976773167, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-976773167, default 976773167): +50G

Created a new partition 1 of type 'Linux' and of size 50 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 
First sector (104859648-976773167, default 104859648): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (104859648-976773167, default 976773167): 

Created a new partition 2 of type 'Linux' and of size 415.8 GiB.

Command (m for help): p
Disk /dev/sda: 465.76 GiB, 500107862016 bytes, 976773168 sectors
Disk model: PSSD T7         
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 33553920 bytes
Disklabel type: dos
Disk identifier: 0x7debbbc9

Device     Boot     Start       End   Sectors   Size Id Type
/dev/sda1            2048 104859647 104857600    50G 83 Linux
/dev/sda2       104859648 976773167 871913520 415.8G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

barnes-c@homelab:/cluster$ lsblk -f
NAME        FSTYPE   FSVER LABEL       UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
loop0       squashfs 4.0                                                          0   100% /snap/snapd/23772
loop1       squashfs 4.0                                                          0   100% /snap/snapd/24787
sda                                                                                        
├─sda1                                                                                     
└─sda2                                                                                     
mmcblk0                                                                                    
├─mmcblk0p1 vfat     FAT32 system-boot 353E-40F2                             303.2M    40% /boot/firmware
└─mmcblk0p2 ext4     1.0   writable    72b08594-54cf-424a-9626-dfad1c5b7290   52.1G     6% /
barnes-c@homelab:/cluster$ sudo mkfs.ext4 /dev/sda1
mke2fs 1.47.2 (1-Jan-2025)
Creating filesystem with 13107200 4k blocks and 3276800 inodes
Filesystem UUID: 79c282d3-0f5a-4dcf-a2f0-a4fe412b5c09
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
        4096000, 7962624, 11239424

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (65536 blocks): done
Writing superblocks and filesystem accounting information: done   

barnes-c@homelab:/cluster$ sudo mkfs.ext4 /dev/sda2
mke2fs 1.47.2 (1-Jan-2025)
Creating filesystem with 108989190 4k blocks and 27254784 inodes
Filesystem UUID: 0a6a8eb0-9119-4ca0-a7f8-567229674db0
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
        102400000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (262144 blocks): 
done
Writing superblocks and filesystem accounting information: done     

barnes-c@homelab:/cluster$ sudo mkdir -p /mnt/k3s
barnes-c@homelab:/cluster$ sudo mkdir -p /mnt/longhorn
barnes-c@homelab:/cluster$ sudo mount /dev/sda1 /mnt/k3s
barnes-c@homelab:/cluster$ sudo mount /dev/sda2 /mnt/longhorn
barnes-c@homelab:/cluster$ df -h /mnt/k3s
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        49G  2.1M   47G   1% /mnt/k3s
barnes-c@homelab:/cluster$ df -h /mnt/longhorn
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       409G  2.1M  388G   1% /mnt/longhorn

barnes-c@homelab:/cluster$ sudo mount --bind /mnt/k3s/rancher /var/lib/rancher
sudo mount --bind /mnt/k3s/kubelet /var/lib/kubelet
barnes-c@homelab:/cluster$ sudo vim /etc/fstab 
barnes-c@homelab:/cluster$ sudo vim /etc/fstab 
barnes-c@homelab:/cluster$ sudo mount -a
barnes-c@homelab:/cluster$ df -h | grep -E 'rancher|kubelet|k3s|longhorn'
/dev/sda1        49G  224M   47G   1% /mnt/k3s
/dev/sda2       409G  2.1M  388G   1% /mnt/longhorn

## TODOkube

SELEAD SECRETS

### Ansible
Create ansible playbooks to bootstrap cluster, mount nvem's, install packages such as wireguard-tools

### Minecraft
figure out how to spread server across nodes


kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.30.0/controller.yaml
sudo apt install wireguard-tools


curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.30.0/kubeseal-0.30.0-linux-arm64.tar.gz"
tar -xvzf kubeseal-0.30.0-linux-arm64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal