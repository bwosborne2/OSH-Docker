Raspbian is different then Debian for Docker install

https://docs.docker.com/install/linux/docker-ce/debian/

https://docs.docker.com/install/linux/linux-postinstall/

## Debian amd64
`# Uninstall old versions, if they exist`
>sudo apt-get remove docker docker-engine docker.io containerd runc

`# Install Docker Engine - Community`
>curl -fsSL get.docker.com | sh

`# Test Docker`
>sudo docker run hello-world

---
`# Install openHAB
>sudo groupadd -g 9001 -r openhab<br/>
>sudo useradd -d /opt/openhab -u 9001 -g 9001  -m -r -s /sbin/nologin openhab<br/>

>sudo mkdir /opt/openhab/conf<br/>
>sudo mkdir /opt/openhab/userdata<br/>
>sudo mkdir /opt/openhab/addons<br/>
>sudo chown -R openhab:openhab /opt/openhab
