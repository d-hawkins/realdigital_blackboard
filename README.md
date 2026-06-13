# Real Digital Blackboard

6/13/2026 D. W. Hawkins (dwh@caltech.edu)

# Introduction

This repository contains example designs for the Real Digital Blackboard.

Real Digital provides an extensive reference manual and reference designs for this board - see the Resources below.

## Repository Contents

Directory           | Contents
--------------------|-----------
hardware            | Hardware designs
software            | Software designs
references          | Reference documentation
tcl                 | Tcl scripts

## Blackboard Features

* System-on-Chip:
	* AMD/Xilinx single-core Zynq-7000 SoC (XC7Z007S-1CLG400C)
	* 3,600 slices containing 14,400 6-input LUTs and 28,800 flip-flops
	* 50 x 36kbit Block RAMs
	* 66 DSP blocks (DSP48E1 with pre-add, 25x18-bit multiply, 48-bit post-add/accumulate)
* Memory & Storage: 
	* 512MB DDR3 memory
	* 16MB QSPI ROM
	* SD card slot
* Sensors: 
	* LSM9DS1 iNemo module (3-axis accelerometer, gyroscope, and magnetometer)
	* LM75B temperature sensor
* Connectivity:
	* On-board Wi-Fi and Bluetooth (ESP-32 module)
	* USB OTG
	* Audio Codec
* I/O Peripherals:
	* 1080p-capable HDMI port
	* 3 Pmod expansion connectors
	* 12 Slide switches
	* Pushbuttons (4 PL, 2 PS, PROG#, and PS RST#)
	* 4-digit 7-segment display
	* RGB LEDs (2 PL, 1 PS)
	* Thumbwheel potentiometer
	* FT2232H JTAG and PS UART
	* 100MHz PS clock

# Resources

Document | Link
---------|-----
Real Digital Blackboard ($184) | https://www.realdigital.org/hardware/blackboard
Blackboard Linux | https://github.com/RealDigitalOrg/linux-blackboard

# Git LFS Installation

This repository was created using the github web interface, then checked out using Windows 10 WSL, and git LFS was installed using

~~~
$ git clone git@github.com:d-hawkins/realdigital_blackboard.git
$ cd realdigital_blackboard/
$ git lfs install
~~~

The .gitattributes file from another repo was then copied to this repo, and that file checked in.

~~~
$ git add .gitattributes
$ git commit -m "Git LFS tracking" .gitattributes
$ git push
~~~

The .gitattributes file contains file extension patterns for the majority of binary file types that could be checked into the repo (additional patterns can be added as needed).

