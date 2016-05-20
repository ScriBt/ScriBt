#!/bin/bash
#=========================Projekt ScriBt===========================#
# This Script and ROM.rc has to be placed under a Synced Source
# Directory (if and only if you're using this script to build)
#
# Else place these files at your Desired Location
#
# https://github.com/a7r3/scripts - The Original Repo of this ScriBt
#
#==================================================================#
#Initialize
BLANK=$(echo -e '\n');
source $(pwd)/ROM.rc;
echo "=======================================================";
echo "Before i can start, do you like a Colorful life? [y/n]";
echo "=======================================================";
read COLOR;
if [[ "$COLOR" == y ]]; then
	color_my_life;
else
	i_like_colourless;
fi
clear;
echo -e '\n\n';
sleep 0.1;
echo -e "${ORNG}             88P'888'Y88         888                          ${NONE}";
sleep 0.1;
echo -e "${ORNG}             P'  888  'Y  ,e e,  888 ee                       ${NONE}";
sleep 0.1;
echo -e "${ORNG}                 888     d88 88b 888 88b                      ${NONE}";
sleep 0.1;
echo -e "${ORNG}                 888     888   , 888 888                      ${NONE}";
sleep 0.1;
echo -e "${ORNG}                 888      \"YeeP\" 888 888                      ${NONE}";
sleep 0.1;
echo -e " ";
sleep 0.1;
echo -e "${BLU} ad88888ba                           88  88888888ba           ${NONE}";
sleep 0.1;
echo -e "${BLU}d8\"     \"8b                          \"\"  88      \"8b    ,d    ${NONE}";
sleep 0.1;
echo -e "${BLU}Y8,                                      88      ,8P    88    ${NONE}";
sleep 0.1;
echo -e "${BLU}\`Y8aaaaa,     ,adPPYba,  8b,dPPYba,  88  88aaaaaa8P'  MM88MMM ${NONE}";
sleep 0.1;
echo -e "${BLU}  \`\"\"\"\"\"8b,  a8\"     \"\"  88P'   \"Y8  88  88\"\"\"\"\"\"8b,    88    ${NONE}";
sleep 0.1;
echo -e "${BLU}\`8b      8b  8b          88          88  88       8b    88    ${NONE}";
sleep 0.1;
echo -e "${BLU}Y8a     a8P  \"8a,   ,aa  88          88  88      a8P    88,   ${NONE}";
sleep 0.1;
echo -e "${BLU} \"Y88888P\"    \`\"Ybbd8\"'  88          88  88888888P\"     \"Y888 ${NONE}";
sleep 0.1;
echo -e '\n';
sleep 0.1;
echo -e "${CYAN}~#~#~#~#~#~#~#~#~#~#~ By Arvind7352 @XDA #~#~#~#~#~#~#~#~#~#~${NONE}";
sleep 3;
#GET THOSE ROOMS
echo -e '\n\n';

function main_menu
{
	echo -e "${LRED}=======================================================${NONE}";
	echo -e "${LRED}====================${NONE}${CYAN}[*]${NONE}${PURP}MAIN MENU${NONE}${CYAN}[*]${NONE}${LRED}====================${NONE}";
	echo -e "${LRED}=======================================================${NONE}";
	echo -e '\n';
	echo -e "         Select the Action you want to perform         ";
	echo -e '\n';
	echo -e "${LBLU}1${NONE}${CYAN} .......................${NONE}${RED}Sync${NONE}${CYAN}........................${NONE} ${LBLU}1${NONE}";
	echo -e "${LBLU}2${NONE}${CYAN} .....................${NONE}${YELO}Pre-Build${NONE}${CYAN}.....................${NONE} ${LBLU}2${NONE}";
	echo -e "${LBLU}3${NONE}${CYAN} .......................${NONE}${GRN}Build${NONE}${CYAN}.......................${NONE} ${LBLU}3${NONE}";
	echo -e '\n';
	echo -e "4 .......................EXIT........................ 4";
	echo -e "${LRED}=======================================================${NONE}";
	echo -e '\n';
	read ACTION;
	teh_action;
} #main_menu

function teh_action
{
	if [[ "$ACTION" == 1 ]]; then
		sync;
	elif [[ "$ACTION" == 2 ]]; then
		pre_build;
	elif [[ "$ACTION" == 3 ]]; then
		build;
	elif [[ "$ACTION" == 4 ]]; then
		exitScriBt;
	fi
} #teh_action

function sync
{
	echo -e "${LPURP}=======================================================${NONE}";
	echo -e '\n';
	echo -e "Which ROM are you trying to build?
Choose among these (Number Selection)
${BLANK}
1.${BLU} AICP ${NONE}
2.${RED} AOKP ${NONE}
3.${LGRN} AOSP-RRO ${NONE}
4.${DGRAY} AOSP-CAF ${NONE}
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
	echo -e '\n';
	read ROMNO;
	sleep 1;
	#
	rom_name_in_github;
	#
	echo -e '\n';
	echo -e "You have chosen ${LCYAN}->${NONE} $ROM_FN";
	sleep 1;
	echo -e '\n';
	echo -e "Since Branches may live or die at any moment, ${LRED}Specify the Branch${NONE} you're going to sync"
	read BRANCH;
	echo -e '\n';
	echo -e "Let's sync it!";
	echo -e '\n';
	echo -e "${LRED}Number of Threads${NONE} for Sync?";
	echo -e '\n';
	read JOBS;
	echo -e '\n';
	echo -e "${LRED}Force Sync${NONE} needed? ${LGRN}[y/n]${NONE}";
	echo -e '\n';
	read FRC;
	echo -e '\n';
	echo -e "Need some ${LRED}Silence${NONE} in teh Terminal? ${LGRN}[y/n]${NONE}";
	echo -e '\n';
	read SILENT;
	echo -e '\n';
	echo -e "Any ${LRED}Source you have already synced?${NONE} If yes, then say YES and Press ${LCYAN}ENTER${NONE}";
	echo -e '\n';
	read REFY;
	echo -e '\n';
	if [[ "$REFY" == YES ]]; then
		echo -e "Provide me the ${LRED}Synced Source's Location${NONE} from / ";
		read REFER;
	fi
		echo -e '\n';
#Getting Manifest Link
		if [[ "$ROM_NAME" == OmniROM || "$ROM_NAME" == CyanogenMod ]]; then
				MAN=android.git;
		fi
		if [[ "$ROM_NAME" == TeamOrion || "$ROM_NAME" == SlimRoms || "$ROM_NAME" == AOSP-CAF || "$ROM_NAME" == ResurrectionRemix || "$ROM_NAME" == AOKP || "$ROM_NAME" == TipsyOS || "$ROM_NAME" == AICP || "$ROM_NAME" == XOSP-Project ]]; then
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
			REF=--reference\=\"${REFER}\"
		else
			REF= ;
		fi

	#Naming && Syncing
	echo -e "Name your Build Directory";
	read DIR;
	mkdir $DIR;
	cd $DIR;

	echo -e "${LBLU}=========================================================${NONE}";
	echo -e '\n';
	echo -e "Let's Initialize teh ROM Repo";
	echo -e '\n';
	repo init "$REF" -u https://github.com/"$ROM_NAME"/"$MAN" -b "$BRANCH" ;
	echo -e '\n';
	echo -e "Repo Init'ed";
	echo -e '\n';
	echo -e "${LBLU}=========================================================${NONE}";
	echo -e '\n';
	echo -e "Now Create a folder named local_manifests, create a \"local_manifest.xml\" file in it and add your Device, Kernel, Vendor and other Device-Specific Repo links. Press \"${LCYAN}ENTER${NONE}\" After it's ${LPURP}Done.${NONE}";
	read ENTER;
	echo -e '\n';
	echo -e "Let's Sync!";
	echo -e '\n';
	repo sync -j${JOBS} ${SILENT} ${FRC} ;
	echo -e '\n';
	echo -e "${LPURP}Done.${NONE}!";
	echo -e "${LRED}=========================================================${NONE}";
#Next ACTION to be Performed
echo -e '\n\n';
echo -e "${LRED}=========================================================${NONE}";
echo -e '\n';
echo -e " 2. Pre Build";
echo -e " ${CYAN}3${NONE}. ${GRN}Build${NONE}    ";
echo -e '\n';
echo -e " 4. EXIT     ";
echo -e "${LRED}=========================================================${NONE}";
read ACTION;
teh_action;

} #sync

function pre_build
{

	echo -e "${CYAN}Initializing Build Environment${NONE}"
	. build/envsetup.sh
	echo -e "${LPURP}Done.${NONE}."
	echo -e '\n\n';
	echo -e "${LCYAN}=======================DEVICE INFO=======================${NONE}";
	echo -e "What's your ${LRED}Device's CodeName${NONE} ${LGRN}[Refer Device Tree - All Lowercases]${NONE}?";
	echo -e '\n';
	read DEVICE;
	echo -e '\n';
	echo -e "The ${LRED}Build type${NONE}? ${LGRN}[userdebug/user/eng]${NONE}";
  echo -e '\n';
	read BTYP;
	echo -e '\n';
	echo -e "Your ${LRED}Device's Company/Vendor${NONE} (All Lowercases)?";
	echo -e '\n';
	read COMP;
	echo -e '\n';
	echo -e "${LCYAN}=========================================================${NONE}";
	rom_name_in_source;
	echo -e '\n\n'
	echo -e "${LPURP}=========================================================${NONE}";
	echo -e "Now, there are Four Strategies of Adding your device to the ROM vendor so that The ROM can get built for your device. Choose the file which you find in vendor/${ROMNIS}";
	echo -e "${BLU}vendorsetup.sh (${LCYAN}ENTER${NONE} 1)${NONE}";
	echo -e "${ORANGE}${ROMNIS}.devices (If saw that, ignore presence of vendorsetup.sh)(${LCYAN}ENTER${NONE} 2)${NONE}";
	echo -e "${PURP}Synced AOSP-RRO / AOSP-CAF ? (${LCYAN}ENTER${NONE} 3)${NONE}";
	echo -e "${GREEN}You see a folder named 'products' inside teh folder (${LCYAN}ENTER${NONE} 4)${NONE}";
	read STRT;
	echo -e '\n';
	if [[ $STRT == 1 ]]; then
		echo -e "Add this line at teh end of ${LBLU}vendorsetup.sh${NONE}";
		echo -e '\n';
		echo -e "add_lunch_combo ${ROMNIS}_${DEVICE}_${BTYP}";
	fi

	if [[ $STRT == 2 ]]; then
		echo -e "Open ${ROMNIS}.devices file";
		echo -e "Insert this at the End of the File";
		echo -e '\n';
		echo -e "${DEVICE}";
	fi

	if [[ "$STRT" == 3 ]]; then
		echo -e "Let's go to teh ${LRED}Device Directory!${NONE}";
		cd $(pwd)/device/${COMP}/${DEVICE};
		echo -e "Need to create a vendorsetup.sh - I'll create that for you if it isn't";
			if [[ $(-f vendorsetup.sh) != 1 ]]; then
				touch vendorsetup.sh;
			fi
		echo -e "Open that file and ${LCYAN}ENTER${NONE} the following contents";
		echo -e '\n'
		echo -e "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}";
		echo -e "${LPURP}Done.${NONE}. Let's go back."
		croot;
	fi
	if [[ $STRT == 4 ]]; then
		echo -e "This Strategy, AFAIK was only on AOKP (kitkat) and PAC-ROM (pac-5.1).";
		echo -e "Let's go to vendor/$ROMNIS/products";
		cd vendor/${ROMNIS}/products;
		echo -e '\n';
		echo -e "${LPURP}Done.${NONE}.";
			if [[ "$ROMNIS" == pac ]]; then
				echo -e "Creating file ${ROMNIS}_${DEVICE}.mk";
				touch ${ROMNIS}_${DEVICE}.mk
			else
				echo -e "Creating file ${DEVICE}.mk";
				touch ${DEVICE}.mk
			fi
	fi
		echo -e "\n${LPURP}Done.${NONE}. Open that file now."
		echo -e "\nAdd these lines";
			if [[ "$ROMNIS" == pac ]]; then
				echo -e "FAIL. WIP";
			fi
			if [[ "$ROMNIS" == aokp ]]; then
				${BLANK}
				echo -e "WIP WIP!";
			fi
		croot;
		echo -e '\n\n'
		echo -e "Now ${ROMNIS}fy! your Device Tree! Press ${LCYAN}ENTER${NONE} when ${LPURP}Done.${NONE} ";
		read NOOB;
		echo -e "${LPURP}=========================================================${NONE}"
		echo -e '\n\n';
		sleep 3;
		echo -e '\n';
		echo -e "I_IZ_NOOB :P";

		#Next ACTION to be Performed
		echo -e '\n\n';
		echo -e "${LRED}=========================================================${NONE}";
		echo -e '\n';
		echo -e " ${CYAN}1${NONE}. ${RED}Sync${NONE}    ";
		echo -e " ${CYAN}3${NONE}. ${GRN}Build${NONE}    ";
		echo -e '\n';
		echo -e " 4. EXIT     ";
		echo -e "${LRED}=========================================================${NONE}";
		read ACTION;
		teh_action;

} #pre_build

function build
{

	function make_module
	{
		echo -e "Do you know the build location of the Module?";
		read KNWLOC;
		if [[ "$KNWLOC" == y ]]; then
			make_it;
		else
			echo -e "Do either of these two actions: \n1. ${BLU}G${NONE}${RED}o${NONE}${YELO}o${NONE}${BLU}g${NONE}${GRN}l${NONE}${RED}e${NONE} it (Easier)\n2. Run this command in terminal : ${LBLU}sgrep \"LOCAL_MODULE := Insert_MODULE_NAME_Here \"${NONE}.\n\n Press ${LCYAN}ENTER${NONE} after it's ${LPURP}Done.${NONE}.";
			read OK;
			make_it;
		fi
	} #make_module

	function make_it #Part of make_module
	{
		echo -e "${LCYAN}ENTER${NONE} the Directory where the Module is made from";
		read MODDIR;
		echo -e "Do you want to ${LRED}push the Module${NONE} to the ${LRED}Device${NONE} ? (Running the Same ROM) ${LGRN}[y/n]${NONE}";
		read PMOD;
		if [[ "$PMOD" == y ]]; then
			mmmp -B $MODDIR;
		else
			mmm -B $MODDIR;
		fi
	} #make_it

	function set_ccache
	{
		echo -e "Setting up CCACHE"
		prebuilts/misc/linux-x86/ccache/ccache -M ${CCSIZE}G
		echo -e "CCACHE Setup Successful."
	} #set_ccache

	function set_ccvars
	{
		echo -e "Provide this Script Root-Access, so that it can write CCACHE export values. No Hacks Honestly (Check the Code)"
		echo -en "Why? Coz .bashrc or it's equivalents are set to READ-Only, and only can be edited by a Root-User"
		sudo -i;
		if [[ $(whoami) == root ]]; then
			echo -e "Thanks, Performing Changes."
		else
			echo -e "No Root Access, Abort."
			main_menu;
		fi
		echo -e "CCACHE Size must be >50 GB.\n Think about it and Specify the Size (Number) for Reservation of CCACHE (in GB)";
		read CCSIZE;
		echo -e "Create a New Folder for CCACHE and Specify it's location from / here"
		read CCDIR;
			if [[ $( -f ~/.bashrc ) == 1 ]]; then
				echo "export USE_CCACHE=1" >> ~/.bashrc
				echo "export CCACHE_DIR=${CCDIR}" >> ~/.bashrc
				source ~/.bashrc
			elif [[ $( -f ~/.profile ) == 1 ]]; then
				echo "export USE_CCACHE=1" >> ~/.profile
				echo "export CCACHE_DIR=${CCDIR}" >> ~/.profile
				source ~/.profile
			elif [[ $( -f SOME_FILE )]]; then
				echo "export USE_CCACHE=1" >> /SOME_LOC/SOME_FILE
				echo "export CCACHE_DIR=${CCDIR}" >> /SOME_LOC/SOME_FILE
				echo "Restart your PC and Select Step 'B'"
			else
				echo -e "Strategies failed. If you have knowledge of .bashrc's equivalent in your Distro, then Paste these lines at the end of the File";
				echo -en "export USE_CCACHE=1"
				echo -en "export CCACHE_DIR=${CCDIR}"
				echo -e "Now Log-Out and Re-Login. The Changes will be considered after that."
			fi
		echo -e "Giving up Root-Access."
		exit
	} #set_ccvars

	echo -e "${LPURP}=========================================================${NONE}"
	echo -e '\n';
	echo -e "${CYAN}Initializing Build Environment${NONE}";
	. build/envsetup.sh
	echo -e "${LPURP}Done.${NONE}."
	echo -e '\n';
	echo -e "Select the Build Option:\n";
	echo -e '\n';
	echo -e "${GRN}1. Start Building ROM (ZIP output)${NONE}";
	echo -e "${ORNG}2. Clean only Staging Directories and Emulator Images (*.img)${NONE}";
	echo -e "${LRED}3. Clean the Entire Build (/out) Directory (THINK BEFORE SELECTING THIS!)${NONE}";
	echo -e "${LGRN}4. Make a Particular Module${NONE}";
	echo -e "${LGRN}5. Setup CCACHE for Faster Builds ${NONE}";
	echo -e '\n';
	echo -e "${LPURP}=========================================================${NONE}"
	echo -e '\n';
	read BOPT;
	echo -e '\n';
		if [[ "$BOPT" == 1 ]]; then
		echo -e "Should i use '${YELO}make${NONE}' or '${RED}mka${NONE}' ?"
		read MKWAY;
		if [[ "$MKWAY" == make ]]; then
			BCORES=$(grep -c ^processor /proc/cpuinfo);
		else
			BCORES="";
		fi
		if [[ "$ROMNIS" == tipsy || "$ROMNIS" == validus || "$ROMNIS" == tesla ]]; then
			$MKWAY $ROMNIS $BCORES
		else
			if [[ $(grep -q "^bacon:" "${ANDROID_BUILD_TOP}/build/core/Makefile") ]]; then
				$MKWAY bacon $BCORES
			else
				$MKWAY otapackage $BCORES
			fi
		fi

  	fi

	if [[ "$BOPT" == 2 ]]; then
		$MKWAY installclean
	fi

	if [[ "$BOPT" == 3 ]]; then
		$MKWAY clean
	fi

	if [[ "$BOPT" == 4 ]]; then
		make_module;
	fi

	if [[ "$BOPT" == 5 ]]; then
		echo -e "Two Steps. Select one of them (If seeing this for first time - Enter A)";
		echo -e " A. Enabling CCACHE Variables in .bashrc or it's equivalent"
		echo -e " B. Reserving Space for CCACHE";
		read CCOPT;
		if [[ "$CCOPT" == A ]]; then
			set_ccvars;
		elif [[ "$CCOPT" == B ]]; then
			set_ccache;
		else
			echo -e "Drunk? restart this Script.";
		fi
	fi

	#Next ACTION to be Performed
	echo -e '\n\n';
	echo -e "${LRED}=========================================================${NONE}";
	echo -e '\n';
	echo -e " ${RED}1. Sync${NONE}";
	echo -e " ${YELO}2. Pre-Build${NONE} ";
	echo -e '\n';
	echo -e " 4. EXIT     ";
	echo -e "${LRED}=========================================================${NONE}";
	read ACTION;
	teh_action;

} #build

function exitScriBt
{
	echo -e '\n\n';
	echo -e "Thanks for using this ${LRED}S${NONE}cri${GRN}B${NONE}t. Have a Nice Day";
	sleep 2;
	exit 0;
} #exitScriBt

#START IT --- VROOM!
main_menu;
