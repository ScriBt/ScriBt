
![ScriBt in Action](http://i.imgur.com/5p97f9i.png?2)

#####ROM Sync && Build Script for Learning Developers

Ready to use. Extensive Testing needed.

ScriBt consists of five main Actions:

#####1. Init -

  a. Choose a ROM

  b. Initialize it's Repo

  c. Add a local_manifest for Device Specfic Additions / Changes

#####2. Sync

  Sync the Sources - Setting Sync Options / Flags available

#####3. Pre Build -

  Add Device to the ROM Vendor, that's all

#####4. Build -

  a. Build the Entire ROM

    * Clean /out Entirely or only Staging Directories

    * Start Build

  c. Make a Particular Module

  d. Setup CCACHE

  e. Give comments based on the Final Build Status

    * Build Success

    * no rule to make target: /out/*****/{MODULE_NAME}_intermediates - Search for MODULE_NAME in Build, Else give Search Suggestions based on MODULE_NAME

    * Arbitrary Error (Can't help because Entropy of Increase in Errors gets Incremented day by day :P)

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

Automation Works are complete, though it needs testing in every way! Users can add their own commands in the default sequence ( I do it )

For Automating ScriBt

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
17. Resurrection Remix
18. SlimRoms
19. Temasek
20. GZR Tesla
21. TipsyOs
22. GZR Validus
23. XenonHD by Team Horizon
24. Xperia Open Source Project aka "XOSP"

More ROMs will be added, if missed 'em

#Happy ScriBting!
