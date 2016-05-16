#!/bin/sh
clear
echo "Teh ROM Builder";
echo "By Arvind7352 @XDA";
sleep 3;
#Initialize
source $(pwd)/ROM.rc;
#GET THOSE ROOMS
cat << _ROM_
Which ROM are you trying to build? Choose among these (Enter teh corresponding number for selection)

1. AICP
2. AOKP
3. AOSP-CAF
4. AOSP-RRO
5. CyanogenMod
6. DirtyUnicorns
7. OmniROM
8. OrionOS
9. PAC-ROM
10. Resurrection Remix
11. GZR Tesla
12. TipsyOS
13. GZR Validus
14. XenonHD by Team Horizon
15. Xperia Open Source Project aka XOSP

_ROM_
echo "";
echo "";
read ROMNO;
sleep 1;
echo "";
echo "";
#
rom_name_in_github;
#
echo "You have chosen $ROM_NAME";
sleep 1;
echo "Since Branches may live or die at any moment, specify the Branch you're going to sync"
read BRANCH;
BRNC=-b\t${BRANCH};
echo "";
echo "Let's sync it!";
echo "";
echo "Number of Threads for Sync?";
read JOBS;
echo "";
echo "Force Sync needed? [y/n]";
read FRC;
echo "";
echo "Need some Silence in teh Terminal? [y/n]";
read SILENT;
echo "";
echo "Any Source you have already synced? If yes, then say YES (press ENTER) and then specify it's location from / ";
read REFY;
read REF;
echo "";
#Getting Manifest Link
if [[ "$ROM_NAME" == OmniROM || "$ROM_NAME" == CyanogenMod ]]; then
	MAN=android.git;
fi
if [[ "$ROM_NAME" == TeamOrion || "$ROM_NAME" == AOSP-CAF || "$ROM_NAME" == ResurrectionRemix || "$ROM_NAME" == AOKP || "$ROM_NAME" == TipsyOS || "$ROM_NAME" == AICP || "$ROM_NAME" == XOSP-Project ]]; then
	MAN=platform_manifest.git;
fi
if [[ "$ROM_NAME" == DirtyUnicorns ]]; then
	MAN=android_manifest.git;
fi
if [[ "$ROM_NAME" == AOSP-RRO || "$ROM_NAME" == ValidusOs-M || "$ROM_NAME" == Tesla-M ]]; then
	MAN=manifest.git;
fi
if [[ "$ROM_NAME" == PAC-ROM ]]; then
	MAN=pac-rom.git;
fi
#Sync-Options
if [[ "$SILENT" == y ]]; then
  SILENT=-q;
else
  SILENT= ;
fi
if [[ "$FRC" == y ]]; then
  FRC=--force-sync;
else
  FRC= ;
fi
if [[ "$REFY" == YES ]]; then
	REF=--reference\=\"${REF}\"
else
	REF= ;
fi

#Naming && Syncing
echo "Name your Build Directory";
read DIR;
mkdir $DIR;
cd $DIR;

echo "========================================================="

echo "Let's Initialize teh ROM Repo";
repo init "$REF" -u https://github.com/"$ROM_NAME"/"$MAN" ${BRNC} ;
echo "";
echo "Repo Init'ed";
echo "";
echo "Now Create a \"local_manifests.xml\" file and add your Device, Kernel, Vendor and other Device-Specific Sources. Press \"ENTER\" After it's Done";
read ENTER;
echo "Let's Sync!";
repo sync -j${JOBS} ${SILENT} ${FRC} ;
echo "DONE!";

echo "========================================================="

echo "What's your Device's Good CodeName (Look at your Device tree and answer)?";
read DEVICE;
echo "The Build type? (userdebug/user/eng)";
echo BTYP;
echo "Your Device's Company/Vendor (All Lowercases)?";
read COMP;

rom_name_in_source;

echo "Now, there are Four Strategies of Adding your device to the ROM vendor so that The ROM can get built for your device. Choose the file which you find in vendor/${ROMNIS}";
echo "vendorsetup.sh (Enter 1)";
echo "${ROMNIS}.devices (Enter 2)";
echo "Synced AOSP-RRO / AOSP-CAF ? (Enter 3)"
echo "You see a folder named \'products\' inside teh folder (Enter 4)";
read STRT;

if [[ $STRT == 1 ]]; then
	echo "Add this line at teh end of vendorsetup.sh";
	echo "add_lunch_combo ${ROMNIS}_${DEVICE}_${BTYP}";
fi

if [[ $STRT == 2 ]]; then
	echo "Open ${ROMNIS}.devices file";
	echo "Insert this at the End of the File";
	echo "${DEVICE}";
fi

if [[ "$STRT" == 3 ]]
echo "Let's go to teh Device Directory!";
cd $(pwd)/device/${COMP}/${DEVICE};
echo "Need to create a vendorsetup.sh - I'll create that for you if it isn't"
if [[ $(-f vendorsetup.sh) != 1 ]]; then
touch vendorsetup.sh;
fi
echo "Open that file and Enter the following contents";
echo "";
echo "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}"
fi

if [[ $STRT == 4 ]]; then
	echo "This Strategy, AFAIK was only on AOKP (kitkat) and PAC-ROM (pac-5.1)."
	echo "Let's go to vendor/$ROMNIS/products";
	cd vendor/${ROMNIS}/products
	echo"\nDone."
if [[ "$ROMNIS" == pac]]; then
	echo "Creating file ${ROMNIS}_${DEVICE}.mk";
	touch ${ROMNIS}_${DEVICE}.mk
else
	echo "Creating file ${DEVICE}.mk";
	touch ${DEVICE}.mk
fi
	echo "\nDone. Open that file now."
	echo "\nAdd these lines";
if [[ "$ROMNIS" == pac ]]; then
	echo "FAIL. WIP";
if [[ "$ROMNIS" == aokp ]]; then
	echo "";
	echo "WIP WIP!";
fi

echo "Now ${ROMNIS}fy! your Device Tree! Press Enter when DONE ";
read NOOB;
echo "========================================================="
echo "Now start the build process! The Script's work is DONE. Enjoy!";
echo "Thanks for using this script!";
sleep 3;
echo "Are you feeling even lazy to start the Build? OH, COME ON! -(these commands)- \n. build/envsetup.sh \nlunch ${ROMNIS}_${DEVICE}-${BTYP}";
echo "";
echo "I_IZ_NOOB :P";
