#!/bin/bash
# Langstone-V2 Install script 
# Buster Version G4EML 16/11/21

echo "################################################################"
echo "## Installing Langstone-V2 Transceiver with Hyperpixel Display##"
echo "################################################################"

echo "#################################"
echo "##  Update the Package Manager ##"
echo "#################################"

# Update the package manager
sudo dpkg --configure -a
sudo apt-get -y update --allow-releaseinfo-change

# Uninstall the apt-listchanges package to allow silent install of ca certificates (201704030)
# http://unix.stackexchange.com/questions/124468/how-do-i-resolve-an-apparent-hanging-update-process
sudo apt-get -y remove apt-listchanges

# -------- Upgrade distribution ------

echo "#################################"
echo "##     Update Distribution     ##"
echo "#################################"

# Update the distribution
sudo apt-get -y dist-upgrade

echo "#################################"
echo "##       Install Packages      ##"
echo "#################################"

# Install the packages that we need
sudo apt-get -y install git
sudo apt-get -y install libxml2 libxml2-dev bison flex libcdk5-dev cmake
sudo apt-get -y install libaio-dev libusb-1.0-0-dev libserialport-dev libxml2-dev libavahi-client-dev 
sudo apt-get -y install gr-iio
sudo apt-get -y install gnuradio
sudo apt-get -y install raspi-gpio
sudo apt-get -y install sshpass
sudo apt-get -y install libi2c-dev
sudo apt-get -y install doxygen
sudo apt-get -y install swig


echo "#################################"
echo "##     Install Hyperpixel      ##"
echo "#################################"

cd ~
git clone https://github.com/pimoroni/hyperpixel4 -b pi4
cd hyperpixel4
sudo ./install.sh

echo "#################################"
echo "##     Install Wiring Pi       ##"
echo "#################################"

# install WiringPi
cd /tmp
wget https://project-downloads.drogon.net/wiringpi-latest.deb
sudo dpkg -i wiringpi-latest.deb
cd ~


# Install LimeSuite 22.09 as at 27 Feb 23
# Commit 9c983d872e75214403b7778122e68d920d583add
echo
echo "#######################################"
echo "##### Installing LimeSuite 22.09 #####"
echo "######################################"
wget https://github.com/myriadrf/LimeSuite/archive/9c983d872e75214403b7778122e68d920d583add.zip -O master.zip
unzip -o master.zip
cp -f -r LimeSuite-9c983d872e75214403b7778122e68d920d583add LimeSuite
rm -rf LimeSuite-9c983d872e75214403b7778122e68d920d583add
rm master.zip

# Compile LimeSuite
cd LimeSuite/
mkdir dirbuild
cd dirbuild/
cmake ../
make
sudo make install
sudo ldconfig
cd /home/pi

# Install udev rules for LimeSuite
cd LimeSuite/udev-rules
chmod +x install.sh
sudo /home/pi/LimeSuite/udev-rules/install.sh
cd /home/pi/	

# Record the LimeSuite Version 
echo "9c983d8" >/home/pi/LimeSuite/commit_tag.txt



echo "#################################"
echo "##        Install gr-limesdr   ##"
echo "#################################"

git clone https://github.com/myriadrf/gr-limesdr.git
cd gr-limesdr
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig

cd ~



echo "#################################"
echo "##        Install LibIIO       ##"
echo "#################################"

#install libiio
git clone https://github.com/analogdevicesinc/libiio.git
cd libiio
cmake ./
make all
sudo make install

cd ~
# Set auto login to command line.

sudo raspi-config nonint do_boot_behaviour B2

# Enable i2c support

sudo raspi-config nonint do_i2c 0

# install the Langstone Files

echo "####################################"
echo "##     Installing Langstone-v2    ##"
echo "####################################"

git clone https://github.com/g4eml/Langstone-V2.git
mv Langstone-V2 Langstone
cd Langstone
chmod +x build
chmod +x run_lime
chmod +x stop_lime
chmod +x run_pluto
chmod +x stop_pluto
chmod +x update
chmod +x set_pluto
chmod +x set_sdr
chmod +x set_sound
chmod +x run_both
chmod +x stop_both

./build


#make Langstone autostart on boot

if !(grep Langstone ~/.bashrc) then
  echo if test -z \"\$SSH_CLIENT\" >> ~/.bashrc 
  echo then >> ~/.bashrc
  echo /home/pi/Langstone/run >> ~/.bashrc
  echo fi >> ~/.bashrc
fi

#Configure the boot parameters

if !(grep display_lcd_rotate /boot/config.txt) then
  sudo sh -c "echo display_lcd_rotate=3 >> /boot/config.txt"
fi
if !(grep disable_splash /boot/config.txt) then
  sudo sh -c "echo disable_splash=1 >> /boot/config.txt"
fi
if !(grep global_cursor_default /boot/cmdline.txt) then
  sudo sed -i '1s,$, vt.global_cursor_default=0,' /boot/cmdline.txt
fi

#remove overlay from display driver 

sudo sed -i '/dtoverlay=vc4-fkms-v3d/s/^/#/' /boot/config.txt

cd ~
cd Langstone
./set_sdr


echo "#################################"
echo "##       Reboot and Start      ##"
echo "#################################"

#Reboot and start
sudo reboot




