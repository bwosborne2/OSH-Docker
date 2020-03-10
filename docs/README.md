Raspbian is different then Debian for Docker install

https://docs.docker.com/install/linux/docker-ce/debian/

https://docs.docker.com/install/linux/linux-postinstall/

## Debian amd64
`# Uninstall old versions, if they exist`
>sudo apt-get remove docker docker-engine docker.io containerd runc

`# Set up repo`
>sudo apt-get update<br/>
>sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common<br/>
>curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - <br/>
>sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

`# Install Docker Engine - Community`
>sudo apt-get update<br/>
>sudo apt-get install docker-ce docker-ce-cli containerd.io

`# Test Docker`
>sudo docker run hello-world
