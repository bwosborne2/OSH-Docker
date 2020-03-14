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

sudo groupadd -g 9001 -r openhab
sudo useradd -d /opt/openhab -u 9001 -g 9001  -m -r -s /sbin/nologin openhab

sudo mkdir /opt/openhab/conf
sudo mkdir /opt/openhab/userdata
sudo mkdir /opt/openhab/addons
sudo chown -R openhab:openhab /opt/openhab
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
