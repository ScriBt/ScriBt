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
# Create a folder for your Source (If First Sync) and                  #
# Place these files inside it                                          #
#                                                                      #
# https://github.com/a7r3/scripts - The Original Repo of this ScriBt   #
#                                                                      #
# You're free to enter your modifications and submit it to me with     #
# a Pull Request, such Contributions are readily WELCOME               #
#                                                                      #
# CONTRIBUTORS FOR THIS PROJECT:                                       #
# Arvind Raj (Myself)                                                  #
# Adrian DC                                                            #
# Akhil Narang                                                         #
#======================================================================#

# Create a Text file to Store Intermediate Outputs for Working on Some Commands
TMP=temp.txt; # temp
RTMP=repo_log.txt; # repo sync logs
RMTMP=rom_compile.txt; # rom build Logs
rm -rf ${TMP} ${RTMP} ${RMTMP};
touch ${RTMP} ${RMTMP} ${TMP};
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
	nline;
	echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Cheat Code SHUT_MY_MOUTH applied. I won't ask questions anymore";
	nline;
	echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Loading all Vars...."
	color;
	repoinit;
	reposync;
	deviceinfo;
	buildinfo;
	nline;
	echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Successfully Collected Information. Ready to Go!"
	nline
else
	echo -e "Using this for first time?\nDon't lose patience the next time. ${LCYAN}Enter${NONE} your Values in PREF.rc and Shut my Mouth! lol";
	nline;
	echo -e "PREF.rc is the file"
fi
nline;
echo "=======================================================";
echo -e "Before I can start, do you like a \033[1;31mC\033[0m\033[0;32mo\033[0m\033[0;33ml\033[0m\033[0;34mo\033[0m\033[0;36mr\033[0m\033[1;33mf\033[0m\033[1;32mu\033[0m\033[0;31ml\033[0m life? [y/n]";
echo "=======================================================";
nline;
if [ -f PREF.rc ]; then
	color;
	echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Coloured ScriBt : $COLOR "
else
	read COLOR;
fi
nline;
if [[ "$COLOR" == "y" ]]; then
	color_my_life;
	echo -e "Coloring AutoBot";
else
	i_like_colourless;
fi
sleep 2;
clear;
echo -ne '\033]0;ScriBt\007'
echo -e '\n\n';
sleep 0.1;
echo -e "${LRED}             88P'888'Y88         888                          ${NONE}";
sleep 0.1;
echo -e "${LRED}             P'  888  'Y  ,e e,  888 ee                       ${NONE}";
sleep 0.1;
echo -e "${LRED}                 888     d88 88b 888 88b                      ${NONE}";
sleep 0.1;
echo -e "${LRED}                 888     888   , 888 888                      ${NONE}";
sleep 0.1;
echo -e "${LRED}                 888      \"YeeP\" 888 888                      ${NONE}";
sleep 0.1;
echo -e " ";
sleep 0.1;
echo -e "${LBLU} ad88888ba                           88  88888888ba           ${NONE}";
sleep 0.1;
echo -e "${LBLU}d8\"     \"8b                          \"\"  88      \"8b    ,d    ${NONE}";
sleep 0.1;
echo -e "${LBLU}Y8,                                      88      ,8P    88    ${NONE}";
sleep 0.1;
echo -e "${LBLU}\`Y8aaaaa,     ,adPPYba,  8b,dPPYba,  88  88aaaaaa8P'  MM88MMM ${NONE}";
sleep 0.1;
echo -e "${LBLU}  \`\"\"\"\"\"8b,  a8\"     \"\"  88P'   \"Y8  88  88\"\"\"\"\"\"8b,    88    ${NONE}";
sleep 0.1;
echo -e "${LBLU}\`8b      8b  8b          88          88  88       8b    88    ${NONE}";
sleep 0.1;
echo -e "${LBLU}Y8a     a8P  \"8a,   ,aa  88          88  88      a8P    88,   ${NONE}";
sleep 0.1;
echo -e "${LBLU} \"Y88888P\"    \`\"Ybbd8\"'  88          88  88888888P\"     \"Y888 ${NONE}";
sleep 0.1;
nline;
sleep 0.1;
echo -e "${LCYAN}~#~#~#~#~#~#~#~#~#~#~${NONE} ${LRED}By Arvind7352${NONE} - ${ORNG}XDA${NONE} ${LCYAN}#~#~#~#~#~#~#~#~#~#~${NONE}";
sleep 3;
#GET THOSE ROOMS
nline;
nline;

function exitScriBt
{
	echo -e '\n\n';
	echo -e "Thanks for using this ${LRED}S${NONE}cri${GRN}B${NONE}t. Have a Nice Day";
	sleep 2;
	nline;
	echo "${LRED}Bye!${NONE}"
	exit 0;
} #exitScriBt

the_response ()
{
	if [[ "$1" == "COOL" ]]; then
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Automated $2 ${LGRN}Successful! :)${NONE}"
	elif [[ "$1" == "FAIL" ]]; then
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Automated $2 ${LRED}Failed :(${NONE}"
	fi
}

function main_menu
{
	echo -ne '\033]0;ScriBt : Main Menu\007'
	echo -e "${LRED}=======================================================${NONE}";
	echo -e "${LRED}====================${NONE}${CYAN}[*]${NONE}${PURP}MAIN MENU${NONE}${CYAN}[*]${NONE}${LRED}====================${NONE}";
	echo -e "${LRED}=======================================================${NONE}";
	nline;
	echo -e "         Select the Action you want to perform         ";
	nline;
	echo -e "${LBLU}1${NONE}${CYAN} ................${NONE}${RED}Choose ROM & Init*${NONE}${CYAN}.................${NONE} ${LBLU}1${NONE}";
	echo -e "${LBLU}2${NONE}${CYAN} .......................${NONE}${YELO}Sync${NONE}${CYAN}........................${NONE} ${LBLU}2${NONE}";
	echo -e "${LBLU}3${NONE}${CYAN} .....................${NONE}${GRN}Pre-Build${NONE}${CYAN}.....................${NONE} ${LBLU}3${NONE}";
	echo -e "${LBLU}4${NONE}${CYAN} .......................${NONE}${LGRN}Build${NONE}${CYAN}.......................${NONE} ${LBLU}4${NONE}";
	echo -e "${LBLU}5${NONE}${CYAN} ........${NONE}${PURP}Check and Install Build Dependencies${NONE}${CYAN}.......${NONE} ${LBLU}5${NONE}";
	nline;
	echo -e "6 .......................EXIT........................ 6";
	nline;
	echo -e "* - Sync will Automatically Start after Init'ing Repo";
	echo -e "${LRED}=======================================================${NONE}";
	nline;
	read ACTION;
	teh_action $ACTION;

} #main_menu

function quick_menu
{
	echo -ne '\033]0;ScriBt : Quick Menu\007'
	echo -e "${YELO}============================${NONE} ${LRED}QUICK-MENU${NONE} ${YELO}=============================${NONE}"
	echo -e "${RED}1. Init${NONE} | ${YELO}2. Sync${NONE} | ${GRN}3. Pre-Build${NONE} | ${LGRN}4. Build${NONE} | ${PURP}5. Install Dependencies${NONE}"
	echo -e "                               6. Exit                               "
	echo -e "${YELO}=====================================================================${NONE}"
	read ACTION;
	teh_action $ACTION;
}

cherrypick ()
{
	echo -ne '\033]0;ScriBt : Picking Cherries\007'
	echo -e "${GRN}========================= Teh${NONE} ${LRED}Cherry${NONE} ${GRN}Picker========================${NONE}";
 	nline;
	echo -e "     ${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Attempting to Cherry-Pick Provided Commits         ";
  git fetch https://github.com/${REPOPK}/${REPONAME} ${CP_BRNC}
 	nline;
 	git cherry-pick $1;
 	echo -e "IT's possible that you may face conflicts while merging a C-Pick. Solve those and then Continue."
	echo -e "${GRN}==================================================================${NONE}"
}

function installdeps
{
	if [ -f PREF.rc ]; then
		teh_action 5;
	fi
	function java_select
	{
		echo -e "If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)"
		echo -e "You may now select the Version of Java which is to be used BY-DEFAULT"
		echo -e "${BLU}================================================================${NONE}"
		nline;
		sudo update-alternatives --config java
		nline;
		echo -e "${BLU}================================================================${NONE}"
		nline;
		sudo update-alternatives --config javac
		nline;
		echo -e "${BLU}================================================================${NONE}";
	}

	function java6
	{
		echo -ne '\033]0;ScriBt : Java 6 Installation\007'
		echo -e "Installing OpenJDK-6 (Java 1.6.0)"
		echo -e "Remove other Versions of Java [y/n]? ( Removing them is Recommended)"
		nline;
		read REMOJA;
		nline;
		if [[ "$REMOJA" == "y" ]]; then
		sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
		nline;
		echo -e "Removed Other Versions successfully"
		elif [[ "$REMOJA" == "n" ]]; then
		 echo -e "Keeping them Intact"
	 	fi
	 	echo -e "${RED}==========================================================${NONE}";
	 	nline;
		sudo apt-get update
		echo -e "${RED}==========================================================${NONE}";
		nline;
		sudo apt-get install openjdk-6-jdk
		nline;
		echo -e "${RED}==========================================================${NONE}";
		nline;
		if [[ $( java -version &> $TMP && grep -c 'java version "1.6' $TMP ) == "1" ]]; then
			echo -e "OpenJDK-6 or Java 6 has been successfully installed"
			echo -e "${RED}==========================================================${NONE}";
		fi
	}

	function java7
	{
		echo -ne '\033]0;ScriBt : Java 7 Installation\007'
		echo -e "Installing OpenJDK-7 (Java 1.7.0)"
		echo -e "Remove other Versions of Java [y/n]? ( Removing them is Recommended)"
		nline;
		read REMOJA;
		nline;
		if [[ "$REMOJA" == "y" ]]; then
			sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
			echo -e "Removed Other Versions successfully"
		elif [[ "$REMOJA" == "n" ]]; then
		 	echo -e "Keeping them Intact"
	 	fi
	 	nline;
	 	echo -e "${RED}==========================================================${NONE}";
		nline;
		sudo apt-get update
		nline;
		echo -e "${RED}==========================================================${NONE}";
		nline;
		sudo apt-get install openjdk-7-jdk
		nline;
		if [[ $(java -version &> $TMP && grep -c 'java version "1.7' $TMP ) == "1" ]]; then
			nline;
			echo -e "${RED}==========================================================${NONE}";
			echo -e "OpenJDK-7 or Java 7 has been successfully installed"
		fi
		echo -e "${RED}==========================================================${NONE}";
	}

	function java8
	{
		echo -ne '\033]0;ScriBt : Java 8 Installation\007'
		echo -e "Remove other Versions of Java [y/n]? ( Removing them is Recommended)"
		nline;
		read REMOJA;
		if [[ "$REMOJA" == "y" ]]; then
			nline;
			sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*
			nline;
			echo -e "Removed Other Versions successfully"
		elif [[ "$REMOJA" == "n" ]]; then
		 	echo -e "Keeping them Intact"
	 	fi
		nline;
		echo -e "Installing OpenJDK-8 (Java 1.8.0)"
		nline;
		echo -e "${RED}==========================================================${NONE}";
		nline;
		sudo apt-get update
		nline;
		echo -e "${RED}==========================================================${NONE}";
		nline;
		sudo apt-get install openjdk-8-jdk
		nline;
		echo -e "${RED}==========================================================${NONE}";
		if [[ $( java -version &> $TMP && grep -c 'java version "1.8' $TMP ) == 1 ]]; then
			nline;
			echo -e "OpenJDK-8 or Java 8 has been successfully installed"
			nline;
		fi
		echo -e "${RED}==========================================================${NONE}";
	}

	echo -e "${RED}==========================================================${NONE}";
	nline;
	echo -e "Installing Build Dependencies..."
	nline;
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
pngcrush schedtool libwxgtk2.8-dev python liblz4-tool \
maven maven2
	nline;
	echo -e "${RED}==========================================================${NONE}";
	nline;
	echo -e "Updating / Installing Android udev rules (51-android)"
	nline;
	sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules
	sudo chmod a+r /etc/udev/rules.d/51-android.rules
	nline;
	sudo service udev restart
	nline;
	echo -e "${RED}==========================================================${NONE}";
	echo -e '\n\n';
	echo -e "${LGRN}=====================${NONE} ${LPURP}JAVA Installation${NONE} ${LGRN}====================${NONE}";
	nline;
	echo -e "1. Install Java"
	echo -e "2. Switch Between Java Versions / Providers"
	nline;
	echo -e "3. Already Configured? Back to Main Menu"
	echo -e "${LGRN}==========================================================${NONE}";
	nline;
	read JAVAS;
	nline;
	if [[ "$JAVAS" == "1" ]]; then
		echo -ne '\033]0;ScriBt : Java\007'
		echo -e "Android Version of the ROM you're building ? "
		echo -e "1. 4.4 KitKat"
		echo -e "2. 5.x.x Lollipop & 6.x.x Marshmallow"
		echo -e "3. Android N (lol)"
		nline;
		read ANDVER;
		nline;
		if [[ "$ANDVER" == "1" ]]; then
			java6;
		elif [[ "$ANDVER" == "2" ]]; then
			java7;
		elif [[ "$ANDVER" == "3" ]]; then
			java8;
		fi
	elif [[ "$JAVAS" == "2" ]]; then
		java_select;
	elif [[ "$JAVAS" == "3" ]]; then
		main_menu;
	fi

} #installdeps

function sync
{
	if [ -f PREF.rc ]; then
		repoinit;
		rom_name_in_github;
		teh_action 2;
	fi
	nline;
	echo -e "Let's sync it!";
	nline;
	echo -e "${LRED}Number of Threads${NONE} for Sync?";
	nline;
	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		reposync;
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} No of Threads : ${JOBS}"
	else
		read JOBS;
	fi
	nline;
	echo -e "${LRED}Force Sync${NONE} needed? ${LGRN}[y/n]${NONE}";
	nline;
	if [ -f PREF.rc ]; then
		reposync;
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Force Sync : ${FRC}"
	else
		read FRC;
	fi
	nline;
	echo -e "Need some ${LRED}Silence${NONE} in teh Terminal? ${LGRN}[y/n]${NONE}";
	nline;

	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		reposync;
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Silent Sync : ${SIL}"
	else
		read SIL;
	fi
	nline;

	echo -e "Sync only Current Branch? ${LGRN}[y/n]${NONE} (Saves Space)"
	nline;
	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		reposync;
		echo -e  "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Sync Current Branch : $CRNT"
	else
		read CRNT;
	fi
	nline;
	echo -e "Sync with ${LRED}clone-bundle${NONE} ${LGRN}[y/n]${NONE}?"
	nline;
	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		reposync;
		echo -e  "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Use ${LRED}clone-bundle${NONE} : $CLN"
	else
		read CLN;
	fi

	nline;
	echo -e "${LRED}=====================================================================${NONE}";
	#Sync-Options
	if [[ "$SIL" == "y" ]]; then
		SILENT=-q;
	else
		SILENT=" " ;
	fi
	if [[ "$FRC" == "y" ]]; then
		FORCE=--force-sync;
	else
		FORCE=" " ;
	fi
	if [[ "$CRNT" == "y" ]]; then
		SYNC_CRNT=-c;
	else
		SYNC_CRNT=" ";
	fi
	if [[ "$CLN" == "y" ]]; then
		CLN_BUN=" ";
	else
		CLN_BUN=--no-clone-bundle;
	fi

	nline;
	echo -e "Let's Sync!";
	nline;
	repo sync -j${JOBS} ${SILENT} ${FORCE} ${SYNC_CRNT} ${CLN_BUN}  2>&1 | tee $RTMP;
	nline;
	if [[ $(tac $RTMP | grep -m 1 -c 'Syncing work tree: 100%') == 1 ]]; then
		echo -e "ROM Source synced successfully."
		if [ -f PREF.rc ]; then
			nline;
			the_response COOL Sync;
		fi
	else
		if [ -f PREF.rc ]; then
			nline;
			the_response FAIL Sync;
		fi
		nline;
		echo -e "${LPURP}Done.${NONE}!";
		nline;
		echo -e "${LRED}=====================================================================${NONE}";
		nline;
		if [ ! -f PREF.rc ]; then
			quick_menu;
		fi
	fi
} #sync

function init
{
	if [ -f PREF.rc ]; then
		teh_action 1;
	fi
	echo -e "${LPURP}=======================================================${NONE}";
	nline;
	echo -e "Which ROM are you trying to build?
Choose among these (Number Selection)

1.${BLU} AICP ${NONE}
2.${RED} AOKP ${NONE}
3.${LGRN} AOSP-RRO ${NONE}
4.${DGRAY} AOSP-CAF ${NONE}
5.${CYAN} BlissRoms by Team Bliss${NONE}
6.${CYAN} CandyRoms ${NONE}
7.${LCYAN} Cyan${NONE}${CYAN}ide-L${NONE}
8.${CYAN} CyanogenMod ${NONE}
9.${ORNG} DirtyUnicorns ${NONE}
10.${YELO} Flayr OS ${NONE}
11.${BLU} Krexus${NONE}-${GRN}CAF${NONE}
12.${GRN} OmniROM ${NONE}
13.${PURP} Orion OS ${NONE}
14.${ORNG} OwnROM ${NONE}
15.${BLU} PAC-ROM ${NONE}
16.${LRED} Resurrection Remix ${NONE}
17.${LBLU} SlimRoms ${NONE}
18.${LRED} Temasek ${NONE}
19.${LBLU} GZR Tesla ${NONE}
20.${YELO} Tipsy OS ${NONE}
21.${LPURP} GZR Validus ${NONE}
22.${LCYAN} XenonHD by Team Horizon ${NONE}
23.${BLU} Xperia Open Source Project aka XOSP ${NONE}

${LPURP}=======================================================${NONE}";
	nline;
	read ROMNO;
	sleep 1;
	#
	rom_name_in_github;
	#
	nline;
	echo -e "You have chosen ${LCYAN}->${NONE} $ROM_FN";
	sleep 1;
	nline;
	echo -e "Since Branches may live or die at any moment, ${LRED}Specify the Branch${NONE} you're going to sync"
	nline;

	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		repoinit;
		echo -e "${LRED}Branch${NONE} : $BRANCH"
	else
		read BRANCH;
	fi

	nline;
	echo -e "Any ${LRED}Source you have already synced?${NONE} If ${LGRN}yes${NONE}, then say ${LGRN}YES${NONE} and Press ${LCYAN}ENTER${NONE}";
	nline;

	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		repoinit;
		if [[ "$REFY" == YES ]]; then
			echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} ${LGRN}YES${NONE}, you have a Reference Source"
			nline;
			echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} The Reference location is : ${REF}"
		else
			echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} ${LRED}NO${NONE}, you don't have a Reference Source. Going for a ${LGRN}Fresh${NONE} Sync"
		fi
	else
		read REFY;
	fi

	if [ ! -f PREF.rc ]; then
		if [[ "$REFY" == YES ]]; then
			nline;
			echo -e "Provide me the ${LRED}Synced Source's Location${NONE} from / ";
			nline;
			read REFER;
			REF=--reference\=\"${REFER}\"
		else
			REF=" " ;
		fi
	fi

	nline;
	echo -e "Set ${LRED}clone-depth${NONE} ? ${LGRN}[y/n]${NONE} (Basically, it Syncs the ${GRN}Entire commit history of any repo${NONE}, thus Occupying ${LRED}More space${NONE})"
	if [ -f PREF.rc ]; then
		repoinit;
		echo -e "Use ${LRED}clone-depth${NONE} : ${CLND}"
	else
		read CLND;
	fi
	nline;
	echo -e "Depth ${LRED}Value${NONE}? (Default ${LRED}1${NONE})"
	nline;
	if [ -f PREF.rc ]; then
		repoinit;
		echo -e "clone-depth ${LRED}Value${NONE} : ${DEPTH}";
	else
		read DEPTH;
	fi
	if [ -z "$DEPTH" ]; then
		DEPTH=1;
	fi
		nline;
	#Getting Manifest Link
		if [[ "$ROM_NAME" == "OmniROM" || "$ROM_NAME" == "CyanogenMod" || "$ROM_NAME" == "OwnROM" || "$ROM_NAME" == "temasek" ]]; then
			MAN=android.git;
		fi
		if [[ "$ROM_NAME" == "TeamOrion" || "$ROM_NAME" == "SlimRoms" || "$ROM_NAME" == "AOSP-CAF" || "$ROM_NAME" == "ResurrectionRemix" || "$ROM_NAME" == "AOKP" || "$ROM_NAME" == "TipsyOS" || "$ROM_NAME" == "AICP" || "$ROM_NAME" == "XOSP-Project" || "$ROM_NAME" == "BlissRoms" ]]; then
			MAN=platform_manifest.git;
		fi
		if [[ "$ROM_NAME" == "DirtyUnicorns" ]]; then
			MAN=android_manifest.git;
		fi
		if [[ "$ROM_NAME" == "AOSP-RRO" || "$ROM_NAME" == "FlayrOS" || "$ROM_NAME" == "Krexus-CAF" || "$ROM_NAME" == "ValidusOs-M" || "$ROM_NAME" == "Tesla-M" ]]; then
				MAN=manifest.git;
		fi
		if [[ "$ROM_NAME" == "PAC-ROM" ]]; then
				MAN=pac-rom.git;
		fi
		if [[ "$ROM_NAME" == "CandyRoms" ]]; then
				MAN=candy.git;
		fi
		if [[ "$ROM_NAME" == "CyanideL" ]]; then
			MAN=cyanide_manifest.git;
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
			nline;
			echo "Adding ~/bin to PATH"
			nline;
			echo -e "# set PATH so it includes user's private bin if it exists" >> ~/.profile
			echo -e "if [ -d \"\$HOME/bin\" ] ; then" >> ~/.profile
			echo -e "\tPATH=\"\$HOME/bin:\$PATH\" "; >> ~/.profile
			echo -e "fi"; >> ~/.profile
			source ~/.profile
			echo -e "${LGRN}DONE!${NONE}. Ready to Init Repo"
			nline;
		fi

	echo -e "${LBLU}=========================================================${NONE}";
	nline;
	echo -e "Let's Initialize teh ROM Repo";
	nline;
	repo init ${REF} -u https://github.com/${ROM_NAME}/${MAN} -b ${BRANCH} ;
	nline;
	echo -e "Repo Init'ed";
	nline;
	echo -e "${LBLU}=========================================================${NONE}";
	nline;
	mkdir .repo/local_manifests
	echo -e "A folder \"local_manifests\" has been created for you."
	echo -e "Add either a local_manifest.xml or roomservice.xml as per your choice";
	echo -e "And add your Device-Specific Repos, essential for Building. Press ENTER to start Syncing.";
	read ENTER;
	nline;

#Start Sync now
sync;

} #init

function pre_build
{
	if [ -f PREF.rc ]; then
		teh_action 3;
	fi
	echo -e "${CYAN}Initializing Build Environment${NONE}"
	nline;
	. build/envsetup.sh
	nline;
	echo -e "${LPURP}Done.${NONE}."
	echo -e '\n\n';
	echo -e "${LCYAN}====================== DEVICE INFO ======================${NONE}";
	nline;
	echo -e "What's your ${LRED}Device's CodeName${NONE} ${LGRN}[Refer Device Tree - All Lowercases]${NONE}?";
	nline;

	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		deviceinfo;
		echo -e "Your Device ${LRED}Name${NONE} is : ${DEVICE}"
	else
		read DEVICE;
	fi
	nline;
	echo -e "The ${LRED}Build type${NONE}? ${LGRN}[userdebug/user/eng]${NONE}";
	nline;

	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		deviceinfo;
		echo -e "Build ${LRED}type${NONE}: ${DEVICE}"
	else
		read BTYP;
	fi

	nline;
	echo -e "Your ${LRED}Device's Company/Vendor${NONE} (All Lowercases)?";
	nline;

	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		deviceinfo;
		echo -e "Device's ${LRED}Vendor${NONE} : ${COMP}"
	else
		read COMP;
	fi

	nline;
	echo -e "${LCYAN}=========================================================${NONE}";
	rom_name_in_source;
	nline;
	nline;

function vendor_strat_all
{
	cd vendor/${ROMNIS}
	echo -e "${LPURP}=========================================================${NONE}"
	nline;
	if [ -f ${ROMNIS}.devices ]; then
		echo -e "Adding your Device to ROM Vendor (Strategy 1)";
		nline;
		if [[ $(grep -c '${DEVICE}' ${ROMNIS}.devices) == "0" ]]; then
			echo "${DEVICE}" >> ${ROMNIS}.devices;
		else
			echo -e "Device was already added to ${ROMNIS} vendor"
		fi
		echo "${LGRN}DONE!${NONE}!"
		croot;
	elif [ -f ${ROMNIS}-device-targets ]; then
		echo -e "Adding your Device to ROM Vendor (Strategy 4)"
		nline;
		if [[ $(grep -c '${DEVICE}' ${ROMNIS}-device-targets) == "0" ]]; then
			echo -e "${ROMNIS}_${DEVICE}-${BTYP}";
		else
			echo -e "Device was already added to ${ROMNIS} vendor"
		fi
		echo "${LGRN}DONE!${NONE}"
	elif [ -f vendorsetup.sh ]; then
		echo -e "Adding your Device to ROM Vendor (Strategy 2)"
		nline;
		if [[ $(grep -c '${DEVICE}' vendorsetup.sh) == "0" ]]; then
			echo "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}" >> vendorsetup.sh
		else
			echo -e "Device was already added to ${ROMNIS} vendor";
		fi
		echo "${LGRN}DONE!${NONE}"
		croot;
	else
		croot;
		echo "Adding your Device to ROM Vendor (Strategy 3)"
		echo -e "Let's go to teh ${LRED}Device Directory!${NONE}";
		nline;
		cd device/${COMP}/${DEVICE};
		echo -e "Creating vendorsetup.sh if absent in tree";
			if [ ! -f vendorsetup.sh ]; then
				touch vendorsetup.sh;
				echo -e "Done [1/2]"
			fi
			if [[ $(grep -c '${ROMNIS}_${DEVICE}' vendorsetup.sh ) == "0" ]]; then
				echo -e "add_lunch_combo ${ROMNIS}_${DEVICE}-${BTYP}" >> vendorsetup.sh
			else
				echo -e "Device already added to vendorsetup.sh"
			fi
		nline;
		echo "DONE! [2/2]"
		croot;
	fi
	echo -e "${LPURP}=========================================================${NONE}"
} #vendor_strat

function vendor_strat_kpa #for ROMs having products folder
{
	croot;
	cd vendor/${ROMNIS}/products;
	# SHUT_MY_MOUTH
	if [ ! -f PREF.rc ]; then
		if [[ "$ROMNIS" == "pac" || "$ROMNIS" == "krexus" ]]; then
			THE_FILE=${ROMNIS}_${DEVICE}.mk;
		else
			#AOKP
			THE_FILE=${DEVICE}.mk
			nline >> AndroidProducts.mk;
			echo "PRODUCT_MAKEFILES := \ " >> AndroidProducts.mk;
			echo -e "\t$(LOCAL_DIR)/${DEVICE}.mk" >> AndroidProducts.mk;
		fi
	else
		vendorstrat;
		${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Device-Vendor Conjunction File : ${THE_FILE};
	fi
	#Create Device-Vendor Conjuctor
	touch ${THE_FILE};
	echo -e "Name your Device Specific Configuration File ( eg. ${ROMNIS}.mk / full_huashan.mk as in your device tree)"
	nline;
	# SHUT_MY_MOUTH
	if [ ! -f PREF.rc ]; then
		read DEVCON;
	else
		vendorstrat;
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Device Configuration file : ${DEVCON}";
	fi
	echo -e "\$(call inherit-product, device/${COMP}/${DEVICE}/${DEVCON})" >> ${THE_FILE};
	echo -e "Specify your Device's Resolution in the format ${LCYAN}HORIZONTAL${NONE}${LRED}x${NONE}${LCYAN}VERTICAL${NONE} (eg. 1280x720)"
	if [ ! -f PREF.rc ]; then
		echo -e "Among these Values - Select the one which is nearest or almost Equal to that of your Device"
		echo -e "Resolutions which are available for AOKP are shown by \"(AOKP)\". All Res are available for PAC-ROM ";
		echo -e "
${LPURP}240${NONE}x400
${LPURP}320${NONE}x480 (AOKP)
${LPURP}480${NONE}x800 and ${LPURP}480${NONE}x854 (AOKP)
${LPURP}540${NONE}x960 (AOKP)
${LPURP}600${NONE}x1024
${LPURP}720${NONE}x1280 (AOKP)
${LPURP}768${NONE}x1024 and ${LPURP}768${NONE}x1280 (AOKP)
${LPURP}800${NONE}x1280 (AOKP)
${LPURP}960${NONE}x540
${LPURP}1080${NONE}x1920 (AOKP)
${LPURP}1200${NONE}x1920
${LPURP}1280${NONE}x800
${LPURP}1440${NONE}x2560
${LPURP}1536${NONE}x2048
${LPURP}1600${NONE}x2560
${LPURP}1920${NONE}x1200
${LPURP}2560${NONE}x1600";
		nline;
		echo -e "Type only the First (Highlighted in ${LPURP}Purple${NONE}) Number (eg. if 720x1280 then type in 720)";
		read BOOTRES;
	else
		vendorstrat;
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Resolution Choosed : ${BOOTRES}";
	fi
	#Vendor-Calls
	if [[ "$ROMNIS" == "krexus" ]]; then
		echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/common.mk)" >> ${THE_FILE};
		echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/vendorless.mk)" >> ${THE_FILE};
	fi
	if [[ "$ROMNIS" == "pac" ]]; then
			echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/pac_common.mk)" >> ${THE_FILE};
			echo "PAC_BOOTANIMATION_NAME := ${BOOTRES};" >> ${THE_FILE};
	fi
	if [[ "$ROMNIS" == "aokp" ]]; then
		# Boot animation
		echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> ${THE_FILE};
		echo "PRODUCT_COPY_FILES += \ " >> ${THE_FILE};
    echo -e "\tvendor/aokp/prebuilt/bootanimation/bootanimation_${BOOTRES}.zip:system/media/bootanimation.zip" >> ${THE_FILE};
	fi
	#PRODUCT_NAME is the only ROM-dependent variable, setting it here is better.
	echo "PRODUCT_NAME := ${ROMNIS}_${DEVICE}" >> ${THE_FILE};
} #vendor_strat_kpa

	if [ -f vendor/${ROMNIS}/products ]; then
		if [ ! -f vendor/${ROMNIS}/products/${ROMNIS}_${DEVICE}.mk || ! -f vendor/${ROMNIS}/products/${DEVICE}.mk ]; then
			vendor_strat_kpa; #if found products folder
		else
			echo -e "Looks like ${DEVICE} has been already added to ${ROMNIS} vendor. Good to go"
		fi
	else
		vendor_strat_all; #if not found
	fi
		croot;
	if [ ! -f PREF.rc ]; then
		echo -e "${PURP}=========================================================${NONE}"
		nline;
		echo -e "Now, ${ROMNIS}fy your Device Tree. Press ${LCYAN}Enter${NONE}, when ${LGRN}done${NONE}"
		nline;
		echo -e "${PURP}=========================================================${NONE}"
		read ENTDONE;
	fi
	if [ ! -f PREF.rc ]; then
		quick_menu;
	else
	the_response COOL Pre-Build;
	fi

} #pre_build

function build
{
	if [ -f PREF.rc ]; then
		repoinit;
		rom_name_in_github;
		teh_action 4;
	fi

	function clean_build
	{	          #Automate           #Manual
		if [[ "$COPT" == "2" || "$BOPT" == "2" ]]; then
			$MKWAY installclean
		fi
		          #Automate            #Manual
		if [[ "$COPT" == "3" || "$BOPT" == "3" ]]; then
			$MKWAY clean
		fi
	} #clean_build

	function make_it #Part of make_module
	{
		echo -e "${LCYAN}ENTER${NONE} the Directory where the Module is made from";
		nline;
		read MODDIR;
		echo -e "Do you want to ${LRED}push the Module${NONE} to the ${LRED}Device${NONE} ? (Running the Same ROM) ${LGRN}[y/n]${NONE}";
		nline;
		read PMOD;
		nline;
		if [[ "$PMOD" == "y" ]]; then
			mmmp -B $MODDIR;
		else
			mmm -B $MODDIR;
		fi
	} #make_it

	make_module ()
	{
		if [ -z "$1" ]; then
		nline;
		read KNWLOC;
		nline
		echo -e "Know the Location of the Module?"
		fi
		if [[ "$KNWLOC" == "y" || "$1" == "y" ]]; then
			make_it;
		else
			echo -e "Do either of these two actions: \n1. ${BLU}G${NONE}${RED}o${NONE}${YELO}o${NONE}${BLU}g${NONE}${GRN}l${NONE}${RED}e${NONE} it (Easier)\n2. Run this command in terminal : ${LBLU}sgrep \"LOCAL_MODULE := Insert_MODULE_NAME_Here \"${NONE}.\n\n Press ${LCYAN}ENTER${NONE} after it's ${LPURP}Done.${NONE}.";
			nline;
			read OK;
			make_it;
		fi
	} #make_module

	function post_build
	{
		if [[ $(tac $RMTMP | grep -c -m 1 '#### make completed successfully') == "1" ]]; then
			nline;
			echo "Build Completed ${LGRN}Successfully!${NONE} Cool. Now make it ${LRED}Boot!${NONE}"
			the_response COOL Build;
			teh_action 6 COOL;
		elif [[ $(tac $RMTMP | grep -c -m 1 'No rule to make target') == "1" ]]; then
			if [ ! -f PREF.rc ]; then
				echo -e "Looks like a Module isn't getting built / Missing"
				echo -e "You'll see a line like this:"
				nline;
				echo -e "No rule to make target '$(pwd)/out/....../${LRED}<MODULE_NAME>${NONE}_intermediates'"
				nline;
				echo -e "${LCYAN}Enter${NONE} whatever you see in place of ${LRED}<MODULE_NAME>${NONE} (Case-Sensitive please)"
				read MOD_NAME;
				echo -e "Let's Search for ${LRED}${MOD_NAME}${NONE} ! This will take time, but it's Valuable";
				nline;
				sgrep "LOCAL_MODULE := ${MOD_NAME}" 2>&1 | tee mod.txt;
				nline;
				if [[ $(grep -c -m 1 'LOCAL_MODULE') == "1" ]]; then
					echo -e "Looks like you've found that location, let's make it"
					nline;
					make_module y;
				else
					echo -e "The Repo which builds that module is ${LRED}missing${NONE}\n"
					echo -e "======================================================================================================";
					nline;
					echo -e "Let me search that module for you -> http://lmgtfy.com/?q=LOCAL_MODULE+%3A%3D+${MOD_NAME}"
					nline;
					echo -e "======================================================================================================";
					echo -e "\nIF you found that module's repo, Sync it to the path as shown in the Repo URL\n";
					echo -e "For Example https://github.com/CyanogenMod/android_bionic should be synced to $(pwd)/bionic";
					nline;
					make module;
				fi
			else
				the_response FAIL Build;
				teh_action 6 FAIL;
			fi
		else
			echo -e "WEW. ${YELO}I_iz_Noob${NONE}. Probably you need to Search the Internet for Resolution of the Above Error";
			if [ -f PREF.rc ]; then
				teh_action 6 FAIL;
				the_response FAIL Build;
			fi
		fi
	}

	function set_ccache
	{
		echo -e "Setting up CCACHE"
		nline;
		prebuilts/misc/linux-x86/ccache/ccache -M ${CCSIZE}G
		echo -e "CCACHE Setup ${GRN}Successful${NONE}."
		nline;
	} #set_ccache

	function set_ccvars
	{
		echo -e "Provide this Script Root-Access, so that it can write CCACHE export values. No Hacks Honestly (Check the Code)"
		echo -en "Why? Coz .bashrc or it's equivalents can only be Modified by a Root user"
		nline;
		sudo -i;
		nline;
		if [[ $(whoami) == "root" ]]; then
			echo -e "Thanks, Performing Changes."
		else
			echo -e "No Root Access, Abort."
			main_menu;
		fi
		nline;
		echo -e "CCACHE Size must be ${LRED}>50 GB${NONE}.\n Think about it and Specify the Size (Number) for Reservation of CCACHE (in GB)";
		nline;
		read CCSIZE;
		echo -e "Create a New Folder for CCACHE and Specify it's location from / here"
		nline;
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
		nline;
		echo "Done."
		nline;
		set_ccache;
	} #set_ccvars

	function build_make
	{
		# For Brunchers
		if [[ "$SELT" == "brunch" ]]; then
			clean_build;
			time ${SELT} ${DEVICE}
		else
			# For Mka-s/Make-rs
			if [[ "$MKWAY" == "make" ]]; then
				BCORES=$(grep -c ^processor /proc/cpuinfo);
			else
				BCORES="";
			fi
			if [[ "$ROMNIS" == "tipsy" || "$ROMNIS" == "validus" || "$ROMNIS" == "tesla" ]]; then
				time	$MKWAY $ROMNIS $BCORES 2>&1 | tee $RMTMP;
				nline;
				post_build;
			elif [[ $(grep -q "^bacon:" "${ANDROID_BUILD_TOP}/build/core/Makefile") ]]; then
				time $MKWAY bacon $BCORES 2>&1 | tee $RMTMP;
				nline;
				post_build;
			else
				time $MKWAY otapackage $BCORES 2>&1 | tee $RMTMP;
				nline;
				post_build;
			fi
		fi
} #build_make

function hotel_menu
{
	echo -e "${LBLU}====================================${NONE}${RED}[*]${NONE} ${GRN}HOTEL MENU${NONE} ${RED}[*]${NONE}${LBLU}=====================================${NONE}"
	nline;
	echo -e "                       ${LGRN}So, what would you like to feed your Device?${NONE} "
	nline;
	echo -e "${LRED}A SideNote : Menu is only for your Device, not for you. No Complaints plz.${NONE}"
	nline;
	echo -e "[*] ${RED}lunch${NONE} - If your Device is not in the ROM's Devices list - ${ORNG}Unofficial${NONE} [*]"
	echo -e "[*] ${YELO}breakfast${NONE} - (If your Device is a ${GRN}Official Device${NONE} for that particular ROM - ${GRN}Official${NONE} [*]"
	echo -e "[*] ${GRN}brunch${NONE} - lunch + sync repos from ${ROMNIS}.dependencies + build - ${ORNG}Official/Unofficial${NONE} [*]"
	nline;
	echo -e "Type in the Option you want to select"
	echo -e "${YELO}Tip!${NONE} - If you're building it for the first time, then select ${RED}lunch${NONE} (Recommended)"
	echo -e "${LBLU}===========================================================================================${NONE}"
	nline;

	# SHUT_MY_MOUTH
	if [ -f PREF.rc ]; then
		buildinfo;
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Selected Option : $SELT"
	else
		read SELT;
	fi
	nline;
	if [ -f PREF.rc ]; then
		deviceinfo;              #Gather
		repoinit;                #All
		rom_name_in_source;      #Information
	fi

	if [[ "$SELT" == "lunch" ]]; then
		${SELT} ${ROMNIS}_${DEVICE}-${BTYP}
	elif [[ "$SELT" == "breakfast" ]]; then
		${SELT} ${DEVICE} ${BTYP}
	fi
	nline;
} #hotel_menu

	nline;
	echo -e "${YELO}=========================================================${NONE}"
	echo -e "${CYAN}Initializing Build Environment${NONE}";
	nline;
	. build/envsetup.sh
	nline;
	echo -e "${YELO}=========================================================${NONE}"
	nline;
	echo -e "${LPURP}Done.${NONE}."
	nline;
	echo -e "${LPURP}=========================================================${NONE}"
	ecgo -e '\n;'
	echo -e "Select the Build Option:\n";
	nline;
	echo -e "${LCYAN}1. Start Building ROM (ZIP output)${NONE}";
	echo -e "${YELO}2. Clean only Staging Directories and Emulator Images (*.img)${NONE}";
	echo -e "${LRED}3. Clean the Entire Build (/out) Directory (THINK BEFORE SELECTING THIS!)${NONE}";
	echo -e "${LGRN}4. Make a Particular Module${NONE}";
	echo -e "${LBLU}5. Setup CCACHE for Faster Builds ${NONE}";
	nline;
	echo -e "${LPURP}=========================================================${NONE}"
	nline;

	if [ -f PREF.rc ]; then
		buildinfo;
		echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Option Selected : $BOPT"
	else
		read BOPT;
	fi
	nline;
	if [[ "$BOPT" == "1" ]]; then
		hotel_menu;
		nline;
		echo -e "Should i use '${YELO}make${NONE}' or '${RED}mka${NONE}' ?"
		# SHUT_MY_MOUTH
		nline;
		if [ -f PREF.rc ]; then
			buildinfo;
			echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Selected Method : $MKWAY "
		else
			read MKWAY;
		fi
		nline;
		echo -e "Wanna Clean the ${LPURP}/out${NONE} before Building? ${LGRN}[2 - Remove Staging / 3 - Full Clean]${NONE}"
		nline;
		if [ -f PREF.rc ]; then
			buildinfo;
			echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Option Selected : $COPT ";
		else
			read COPT;
		fi
		nline;
		if [[ "$COPT" == "2"  || "$COPT" == "3" ]]; then
		 clean_build; #CLEAN THE BUILD
		fi
		nline;
		build_make; #Start teh Build!
	fi #$BOPT = 1

	if [[ "$BOPT" == "4" ]]; then
		make_module;
	fi

	if [[ "$BOPT" == "5" ]]; then
		echo -e "Two Steps. Select one of them (If seeing this for first time - ${LCYAN}Enter${NONE} A)";
		echo -e "\tA. Enabling CCACHE Variables in .bashrc or it's equivalent"
		echo -e "\tB. Reserving Space for CCACHE";
		nline;
		read CCOPT;
		if [[ "$CCOPT" == "A" ]]; then
			set_ccvars;
		elif [[ "$CCOPT" == "B" ]]; then
			set_ccache;
		else
			nline;
			echo -e "${YELO}Drunk?${NONE} Back to Build Menu...";
			sleep 2;
			build_menu;
		fi
	fi
} #build

teh_action ()
{
	if [[ "$1" == "1" ]]; then
		if [ ! -f PREF.rc ]; then
			init;
		fi
		echo -ne '\033]0;ScriBt : Init\007';
	elif [[ "$1" == "2" ]]; then
		if [ ! -f PREF.rc ]; then
			sync;
		fi
		echo -ne "\033]0;ScriBt : Syncing ${ROM_FN}\007";
	elif [[ "$1" == "3" ]]; then
		if [ ! -f PREF.rc ]; then
			pre_build;
		fi
		echo -ne '\033]0;ScriBt : Pre-Build\007';
	elif [[ "$1" == "4" ]]; then
		if [ ! -f PREF.rc ]; then
			build;
		fi
		echo -ne "\033]0;ScriBt : Building ${ROM_FN}\007";
	elif [[ "$1" == "5" ]]; then
		if [ ! -f PREF.rc ]; then
			installdeps;
		fi
		echo -ne '\033]0;ScriBt : Installing Dependencies\007';
	elif [[ "$1" == "6" && "$2" == "COOL" ]]; then
		if [ ! -f PREF.rc ]; then
			exitScriBt;
		fi
		echo -ne "\033]0;${ROM_FN} : Success\007";
	elif [[ "$1" == "6" && "$2" == "FAIL" ]]; then
		if [ ! -f PREF.rc ]; then
			exitScriBt;
		fi
		echo -ne "\033]0;${ROM_FN} : Fail\007";
	fi
} #teh_action

#START IT --- VROOM!
if [[ "$1" == "automate" ]]; then
	source $(pwd)/PREF.rc
	echo -e "${RED}*${NONE}${LPURP}AutoBot${RED}*${NONE} Thanks for Selecting Me. Lem'me do your work"
	automate;
else
	main_menu;
fi
