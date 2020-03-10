# Raspberrypi setup

- [Add exFat reading capabilities](https://pimylifeup.com/raspberry-pi-exfat/)
- [Add support to samba server](https://pimylifeup.com/raspberry-pi-samba/)
    - Add entry for every single mounted drive
- [Setting AFP](https://pimylifeup.com/raspberry-pi-afp/)
- Plex
  - [Setup Plex for pi4](https://pimylifeup.com/raspberry-pi-plex-server/)
  - [Setup permission issues 1](https://www.clarkle.com/notes/install-plex-raspberry-pi/)
  - [Setup permission issues 2](https://forums.plex.tv/t/using-ext-ntfs-or-other-format-drives-internal-or-external-on-linux/198544)
  - use `plex user`

> Because Linux is very strict about permissions, being the multi-user system it is, it assumes these unclaimed devices are temporary so mounts them and grants exclusive access to your username only. 

> The moment we log in, it asserunmaintanablets this exclusive-lock as it mounts the drives, leaving user **plex** locked out. No amount of permissions values will allow Plex to see the contents. 

> To work through this security, we must properly manage the media devices by mounting them in a location where Plex can have access

```bash
# Plex setup
# Identify the disk(s) you want to add in the graphical disk manager
> df

# Once identified the disk name run blkid to extract the information needed
> sudo blkid /dev/sdb2
# /dev/sdb2: LABEL="Media" UUID="5DE2-BDCA" TYPE="exfat" PARTUUID="153700ac-00ef-44d3-9f86-e03d8c0bf744"

# create directory where you'll mount the SSD and change ownership
> mkdir home/pi/Plex
> sudo chown -R plex:plex Plex/media

# mount the drive
> sudo mount /dev/sdb2 home/pi/Plex

# create an entry to mount the drive every time the system reboots
> sudo vi /etc/fstab
> /dev/sdb2 /home/pi/Plex exfat defaults 0 0

# add entry to samba config so the drive can be found
> sudo nano /etc/samba/smb.conf

# [Plex media]
# Comment = Plex media folder
# Path = /home/pi/Plex
# Browseable = yes
# Writeable = Yes
# only guest = no
# create mask = 0777
# directory mask = 0777
# Public = yes
# Guest ok = yes

> sudo systemctl restart smbd
> sudo reboot
```

| ![](./df.jpeg) |
|:--:|
| *df output* |

| ![](./lsblk.jpeg) |
|:--:|
| *df alternative with nicer output* |
| *sudo lsblk -o UUID,NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL,MODEL* |
