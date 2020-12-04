#!/usr/bin/env bash
SCRIPT_VERSION=.0.1.0

VERSION=snapshot

userCheck() {
    echo -e "smarthouse User Check"
    if getent passwd | cut -d: -f1 | grep smarthouse > /dev/null 2>&1;  then
        echo -e "User smarthouse already exists"
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
    userdel -rf smarthouse > /dev/null 2>&1
    userAdd
}

userAdd() {
    sudo useradd -d /opt/opensmarthouse -m -r -s /sbin/nologin smarthouse
    userId

}

userId () {
    ID=`id -u smarthouse`
    GR=`id -g smarthouse`
}

dataDirs() {
    echo -e "Data Directory Setup"
    if [ -d /opt/opensmarthouse/conf ]
      then
        echo -e "Directories already exist"
      else
        sudo mkdir /opt/opensmarthouse/conf
        sudo mkdir /opt/opensmarthouse/userdata
        sudo mkdir /opt/opensmarthouse/deploy
        sudo mkdir /opt/opensmarthouse/docker
        sudo chown -R smarthouse:smarthouse /opt/opensmarthouse
    fi

}

dockerConfig() {

    CONFIG=/opt/opensmarthouse/docker/.env
 
    echo -e "In dockerConfig"
    # Write configuration
    sudo at > "$CONFIG" <<- EOF
# OpenHSmartHouose service environment
USER_ID=${ID}
GROUP_ID=${GR}
OSH_HTTP_PORT=8181
OSH_HTTPS_PORT=8443
EXTRA_JAVA_OPTS=-Duser.timezone=$(readlink /etc/localtime | awk -F/ '{print $5"/"$6}')
EOF

    SCRIPT=/opt/opensmarthouse/docker/osh-start.sh
    echo -e "Writing the startup script"
    sudo cat > "$SCRIPT" <<- EOF
docker run \
--name opensmarthouse \
-p 8181:8181 \
-p 8443:8443 \
-v /etc/localtime:/etc/localtime:ro \
-v /opt/opensmarthouse/deploy:/opensmarthouse/deploy \
-v /opt/opensmarthouse/conf:/opensmarthouse/conf \
-v /opt/opensmarthouse/userdata:/opensmarthouse/userdata \
--env-file /opt/opensmarthouse/docker/.env \
--privileged \
-d \
--restart=always \
bwosborne/docker-test:$VERSION
EOF
    # Make the script executable
    sudo chmod +x "$SCRIPT"

}

dockerService() {
    echo Downloading and Starting OpenSmartHouse
    /opt/opensmarthouse/docker/osh-start.sh
}

userCheck
dataDirs
dockerConfig
dockerService
