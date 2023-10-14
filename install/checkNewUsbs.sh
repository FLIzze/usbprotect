#!/bin/bash
#
#needs root to be used 

export DISPLAY=":0"
password=363f821d642863331cafe5ef674a50c8a4a4d4dd2c312cd36aad5f6e21f757bd
password=363f821d642863331cafe5ef674a50c8a4a4d4dd2c312cd36aad5f6e21f757bd

directory="/dev/input/by-id"
nmbtry="0"
bind="0"

passwordInstall=""
passwordBool="false"
passwordUser=""

while :
do
	logs=/var/log/usbprotect/
	usbBusStorage=$(lsusb | grep -i Storage | cut -d " " -f2 | cut -d "0" -f3)
	usbBusFlash=$(lsusb | grep -i Flash | cut -d " " -f2 | cut -d "0" -f3)
	usbBusDrive=$(lsusb | grep -i Drive | cut -d " " -f2 | cut -d "0" -f3)

	usbBus=""

	if [[ -n $usbBusStorage ]]
	then
		usbBus=$usbBusStorage
	elif [[ -n $usbBusFlash ]]
	then
		usbBus=$usbBusStorage
	elif [[ -n $usbBusDrive ]]
	then
		usbBus=$usbBusDrive
	fi

	#echo "$checkUsb"
	#echo $usbBus
	#echo $usbDevice

	if [[ -n $usbBus ]] 
	then
		#echo usb found
		if [[ $nmbtry == "0" ]]
		then
			echo $usbBus-2 | tee /sys/bus/usb/drivers/usb/unbind 
		fi

		if [[ $passwordBool == "true" ]]
		then
			#echo usbKey authorized
			if [[ $nmbtry == "1" && $bind == "0" ]]
			then
				echo $usbBus-2 | tee /sys/bus/usb/drivers/usb/bind 
				bind="1"
			fi
		else
			if [[ $nmbtry == "0" ]]
			then
				passwordUser=$(zenity --password --title usbProtect | sha256sum | cut -d " " -f1)
				if [[ $passwordUser == $password ]]
				then
					nmbtry="1"
					passwordBool="true"
					echo $(date '+[%Y:%m:%d|%H-%M-%S]') good password | tee -a $logs/logs.txt
					zenity --info
				else
					nmbtry="1"
					passwordBool="false"
					fswebcam -q -r 1920 /var/log/usbprotect/pics/pic%Y-%m-%d_%H:%M:%S.png
					echo $(date '+[%Y:%m:%d|%H-%M-%S]') wrong password | tee -a $logs/logs.txt
					zenity --error
				fi
			fi
		fi	
	else 
		#echo usb not found
		bind="0"
		passwordBool="false"
		passwordUser=""
		nmbtry="0"
	fi
	sleep 3s 
done
