#!/usr/bin/env bash
SCRIPT_VERSION=.0.0.1

URL_OPENHAB="https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/files/openHAB"
URL_CONFIG="https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/files/install.conf"
URL_SERVICE_OPENHAB="https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/files/openhab.service"

userCheck() {
    sudo useradd -d /opt/openhab -m -r -s /sbin/nologin openhab
    ID=`id -u openhab`
    GR=`id -g openhab`
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

    CONFIG=/opt/openhab/docker/install.conf

    echo -e "In dockerConfig"
# Write configuration
cat > "$CONFIG" <<- EOF
{
    "USER_ID": "${ID}",
    "GROUP_ID": "${GR}",
    "ARCH": "N/A",
    "OH_VERSION": "2.5.3"

}
EOF
}

dockerService() {
    echo "[Info] Install openHAB startup scripts"
    curl -sL ${URL_OPENHAB} > /opt/openhab/docker/openHAB
    chmod +x /opt/openhab/docker/openHAB
    curl -sL ${URL_SERVICE_OPENHAB} > /etc/systemd/system/openhab.service

    systemctl daemon-reload
    systemctl enable openhab.service
}

userCheck
dataDirs
dockerConfig
dockerService
systemctl start openhab
systemctl daemon-reload

