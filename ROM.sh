#!/bin/sh
#Initialize
BLANK=$(echo -e '\n');
source $(pwd)/ROM.rc;
echo "=======================================================";
echo "Before i can start, do you like a Colorful life? [y/n]";
echo "=======================================================";
read COLOR;
if [[ "$COLOR" == y ]]; then
	color_my_life;
#else
#	i_like_colourless;
fi
clear;
echo -e '\n\n';
echo -e "${ORNG}             88P'888'Y88         888                          ${NONE}";
echo -e "${ORNG}             P'  888  'Y  ,e e,  888 ee                       ${NONE}";
echo -e "${ORNG}                 888     d88 88b 888 88b                      ${NONE}";
echo -e "${ORNG}                 888     888   , 888 888                      ${NONE}";
echo -e "${ORNG}                 888      \"YeeP\" 888 888                      ${NONE}";
echo -e " ";
echo -e "${BLU} ad88888ba                           88  88888888ba           ${NONE}";
echo -e "${BLU}d8\"     \"8b                          \"\"  88      \"8b    ,d    ${NONE}";
echo -e "${BLU}Y8,                                      88      ,8P    88    ${NONE}";
echo -e "${BLU}\`Y8aaaaa,     ,adPPYba,  8b,dPPYba,  88  88aaaaaa8P'  MM88MMM ${NONE}";
echo -e "${BLU}  \`\"\"\"\"\"8b,  a8\"     \"\"  88P'   \"Y8  88  88\"\"\"\"\"\"8b,    88    ${NONE}";
echo -e "${BLU}\`8b      8b  8b          88          88  88       8b    88    ${NONE}";
echo -e "${BLU}Y8a     a8P  \"8a,   ,aa  88          88  88      a8P    88,   ${NONE}";
echo -e "${BLU} \"Y88888P\"    \`\"Ybbd8\"'  88          88  88888888P\"     \"Y888 ${NONE}";
echo -e '\n';
echo -e "${CYAN} ~#~#~#~#~#~#~#~#~#~#~#~# By Arvind7352 @XDA #~#~#~#~#~#~#~#~#~#~#~#~ ${NONE}";
sleep 3;
#GET THOSE ROOMS
echo -e '\n\n';
echo -e "${LPURP}=======================================================${NONE}";
echo -e '\n';
echo -e "Which ROM are you trying to build?
Choose among these (Number Selection)
${BLANK}
1.${BLU} AICP ${NONE}
2.${RED} AOKP ${NONE}
3.${LGRN} AOSP-RRO ${NONE}
5.${CYAN} CyanogenMod ${NONE}
6.${ORNG} DirtyUnicorns ${NONE}
7.${GRN} OmniROM ${NONE}
8.${PURP} OrionOS ${NONE}
9.${BLU} PAC-ROM ${NONE}
10.${LRED} Resurrection Remix ${NONE}
11.${LBLU} GZR Tesla ${NONE}
12.${YELO} TipsyOS ${NONE}
13.${LPURP} GZR Validus ${NONE}
14.${LCYAN} XenonHD by Team Horizon ${NONE}
15.${BLU} Xperia Open Source Project aka XOSP ${NONE}
16.${LBLU} SlimRoms ${NONE}
${BLANK}
${LPURP}=======================================================${NONE}";
echo -e '\n\n';
read ROMNO;
sleep 1;
#
rom_name_in_github;
#
echo -e "You have chosen ${LCYAN}->${NONE} $ROM_FN";
sleep 1;
echo -e '\n';
echo "Since Branches may live or die at any moment, specify the Branch you're going to sync"
read BRANCH;
echo -e '\n';
echo "Let's sync it!";
echo -e '\n';
echo "Number of Threads for Sync?";
echo -e '\n';
read JOBS;
echo "Force Sync needed? [y/n]";
echo -e '\n';
read FRC;
echo "Need some Silence in teh Terminal? [y/n]";
echo -e '\n';
read SILENT;
echo "Any Source you have already synced? If yes, then say YES (press ENTER) and then specify it's location from / ";
echo -e '\n';
read REFY;
read REF;
echo -e '\n';
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

echo "=========================================================";
echo -e '\n';
echo "Let's Initialize teh ROM Repo";
echo -e '\n';
repo init "$REF" -u https://github.com/"$ROM_NAME"/"$MAN" -b "$BRANCH" ;
echo -e '\n';
echo "Repo Init'ed";
echo -e '\n';
echo "=========================================================";
echo -e '\n';
echo "Now Create a \"local_manifests.xml\" file and add your Device, Kernel, Vendor and other Device-Specific Sources. Press \"ENTER\" After it's Done";
read ENTER;
echo -e '\n';
echo "Let's Sync!";
echo -e '\n';
repo sync -j${JOBS} ${SILENT} ${FRC} ;
echo -e '\n';
echo "DONE!";
echo "=========================================================";
echo -e '\n\n';
echo -e "=======================DEVICE INFO======================="
echo "What's your Device's Good CodeName (Look at your Device tree and answer)?";
read DEVICE;
echo "The Build type? (userdebug/user/eng)";
echo BTYP;
echo "Your Device's Company/Vendor (All Lowercases)?";
read COMP;
echo "=========================================================";
rom_name_in_source;
echo -e '\n\n'
echo "=========================================================";
echo "Now, there are Four Strategies of Adding your device to the ROM vendor so that The ROM can get built for your device. Choose the file which you find in vendor/${ROMNIS}";
echo "vendorsetup.sh (Enter 1)";
echo "${ROMNIS}.devices (Enter 2)";
echo "Synced AOSP-RRO / AOSP-CAF ? (Enter 3)";
echo "You see a folder named \'products\' inside teh folder (Enter 4)";
read STRT;
echo -e '\n';
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
echo "Need to create a vendorsetup.sh - I'll create that for you if it isn't";
if [[ $(-f vendorsetup.sh) != 1 ]]; then
touch vendorsetup.sh;
fi
echo "Open that file and Enter the following contents";
echo -e '\n'
echo "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}";
fi

if [[ $STRT == 4 ]]; then
	echo "This Strategy, AFAIK was only on AOKP (kitkat) and PAC-ROM (pac-5.1).";
	echo "Let's go to vendor/$ROMNIS/products";
	cd vendor/${ROMNIS}/products;
	${BLANK}
	echo"Done.";
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
fi
if [[ "$ROMNIS" == aokp ]]; then
	${BLANK}
	echo "WIP WIP!";
fi
echo -e '\n\n'
echo "Now ${ROMNIS}fy! your Device Tree! Press Enter when DONE ";
read NOOB;
echo "========================================================="
echo -e '\n\n';
echo "Now start the build process! The Script's work is DONE. Enjoy!";
echo "Thanks for using this script!";
sleep 3;
echo -e '\n';
echo "Are you feeling even lazy to start the Build? OH, COME ON! -(these commands)- . build/envsetup.sh lunch ${ROMNIS}_${DEVICE}-${BTYP}";
echo -e '\n';
echo "I_IZ_NOOB :P";
