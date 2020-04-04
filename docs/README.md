Raspbian is different then Debian for Docker install

https://docs.docker.com/install/linux/docker-ce/debian/

https://docs.docker.com/install/linux/linux-postinstall/

## Debian amd64
```
# Preparation
su -
apt-get install sudo curl

# Uninstall old versions, if they exist
sudo apt-get remove docker docker-engine docker.io containerd runc
```

```
# Install Docker Engine - Community
curl -fsSL get.docker.com | sudo sh
```

```
# Install Docker Compose
sudo apt-get install -y docker-compose
```

---
```
# Install openHAB

curl -sL "https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/installer.sh" | sudo bash -s --

```

         
```
# Commands
sudo systemctl status openhab
sudo systemctl stop openhab
```

```
# To clean up
sudo systemctl stop openhab
sudo systemctl disable openhab
sudo rm /etc/systemd/system/openhab.service

sudo userdel -r openhab
```
