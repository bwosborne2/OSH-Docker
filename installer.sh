#!/usr/bin/env bash
SCRIPT_VERSION=.0.0.4

VERSION=3.0.0-snapshot

userCheck() {
    echo -e "openHAB User Check"
    if getent passwd | cut -d: -f1 | grep openhab > /dev/null 2>&1;  then
        echo -e "User openhab already exists"
        select choice in "Use existing user"  "Delete existing user & home directory" "Exit"; do
            case $choice in
                "Delete existing user & home directory" ) userDel; break;;
                "Use existing user" ) userId; break;;
                "Exit" ) exit; break;;
            esac
        done
    else
        userAdd
    fi
}

userDel() {
    userdel -rf openhab > /dev/null 2>&1
    userAdd
}

userAdd() {
    sudo useradd -d /opt/openhab -m -r -s /sbin/nologin openhab
    userId

}

userId () {
    ID=`id -u openhab`
    GR=`id -g openhab`
}

dataDirs() {
    echo -e "Data Directory Setup"
    if [ -d /opt/openhab/conf ]
      then
        echo -e "Directories already exist"
      else
        mkdir /opt/openhab/conf
        mkdir /opt/openhab/userdata
        mkdir /opt/openhab/addons
        mkdir /opt/openhab/docker
        chown -R openhab:openhab /opt/openhab
    fi

}

dockerConfig() {

    CONFIG=/opt/openhab/docker/.env
    TIMEZONE = `readlink /etc/localtime | awk -F/ '{print $5"/"$6}'`
    
    echo -e "In dockerConfig"
    # Write configuration
    cat > "$CONFIG" <<- EOF
# OpenHAB service environment
USER_ID=${ID}
GROUP_ID=${GR}
OPENHAB_HTTP_PORT=8080
OPENHAB_HTTPS_PORT=8443
EXTRA_JAVA_OPTS=-Duser.timezone=TIMEZONE
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
--privileged \
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
