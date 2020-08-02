#!/usr/bin/env bash
SCRIPT_VERSION=.0.0.2

VERSION=2.5.7

userCheck() {
    echo -e "openHAB User Check"
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

    CONFIG=/opt/openhab/docker/.env
    
    echo -e "In dockerConfig"
    # Write configuration
    cat > "$CONFIG" <<- EOF
# OpenHAB service environment
USER_ID=${ID}
GROUP_ID=${GR}
OPENHAB_HTTP_PORT=8080
OPENHAB_HTTPS_PORT=8443
EOF
    #!/usr/bin/env bash
    SCRIPT=/opt/openhab/docker/oh-start.sh
    echo -e "Writing the startup script"
    cat > "$SCRIPT" <<- EOF
docker run \
--name openhab \
-p 8080:8080 \
-p 8443:8443 \
-v /etc/localtime:/etc/localtine:ro \
-v /opt/openhab/addons:/openhab/addons \
-v /opt/openhab/conf:/openhab/conf \
-v /opt/openhab/userdata:/openhab/userdata \
--env-file /opt/openhab/docker/.env \
-d \
--restart=always \
openhab/openhab:$VERSION
EOF
    # Make the script executable
    chmod +x "$SCRIPT"

}

dockerService() {
    echo Downloading and Starting OpenHAB
    /opt/openhab/docker/oh-start.sh
}

userCheck
dataDirs
dockerConfig
dockerService
