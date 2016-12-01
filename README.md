
![ScriBt in Action](http://i.imgur.com/5p97f9i.png?2)

**ROM Sync && Build Script for Learning Developers**

Ready to use. Extensive Testing needed.

**Now at [XDA-Developers](http://forum.xda-developers.com/chef-central/android/guide-tool-projekt-scribt-v1-33-t3503018)**

**Supports Ubuntu & Debian based Distros, and ArchLinux**

**Tip!** : **ROMNIS** - **ROM** **N**ame **I**n **S**ource - eg. cm, bliss, candy, crdroid etc.

ScriBt consists of five main Actions:

#1. Init

a. **Choose** a ROM

b. **Initialize** its Repo

c. **Add** a local_manifest for Device Specfic Additions / Changes

#2. Sync

**Sync** the Sources - Setting Sync Options / Flags available

#3. Pre Build

**The Biggest Part/Function of ScriBt**

a. **Add Device** to ROM Vendor

b. Make an **Interactive Makefile** under the Device Tree (Identifiable by ROMs BuildSystem)

  * This was created in order to prevent unnecessary modifications to already present files in the Device Tree and messing it up

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

   * Arbitrary Error (Can't be helped due to entropy of increase in errors which increases day by day :P)

#5. Tools

a. Install Build Dependencies based on Distro Version

b. Install / Configure **Java**

c. Setup **android-51** rules (For proper usage of ADB)

d. Revert to make 3.81

e. CCACHE Setup

f. Add/Update Git Credentials

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
The script terminates with ```exit``` after its run. Unless you run the script under a new shell, it will close your existing shell.

#What do the colors mean ?

![Colors](https://cloud.githubusercontent.com/assets/14874906/20798870/6f6693e0-b806-11e6-81cc-9bde431a4e5a.png)

[!] in..

    RED - The Particular Task has Failed / User has Entered an Incorrect Value

    BLUE - Information

    GREEN - Task Completed

    YELLOW - Task to be under Execution

    PINK - AutoBot speaks

[?] in..

    RED - A Question is asked

[>] in..

    CYAN - An Answer is Expected :P

[#] in..

    PINK - Root Access Prompt

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

#Transferability

```bash ROM.sh cd <directory>```

1st Parameter - Indicates that you want to transfer it - alias is 'cd' to make it similiar with the 'cd' command

2nd Parameter - The directory to which you need to transfer ScriBt

Make sure you enter a proper directory, which has **read/write permissions**. This action will **transfer** ScriBt to the directory mentioned by the user as well as **execute** it from that directory.

If you want to automate the ScriBt after changing directory, then 3rd Parameter should be 'automate'. It'd look like this...

```bash ROM.sh cd <directory> automate```

# Updates

ScriBt is updated on the basis of the Version Number mentioned in a file named VERSION

**Do not try to EDIT it**

If the Version Number in GitHub is more than the Local Version number, then ScriBt will prompt the user to update.
If there are modifications present in the old version, then ScriBt moves it to a folder named 'old'. You will find your old Scripts there.

```upScriBt``` does the Updating work.

**ROM.sh** first checks for a newer version of upScriBt.sh and **downloads it** if available.
**upScriBt.sh then **checks updates** for the other files on the basis of the above Procedure

#Device Types

* ```full``` - This indicates that the Device has **Adequate Storage Space** for building Entire Android System for it
* ```mini``` - This indicates that the Device has **Low Storage Space**, so only Android Essentials are built ( Fewer Apps and Stuff )

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
    - Recommended for Systems with >8GB RAM.
    - Systems with 4GB RAM can use it too, but it may cause lag during compilation, so using Swap is recommended for such users.

* **Ninja** was introduced from Android Nougat (7.x.x) as an alternative **Build System**.
    - No compatibility requirements.
    - Some features of it are quicker incremental builds, and showing progress of the build on compilation

* Companions for Ninja (iirc), which were introduced in Nougat are...
    - **Kati** - https://android.googlesource.com/platform/build/kati/#kati
    (AFAIK, It Generates a .ninja file, in BluePrint Language, which guides through the build process...)
    - **Soong** - https://android.googlesource.com/platform/build/soong#Soong
    - **BluePrint** - https://android.googlesource.com/platform/build/blueprint/#Blueprint-Build-System
    (A Language...)

So, the ways of building Android are...

* Using **Normal** Build System
    - **with** Jack Toolchain (MarshMallow onwards)
    - **without** Jack Toolchain (Till Nougat)
* Using **Ninja** Build System
    - **with** Jack Toolchain (Nougat onwards)
    - **without** Jack Toolchain (Nougat onwards)

#Contributors

* Arvindraj "a7r3" (Myself)
* Adrian DC "AdrianDC"
* Akhil Narang "akhilnarang"
* Tom Radtke "CubeDev"
* nosedive

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

**More ROMs will be added**

#Happy ScriBting!
