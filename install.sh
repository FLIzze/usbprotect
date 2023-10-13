#!/bin/bash

path=$(pwd)

touch /etc/systemd/system/usbProtect.service

echo -e "[Unit] \nDescription=usbProtected, ask password \n[Service] \nEnvironment="XAUTHORITY=/home/abel/.Xauthority"\nExecStart=/etc/init.d/usbProtect.sh/checkNewUsbs.sh\nUser=root\n[Install] \nWantedBy=multi-user.target" | tee /etc/systemd/system/usbProtect.service

echo Set a password to use usbStorage: 
read password
password=$($password | sha256sum | cut -d " " -f1) 2> /dev/null

mv ./usbProtect.sh /etc/init.d/
sed -i '6i password='$password' /etc/init.d/usbProtect.sh

touch /var/logs/usbprotect.txt

systemctl daemon-reload 
systemctl start usbProtect.service
systemctl enable usbProtect.service

