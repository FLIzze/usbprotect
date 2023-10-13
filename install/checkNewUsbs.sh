#!/bin/bash
#
#needs root to be used 

export DISPLAY=":0"
password=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

directory="/dev/input/by-id"
nmbtry="0"
bind="0"

passwordInstall=""
passwordBool="false"
passwordUser=""

while :
do
	#checkUsb=$(lsusb | grep XBOX | cut -d " " -f1)
	#passwordBool=$(cat /home/abel/Documents/scripts/usbProtect/usb.txt | cut -d " " -f1)
	#nmbtry=$(cat /home/abel/Documents/scripts/usbProtect/usb.txt | cut -d " " -f2)
	logs=/var/log/usbprotect/
	usbBus=$(lsusb | grep Storage | cut -d " " -f2 | cut -d "0" -f3)
	usbDevice=$(lsusb | grep Drive | cut -d " " -f4 | cut -d ":" -f1 | cut -d "0" -f3)

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

			#konsole --new-tab --fullscreen --hide-menubar -e ./home/abel/Documents/scripts/askpasswordBool.sh
			#gnome-terminal -x bash -c "<./home/abel/Documents/scripts/askpasswordBool.sh>; exec bash"
				#konsole --fullscreen --hide-tabbar -e ./askpasswordBool.sh
				#bash /home/abel/Documents/scripts/usbProtect/askPasswordZen.sh
				passwordUser=$(zenity --password --title usbProtect) 
				passwordUser=$($passwordUser | sha256sum | cut -d " " -f1)
				echo $passwordUser
				echo $passwordInstall
				if [[ $passwordUser == $passwordInstall ]]
				then
					zenity --info
					nmbtry="1"
					passwordBool="true"
					echo $(date '+[%Y:%m:%d|%H-%M-%S]') good password | tee -a $logs/logs.txt
				else
					zenity --error
					nmbtry="1"
					passwordBool="false"
					fswebcam -q -r 1920 /var/log/usbprotect/pics/pic%Y-%m-%d_%H:%M:%S.png
					echo $(date '+[%Y:%m:%d|%H-%M-%S]') wrong password | tee -a $logs/logs.txt
				fi
			else
				echo unplug the usbKey to try again
			fi
		fi	
	else 
		#echo usb not found
		bind="0"
		passwordBool="false"
		passwordUser=""
		nmbtry="0"
	fi
sleep 2s
done
