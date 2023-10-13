#!/bin/bash
#
#needs root to be used 

#export DISPLAY=":0"

directory="/dev/input/by-id"
nmbtry="0"
bind="0"
passwordBool="false"
passwordUser=""
while :
do
	#checkUsb=$(lsusb | grep XBOX | cut -d " " -f1)
	#passwordBool=$(cat /home/abel/Documents/scripts/usbProtect/usb.txt | cut -d " " -f1)
	#nmbtry=$(cat /home/abel/Documents/scripts/usbProtect/usb.txt | cut -d " " -f2)
	logs=/var/log/usbprotect.txt
	usbBus=$(lsusb | grep Storage | cut -d " " -f2 | cut -d "0" -f3)
	usbDevice=$(lsusb | grep Drive | cut -d " " -f4 | cut -d ":" -f1 | cut -d "0" -f3)

	#echo "$checkUsb"
	#echo $usbBus
	#echo $usbDevice

	if [[ -n $usbBus ]]
	then
		echo usb found
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
				echo $passwordUser
				echo $password
				if [[ $passwordUser == $password ]]
				then
					nmbtry="1"
					passwordBool="true"
					echo good password | tee -a $logs
				else
					nmbtry="1"
					passwordBool="false"
					echo wrong password | tee -a $logs
				fi
			else
				echo unplug the usbKey to try again
			fi
		fi	
	else 
		echo usb not found
		bind="0"
		passwordBool="false"
		nmbtry="0"
	fi
sleep 2s
done
