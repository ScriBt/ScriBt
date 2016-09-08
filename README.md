
![ScriBt in Action](http://i.imgur.com/5p97f9i.png?2)

#####ROM Sync && Build Script for Learning Developers

Ready to use. Extensive Testing needed.

**Tip!** : **ROMNIS** - **ROM** **N**ame **I**n **S**ource - eg. cm, bliss, candy, crdroid etc.

ScriBt consists of five main Actions:

#1. Init

a. **Choose** a ROM

b. **Initialize** it's Repo

c. **Add** a local_manifest for Device Specfic Additions / Changes

#2. Sync

**Sync** the Sources - Setting Sync Options / Flags available

#3. Pre Build

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

b. Install / Configure **JAVA**

c. Setup **android-51** rules (For proper usage of ADB)

d. Revert to make 3.81

e. CCACHE Setup

#6. Automated Cherry Picking

as said before,
#Extensive Testing is needed.


#Usage
```
bash ROM.sh
```

##### Why not ./ROM.sh
```exit``` command will close the terminal when script is called in that
way, bash ROM.sh won't :D

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

# Device Types

* ```full``` - This indicates that the Device has **Adequate Storage Space** for building Entire Android System for it
* ```mini``` - This indicates that the Device has a **Low Storage Space**, so only Android Essentials are built ( Lesser Apps and Stuff )

* **common_full_phone, common_mini_phone** - An Android SmartPhone
* **common_full_tablet, common_mini_tablet, common_tablet** - An Android Tablet
* **common_full_tablet_lte** - A Tablet with LTE (4G) Functionality
* **common_full_tablet_wifionly** - A Tablet with Wi-Fi functionality
* **common_full_tv, common_mini_tv** - Android TV
* **common_full_hybrid_wifionly** - Android Device with any Size ( Phone / Tablet ) ( used if Device Type is unknown )

* NOTE : IF you're building for a Phone and common_full_phone / common_mini_phone isn't in the list, then press Enter (Leave Blank) as the ROM will consider the Device as a Phone.

# Building Android

* **Jack** was introduced as a **Toolchain** from MarshMallow onwards for **Apps and Frameworks**.
	- Uses a Java VM for compilation of Java Source Code (.java) to '.dex' (**D**alvik **Ex**ecutable) files
	- Recommended for Systems having >8GB RAM.
	- Systems with 4GB RAM can use it too, but it may cause heavy lags on compilation, so using Swap memory is Recommended for such users.

* **Ninja** was introduced from Android Nougat (7.x.x) as an Alternative **Build System**.
	- No Compatibility Requirements.

* Companions for Ninja (iirc), which were introduced in Nougat are...
	- **Kati** - https://android.googlesource.com/platform/build/kati/#kati
	- **Soong** - https://android.googlesource.com/platform/build/soong#Soong
	- **BluePrint** - https://android.googlesource.com/platform/build/blueprint/#Blueprint-Build-System

So, the ways of Building Android are...

* Using **Normal** Build System
	- Using Jack Toolchain (MarshMallow onwards)
	-  Not Using Jack Toolchain (Till Nougat)
* Using **Ninja** Build System
	- **with** Jack Toolchain (Nougat onwards)
	- **without** Jack Toolchain (Nougat onwards)

#CONTRIBUTORS

* Arvindraj "a7r3" (Myself)
* Adrian DC "AdrianDC"
* Akhil Narang "akhilnarang"
* CubeDev
* Many more as this goes public

#Supported ROMs

1. AICP
2. AOKP
3. AOSiP
4. AOSP-CAF
5. AOSP-RRO
6. BlissRoms
7. CandyRoms
8. crDroid
9. Cyanide-L
10. CyanogenMod
11. Dirty Unicorns
12. FlayrOS
13. Krexus - CAF
14. OmniROM
15. OrionOS
16. OwnROM
17. PAC-ROMs
18. Paranoid Android / AOSPA
19. Resurrection Remix
20. SlimRoms
21. Temasek
22. GZR Tesla
23. TipsyOs
24. GZR Validus
25. XenonHD by Team Horizon
26. XOSP
27. Zephyr-OS

More ROMs will be added, if missed 'em

#Happy ScriBting!
