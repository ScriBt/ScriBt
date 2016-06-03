# Projekt ScriBt

#####ROM Sync && Build Script for Learning Developers

This is still a WiP script. Extensive Testing needed.

The Script consists of five main Actions:

#####1. Init -

  a. Choose a ROM

  b. Initialize it's Repo

#####2. Sync -

  a. Add a local_manifest for Device Specfic things

  b. Sync the Sources

#####3. Pre Build -

  Add Device to the ROM Vendor, that's all

#####4. Build -

  a. Build the Entire ROM

  b. Clean /out Entirely or only Staging Directories

  c. Make a Particular Module

  d. Setup CCACHE

#####5. Install Deps and Java

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

Automation is still a WiP i.e. it needs Extensive Testing in every way!

For Automating the ScriBt

1. PREF.rc must have your Desired Values in all Functions

2. Enter this on Terminal to Start with Automation

```
bash ROM.sh automate
```

#CONTRIBUTORS

* Arvind Raj "a7r3" (Myself)
* Adrian DC "AdrianDC"
* Akhil Narang "akhilnarang"
* Many more as this goes public

#Supported ROMs

* Android Ice Cold Project aka AICP
* Android Open Kang Project aka AOKP
* Android Open Source Project - CAF aka AOSP-CAF
* Android Open Source Project with RRO aka AOSP-RRO
* CandyRoms
* Cyanide-L
* CyanogenMod
* Dirty Unicorns
* GZR Tesla
* GZR Validus
* Krexus - CAF
* OmniROM
* Orion
* OwnROM
* PAC-ROMs
* Resurrection Remix
* SlimRoms
* Temasek
* TipsyOs
* XenonHD by Team Horizon
* Xperia Open Source Project aka XOSP

More ROMs will be added, if missed 'em

#Happy ScriBting!
