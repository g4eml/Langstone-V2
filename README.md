# Langstone-V2 SDR Transceiver by Colin Durbridge G4EML

** Note this project is still in the development phase. It may not be fully functional.**

This is an experimental project to produce a simple VHF, UHF and Microwave SDR Transceiver operating on SSB CW and FM.

It was inspired by the very successful Portsdown Amateur Television system created by the British Amateur Television Club.

To install the software on a raspberry pi please follow the instructions further down the page. 

**More information can also be found on the UK Microwave group wiki at https://wiki.microwavers.org.uk/Langstone_Project**

Currently only the following hardware is supported:-

- Raspberry Pi 4

- Official Raspberry Pi 7" touchscreen, DFRobot DFR0550 5" Touchscreen or Pimoroni Hyperpixel4 4" Touchscreen

- Adalm Pluto SDR Module or Lime SDR Mini

- USB Audio module. Connected to loudspeaker or headphones and microphone. 
 
- USB Scroll mouse

- Optional GPIO extender using MCP23017 Module. (This is primarily used with the Hyperpixel display but can also be used with the 7" display if prefered). 

**Note, the following GPIO inputs and outputs can not be used with the Hyperpixel4 display because it uses all of the GPIO. You will need to add an MCP23017 i2c module for any inputs and outputs.**

- PTT via Raspberry Pi GPIO pin 11. This needs a pull up resistor to 3.3V. Grounding this pin will switch to Transmit.

- CW Key is via Raspberry Pi GPIO pin 12. This needs a pull up resistor to 3.3V. Grounding this pin will key the transmitter. 

- Tx Output is via Raspberry Pi GPIO pin 40. This output goes high when the Langstone is transmitting. This can be used to switch antenna relays and amplifiers. (100ms delay included for sequencing)

- 8 Band select Outputs on pins 28, 35, 7, 22, 16, 18, 19, and 21. These can be used to select external filters, amplifiers or Transverters. The state of these outputs is defined using the Band Bits setting. 

- The TX output and first three of the Band Select outputs are also available on the Internal Pluto GPO connector. GPO0 is the Tx Output, GPO1-3 are the Band Select outputs.The main use for these is for when the Pluto is remotely mounted. Care must be taken as these pins are low voltage. They will need to be buffered before use. 

- To provide I/O when using a Hyperpixel4 display, support has been added for an external MCP23017 module which is cheaply available on Ebay etc. This provides 16 digital inputs or outputs and is connected the the i2c port on the Hyperpixel display. It can also optionally be used with the 7" display by connecting to the Raspbery pi i2c. (pins 3 and 5 of the GPIO connector)

- When using the MCP23017 module Port B will output the 8 band select bits. Port A bit 0 will be the PTT input, Port A bit 1 will be the Key input and Port A bit 7 will be the Tx Output. 

To build a complete functional transceiver you will need to add suitable filters, preamplifiers and power amplifiers to the Adalm Pluto. 

All control is done using the touchscreen and mouse.

Tuning uses the mouse scrollwheel. The mouse left and right buttons select the tuning step. The centre button is used for the CW key.  Mouse movement is not used.

A mouse is used to provide the tuning input because it effectively hands the task of monitoring the tuning knob to a seperate processor (in the mouse). Rotary encoders can be tricky to handle reliably in linux. 

It is easy to modify a cheap mouse by disconnecting the existing switches and wiring the PCB to larger switches on the Langstone front panel. The scroll wheel can likewise be replaced with a panel mounted tuning knob. 

Microphone input and headphone output uses the USB audio device. (a couple of pounds on Ebay)

The software consists of three parts. The SDR itself uses two python GNURadio Flowgraphs (Lang_TX.py and Lang_RX.py)which can be created on a PC running GNUradio companion. These Python programs are then manually edited by adding the code from ControlTX.py and ControlRX.py so it can be controlled by the GUI part of the software. This is written in C and communicates with GNURadio using a Linux Pipe. However to build and use a Langstone transceiver you do not need to know this!



# Installation for Langstone Transceiver

The preferred installation method only needs a Windows PC connected to the same (internet-connected) network as your Raspberry Pi.  Do not connect a keyboard or HDMI display directly to your Raspberry Pi.

- First download the 2021-05-07 release of Raspios Buster Lite on to your Windows PC from here  https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip

(This version is known to work. Newer versions should also work and may speed up the installation but have not yet been tested) 

- Unzip the image and then transfer it to a Micro-SD Card using Win32diskimager https://sourceforge.net/projects/win32diskimager/
- Make sure you use a good quality class 10 Micro-SD Card. (16GB is OK) The performance of the Raspberry Pi can be badly affected by poor quality cards. 

- Before you remove the card from your Windows PC, look at the card with windows explorer; the volume should be labeled "boot".  Create a new empty file called ssh in the top-level (root) directory by right-clicking, selecting New, Text Document, and then change the name to ssh (not ssh.txt).  You should get a window warning about changing the filename extension.  Click OK.  If you do not get this warning, you have created a file called ssh.txt and you need to rename it ssh.  IMPORTANT NOTE: by default, Windows (all versions) hides the .txt extension on the ssh file.  To change this, in Windows Explorer, select File, Options, click the View tab, and then untick "Hide extensions for known file types". Then click OK.

- Connect the touchscreen display, USB mouse, USB Sound Card, and Pluto now.   Power up the RPi with the new card inserted, and a network connection.  Do not connect a keyboard or HDMI display to the Raspberry Pi. 

- Find the IP address of your Raspberry Pi using an IP Scanner (such as Advanced IP Scanner http://filehippo.com/download_advanced_ip_scanner/ for Windows, or Fing on an iPhone) to get the RPi's IP address 

- From your windows PC use Putty (http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) to log in to the IP address that you noted earlier.  You will get a Security warning the first time you try; this is normal.

- Log in (user: pi, password: raspberry) then cut and paste the following code in, one line at a time:

# For the 7" Raspberry Pi Display:-

```sh
wget https://raw.githubusercontent.com/g4eml/Langstone/master/install.sh
chmod +x install.sh
./install.sh
```

# For the 5" DFR0550 Display:-

```sh
wget https://raw.githubusercontent.com/g4eml/Langstone/master/install_dfr0550.sh
chmod +x install_dfr0550.sh
./install_dfr0550.sh
```

# For the 4" Hyperpixel4 Display:-

```sh
wget https://raw.githubusercontent.com/g4eml/Langstone/master/install_hyperpixel4.sh
chmod +x install_hyperpixel4.sh
./install_hyperpixel4.sh
```

#  To build the development version for the 7" Raspberry Pi Display (Not Guaranteed to work. For testing only):-

```sh
wget https://raw.githubusercontent.com/g4eml/Langstone/Dev/install_Dev.sh
chmod +x install_Dev.sh
./install_Dev.sh
```

The initial build can take some time, however it does not need any user input, so go and make a cup of coffee and keep an eye on the touchscreen.  When the build is finished the Pi will reboot and start-up with the Langstone Transceiver. Note that sometimes the first reboot does not start correctly. Just recyle the power and try again. If it still does not appear to be working then see the file 'Debugging Notes.txt' and the Langstone wiki for some things to look at.

# Updating the Software. 

If you have a running Langstone you can update by doing the following. 

Log into the Pi using SSH as described above. 

cd Langstone

./stop

./update

sudo reboot


