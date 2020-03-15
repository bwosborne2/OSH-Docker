Raspbian is different then Debian for Docker install

https://docs.docker.com/install/linux/docker-ce/debian/

https://docs.docker.com/install/linux/linux-postinstall/

## Debian amd64
```
# Uninstall old versions, if they exist
sudo apt-get remove docker docker-engine docker.io containerd runc
```

```
# Install Docker Engine - Community
curl -fsSL get.docker.com | sh
```

```
# Test Docker
sudo docker run hello-world
```

---
```
# Install openHAB


curl -sL "https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/installer.sh" | sudo bash -s --
```

```
sudo docker run \
            --name openhab \
            --net=host \
            -v /etc/localtime:/etc/localtime:ro \
            -v /etc/timezone:/etc/timezone:ro \
            -v /opt/openhab/conf:/openhab/conf \
            -v /opt/openhab/userdata:/openhab/userdata \
            -v /opt/openhab/addons:/openhab/addons \
            -d \
            --restart=always \
            openhab/openhab:latest
```            
```
# Commands
sudo docker stop openhab
sudo docker rm openhab
```
