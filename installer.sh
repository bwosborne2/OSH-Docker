#!/usr/bin/env bash
SCRIPT_VERSION=.0.0.5

VERSION=3.1.0-snapshot

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
        sudo mkdir /opt/openhab/conf
        sudo mkdir /opt/openhab/userdata
        sudo mkdir /opt/openhab/addons
        sudo mkdir /opt/openhab/docker
        sudo chown -R openhab:openhab /opt/openhab
    fi

}

dockerConfig() {

    CONFIG=/opt/openhab/docker/.env
 
    echo -e "In dockerConfig"
    # Write configuration
    sudo cat > "$CONFIG" <<- EOF
# OpenHAB service environment
USER_ID=${ID}
GROUP_ID=${GR}
OPENHAB_HTTP_PORT=8080
OPENHAB_HTTPS_PORT=8443
EXTRA_JAVA_OPTS=-Duser.timezone=$(readlink /etc/localtime | awk -F/ '{print $5"/"$6}')
EOF

    SCRIPT=/opt/openhab/docker/oh-start.sh
    echo -e "Writing the startup script"
    sudo cat > "$SCRIPT" <<- EOF
docker run \
--name openhab \
-p 8080:8080 \
-p 8443:8443 \
-v /etc/localtime:/etc/localtime:ro \
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
    sudo chmod +x "$SCRIPT"

}

dockerService() {
    echo Downloading and Starting OpenHAB
    /opt/openhab/docker/oh-start.sh
}

userCheck
dataDirs
dockerConfig
dockerService
