#!/bin/bash

TARGET_DEVICES=(
	"046d c547" # Pro X Superlight Lightspeed dongle
)

USB_DEV_PATH="/sys/bus/usb/devices/"
TRAILING_PATH="power/wakeup"

# For every device listed at USB_DEV_PATH
for DEVICE_PATH in "${USB_DEV_PATH}"*/; do

	# Only check the ones that have wakeup data
	if [[ -f ${DEVICE_PATH}${TRAILING_PATH} ]]; then

		# Either "enabled" or "disabled"
		STATE=$(<${DEVICE_PATH}${TRAILING_PATH})

		# Only check devices that are "enabled", and thus can wake the device
		if [[ ${STATE} == "enabled" ]]; then

			VID=$(<${DEVICE_PATH}"idVendor")
			PID=$(<${DEVICE_PATH}"idProduct")

			# If the target devices array contains the found VID/PID combo, disable it
			if [[ "${TARGET_DEVICES[*]}" =~ "${VID} ${PID}" ]]; then
				echo "disabled" > "${DEVICE_PATH}${TRAILING_PATH}"
			fi
		fi
	fi
done
