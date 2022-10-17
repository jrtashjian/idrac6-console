#!/bin/bash

if [ -z "$1" ]; then
	echo
	echo "Usage: connect.sh HOST[:PORT] [-u USER] [-p PASSWORD]"
	echo

	exit
fi

IDRAC_HOST=$(echo $1 | cut -d : -f 1)
IDRAC_PORT=$(echo $1 | cut -d : -f 2)

if [ "$IDRAC_HOST" == "$IDRAC_PORT" ]; then
	IDRAC_PORT=""
fi

shift
while getopts "u:p:" arg; do
	case "$arg" in
		'u') IDRAC_USER=$OPTARG ;;
		'p') IDRAC_PASS=$OPTARG ;;
	esac
done

IDRAC_PORT="${IDRAC_PORT:=5900}"
IDRAC_USER="${IDRAC_USER:=root}"
IDRAC_PASS="${IDRAC_PASS:=calvin}"

# https://download.oracle.com/otn/java/jdk/7u80-b15/jre-7u80-linux-x64.tar.gz
JRE="$PWD/jre1.7.0_80"

if [ ! -d $JRE ]; then
	tar -xzvf $PWD/jre-7u80-linux-x64.tar.gz
fi

# Download avctKVM.jar, libavmlinux.so, and libavctKVMIO.so from the host machine.
HOST="host_${IDRAC_HOST//[.:]/_}"
HOST_DIR="$PWD/$HOST"

if [ ! -d $HOST ]; then
	mkdir -p $HOST_DIR/lib
	wget -O $HOST_DIR/avctKVM.jar https://$IDRAC_HOST/software/avctKVM.jar --no-check-certificate

	wget -O $HOST_DIR/avctVM.zip https://$IDRAC_HOST/software/avctVMLinux64.jar --no-check-certificate
	unzip $HOST_DIR/avctVM.zip libavmlinux.so -d $HOST_DIR/lib

	wget -O $HOST_DIR/avctKVMIO.zip https://$IDRAC_HOST/software/avctKVMIOLinux64.jar --no-check-certificate
	unzip $HOST_DIR/avctKVMIO.zip libavctKVMIO.so -d $HOST_DIR/lib
fi

$JRE/bin/java \
	-cp \
	$HOST_DIR/avctKVM.jar \
	-Djava.library.path=$HOST_DIR/lib \
	com.avocent.idrac.kvm.Main \
	ip=$IDRAC_HOST \
	kmport=$IDRAC_PORT vport=$IDRAC_PORT \
	user=$IDRAC_USER \
	passwd=$IDRAC_PASS \
	apcp=1 version=2 vmprivilege=true \
	"helpurl=https://$IDRAC_HOST/help/contents.html"
