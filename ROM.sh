#!/bin/bash
#=========================Projekt ScriBt===========================#
# This Script and ROM.rc has to be placed under a Synced Source
# Directory (if and only if you're using this script to build)
#
# Else
# Create a folder for your Source and Place these files inside it
#
# https://github.com/a7r3/scripts - The Original Repo of this ScriBt
#
#==================================================================#
START=${pwd};
BLANK=$(echo -e '\n');
if [ -f "${PWD}/ROM.rc" ]; then
	#Initialize
	source $(pwd)/ROM.rc;
else
	echo "ROM.rc isn't present in ${PWD}, please make sure repo is cloned correctly";
	exit 1;
fi

echo "=======================================================";
echo -e "Before I can start, do you like a \033[1;31mC\033[0m\033[0;32mo\033[0m\033[0;33ml\033[0m\033[0;34mo\033[0m\033[0;36mr\033[0m\033[1;33mf\033[0m\033[1;32mu\033[0m\033[0;31ml\033[0m life? [y/n]";
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
	echo -e "${LBLU}1${NONE}${CYAN} ................${NONE}${RED}Choose ROM & Init*${NONE}${CYAN}.................${NONE} ${LBLU}1${NONE}";
	echo -e "${LBLU}2${NONE}${CYAN} .......................${NONE}${YELO}Sync${NONE}${CYAN}........................${NONE} ${LBLU}2${NONE}";
	echo -e "${LBLU}3${NONE}${CYAN} .....................${NONE}${GRN}Pre-Build${NONE}${CYAN}.....................${NONE} ${LBLU}3${NONE}";
	echo -e "${LBLU}4${NONE}${CYAN} .......................${NONE}${LGRN}Build${NONE}${CYAN}.......................${NONE} ${LBLU}4${NONE}";
	echo -e "${LBLU}5${NONE}${CYAN} ........${NONE}${PURP}Check and Install Build Dependencies${NONE}${CYAN}.......${NONE} ${LBLU}5${NONE}";
	echo -e '\n';
	echo -e "6 .......................EXIT........................ 6";
	echo -e '\n';
	echo -e "* - Sync will Automatically Start after Init'ing Repo";
	echo -e "${LRED}=======================================================${NONE}";
	echo -e '\n';
	read ACTION;
	teh_action;

} #main_menu

function teh_action
{

	if [[ "$ACTION" == 1 ]]; then
		init;
	elif [[ "$ACTION" == 2 ]]; then
		sync;
	elif [[ "$ACTION" == 3 ]]; then
		pre_build;
	elif [[ "$ACTION" == 4 ]]; then
		build;
	elif [[ "$ACTION" == 5 ]]; then
		installdeps;
	elif [[ "$ACTION" == 6 ]]; then
		exitScriBt;
	fi

} #teh_action

function installdeps
{

	function java_select
	{
		echo -e "If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)"
		echo -e "You may now select the Version of Java which is to be used BY-DEFAULT"
		echo -e "================================================================"
		echo -e '\n';
		sudo update-alternatives --config java
		echo -e '\n';
		echo -e "================================================================"
		echo -e '\n';
		sudo update-alternatives --config javac
		echo -e '\n';
		echo -e "================================================================";
	}
	function java6
	{
		echo -e "Installing OpenJDK-6 (Java 1.6.0)"
		sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
		sudo apt-get update
		sudo apt-get install openjdk-6-jdk
		if [[ $( java -version | grep -c "java version \"1.6" ) == 1 ]]; then
			echo -e "OpenJDK-6 or Java 6 has been successfully installed"
	}


	function java7
	{

		echo -e "Installing OpenJDK-7 (Java 1.7.0)"
		echo -e "Remove other Versions of Java [y/n]? ( Removing them is Recommended)"
		read REMOJA;
		if [[ "$REMOJA" == y ]]; then
		sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
		echo -e "Removed Other Versions successfully"
	elif [[ "$REMOJA" == n ]]; then
		 echo -e "Keeping them Intact"
	 fi
	 	echo -e "==========================================================";
		echo -e '\n';
		sudo apt-get update
		echo -e '\n';
		echo -e "==========================================================";
		echo -e '\n';
		sudo apt-get install openjdk-7-jdk
		if [[ $( java -version | grep -c "java version \"1.7" ) == 1 ]]; then
			echo -e '\n';
			echo -e "==========================================================";
			echo -e "OpenJDK-7 or Java 7 has been successfully installed"
		fi
		echo -e "==========================================================";

	}

	function java8
	{

		echo -e "Remove other Versions of Java [y/n]? ( Removing them is Recommended)"
		read REMOJA;
		if [[ "$REMOJA" == y ]]; then
			sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
			echo -e "Removed Other Versions successfully"
		elif [[ "$REMOJA" == n ]]; then
		 	echo -e "Keeping them Intact"
	 	fi
		echo -e "Installing OpenJDK-8 (Java 1.8.0)"
		echo -e "==========================================================";
		echo -e '\n';
		sudo apt-get update
		echo -e '\n';
		echo -e "==========================================================";
		echo -e '\n';
		sudo apt-get install openjdk-8-jdk
		echo -e '\n';
		echo -e "==========================================================";
		if [[ $( java -version | grep -c "java version \"1.8" ) == 1 ]]; then
			echo -e "OpenJDK-8 or Java 8 has been successfully installed"
		fi
		echo -e "==========================================================";

		}

echo -e "==========================================================";
echo -e '\n';
echo -e "Checking and Installing Build Dependencies Now..."
echo -e '\n';
sudo apt-get install git-core gnupg ccache lzop flex bison \
 										 gperf build-essential zip curl zlib1g-dev \
									 	 zlib1g-dev:i386 libc6-dev lib32ncurses5 lib32z1 \
										 lib32bz2-1.0 lib32ncurses5-dev x11proto-core-dev \
										 libx11-dev:i386 libreadline6-dev:i386 lib32z-dev \
										 libgl1-mesa-glx:i386 libgl1-mesa-dev g++-multilib \
										 mingw32 tofrodos python-markdown libxml2-utils xsltproc \
										 readline-common libreadline6-dev libreadline6 \
										 lib32readline-gplv2-dev libncurses5-dev lib32readline5 \
										 lib32readline6 libreadline-dev libreadline6-dev:i386 \
										 libreadline6:i386 bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev \
										 lib32bz2-dev libsdl1.2-dev libesd0-dev squashfs-tools \
										 pngcrush schedtool libwxgtk2.8-dev python liblz4-tools \
echo -e '\n';
echo -e "==========================================================";
echo -e '\n\n'
echo -e "=====================JAVA Installation====================";
echo -e '\n';
echo -e "1. Install Java"
echo -e "2. Switch Between Java Versions / Providers"
echo -e '\n';
echo -e "3. Back to Main Menu"
echo -e "==========================================================";
echo -e '\n';
read JAVAS;

if [[ "$JAVAS" == 1 ]]; then
	echo -e "Android Version of the ROM you're building ? "
	echo -e "1. 4.4 KitKat"
	echo -e "2. 5.x.x Lollipop & 6.x.x Marshmallow"
	echo -e "3. Android N (lol)"
	read ANDVER;
	if [[ "$ANDVER" == 1 ]]; then
		java6;
	elif [[ "$ANDVER" == 2 ]]; then
		java7;
	elif [[ "$ANDVER" == 3 ]]; then
		java8;
	fi
elif [[ "$JAVAS" == 2 ]]; then
	java_select;
elif [[ "$JAVAS" == 3 ]]; then
	main_menu;
fi

}
function sync
{

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
		echo -e '\n';
		read REFER;
	fi
		echo -e '\n';
	#Sync-Options
	if [[ "$SILENT" == y ]]; then
		SILENT=-q;
	else
		SILENT=" " ;
	fi
	if [[ "$FRC" == y ]]; then
		FRC=--force-sync;
	else
		FRC=" " ;
	fi
	if [[ "$REFY" == YES ]]; then
		REF=--reference\=\"${REFER}\"
	else
		REF=" " ;
	fi
	echo -e "Let's Sync!";
	echo -e '\n';
	repo sync -j${JOBS} ${SILENT} ${FRC} ;
	if [[ $( grep -c "Syncing work tree: 100%" ) == 1 ]]; then
		echo -e "ROM Source synced successfully."
	fi
	echo -e '\n';
	echo -e "${LPURP}Done.${NONE}!";
	echo -e "${LRED}=========================================================${NONE}";
		echo -e "Start Over Again?\n 1 to Restart\n 0 for Main Menu"
	read B2M;
	if [[ "$B2M" == 1 ]]; then
		sync;
	elif [[ "$B2M" == 0 ]]; then
		main_menu;
	fi

} #sync

function init
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
#Check for Presence of Repo Binary
		if [[ ! $(which repo) ]]; then
			echo -e "Looks like the Repo binary isn't installed. Let's Install it."
			if [ ! -d "${HOME}/bin" ]; then
				mkdir -p ${HOME}/bin
			fi
			curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
			chmod a+x ~/bin/repo
			echo -e "Repo Binary Installed"
			echo "Adding ~/bin to PATH"
			echo -e "# set PATH so it includes user's private bin if it exists" >> ~/.profile
			echo -e "if [ -d \"\$HOME/bin\" ] ; then" >> ~/.profile
			echo -e "\tPATH=\"\$HOME/bin:\$PATH\" "; >> ~/.profile
			echo -e "fi"; >> ~/.profile
			source ~/.profile
			echo -e "DONE. Ready to Init Repo"
			echo -e '\n';
		fi

	echo -e "${LBLU}=========================================================${NONE}";
	echo -e '\n';
	echo -e "Let's Initialize teh ROM Repo";
	echo -e '\n';
	repo init ${REF} -u https://github.com/${ROM_NAME}/${MAN} -b ${BRANCH} ;
	echo -e '\n';
	echo -e "Repo Init'ed";
	echo -e '\n';
	echo -e "${LBLU}=========================================================${NONE}";
	echo -e '\n';
	mkdir .repo/local_manifests
	echo -e "A folder \"local_manifests\" has been created for you."
	echo -e "Add either a local_manifest.xml or roomservice.xml as per your choice";
	echo -e "And add your Device-Specific Repos, essential for Building. Press ENTER to start Syncing.";
	read ENTER;
	echo -e '\n';

#Start Sync now
sync;

} #init

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

	function btype
	{
		echo -e "The ${LRED}Build type${NONE}? ${LGRN}[userdebug/user/eng]${NONE}";
		echo -e '\n';
		read BTYP;
		if [[ "$BTYP" != userdebug || "$BTYP" != eng || "$BTYP" != user ]]; then
			echo -e "Invalid Build-Type. Specify Again"
			btype;
		fi
	} #btype_verification

	# Get Build-Type from user
	btype;
	echo -e '\n';
	echo -e "Your ${LRED}Device's Company/Vendor${NONE} (All Lowercases)?";
	echo -e '\n';
	read COMP;
	echo -e '\n';
	echo -e "${LCYAN}=========================================================${NONE}";
	rom_name_in_source;
	echo -e '\n\n'
	cd vendor/${ROMNIS}
	if [[ $( ls | grep -c "${ROMNIS}.devices" ) == 1 ]]; then
		echo -e "Adding your Device to ROM Vendor (Strategy 1)";
		echo -e '\n';
		echo "${DEVICE}" >> ${ROMNIS}.devices;
		echo "DONE!"
		croot;
	elif [[ $( ls | grep -c "vendorsetup.sh" ) == 1 ]]; then
		echo -e "Adding your Device to ROM Vendor (Strategy 2)"
		echo -e '\n';
		echo "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}" >> vendorsetup.sh
		echo "DONE!"
		croot;
	else
		croot;
		echo "Adding your Device to ROM Vendor (Strategy 3)"
		echo -e "Let's go to teh ${LRED}Device Directory!${NONE}";
		cd device/${COMP}/${DEVICE};
		echo -e "Creating VendorSetup.sh if absent in tree";
			if [ ! -f vendorsetup.sh ]; then
				touch vendorsetup.sh;
				echo -e "Done [1/2]"
			fi
		echo -e "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}" >> vendorsetup.sh
		echo "DONE! [2/2]"
		croot;
	fi
#	if [[ $STRT == 4 ]]; then
#		echo -e "This Strategy, AFAIK was only on AOKP (kitkat) and PAC-ROM (pac-5.1).";
#		echo -e "Let's go to vendor/$ROMNIS/products";
#		cd vendor/${ROMNIS}/products;
#		echo -e '\n';
#		echo -e "${LPURP}Done.${NONE}.";
#			if [[ "$ROMNIS" == pac ]]; then
#				echo -e "Creating file ${ROMNIS}_${DEVICE}.mk";
#				touch ${ROMNIS}_${DEVICE}.mk
#			else
#				echo -e "Creating file ${DEVICE}.mk";
#				touch ${DEVICE}.mk
#			fi
#	fi
#		echo -e "\n${LPURP}Done.${NONE}. Open that file now."
#		echo -e "\nAdd these lines";
#			if [[ "$ROMNIS" == pac ]]; then
#				echo -e "FAIL. WIP";
#			fi
#			if [[ "$ROMNIS" == aokp ]]; then
#				${BLANK}
#				echo -e "WIP WIP!";
#			fi

# Must be on Working Directory
		croot;
# Done
		echo -e '\n\n'
		echo -e "Now ${ROMNIS}fy! your Device Tree! Press ${LCYAN}ENTER${NONE} when ${LPURP}Done.${NONE} ";
		echo -e "${LPURP}=========================================================${NONE}"
		read NOOB;
		echo -e '\n\n';
		sleep 3;
		echo -e '\n';
		echo -e "I_IZ_NOOB :P - We're Successful";

		echo -e "Start Over Again?\n 1 to Restart\n 0 for Main Menu"
		read B2M;
		if [[ "$B2M" == 1 ]]; then
			pre_build;
		elif [[ "$B2M" == 0 ]]; then
			main_menu;
		fi

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
		echo -e '\n';
	} #set_ccache

	function set_ccvars
	{
		echo -e "Provide this Script Root-Access, so that it can write CCACHE export values. No Hacks Honestly (Check the Code)"
		echo -en "Why? Coz .bashrc or it's equivalents can only be Modified by a Root user"
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
			if [ -f ${HOME}/.bashrc ]; then
					echo "export USE_CCACHE=1" >> ${HOME}/.bashrc
					echo "export CCACHE_DIR=${CCDIR}" >> ${HOME}/.bashrc
					source ${HOME}/.bashrc
			elif [ -f ${HOME}/.profile ]; then
				echo "export USE_CCACHE=1" >> ${HOME}/.profile
				echo "export CCACHE_DIR=${CCDIR}" >> ${HOME}/.profile
				source ${HOME}/.profile
#			elif [[ $( -f SOME_FILE )]]; then
#				echo "export USE_CCACHE=1" >> /SOME_LOC/SOME_FILE
#				echo "export CCACHE_DIR=${CCDIR}" >> /SOME_LOC/SOME_FILE
#				echo "Restart your PC and Select Step 'B'"
			else
				echo -e "Strategies failed. If you have knowledge of finding .bashrc's equivalent in your Distro, then Paste these lines at the end of the File";
				echo -en "export USE_CCACHE=1";
				echo -en "export CCACHE_DIR=${CCDIR}";
				echo -e "Now Log-Out and Re-Login. Select Step B. The Changes will be considered after that.";
				echo -e "Alternatively run source ~/.profile";
				sleep 2
				exitScriBt;
			fi
		echo -e "Giving up Root Access";
		exit
		echo "Done."
		echo -e '\n';
		set_ccache;
	} #set_ccvars

	function post_make
	{
		if [[ $(grep -c "make completed successfully") == 1 ]]; then
			echo -e '\n';
			echo "Build Completed! Cool. Now make it Boot!"
#		elif [[ $(grep -c "No rule to make target ") == 1 ]]; then
#			echo -e "Looks like a Module isn't getting built."
#			echo -e "Find the name of the Missing Module, and Search from where it is being made."
#			echo -e "If done do a mmm to it - There are two chances:"
#			echo -e "		Either the Module will get built - OR - The Module will ask for other Dependency for it to get built"
		fi
	}

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
				post_build;
			else
				$MKWAY otapackage $BCORES
				post_build;
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

echo -e "Start Over Again?\n 1 to Restart\n 0 for Main Menu"
read B2M;
if [[ "$B2M" == 1 ]]; then
	build;
elif [[ "$B2M" == 0 ]]; then
	main_menu;
fi

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
