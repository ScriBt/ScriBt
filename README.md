
![ScriBt in Action](http://i.imgur.com/5p97f9i.png?2)

**ROM Sync && Build Script for Learning Developers**

Ready to use. Extensive Testing needed.

**Supports Ubuntu & Debian based Distros, and ArchLinux**

**Tip!** : **ROMNIS** - **ROM** **N**ame **I**n **S**ource - eg. cm, bliss, candy, crdroid etc.

ScriBt consists of five main Actions:

#1. Init

a. **Choose** a ROM

b. **Initialize** it's Repo

c. **Add** a local_manifest for Device Specfic Additions / Changes

#2. Sync

**Sync** the Sources - Setting Sync Options / Flags available

#3. Pre Build

**The Biggest Part/Function of ScriBt**

a. **Add Device** to ROM Vendor

b. Make an **Interactive Makefile** under Device Tree (Identifiable by ROM's BuildSystem)

  * This was created in order to prevent unnecessary Modifications to already present files in the Device Tree and messing it up eventually...

  * Idea came into existence, When I saw most of the ROMs (... not having ```products``` folder in ROM vendor && excluding AOSP-CAF/AOSP-RRO) having these lines in one of the BuildSystem's files...

  ```# A ROMNIS build needs only the ROMNIS product makefiles.```

  ```ifneq ($(ROMNIS_BUILD),)
     all_product_configs := $(shell ls device/*/$(ROMNIS_BUILD)/ROMNIS.mk)```

#4. Build

a. Build the Entire ROM

   * **Clean** /out Entirely or only Staging Directories

   * **Start** Build

b. Make a Particular Module

c. Setup **CCACHE**

d. Give **comments** based on the Final Build Status

   * Build Success

   * Arbitrary Error (Can't help because Entropy of Increase in Errors gets Incremented day by day :P)

#5. Tools

a. Install Build Dependencies based on Distro Version

b. Install / Configure **Java**

c. Setup **android-51** rules (For proper usage of ADB)

d. Revert to make 3.81

e. CCACHE Setup

#6. Automated Cherry Picking

# prefGen

** aka Config Generator **
* After work's done, ScriBt saves the Configurations for that session, so that it could be automated next time...
This is done on User's wish.
* User should enter the function sequence though (under function automate), Information Gathering is done by ```prefGen```

As said before,
#Extensive Testing is needed.


#Usage
```
bash ROM.sh
```

##### Why not . /ROM.sh ?
```exit``` command will close the terminal when script is called in that way, bash ROM.sh runs the script in a seperate bash shell, so if the exit command is used, it will terminate that shell and not the terminal in which it was executed.

#What do the colors mean ?

[!] in..

    RED - The Particular Task has Failed / User has Entered an Incorrect Value

    BLUE - Information

    GREEN - Task Completed

    YELLOW - Task to be under Execution

    PURPLE - AutoBot speaks

[?] in..

    RED - A Question is asked

[>] in..

    CYAN - An Answer is Expected :P

This method of coloring is **Relevant_Coloring** and is inspired from [a scene in Person of Interest](https://goo.gl/photos/s8YpQL1eBxSYwCWS7) and ADB Logs on a phone (Log types like E for Error, F for Fatal etc.)

#Automation Notes

Users can add their own commands in the default sequence ( I do it )

For Automating ScriBt

1. PREF.rc must have your Desired Values for all Variables listed

2. Enter this on Terminal to Start with Automation

```
bash ROM.sh automate
```

#####Functions that can be automated

* sync
* pre_build **^**
* build
* the_cherries

**^** - The Device Tree must be Compatible with the ROM you're building (Extra Toolchain Configs, Overlays etc. **ROMNIS-fying is taken care of in Point 3b** ) Else, Issues :) :P

#Variables necessary for Automation

Since Vars have been removed from PREF.rc, those info will be seperately provided by me in the snippet below...

https://gist.github.com/a7r3/9fdbf9cca66c339cc87858960149ac09

#Device Types

* ```full``` - This indicates that the Device has **Adequate Storage Space** for building Entire Android System for it
* ```mini``` - This indicates that the Device has a **Low Storage Space**, so only Android Essentials are built ( Lesser Apps and Stuff )

* **common_full_phone, common_mini_phone** - An Android SmartPhone
* **common_full_tablet, common_mini_tablet, common_tablet** - An Android Tablet
* **common_full_tablet_lte** - A Tablet with LTE (4G) Functionality
* **common_full_tablet_wifionly** - A Tablet with Wi-Fi functionality
* **common_full_tv, common_mini_tv** - Android TV
* **common_full_hybrid_wifionly** - Android Device with any Size ( Phone / Tablet ) ( used if Device Type is unknown )

* NOTE : IF you're building for a Phone and common_full_phone / common_mini_phone isn't in the list, then press Enter (Leave Blank) as the ROM will consider the Device as a Phone.

#Building Android

* **Jack** was introduced as a **Toolchain** from MarshMallow onwards for **Apps and Frameworks**.
    - Uses a Java VM for compilation of Java Source Code (.java) to '.dex' (**D**alvik **Ex**ecutable) files
    - Recommended for Systems having >8GB RAM.
    - Systems with 4GB RAM can use it too, but it may cause heavy lags on compilation, so using Swap memory is Recommended for such users.

* **Ninja** was introduced from Android Nougat (7.x.x) as an Alternative **Build System**.
    - No Compatibility Requirements.
    - Some Features of it are Quicker Incremental Builds, and showing Progress of Build on compilation

* Companions for Ninja (iirc), which were introduced in Nougat are...
    - **Kati** - https://android.googlesource.com/platform/build/kati/#kati
    - **Soong** - https://android.googlesource.com/platform/build/soong#Soong
    - **BluePrint** - https://android.googlesource.com/platform/build/blueprint/#Blueprint-Build-System

So, the ways of Building Android are...

* Using **Normal** Build System
    - **with** Jack Toolchain (MarshMallow onwards)
    - **without** Jack Toolchain (Till Nougat)
* Using **Ninja** Build System
    - **with** Jack Toolchain (Nougat onwards)
    - **without** Jack Toolchain (Nougat onwards)

#CONTRIBUTORS

* Arvindraj "a7r3" (Myself)
* Adrian DC "AdrianDC"
* Akhil Narang "akhilnarang"
* CubeDev
* nosedive
* Many more as this goes public

#Supported ROMs

1. AICP
2. AOKP
3. AOSiP
4. AOSP-CAF
5. AOSP-RRO
6. BlissRoms
7. CandyRoms
8. CarbonROM
9. crDroid
10. Cyanide-L
11. CyanogenMod
12. DirtyUnicorns
13. Flayr OS
14. Krexus-CAF
15. OctOs
16. OmniROM
17. Orion OS
18. OwnROM
19. PAC-ROM
20. AOSPA
21. Resurrection Remix
22. SlimRoms
23. Temasek
24. GZR Tesla
25. Tipsy OS
26. GZR Validus
27. VanirAOSP
28. XenonHD
29. XOSP
30. Zephyr-Os

**More ROMs will be added, if missed 'em**

#Happy ScriBting!
