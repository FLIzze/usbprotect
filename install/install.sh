#!/bin/bash

path=$(pwd)

touch /etc/systemd/system/usbProtect.service

echo -e "[Unit] \nDescription=usbProtected, ask password \n[Service] \nEnvironment="XAUTHORITY=/home/abel/.Xauthority"\nExecStart=/etc/init.d/checkNewUsbs.sh\nUser=root\n[Install] \nWantedBy=multi-user.target" | tee /etc/systemd/system/usbProtect.service 2> /dev/null

echo Set a password to use usbStorage: 
read password
password=$($password | sha256sum | cut -d " " -f1)

mv ./checkNewUsbs.sh /etc/init.d/
sed -i '6i password='$password /etc/init.d/checkNewUsbs.sh

mkdir /var/log/usbprotect
touch /var/log/usbprotect/logs.txt
mkdir /var/log/usbprotect/pics

systemctl daemon-reload 
systemctl start usbProtect.service
systemctl enable usbProtect.service

