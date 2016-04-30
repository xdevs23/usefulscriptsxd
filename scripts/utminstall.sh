#!/sbin/bash

sudo mv $1 /usr/share/themes/$1
sudo chmod 755 /usr/share/themes/$1

unity-tweak-tool &
