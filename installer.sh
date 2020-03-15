#!/usr/bin/env bash
SCRIPT_VERSION=.0.0.1

GREY_RED='\033[0;37;41m'
GREEN_DARK='\033[0;32;40m'
BLUE_DARK='\033[1;34;40m'
BLACK_WHITE='\033[1;30;47m'
RED_WHITE='\033[1;31;47m'
BLINKING='\033[5;37;41m'
NC='\033[0m' # Reset

SILENT=false

URL_BIN_OPENHAB="https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/files/openHAB"
URL_SERVICE_OPENHAB="https://raw.githubusercontent.com/bwosborne2/OSH-Docker/master/files/openhab.service"


userCheck() {
#    sudo useradd -d /opt/openhab -m -r -s /sbin/nologin openhab
    sudo groupadd -g 9001 -r openhab
    sudo useradd -d /opt/openhab -u 9001 -g 9001  -m -r -s /sbin/nologin openhab
    ID=`id -u openhab`
    GR=`id -g openhab`
    echo -e "User: $ID"
    echo -e "Group: $GR"

}

dataDirs() {
    echo -e "Data Directory Setup"
    sudo mkdir /opt/openhab/conf
    sudo mkdir /opt/openhab/userdata
    sudo mkdir /opt/openhab/addons
    sudo mkdir /opt/openhab/docker
    sudo chown -R openhab:openhab /opt/openhab

}

dockerService() {
    echo "[Info] Install openHAB startup scripts"
    curl -sL ${URL_BIN_OPENHAB} > /opt/openhab/docker/openHAB
    curl -sL ${URL_SERVICE_OPENHAB} > /etc/systemd/system/openhab.service
    
    chmod a+x /opt/openhab/docker/openHAB
    systemctl enable openhab.service
}

addonsCfgCheck() {

    if [[ "${ACTION}" =~ "OpenHAB"]]; then
        echo -e "OpenHAB chosen"
	elif [[ "${ACTION}" =~ "docker]]; then
        echo -e "OpenHAB chosen"
	fi

#    versions
}


menu() {
    CURRENT_ACCOUNT=$(whoami)
    clear
    if [[ "${CURRENT_ACCOUNT}" != "openhab" ]]; then
        echo; echo -e "${BLINKING}!!!!!${GREY_RED} This script MUST be executed by the account that runs openHAB, typically 'openhab' ${BLINKING}!!!!!${NC}"
        select choice in "Continue (my openHAB account is \"${CURRENT_ACCOUNT}\")" "Exit"; do
            case $choice in
                "Continue (my openHAB account is \"${CURRENT_ACCOUNT}\")" ) break;;
                "Exit" ) exit; break;;
            esac
        done
    fi

    echo; echo -e "${GREEN_DARK}What would you like to do?${NC}"
    select ACTION in "Install or upgrade Zigbee binding" "Install or upgrade Z-Wave binding" "Install or upgrade both bindings" "Install serial transport" "Uninstall Zigbee binding" "Uninstall Z-Wave binding" "Uninstall both bindings" "Exit"; do
        case $ACTION in
            "Install Docker" ) break;;
            "Install OpenHAB" ) break;;
            "Exit" ) echo; exit;;
        esac
    done

    addonsCfgCheck
}



userCheck
dataDirs
dockerService
systemctl start openhab
