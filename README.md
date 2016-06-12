# Projekt ScriBt

#####ROM Sync && Build Script for Learning Developers

This is still a WiP script. Extensive Testing needed.

The Script consists of five main Actions:

#####1. Init -

  a. Choose a ROM

  b. Initialize it's Repo

  c. Add a local_manifest for Device Specfic things

#####2. Sync -  Sync the Sources

#####3. Pre Build -

  Add Device to the ROM Vendor, that's all

#####4. Build -

  a. Build the Entire ROM

  b. Clean /out Entirely or only Staging Directories

  c. Make a Particular Module

  d. Setup CCACHE

#####5. Install Deps

  a. Install Build Dependencies

  b. Install / Configure JAVA

  c. Setup android-51 rules (For proper usage of ADB)

#####6. Automated Cherry Picking

as said before,
#Extensive Testing is needed.


#####Usage
```
bash ROM.sh
```

##### Why not ./ROM.sh
```exit``` command will close the terminal when script is called in that
way, bash ROM.sh won't :D

#####Automation Notes

Automation Works are complete, though it needs testing in every way!

For Automating the ScriBt

1. PREF.rc must have your Desired Values in all Functions

2. Enter this on Terminal to Start with Automation

```
bash ROM.sh automate
```

#####Functions that can be automated

* sync
* pre_build ^
* build
* the_cherries

^ - The Device Tree must be Compatible with the ROM you're building. Else, Issues :) :P

#CONTRIBUTORS

* Arvind Raj "a7r3" (Myself)
* Adrian DC "AdrianDC"
* Akhil Narang "akhilnarang"
* Many more as this goes public

#Supported ROMs

* Android Ice Cold Project aka "AICP"
* Android Open Kang Project aka "AOKP"
* Android Open Source Project - CAF aka "AOSP-CAF"
* Android Open Source Project with RRO aka "AOSP-RRO"
* BlissRoms
* CandyRoms
* Cyanide-L
* CyanogenMod
* Dirty Unicorns
* FlayrOS
* GZR Tesla
* GZR Validus
* Krexus - CAF
* OmniROM
* OrionOS
* OwnROM
* PAC-ROMs
* Resurrection Remix
* SlimRoms
* Temasek
* TipsyOs
* XenonHD by Team Horizon
* Xperia Open Source Project aka "XOSP"

More ROMs will be added, if missed 'em

#Happy ScriBting!
