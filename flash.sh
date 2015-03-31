#!/bin/sh

FASTBOOT=${FASTBOOT:-fastboot}

IMAGES_PATH=${PWD}
IMAGES_FLASH="boot:boot.img system:system.img recovery:recovery.img cache:cache.img"

DEVICES_TO_FLASH=""

check_files()
{
	echo "[#] Checking that we have expected partitions files ..."

	for part in ${IMAGES_FLASH};
	do
		TARGET=$(echo ${part} | cut -d':' -f1)
		SOURCE=$(echo ${part} | cut -d':' -f2)

		if [ -z "${TARGET}" -o -z "${SOURCE}" ]; then
			echo " [!] Missing target (${TARGET}) or source (${SOURCE})"
			exit 1
		fi;

		FILESOURCE="${IMAGES_PATH}/${SOURCE}"
		if [ ! -f "${FILESOURCE}" ]; then
			echo " [!] Unable to read source (${FILESOURCE})"
			exit 1
		else
			echo " [>] Found file ${FILESOURCE} for ${TARGET}"
		fi;
	done;

	echo "[#] All check."
	echo ""
}

flash_one_device()
{
	SN=$1
	if [ -z "${SN}" ]; then
		echo "No target device, please give one."
		exit 1
	fi;

	FAILED=""

	echo "[-] Flashing device: ${SN}"
	for part in ${IMAGES_FLASH};
	do
		TARGET=$(echo ${part} | cut -d':' -f1)
		SOURCE=$(echo ${part} | cut -d':' -f2)
		echo -n "  [-] Flashing '${TARGET}' with '${SOURCE}'"
		OUTPUT=$(${FASTBOOT} -s ${SN} flash ${TARGET} "${IMAGES_PATH}/${SOURCE}" 2>&1)
		RC=$?
		if [ ${RC} -eq 0 ]; then
			echo " OK"
		else
			FAILED="${FAILED} ${part}"
			echo " KO: ${RC}"
		fi;
	done;

	if [ ! -z "${FAILED}" ]; then
		echo "[!] Failure while flashing device ${SN}: ${FAILED}"
	else
		echo "[-] All partitions flashed successfully."
		${FASTBOOT} -s ${SN} reboot 2>&1 > /dev/null
	fi;

	echo ""
}

enumerate_devices()
{
	echo "[#] Enumerating fastboot devices"
	DEVICES=$(${FASTBOOT} devices | awk '{ print $1 }')
	NB=$(echo ${DEVICES} | wc -w)
	echo " [=] Found a total of ${NB} devices:"
	for d in ${DEVICES};
	do
		PRODUCT=$(${FASTBOOT} -s ${d} getvar product 2>&1 | grep '^product:' | cut -d' ' -f2)
		echo "  [-] Product: ${PRODUCT}\tS/N: ${d}"
	done;
	echo "[#] All devices enumerated"
	echo ""
	DEVICES_TO_FLASH=${DEVICES}
}

do_confirm()
{
	echo ""
	echo " *** You still have a chance to cancel this now."
	echo " *** Do you really want to do this ? (y/N)"
	read CONFIRMATION
	echo ""

	if [ "${CONFIRMATION}" = "n" -o "${CONFIRMATION}" = "N" ]; then
		echo "Aborting."
		exit 0
	fi;
	if [ "${CONFIRMATION}" = "y" -o "${CONFIRMATION}" = "Y" ]; then
		return 0
	fi;

	echo "Unable to read a valid answer."
	do_confirm
}

confirm()
{
	echo ""
	echo " *** WARNING *** YOU ARE ABOUT TO FLASH ${NB} DEVICES WITH"
	echo " *** WARNING *** IMAGES FROM ${IMAGES_PATH}"
	echo " *** WARNING *** PLEASE MAKE SURE YOU HAVE ONLY HAVE PLUGGED"
	echo " *** WARNING *** THE DEVICES THAT NEEDS TO BE FLASHED"
	echo ""
	do_confirm
}

###

while [ $# -gt 0 ]; do
	case "$1" in
	"-s")
		DEVICES_TO_FLASH="$2"
		shift
		;;
	"-p")
		IMAGES_PATH=$(realpath $2)
		shift
		;;
	"-h"|"--help")
		echo "Usage: $0 [-s device] [-p path]"
		exit 0
		;;
	"-"*)
		echo "$0: Unrecognized option: $1"
		exit 1
		;;
	esac
	shift
done

check_files

# If the user do not specify a serial number, let's warn
if [ -z "${DEVICES_TO_FLASH}" ]; then
	enumerate_devices
	confirm
fi;

for d in ${DEVICES_TO_FLASH};
do
	flash_one_device $d
done;
