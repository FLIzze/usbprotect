#!/bin/bash

path=$(pwd)

touch /etc/systemd/system/usbProtect.service

echo -e "[Unit] \nDescription=usbProtected, ask password \n[Service] \nEnvironment="XAUTHORITY=/home/abel/.Xauthority"\nExecStart=/etc/init.d/checkNewUsbs.sh\nUser=root\n[Install] \nWantedBy=multi-user.target" | tee /etc/systemd/system/usbProtect.service 

password=$(zenity --entry --text="set password to use usbKey" --title usbprotect | sha256sum | cut -d " " -f1)

mv ./checkNewUsbs.sh /etc/init.d/
sed -i '6i password='$password /etc/init.d/checkNewUsbs.sh

mkdir /var/log/usbprotect 2> /dev/null
touch /var/log/usbprotect/logs.txt 2> /dev/null
mkdir /var/log/usbprotect/pics 2> /dev/null

systemctl daemon-reload 
systemctl start usbProtect.service
systemctl enable usbProtect.service

