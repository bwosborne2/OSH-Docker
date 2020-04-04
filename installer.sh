#!/usr/bin/env bash
SCRIPT_VERSION=.0.0.2

# Local Paths
URL_DOCKER_COMPOSE="https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/files/docker-compose.yml"
URL_SERVICE_OPENHAB="https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/files/openhab.service"

userCheck() {
    sudo useradd -d /opt/openhab -m -r -s /sbin/nologin openhab
    ID=`id -u openhab`
    GR=`id -g openhab`
    AR=`dpkg --print-architecture`
}

dataDirs() {
    echo -e "Data Directory Setup"
    sudo mkdir /opt/openhab/conf
    sudo mkdir /opt/openhab/userdata
    sudo mkdir /opt/openhab/addons
    sudo mkdir /opt/openhab/docker
    sudo chown -R openhab:openhab /opt/openhab

}

dockerConfig() {

    CONFIG=/opt/openhab/docker/.env
    
    echo -e "In dockerConfig"
# Write configuration
cat > "$CONFIG" <<- EOF
# OpenHAB service environment
USER_ID=${ID}
GROUP_ID=${GR}
OH_VERSION=2.5.3
ARCH=${AR}
EOF
}

dockerService() {
    echo "[Info] Install openHAB startup scripts"
    curl -sL  ${URL_DOCKER_COMPOSE} > /opt/openhab/docker/docker-compose.yml
    curl -sL  ${URL_SERVICE_OPENHAB} > /etc/systemd/system/openhab.service

    systemctl daemon-reload
    systemctl enable openhab.service
}

userCheck
dataDirs
dockerConfig
dockerService
systemctl start openhab
