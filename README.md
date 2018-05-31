![Icon](http://www.gridprotectionalliance.org/images/products/icons%2064/substationSBG.png)![substationSBG](http://www.gridprotectionalliance.org/images/products/substationSBG.png)
# About
substationSBG couples the features of [openPDC](https://github.com/GridProtectionAlliance/openPDC) and [SIEGate](https://github.com/GridProtectionAlliance/SIEGate) to form a purpose-built, high-availability data gateway for use in substations. It is both a substation PDC with a local data historian and a phasor gateway to enable the secure, reliable communication of synchrophasor data from the substation to the control center. It has been extensively tested on fan-less substation computers for both 32 and 64 bit processors using either Windows or Linux operating systems.
Phasor data that moves through the substationSBG is persisted locally in a short-term rolling archive. Following any communications outage between the substation and control center, data archived locally by the substationSBG is transmitted (at lower priority than real-time data) back to the control central to ensure that the central archive-of-record is complete. The substationSBG is typically configured to use the [Gateway Exchange Protocol (GEP)](http://www.gridprotectionalliance.org/docs/products/gsf/gep-overview.pdf) to transfer data from the substation to other systems.

# Documentation and Support

* Documentation for substationSBG can be found [here](https://github.com/GridProtectionAlliance/substationSBG/blob/master/Source/Documentation/wiki/Substation_Secure_Buffered_Gateway.md)
* Get in contact with our development team on our new [discussion board](http://discussions.gridprotectionalliance.org/c/gpa-products/substation-sbg).
* View old discussion board topics [here](https://archive.codeplex.com/?p=substationsbg).
* Check out the [wiki](https://gridprotectionalliance.org/wiki/doku.php?id=substationsbg:overview).

# Deployment
To deploy:

1. Make sure your system meets all the [requirements](#requirements) below.
* Choose a [download](#downloads) option below.
* Unzip files.
* Run substationSBGSetup.msi.
* Follow the wizard.
* Enjoy.

## Requirements

### Hardware
The substationSBG executes on ruggedized, fanless substation 64-bit computers like the SEL 3355.

### Software
* The substationSBG is intended for deployment using Windows Server 2008 or later. However, the substationSBG will run under other Windows operating systems. Automated gap filling and some security features requires use of a centrally hosted openPDC, SIEGate node, or substationSBG.

* .NET 4.6 or higher.
* 64-bit Windows 7 or newer.
* Database management system such as:
  * SQL Server (Express version is fine)
  * MySQL
  * Oracle
  * PostgreSQL
  * SQLite (included, no extra install required)

## Downloads
* Download the latest stable release [here](https://github.com/GridProtectionAlliance/substationSBG/releases).
* Download the nightly build [here](http://gridprotectionalliance.org/nightlybuilds/substationSBG/Beta/substationSBG.Installs.zip).

# Contributing
If you would like to contribute please:

1. Read our [styleguide.](https://www.gridprotectionalliance.org/docs/GPA_Coding_Guidelines_2011_03.pdf)
* Fork the repository.
* Do awesome things.
* Create a pull request.

# License
SubstationSBG is licenced for use under the [MIT License](https://opensource.org/licenses/MIT).
