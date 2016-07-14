
![ScriBt in Action](http://i.imgur.com/5p97f9i.png?2)

#####ROM Sync && Build Script for Learning Developers

Ready to use. Extensive Testing needed.

(**Tip!** : **ROMNIS** - **ROM** **N**ame **I**n **S**ource - eg. cm, bliss, candy, crdroid etc.)

ScriBt consists of five main Actions:

#####1. Init -

a. **Choose** a ROM

b. **Initialize** it's Repo

c. **Add** a local_manifest for Device Specfic Additions / Changes

#####2. Sync

**Sync** the Sources - Setting Sync Options / Flags available

#####3. Pre Build -

a. **Add Device** to ROM Vendor
  
b. Make an **Interactive Makefile** under Device Tree (Identifiable by ROM's BuildSystem)
    
  * This was created in order to prevent unnecessary Modifications to already present files in the Device Tree and messing it up eventually...
    
  * Idea came into existence, When I saw most of the ROMs (... not having ```products``` folder in ROM vendor && excluding AOSP-CAF/AOSP-RRO) having these lines in one of the BuildSystem's files...
  
  ```# A ROMNIS build needs only the ROMNIS product makefiles.```
    
  ```ifneq ($(ROMNIS_BUILD),)
    all_product_configs := $(shell ls device/*/$(ROMNIS_BUILD)/ROMNIS.mk)```

#####4. Build -

a. Build the Entire ROM

   * **Clean** /out Entirely or only Staging Directories

   * **Start** Build

b. Make a Particular Module

c. Setup **CCACHE**

d. Give **comments** based on the Final Build Status

   * Build Success

   * ```no rule to make target: /out/*****/{MODULE_NAME}_intermediates``` - Search for ```MODULE_NAME``` in Build, Else give Search Suggestions based on ```MODULE_NAME```

   * Arbitrary Error (Can't help because Entropy of Increase in Errors gets Incremented day by day :P)
 
#####5. Install Deps

a. Install Build Dependencies

b. Install / Configure **JAVA**

c. Setup **android-51** rules (For proper usage of ADB)

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

Automation Works are complete, though it needs testing in every way! Users can add their own commands in the default sequence ( I do it )

For Automating ScriBt

1. PREF.rc must have your Desired Values in all Functions

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

#CONTRIBUTORS

* Arvind Raj "a7r3" (Myself)
* Adrian DC "AdrianDC"
* Akhil Narang "akhilnarang"
* CubeDev
* Many more as this goes public

#Supported ROMs

1. Android Ice Cold Project aka "AICP"
2. Android Open Kang Project aka "AOKP"
3. Android Open Source Project - CAF aka "AOSP-CAF"
4. Android Open Source Project with RRO aka "AOSP-RRO"
5. BlissRoms
6. CandyRoms
7. crDroid
8. Cyanide-L
9. CyanogenMod
10. Dirty Unicorns
11. FlayrOS
12. Krexus - CAF
13. OmniROM
14. OrionOS
15. OwnROM
16. PAC-ROMs
17. Paranoid Android aka AOSPA
18. Resurrection Remix
19. SlimRoms
20. Temasek
21. GZR Tesla
22. TipsyOs
23. GZR Validus
24. XenonHD by Team Horizon
25. Xperia Open Source Project aka "XOSP"

More ROMs will be added, if missed 'em

#Happy ScriBting!
