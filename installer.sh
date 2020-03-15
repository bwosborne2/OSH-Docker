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
    sudo mkdir /opt/openhab/conf
    sudo mkdir /opt/openhab/userdata
    sudo mkdir /opt/openhab/addons
    sudo chown -R openhab:openhab /opt/openhab

}


userCheck
dataDirs
