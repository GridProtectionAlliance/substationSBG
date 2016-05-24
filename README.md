![substationSBG](https://raw.githubusercontent.com/GridProtectionAlliance/substationSBG/master/Source/Documentation/wiki/substationSBG_Logo.png)
# About
substationSBG couples the features of [openPDC](https://github.com/GridProtectionAlliance/openPDC) and [SIEGate](https://github.com/GridProtectionAlliance/SIEGate) to form a purpose-built, high-availability data gateway for use in substations. It is both a substation PDC with a local data historian and a phasor gateway to enable the secure, reliable communication of synchrophasor data from the substation to the control center. It has been extensively tested on fan-less substation computers for both 32 and 64 bit processors using either Windows or Linux operating systems.
Phasor data that moves through the substationSBG is persisted locally in a short-term rolling archive. Following any communications outage between the substation and control center, data archived locally by the substationSBG is transmitted (at lower priority than real-time data) back to the control central to ensure that the central archive-of-record is complete. The substationSBG is typically configured to use the [Gateway Exchange Protocol (GEP)](http://www.gridprotectionalliance.org/docs/products/gsf/gep-overview.pdf) to transfer data from the substation to other systems.

# Documentation

Documentation for substationSBG can be found [here](https://github.com/GridProtectionAlliance/substationSBG/blob/master/Source/Documentation/wiki/Substation_Secure_Buffered_Gateway.md)

# Deployment
To deploy:

1. Make sure your system meets all the requirements below.
* Download the [latest stable release](#latest-stable-release) or [nightly build](#nightly-build).
* Unzip files.
* Start "setup.exe".
* Follow the wizard.
* Enjoy.

## Requirements
### Hardware
The substationSBG executes on ruggedized, fanless substation 64-bit computers like the SEL 3355.
### Software
* The substationSBG is intended for deployment using Windows Server 2008 or later. However, the substationSBG will run under other Windows operating systems. Automated gap filling and some security features requires use of a centrally hosted openPDC, SIEGate node, or substationSBG.
* 64-bit OS.
* .NET 4.5.
* Database Management System such as
  * SQL Server
  * MySQL
  * Oracle
  * SQLite

## Latest Stable Release
Download the latest stable release [here (empty)]().

## Nightly Build
Download the nightly build [here](http://gridprotectionalliance.org/nightlybuilds/substationSBG/Beta/substationSBG.Installs.zip).

# Contributing
If you would like to contribute please:

1. Read the [styleguide.](https://www.gridprotectionalliance.org/docs/GPA_Coding_Guidelines_2011_03.pdf)
* Fork the repository.
* Do awesome things.
* Create a pull request.
