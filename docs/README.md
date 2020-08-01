Raspbian is different then Debian for Docker install

https://docs.docker.com/install/linux/docker-ce/debian/

https://docs.docker.com/install/linux/linux-postinstall/

## Debian amd64
```
# Preparation
su -
apt-get install sudo
adduser {username] sudo

apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) \
  stable"

apt-get update
```
```
# Relogin as [username]
```
```
# Uninstall old versions, if they exist
sudo apt-get remove docker docker-engine docker.io containerd runc
```

```
# Install Docker Engine - Community
apt-get install docker-ce docker-ce-cli containerd.io
```

---
```
# Install openHAB

curl -sL "https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/installer.sh" | sudo bash -s --

```
---
         
```
# To clean up
sudo docker stop openhab
sudo userdel -r openhab

# Clean up Docker
sudo docker system prune
```
