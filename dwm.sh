## == dwm install script == ##

DWMDIR=$(pwd)

echo "make sure the internet is connected or press ctrl+c"
sleep 4

echo "----- downloading required packages -----"

## required packages for dwm to compile
sudo pacman -S --noconfirm libxft xdotool xorg-server xorg-xinit xwallpaper

## other basic packages
sudo pacman -S --noconfirm acpilight alacritty bluez bluez-utils dunst exa \
	firefox go gvfs-mtp libnotify maim mpv nodejs ntfs-3g pcmanfm picom \
	pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulsemixer sxiv \
	ttf-fantasque-sans-mono ttf-joypixels unzip xclip xdg-user-dirs yarn \
	yt-dlp zathura zathura-pdf-mupdf zip

## dwm utility
git clone https://github.com/73bits/dwm.git ${HOME}/.local/src/dwm
sed -i 's/^XINERAMA/#XINERAMA/g' ${HOME}/.local/src/dwm/config.mk
sudo make -C ${HOME}/.local/src/dwm install

## touchpad / mouse setting
sudo cat > ./temp << EOF
Section "InputClass"
	Identifier "devname"
	Driver "libinput"
	Option "Tapping" "on"
	Option "NaturalScrolling" "true"
	Option "AccelSpeed" "0.3"
EndSection
EOF
sudo mv ./temp /etc/X11/xorg.conf.d/30-touchpad.conf -f


#add user in video group for acpilight
sudo usermod -a -G video ${USER}

clear ; printf "\n\n\t----- REBOOT NOW -----\n\n"

rm ${DWMDIR}/dwm.sh -f
