#!/bin/bash
#==========================Projekt ScriBt==============================#
#============ Copyright 2016, Arvind Raj Thangaraj - "a7r3" ===========#
#======================================================================#
#                                                                      #
# This software is licensed under the terms of the GNU General Public  #
# License version 2, as published by the Free Software Foundation, and #
# may be copied, distributed, and modified under those terms.          #
#                                                                      #
# This program is distributed in the hope that it will be useful,      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of       #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
# GNU General Public License for more details.                         #
#                                                                      #
#======================================================================#
#                                                                      #
# This Script and ROM.rc has to be placed under a Synced Source        #
# Directory (if and only if you're using this script to build)         #
#                                                                      #
# Else                                                                 #
# Create a folder for your Source and Place these files inside it      #
#                                                                      #
# https://github.com/a7r3/scripts - The Original Repo of this ScriBt   #
#                                                                      #
# You're free to enter your modifications and submit it to me with     #
# a Pull Request, such Contributions are readily WELCOME               #
#                                                                      #
# CONTRIBUTORS FOR THIS PROJECT:                                       #
# Arvind Raj (Myself)                                                  #
# Akhil Narang                                                         #
#======================================================================#

# Create a Text file to Store Intermediate Outputs for Working on Some Commands
touch tmpscribt.txt;
TMP=tmpscribt.txt;
# Blank Line
BLANK=echo -e '\n';
# Load the Basic Variables
if [ -f "${PWD}/ROM.rc" ]; then
	source $(pwd)/ROM.rc;
else
	echo "ROM.rc isn't present in ${PWD}, please make sure repo is cloned correctly";
	exit 1;
fi

#CHEAT CHEAT CHEAT!
if [ -f PREF.rc ]; then
	source $(pwd)/PREF.rc
	$(BLANK)
	echo -e "*AutoBot* Cheat Code SHUT_MY_MOUTH applied. I won't ask questions anymore";
	$(BLANK)
	echo -e "*AutoBot* Loading all Vars...."
	color;
	repoinit;
	reposync;
	deviceinfo;
	buildinfo;
	$(BLANK)
	echo -e "*AutoBot* Successfully Collected Information. Ready to Go!"
else
	echo -e "Don't lose patience the next time. Enter your Values in PREF.rc and Shut my Mouth! lol";
	$(BLANK)
	echo -e "PREF.rc is the file"
fi

echo "=======================================================";
echo -e "Before I can start, do you like a \033[1;31mC\033[0m\033[0;32mo\033[0m\033[0;33ml\033[0m\033[0;34mo\033[0m\033[0;36mr\033[0m\033[1;33mf\033[0m\033[1;32mu\033[0m\033[0;31ml\033[0m life? [y/n]";
echo "=======================================================";

if [ -f PREF.rc ]; then
	color;
	$(BLANK)
	echo -e "*AutoBot* Coloured ScriBt : $COLOR "
else
	read COLOR;
fi

if [[ "$COLOR" == y ]]; then
	color_my_life;
else
	i_like_colourless;
fi
clear;
echo -ne '\033]0;ScriBt\007'
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
$(BLANK)
sleep 0.1;
echo -e "${CYAN}~#~#~#~#~#~#~#~#~#~#~ By Arvind7352 @XDA #~#~#~#~#~#~#~#~#~#~${NONE}";
sleep 3;
#GET THOSE ROOMS
$(BLANK)
$(BLANK)

function main_menu
{

	echo -e "${LRED}=======================================================${NONE}";
	echo -e "${LRED}====================${NONE}${CYAN}[*]${NONE}${PURP}MAIN MENU${NONE}${CYAN}[*]${NONE}${LRED}====================${NONE}";
	echo -e "${LRED}=======================================================${NONE}";
	$(BLANK)
	echo -e "         Select the Action you want to perform         ";
	$(BLANK)
	echo -e "${LBLU}1${NONE}${CYAN} ................${NONE}${RED}Choose ROM & Init*${NONE}${CYAN}.................${NONE} ${LBLU}1${NONE}";
	echo -e "${LBLU}2${NONE}${CYAN} .......................${NONE}${YELO}Sync${NONE}${CYAN}........................${NONE} ${LBLU}2${NONE}";
	echo -e "${LBLU}3${NONE}${CYAN} .....................${NONE}${GRN}Pre-Build${NONE}${CYAN}.....................${NONE} ${LBLU}3${NONE}";
	echo -e "${LBLU}4${NONE}${CYAN} .......................${NONE}${LGRN}Build${NONE}${CYAN}.......................${NONE} ${LBLU}4${NONE}";
	echo -e "${LBLU}5${NONE}${CYAN} ........${NONE}${PURP}Check and Install Build Dependencies${NONE}${CYAN}.......${NONE} ${LBLU}5${NONE}";
	$(BLANK)
	echo -e "6 .......................EXIT........................ 6";
	$(BLANK)
	echo -e "* - Sync will Automatically Start after Init'ing Repo";
	echo -e "${LRED}=======================================================${NONE}";
	$(BLANK)
	read ACTION;
	teh_action;

} #main_menu

function exitScriBt
{
	echo -e '\n\n';
	echo -e "Thanks for using this ${LRED}S${NONE}cri${GRN}B${NONE}t. Have a Nice Day";
	sleep 2;
	echo -e "Removing Temporary Files"
	rm -rf $TMP;
	echo "DONE"
	echo "Bye!"
	exit 0;
} #exitScriBt

function teh_action
{
	if [[ "$ACTION" == 1 ]]; then
		init;
		echo -ne '\033]0;ScriBt : Init\007'
	elif [[ "$ACTION" == 2 ]]; then
		sync;
		echo -ne '\033]0;ScriBt : Sync\007'
	elif [[ "$ACTION" == 3 ]]; then
		pre_build;
		echo -ne '\033]0;ScriBt : Pre-Build\007'
	elif [[ "$ACTION" == 4 ]]; then
		build;
		echo -ne '\033]0;ScriBt : Building\007'
		installdeps;
		echo -ne '\033]0;ScriBt : InstallDeps\007'
	elif [[ "$ACTION" == 6 ]]; then
		echo -ne '\033]0;BYE!\007'
	elif [[ "$ACTION" == 5 ]]; then
		exitScriBt;
	fi
} #teh_action

function quick_menu
{
	echo -e "${YELO}============================${NONE} ${LRED}QUICK-MENU${NONE} ${YELO}=============================${NONE}"
	echo -e "${RED}1. Init${NONE} | ${YELO}2. Sync${NONE} | ${GRN}3. Pre-Build${NONE} | ${LGRN}4. Build${NONE} | ${PURP}5. Install Dependencies${NONE}"
	echo -e "                               6. Exit                               "
	echo -e "${YELO}=====================================================================${NONE}"
	read ACTION;
	teh_action;
}

function installdeps
{
	function java_select
	{
		echo -e "If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)"
		echo -e "You may now select the Version of Java which is to be used BY-DEFAULT"
		echo -e "================================================================"
		$(BLANK)
		sudo update-alternatives --config java
		$(BLANK)
		echo -e "================================================================"
		$(BLANK)
		sudo update-alternatives --config javac
		$(BLANK)
		echo -e "================================================================";
	}

	function java6
	{
		echo -e "Installing OpenJDK-6 (Java 1.6.0)"
		echo -e "Remove other Versions of Java [y/n]? ( Removing them is Recommended)"
		$(BLANK)
		read REMOJA;
		$(BLANK)
		if [[ "$REMOJA" == y ]]; then
		sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
		$(BLANK)
		echo -e "Removed Other Versions successfully"
		elif [[ "$REMOJA" == n ]]; then
		 echo -e "Keeping them Intact"
	 	fi
	 	echo -e "==========================================================";
	 	$(BLANK)
		sudo apt-get update
		echo -e "==========================================================";
		$(BLANK)
		sudo apt-get install openjdk-6-jdk
		$(BLANK)
		echo -e "==========================================================";
		$(BLANK)
		if [[ $( java -version &> $TMP && grep -c 'java version "1.6' $TMP ) == 1 ]]; then
			echo -e "OpenJDK-6 or Java 6 has been successfully installed"
		fi
	}

	function java7
	{
		echo -e "Installing OpenJDK-7 (Java 1.7.0)"
		echo -e "Remove other Versions of Java [y/n]? ( Removing them is Recommended)"
		$(BLANK)
		read REMOJA;
		$(BLANK)
		if [[ "$REMOJA" == y ]]; then
			sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
			echo -e "Removed Other Versions successfully"
		elif [[ "$REMOJA" == n ]]; then
		 	echo -e "Keeping them Intact"
	 	fi
	 	$(BLANK)
	 	echo -e "==========================================================";
		$(BLANK)
		sudo apt-get update
		$(BLANK)
		echo -e "==========================================================";
		$(BLANK)
		sudo apt-get install openjdk-7-jdk
		$(BLANK)
		if [[ $(java -version &> $TMP && grep -c 'java version "1.7' $TMP ) == 1 ]]; then
			$(BLANK)
			echo -e "==========================================================";
			echo -e "OpenJDK-7 or Java 7 has been successfully installed"
		fi
		echo -e "==========================================================";
	}

	function java8
	{
		echo -e "Remove other Versions of Java [y/n]? ( Removing them is Recommended)"
		$(BLANK)
		read REMOJA;
		if [[ "$REMOJA" == y ]]; then
			$(BLANK)
			sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
			$(BLANK)
			echo -e "Removed Other Versions successfully"
		elif [[ "$REMOJA" == n ]]; then
		 	echo -e "Keeping them Intact"
	 	fi
		$(BLANK)
		echo -e "Installing OpenJDK-8 (Java 1.8.0)"
		$(BLANK)
		echo -e "==========================================================";
		$(BLANK)
		sudo apt-get update
		$(BLANK)
		echo -e "==========================================================";
		$(BLANK)
		sudo apt-get install openjdk-8-jdk
		$(BLANK)
		echo -e "==========================================================";
		if [[ $( java -version &> $TMP && grep -c 'java version "1.8' $TMP ) == 1 ]]; then
			$(BLANK)
			echo -e "OpenJDK-8 or Java 8 has been successfully installed"
			$(BLANK)
		fi
		echo -e "==========================================================";
	}

	echo -e "==========================================================";
	$(BLANK)
	echo -e "Checking and Installing Build Dependencies Now..."
	$(BLANK)
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
	pngcrush schedtool libwxgtk2.8-dev python liblz4-tool
	$(BLANK)
	echo -e "==========================================================";
	echo -e '\n\n'
	echo -e "=====================JAVA Installation====================";
	$(BLANK)
	echo -e "1. Install Java"
	echo -e "2. Switch Between Java Versions / Providers"
	$(BLANK)
	echo -e "3. Back to Main Menu"
	echo -e "==========================================================";
	$(BLANK)
	read JAVAS;

	if [[ "$JAVAS" == 1 ]]; then
		echo -ne '\033]0;ScriBt : Java\007'
		echo -e "Android Version of the ROM you're building ? "
		echo -e "1. 4.4 KitKat"
		echo -e "2. 5.x.x Lollipop & 6.x.x Marshmallow"
		echo -e "3. Android N (lol)"
		$(BLANK)
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

} #installdeps

function sync
{
	echo -e "Let's sync it!";
	$(BLANK)
	echo -e "${LRED}Number of Threads${NONE} for Sync?";
	$(BLANK)
	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		reposync;
		echo -e "*AutoBot* No of Threads : ${JOBS}"
	else
		read JOBS;
	fi
	$(BLANK)
	echo -e "${LRED}Force Sync${NONE} needed? ${LGRN}[y/n]${NONE}";
	$(BLANK)
	if [ -f PREF.rc ]; then
		reposync;
		echo -e "*AutoBot* Force Sync : ${FRC}"
	else
		read FRC;
	fi
	$(BLANK)
	echo -e "Need some ${LRED}Silence${NONE} in teh Terminal? ${LGRN}[y/n]${NONE}";
	$(BLANK)

	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		reposync;
		echo -e "*AutoBot* Silent Sync : ${SIL}"
	else
		read SIL;
	fi
	$(BLANK)

	echo -e "Sync only Current Branch? [y/n] (Saves Space)"
	$(BLANK)
	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		reposync;
		echo -e  "*AutoBot* Sync Current Branch : $CRNT"
	else
		read CRNT;
	fi

	if [[ "$CRNT" == y ]]; then
		SYNC_CRNT=-c;
	else
		SYNC_CRNT=" ";
	fi

	$(BLANK)
	echo -e "${LRED}=====================================================================${NONE}";
	#Sync-Options
	if [[ "$SIL" == y ]]; then
		SILENT=-q;
	else
		SILENT=" " ;
	fi
	if [[ "$FRC" == y ]]; then
		FORCE=--force-sync;
	else
		FORCE=" " ;
	fi
	echo -e "Let's Sync!";
	$(BLANK)
	repo sync -j${JOBS} ${SILENT} ${FORCE} ${SYNC_CRNT} # 2>&1 | tee $TMP;
	$(BLANK)
	#Useless	if [[ $( grep -c 'Syncing work tree: 100%' $TMP ) == 1 ]]; then
	#Useless		echo -e "ROM Source synced successfully."
	#Useless	fi
	rm -rf $TMP;
	$(BLANK)
	echo -e "${LPURP}Done.${NONE}!";
	$(BLANK)
	echo -e "${LRED}=====================================================================${NONE}";
	$(BLANK)
	if [ ! -f PREF.rc ]; then
		quick_menu;
	else
		echo -e "*AutoBot* Automated sync Successful"
	fi
} #sync

function init
{

	echo -e "${LPURP}=======================================================${NONE}";
	$(BLANK)
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
	$(BLANK)
	read ROMNO;
	sleep 1;
	#
	rom_name_in_github;
	#
	$(BLANK)
	echo -e "You have chosen ${LCYAN}->${NONE} $ROM_FN";
	sleep 1;
	$(BLANK)
	echo -e "Since Branches may live or die at any moment, ${LRED}Specify the Branch${NONE} you're going to sync"
	$(BLANK)

	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		repoinit;
		echo -e "Branch : $BRANCH"
	else
		read BRANCH;
	fi

	$(BLANK)
	echo -e "Any ${LRED}Source you have already synced?${NONE} If yes, then say YES and Press ${LCYAN}ENTER${NONE}";
	$(BLANK)

	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		repoinit;
		if [[ "$REFY" == YES ]]; then
			echo -e "*AutoBot* YES, you have a Reference Source"
			$(BLANK)
			echo -e "*AutoBot* The Reference location is : ${REF}"
		else
			echo -e "*AutoBot* NO, you don't have a Reference Source. Going for a Fresh Sync"
		fi
	else
		read REFY;
	fi

	if [ ! -f PREF.rc ]; then
		if [[ "$REFY" == YES ]]; then
			$(BLANK)
			echo -e "Provide me the ${LRED}Synced Source's Location${NONE} from / ";
			$(BLANK)
			read REFER;
			REF=--reference\=\"${REFER}\"
		else
			REF=" " ;
		fi
	fi

		$(BLANK)
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
			$(BLANK)
			echo "Adding ~/bin to PATH"
			$(BLANK)
			echo -e "# set PATH so it includes user's private bin if it exists" >> ~/.profile
			echo -e "if [ -d \"\$HOME/bin\" ] ; then" >> ~/.profile
			echo -e "\tPATH=\"\$HOME/bin:\$PATH\" "; >> ~/.profile
			echo -e "fi"; >> ~/.profile
			source ~/.profile
			echo -e "DONE. Ready to Init Repo"
			$(BLANK)
		fi

	echo -e "${LBLU}=========================================================${NONE}";
	$(BLANK)
	echo -e "Let's Initialize teh ROM Repo";
	$(BLANK)
	repo init ${REF} -u https://github.com/${ROM_NAME}/${MAN} -b ${BRANCH} ;
	$(BLANK)
	echo -e "Repo Init'ed";
	$(BLANK)
	echo -e "${LBLU}=========================================================${NONE}";
	$(BLANK)
	mkdir .repo/local_manifests
	echo -e "A folder \"local_manifests\" has been created for you."
	echo -e "Add either a local_manifest.xml or roomservice.xml as per your choice";
	echo -e "And add your Device-Specific Repos, essential for Building. Press ENTER to start Syncing.";
	read ENTER;
	$(BLANK)

#Start Sync now
sync;

} #init

function pre_build
{
	echo -e "${CYAN}Initializing Build Environment${NONE}"
	$(BLANK)
	. build/envsetup.sh
	$(BLANK)
	echo -e "${LPURP}Done.${NONE}."
	echo -e '\n\n';
	echo -e "${LCYAN}====================== DEVICE INFO ======================${NONE}";
	$(BLANK)
	echo -e "What's your ${LRED}Device's CodeName${NONE} ${LGRN}[Refer Device Tree - All Lowercases]${NONE}?";
	$(BLANK)

	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		deviceinfo;
		echo -e "Your Device Name is : ${DEVICE}"
	else
		read DEVICE;
	fi
	$(BLANK)
	echo -e "The ${LRED}Build type${NONE}? ${LGRN}[userdebug/user/eng]${NONE}";
	$(BLANK)

	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		deviceinfo;
		echo -e "Build type: ${DEVICE}"
	else
		read BTYP;
	fi

	$(BLANK)
	echo -e "Your ${LRED}Device's Company/Vendor${NONE} (All Lowercases)?";
	$(BLANK)

	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		deviceinfo;
		echo -e "Device's Company : ${COMP}"
	else
		read COMP;
	fi

	$(BLANK)
	echo -e "${LCYAN}=========================================================${NONE}";
	rom_name_in_source;
	$(BLANK)
	$(BLANK)
	echo -e "${LPURP}=========================================================${NONE}"
	cd vendor/${ROMNIS}
	$(BLANK)
	if [ -f ${ROMNIS}.devices ]; then
		echo -e "Adding your Device to ROM Vendor (Strategy 1)";
		$(BLANK)
		echo "${DEVICE}" >> ${ROMNIS}.devices;
		echo "DONE!"
		croot;
	elif [ -f vendorsetup.sh ]; then
		echo -e "Adding your Device to ROM Vendor (Strategy 2)"
		$(BLANK)
		echo "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}" >> vendorsetup.sh
		echo "DONE!"
		croot;
	else
		croot;
		echo "Adding your Device to ROM Vendor (Strategy 3)"
		echo -e "Let's go to teh ${LRED}Device Directory!${NONE}";
		$(BLANK)
		cd device/${COMP}/${DEVICE};
		echo -e "Creating VendorSetup.sh if absent in tree";
			if [ ! -f vendorsetup.sh ]; then
				touch vendorsetup.sh;
				echo -e "Done [1/2]"
			fi
		echo -e "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}" >> vendorsetup.sh
		$(BLANK)
		echo "DONE! [2/2]"
		croot;
	fi
#	if [[ $STRT == 4 ]]; then
#		echo -e "This Strategy, AFAIK was only on AOKP (kitkat) and PAC-ROM (pac-5.1).";
#		echo -e "Let's go to vendor/$ROMNIS/products";
#		cd vendor/${ROMNIS}/products;
#		$(BLANK)
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
		echo -e "${LPURP}=========================================================${NONE}"
		echo -e "Now ${ROMNIS}fy! your Device Tree! Press ${LCYAN}ENTER${NONE} when ${LPURP}Done.${NONE} ";
		read NOOB;
		$(BLANK)
		sleep 2;
		$(BLANK)
		echo -e "${RED}=========================================================${NONE}"
		echo -e "I_IZ_NOOB :P - We're Successful";
		$(BLANK)
		if [ ! -f PREF.rc ]; then
			quick_menu;
		else
			echo -e "*AutoBot* Automated Pre-Build Successful"
		fi
} #pre_build

function build
{
	function clean_build
	{	          #Automate           #Manual
		if [[ "$MKCLNB4BLD" == 2 || "$BOPT" == 2 ]]; then
			$MKWAY installclean
		fi
		          #Automate            #Manual
		if [[ "$MKCLNB4BLD" == 3 || "$BOPT" == 3 ]]; then
			$MKWAY clean
		fi
	} #clean_build

	function make_it #Part of make_module
	{
		echo -e "${LCYAN}ENTER${NONE} the Directory where the Module is made from";
		$(BLANK)
		read MODDIR;
		echo -e "Do you want to ${LRED}push the Module${NONE} to the ${LRED}Device${NONE} ? (Running the Same ROM) ${LGRN}[y/n]${NONE}";
		$(BLANK)
		read PMOD;
		$(BLANK)
		if [[ "$PMOD" == y ]]; then
			mmmp -B $MODDIR;
		else
			mmm -B $MODDIR;
		fi
	} #make_it

	function make_module
	{
		echo -e "Do you know the build location of the Module?";
		$(BLANK)
		read KNWLOC;
		$(BLANK)
		if [[ "$KNWLOC" == y ]]; then
			make_it;
		else
			echo -e "Do either of these two actions: \n1. ${BLU}G${NONE}${RED}o${NONE}${YELO}o${NONE}${BLU}g${NONE}${GRN}l${NONE}${RED}e${NONE} it (Easier)\n2. Run this command in terminal : ${LBLU}sgrep \"LOCAL_MODULE := Insert_MODULE_NAME_Here \"${NONE}.\n\n Press ${LCYAN}ENTER${NONE} after it's ${LPURP}Done.${NONE}.";
			$(BLANK)
			read OK;
			make_it;
		fi
	} #make_module

	function set_ccache
	{
		echo -e "Setting up CCACHE"
		$(BLANK)
		prebuilts/misc/linux-x86/ccache/ccache -M ${CCSIZE}G
		echo -e "CCACHE Setup ${GRN}Successful${NONE}."
		$(BLANK)
	} #set_ccache

	function set_ccvars
	{
		echo -e "Provide this Script Root-Access, so that it can write CCACHE export values. No Hacks Honestly (Check the Code)"
		echo -en "Why? Coz .bashrc or it's equivalents can only be Modified by a Root user"
		$(BLANK)
		sudo -i;
		$(BLANK)
		if [[ $(whoami) == root ]]; then
			echo -e "Thanks, Performing Changes."
		else
			echo -e "No Root Access, Abort."
			main_menu;
		fi
		$(BLANK)
		echo -e "CCACHE Size must be >50 GB.\n Think about it and Specify the Size (Number) for Reservation of CCACHE (in GB)";
		$(BLANK)
		read CCSIZE;
		echo -e "Create a New Folder for CCACHE and Specify it's location from / here"
		$(BLANK)
		read CCDIR;
		if [ -f ${HOME}/.bashrc ]; then
				echo "export USE_CCACHE=1" >> ${HOME}/.bashrc
				echo "export CCACHE_DIR=${CCDIR}" >> ${HOME}/.bashrc
				source ${HOME}/.bashrc
		elif [ -f ${HOME}/.profile ]; then
			echo "export USE_CCACHE=1" >> ${HOME}/.profile
			echo "export CCACHE_DIR=${CCDIR}" >> ${HOME}/.profile
			source ${HOME}/.profile
#		elif [[ $( -f SOME_FILE )]]; then
#			echo "export USE_CCACHE=1" >> /SOME_LOC/SOME_FILE
#			echo "export CCACHE_DIR=${CCDIR}" >> /SOME_LOC/SOME_FILE
#			echo "Restart your PC and Select Step 'B'"
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
		$(BLANK)
		echo "Done."
		$(BLANK)
		set_ccache;
	} #set_ccvars

#	function post_make
#	{
#		if [[ $( grep -c 'make completed successfully' $TMP ) == 1 ]]; then
#			$(BLANK)
#			echo "Build Completed! Cool. Now make it Boot!"
#		elif [[ $(grep -c "No rule to make target ") == 1 ]]; then
#			echo -e "Looks like a Module isn't getting built."
#			echo -e "Find the name of the Missing Module, and Search from where it is being made."
#			echo -e "If done do a mmm to it - There are two chances:"
#			echo -e "		Either the Module will get built - OR - The Module will ask for other Dependency for it to get built"
#		fi
#	} WIP WIP WIP WIP

	function build_make
	{
		# For Brunchers
		if [[ "$SELT" == brunch ]]; then
			time ${SELT} ${DEVICE}
			echo -e "Grab the Logs Before you do anything else. IT will VANISH else"
		else
			# For Mka-s/Make-rs
			if [[ "$MKWAY" == make ]]; then
				BCORES=$(grep -c ^processor /proc/cpuinfo);
			else
				BCORES="";
			fi
			if [[ "$ROMNIS" == tipsy || "$ROMNIS" == validus || "$ROMNIS" == tesla ]]; then
				time	$MKWAY $ROMNIS $BCORES 2>&1 | tee $TMP
				$(BLANK)
				echo -e "Grab the Logs Before you do anything else. IT will VANISH else"
			elif [[ $(grep -q "^bacon:" "${ANDROID_BUILD_TOP}/build/core/Makefile") ]]; then
				time $MKWAY bacon $BCORES 2>&1 | tee $TMP
				$(BLANK)
				echo -e "Grab the Logs Before you do anything else. IT will VANISH else"
#				post_build; WiP
			else
				time $MKWAY otapackage $BCORES 2>&1 | tee $TMP
				$(BLANK)
				echo -e "Grab the Logs Before you do anything else. IT will VANISH else"
#				post_build; WiP
			fi
		fi
} #build_make

function hotel_menu
{
	echo -e "====================================[*] HOTEL MENU [*]====================================="
	$(BLANK)
	echo -e "                       ${LGRN}So, what would you like to feed your Device?${NONE} "
	$(BLANK)
	echo -e "${LRED}A SideNote : Menu is only for your Device, not for you. No Complaints plz.${NONE}"
	$(BLANK)
	echo -e "[*] ${RED}lunch${NONE} - If your Device is not in the ROM's Devices list - ${ORNG}Unofficial${NONE} [*]"
	echo -e "[*] ${YELO}breakfast${NONE} - (If your Device is a ${GRN}Official Device${NONE} for that particular ROM - ${GRN}Official${NONE} [*]"
	echo -e "[*] ${GRN}brunch${NONE} - lunch + sync capabilities like breakfast - ${ORNG}Unofficial${NONE} [*]"
	$(BLANK)
	echo -e "Type in the Option you want to select"
	echo -e "Tip! - If you're building it for the first time, then select lunch (Recommended)"
	echo -e "==========================================================================================="
	$(BLANK)

	#SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		buildinfo;
		echo -e "*AutoBot* Selected Option : $SELT"
	else
		read SELT;
	fi
	$(BLANK)
	if [ -f PREF.rc ]; then
		deviceinfo;              #Gather
		repoinit;                #All
		rom_name_in_source;      #Information
	fi

	if [[ "$SELT" == lunch ]]; then
		${SELT} ${ROMNIS}_${DEVICE}-${BTYP}
	elif [[ "$SELT" == breakfast ]]; then
		${SELT} ${DEVICE}
	fi
	$(BLANK)
	build_make;
} #hotel_menu

	echo -e "${LPURP}=========================================================${NONE}"
	$(BLANK)
	echo -e "${CYAN}Initializing Build Environment${NONE}";
	. build/envsetup.sh
	echo -e "${LPURP}Done.${NONE}."
	$(BLANK)
	echo -e "Select the Build Option:\n";
	$(BLANK)
	echo -e "${GRN}1. Start Building ROM (ZIP output)${NONE}";
	echo -e "${ORNG}2. Clean only Staging Directories and Emulator Images (*.img)${NONE}";
	echo -e "${LRED}3. Clean the Entire Build (/out) Directory (THINK BEFORE SELECTING THIS!)${NONE}";
	echo -e "${LGRN}4. Make a Particular Module${NONE}";
	echo -e "${LGRN}5. Setup CCACHE for Faster Builds ${NONE}";
	$(BLANK)
	echo -e "${LPURP}=========================================================${NONE}"
	$(BLANK)

	if [ -f PREF.rc ]; then
		buildinfo;
		echo -e "*AutoBot* Option Selected : $BOPT"
	else
		read BOPT;
	fi
	$(BLANK)
	if [[ "$BOPT" == 1 ]]; then
		hotel_menu;
		$(BLANK)
		echo -e "Should i use '${YELO}make${NONE}' or '${RED}mka${NONE}' ?"
		#SHUT_MY_MOUTH
		if [ -f PREF.rc ]; then
			buildinfo;
			echo -e "*AutoBot* Selected Method : $MKWAY "
		else
			$(BLANK)
			read MKWAY;
		fi
		$(BLANK)
		echo -e "Wanna Clean the /out before Building? [2/3 as in Build Menu]"
		$(BLANK)
		if [ -f PREF.rc ]; then
			buildinfo;
			echo -e "*AutoBot* Option Selected : $MKCLNB4BLD ";
		else
			read MKCLNB4BLD; #Name's Big - I'll change it later
		fi

		if [[ "$MKCLNB4BLD" == 2  || "$MKCLNB4BLD" == 3 ]]; then
		 clean_build; #CLEAN THE BUILD
		fi

		build_make; #Start teh Build!
	fi #$BOPT = 1

	if [[ "$BOPT" == 4 ]]; then
		make_module;
	fi

	if [[ "$BOPT" == 5 ]]; then
		echo -e "Two Steps. Select one of them (If seeing this for first time - Enter A)";
		echo -e " A. Enabling CCACHE Variables in .bashrc or it's equivalent"
		echo -e " B. Reserving Space for CCACHE";
		$(BLANK)
		read CCOPT;
		if [[ "$CCOPT" == A ]]; then
			set_ccvars;
		elif [[ "$CCOPT" == B ]]; then
			set_ccache;
		else
			$(BLANK)
			echo -e "Drunk? restart this Script.";
		fi
	fi

	if [ ! -f PREF.rc ]; then
		quick_menu;
	else
		echo -e "*AutoBot* Automated Build Successful"
	fi
} #build

#START IT --- VROOM!
if [[ "$1" == automate ]]; then
	source $(pwd)/PREF.rc
	automate;
	echo -e "*AutoBot* Automated Building Selected!"
else
	main_menu;
fi
