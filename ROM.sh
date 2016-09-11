#!/bin/bash
#========================< Projekt ScriBt >============================#
#===========< Copyright 2016, Arvind Raj Thangaraj - "a7r3" >==========#
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
# https://github.com/a7r3/ScriBt - Original Repo of ScriBt             #
#                                                                      #
# Usage: bash ROM.sh (Manual) | bash ROM.sh automate (Automated)       #
#                                                                      #
# You're free to enter your modifications and submit it to me with     #
# a Pull Request, such Contributions are readily WELCOME               #
#                                                                      #
# CONTRIBUTORS FOR THIS PROJECT:                                       #
# Arvind Raj (Myself)                                                  #
# Adrian DC                                                            #
# Akhil Narang                                                         #
# CubeDev                                                              #
#======================================================================#

function apt_check
{
    if [ -d "/etc/apt" ]; then
        echo -e "\n${CL_LRD}Alright, apt detected.${NONE}\n";
    else
        echo -e "\nApt configuration has not been found. A Debian/Ubuntu based Distribution is required to run ScriBt.\n";
        exit 1;
    fi
} # apt_check

function exitScriBt
{
    echo -e "\n\nThanks for using ${CL_LRD}S${NONE}cri${CL_GRN}B${NONE}t. Have a Nice Day\n\n";
    sleep 1;
    echo -e "${CL_LRD}Bye!${NONE}";
    exit 0;
} # exitScriBt

the_response ()
{
    case "$1" in
    "COOL") echo -e "${CL_RED}*${NONE}${CL_PNK}AutoBot${NONE}${CL_RED}*${NONE} Automated $2 ${CL_LGN}Successful! :)${NONE}" ;;
    "FAIL") echo -e "${CL_RED}*${NONE}${CL_PNK}AutoBot${NONE}${CL_RED}*${NONE} Automated $2 ${CL_LRD}Failed :(${NONE}" ;;
    esac
} # the_response

function main_menu
{
    echo -ne '\033]0;ScriBt : Main Menu\007';
    echo -e "${CL_LRD}=======================================================${NONE}";
    echo -e "${CL_LRD}====================${NONE}${CL_CYN}[*]${NONE}${CL_PRP}MAIN MENU${NONE}${CL_CYN}[*]${NONE}${CL_LRD}====================${NONE}";
    echo -e "${CL_LRD}=======================================================${NONE}\n";
    echo -e "${CL_LBL}1${NONE}                 ${CL_RED}Choose ROM & Init*${NONE}${CL_CYN}                 ${NONE} ${CL_LBL}1${NONE}";
    echo -e "${CL_LBL}2${NONE}                       ${CL_YEL}Sync${NONE}${CL_CYN}                         ${NONE} ${CL_LBL}2${NONE}";
    echo -e "${CL_LBL}3${NONE}                     ${CL_GRN}Pre-Build${NONE}${CL_CYN}                      ${NONE} ${CL_LBL}3${NONE}";
    echo -e "${CL_LBL}4${NONE}                       ${CL_LGN}Build${NONE}${CL_CYN}                        ${NONE} ${CL_LBL}4${NONE}";
    echo -e "${CL_LBL}5${NONE}                   ${CL_PRP}Various Tools${NONE}${CL_CYN}                    ${NONE} ${CL_LBL}5${NONE}\n";
    echo -e "6                        EXIT                         6\n";
    echo -e "* - Sync will Automatically Start after Init'ing Repo";
    echo -e "${CL_LRD}=======================================================${NONE}\n";
    echo -e "\nSelect the Option you want to start with : \c";
    read ACTION;
    teh_action $ACTION "mm";
} # main_menu

function quick_menu
{
    echo -ne '\033]0;ScriBt : Quick Menu\007';
    echo -e "${CL_YEL}============================${NONE} ${CL_LRD}QUICK-MENU${NONE} ${CL_YEL}=============================${NONE}";
    echo -e "${CL_RED}1. Init${NONE} | ${CL_YEL}2. Sync${NONE} | ${CL_GRN}3. Pre-Build${NONE} | ${CL_LGN}4. Build${NONE} | ${CL_PRP}5. Tools${NONE}";
    echo -e "                               6. Exit";
    echo -e "${CL_YEL}=====================================================================${NONE}\n";
    read ACTION;
    teh_action $ACTION "qm";
} # quick_menu

cherrypick ()
{
    echo -ne '\033]0;ScriBt : Picking Cherries\007';
    echo -e "${CL_GRN}======================= ${NONE}Pick those ${CL_LRD}Cherries${NONE} ${CL_GRN}======================${NONE}\n";
    echo -e "     ${CL_RED}*${NONE}${CL_PNK}AutoBot${NONE}${CL_RED}*${NONE} Attempting to Cherry-Pick Provided Commits\n";
    git fetch https://github.com/${REPOPK}/${REPONAME} ${CP_BRNC};
    git cherry-pick $1;
    echo -e "\nIT's possible that you may face conflicts while merging a C-Pick. Solve those and then Continue.";
    echo -e "${CL_GRN}==================================================================${NONE}";
} # cherrypick


function set_ccache
{
    echo -e "\n${CL_PNK}Setting up CCACHE${NONE}\n";
    ccache -M ${CCSIZE}G;
    echo -e "\nCCACHE Setup ${CL_LGN}Successful${NONE}.\n";
} # set_ccache

function set_ccvars
{
    echo -e "\nCCACHE Size must be ${CL_LRD}>50 GB${NONE}.\n Specify the Size (Number) for Reservation of CCACHE (in GB) : \c";
    read CCSIZE;
    echo -e "Create a New Folder for CCACHE and Specify it's location from ${CL_LRD}/${NONE} : \c";
    read CCDIR;
    for RC in bashrc profile
    do
    if [ -f ${HOME}/.${RC} ]; then
        sudo echo -e "export USE_CCACHE=1\nexport CCACHE_DIR=${CCDIR}" >> ${HOME}/.${RC};
        . ${HOME}/.${RC};
    fi
    done
    set_ccache;
} # set_ccvars

function tools
{
    if [ ! -z "$automate" ]; then teh_action 5; fi;

    function java_select
    {
        echo -e "If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)";
        echo -e "You may now select the Version of Java which is to be used BY-DEFAULT\n";
        echo -e "${CL_BLU}================================================================${NONE}\n";
        sudo update-alternatives --config java;
        echo -e "\n${CL_BLU}================================================================${NONE}\n";
        sudo update-alternatives --config javac;
        echo -e "\n${CL_BLU}================================================================${NONE}";
    } # java_select

    java ()
    {
        echo -ne "\033]0;ScriBt : Java $1\007";
        echo -e "\nInstalling OpenJDK-$1 (Java 1.$1.0)";
        echo -e "$\n{LRD}Remove other Versions of Java ${CL_LGN}[y/n]${NONE}? : \c";
        read REMOJA;
        echo;
        case "$REMOJA" in
            [yY])
               sudo apt-get purge openjdk-* icedtea-* icedtea6-*;
                echo -e "\nRemoved Other Versions successfully" ;;
            [nN])
                echo -e "Keeping them Intact" ;;
            *)
                echo -e "${CL_LRD}Invalid Selection.${NONE} RE-Answer it."
                java $1;
            ;;
        esac
        echo -e "${CL_RED}==========================================================${NONE}\n";
        sudo apt-get update -y;
        echo -e "\n${CL_RED}==========================================================${NONE}\n";
        sudo apt-get install openjdk-$1-jdk -y;
        echo -e "\n${CL_RED}==========================================================${NONE}";
        if [[ $( java -version > $TMP && grep -c "java version \"1\.$1" $TMP ) == "1" ]]; then
            echo -e "OpenJDK-$1 or Java 1.$1.0 has been successfully installed";
            echo -e "${CL_RED}==========================================================${NONE}";
        fi
    } # java

    function java_ppa
    {
        if [[ ! $(which add-apt-repository) ]]; then
            echo -e "${CL_LRD}add-apt-repository${NONE} not present. Installing it...";
            sudo apt-get install software-properties-common;
        fi
        sudo add-apt-repository ppa:openjdk-r/ppa -y;
        sudo apt-get update -y;
        sudo apt-get install openjdk-7-jdk -y;
    } # java_ppa

    function tool_menu
    {
        echo -e "${CL_PNK}=================== ${CL_LBL}TOOLS${NONE} ${CL_PNK}====================${NONE}\n";
        echo -e "     1. Install Build Dependencies\n";
        echo -e "     2. Install Java (OpenJDK 6/7/8)";
        echo -e "     3. Install and/or Set-up CCACHE";
        echo -e "     4. Install/Update ADB udev rules";
# TODO: echo -e "     6. Find an Android Module's Directory";
        echo -e "     5. Install / Revert to make 3.81";
        echo -e "${CL_PNK}==============================================${NONE}\n";
        read TOOL;
        case "$TOOL" in
            1) installdeps ;;
            2) java_menu ;;
            3) set_ccvars ;;
            4) udev_rules ;;
# TODO:     6) find_mod ;;
            5) make_me_old "do_it"; make_me_old "chk_it" ;;
            *) echo -e "Invalid Selection. Going Back."; tool_menu ;;
        esac
    }

    installdeps ()
    {
        echo -e "${CL_PNK}Analyzing Distro...${NONE}";
        PACK="/etc/apt/sources.list.d/official-package-repositories.list";
        DISTROS=( precise quantal raring saucy trusty utopic vivid wily xenial );
        for DIST in ${DISTROS[*]}
        do
            if [[ $(grep -c "${DIST}" "${PACK}") != "0" ]]; then
                export DISTRO="${DIST}";
            fi
        done
        echo -e "\n${CL_LGN}Installing Build Dependencies...${NONE}\n";
        # Common Packages
        COMMON_PKGS=( git-core git gnupg flex bison gperf build-essential zip curl \
        ccache libxml2-utils xsltproc g++-multilib squashfs-tools zlib1g-dev \
        pngcrush schedtool libwxgtk2.8-dev python lib32z1-dev lib32z-dev lib32z1 \
        libxml2 optipng python-networkx python-markdown make unzip );
        case "$DISTRO" in # Distro-Specific Pkgs
            "precise"|"quantal")
                DISTRO_PKGS=( libc6-dev libncurses5-dev:i386 x11proto-core-dev \
                libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
                libgl1-mesa-dev mingw32 tofrodos zlib1g-dev:i386 ) ;;
            "raring"|"saucy")
                DISTRO_PKGS=( zlib1g-dev:i386 libc6-dev lib32ncurses5 \
                lib32bz2-1.0 lib32ncurses5-dev x11proto-core-dev \
                libx11-dev:i386 libreadline6-dev:i386 \
                libgl1-mesa-glx:i386 libgl1-mesa-dev \
                mingw32 tofrodos readline-common libreadline6-dev libreadline6 \
                lib32readline-gplv2-dev libncurses5-dev lib32readline5 \
                lib32readline6 libreadline-dev libreadline6-dev:i386 \
                libreadline6:i386 bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev \
                lib32bz2-dev libsdl1.2-dev libesd0-dev ) ;;
            "trusty"|"utopic")
                DISTRO_PKGS=( libc6-dev-i386 lib32ncurses5-dev liblz4-tool \
                x11proto-core-dev libx11-dev libgl1-mesa-dev maven maven2 ) ;;
            "vivid"|"wily")
                DISTRO_PKGS=( libesd0-dev liblz4-tool libncurses5-dev \
                libsdl1.2-dev libwxgtk2.8-dev lzop maven maven2 \
                lib32ncurses5-dev lib32readline6-dev liblz4-tool ) ;;
            "xenial")
                DISTRO_PKGS=( automake lzop libesd0-dev maven \
                liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev \
                lzop lib32ncurses5-dev lib32readline6-dev lib32z1-dev \
                zlib1g-dev:i386 libbz2-dev libbz2-1.0 libghc-bzlib-dev ) ;;
        esac
        # Install 'em all
        sudo apt-get install -y ${COMMON_PKGS[*]} ${DISTRO_PKGS[*]};
    } #installdeps

    function java_menu
    {
        echo -e "${CL_LGN}=====================${NONE} ${CL_PNK}JAVA Installation${NONE} ${CL_LGN}====================${NONE}\n";
        echo -e "1. Install Java";
        echo -e "2. Switch Between Java Versions / Providers\n";
        echo -e "\nNote: ScriBt installs Java by OpenJDK";
        echo -e "\n${CL_LGN}==========================================================${NONE}\n";
        read JAVAS;
        echo;
        case "$JAVAS" in
            1)
                echo -ne '\033]0;ScriBt : Java\007';
                echo -e "Android Version of the ROM you're building ? ";
                echo -e "1. Java 1.6.0 (4.4 Kitkat)";
                echo -e "2. Java 1.7.0 (5.x.x Lollipop && 6.x.x Marshmallow)";
                echo -e "3. Java 1.8.0 (7.x.x Nougat)\n";
                echo -e "4. Ubuntu 16.04 & Want to install Java 7";
                read JAVER;
                case "$JAVER" in
                    1) java 6 ;;
                    2) java 7 ;;
                    3) java 8 ;;
                    4) java_ppa ;;
                    *)
                        echo -e "\n${CL_LRD}Invalid Selection${NONE}. Going back\n";
                        java_menu ;;
                esac # JAVER
            ;;
            2) java_select ;;
            *)
                echo -e "\n${CL_LRD}Invalid Selection${NONE}. Going back\n"
                java_menu ;;
        esac # JAVAS
    } # java_menu

    function udev_rules
    {
        echo -e "\n${CL_RED}==========================================================${NONE}\n";
        echo -e "Updating / Creating Android ${CL_LGN}USB udev rules${NONE} (51-android)\n";
        sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules;
        sudo chmod a+r /etc/udev/rules.d/51-android.rules;
        sudo service udev restart;
        echo;
        echo -e "\n${CL_RED}==========================================================${NONE}\n";
    } # udev_rules

    make_me_old ()
    {
        MKVR=$(make -v | head -1 | awk '{print $3}');
        case "$1" in
            "do_it")
                case "${MKVR}" in
                    "3.81")
                        echo -e "${CL_LGN}make 3.81 has already been installed${NONE}" ;;
                    *)
                        echo "Installing make 3.81...";
                        sudo install utils/make /usr/bin/;
                    ;;
                esac
            ;;
            "chk_it")
                if [[ "$MKVR" == "3.81" ]]; then echo -e "${CL_LGN}make 3.81 present${NONE}"; fi
            ;;
        esac
    } # make_me_old

    tool_menu;
} # tools

shut_my_mouth ()
{
    if [ ! -z "$automate" ]; then
        RST="DM$1";
        echo -e "${CL_RED}*${NONE}${CL_PNK}AutoBot${NONE}${CL_RED}*${NONE} $2 : ${!RST}";
    else
        read DM2;
        if [ -z "$3" ]; then export DM$1="${DM2}"; else eval DM$1=${DM2}; fi;
    fi
    echo;
} # shut_my_mouth

function sync
{
    if [ ! -z "$automate" ]; then teh_action 2; fi;
    if [ ! -f .repo/manifest.xml ]; then init; elif [ -z "$inited" ]; then rom_select; fi;
    echo -e "\nPreparing for Sync\n";
    echo -e "${CL_LRD}Number of Threads${NONE} for Sync?\n"; gimme_info "jobs";
    ST="${CL_LRD}Number${NONE} of Threads"; shut_my_mouth JOBS "$ST";
    echo -e "${CL_LRD}Force Sync${NONE} needed? ${CL_LGN}[y/n]${NONE}\n"; gimme_info "fsync";
    ST="${CL_LRD}Force${NONE} Sync"; shut_my_mouth F "$ST";
    echo -e "Need some ${CL_LRD}Silence${NONE} in the Terminal? ${CL_LGN}[y/n]${NONE}\n"; gimme_info "ssync";
    ST="${CL_LRD}Silent${NONE} Sync"; shut_my_mouth S "$ST";
    echo -e "Sync only ${CL_LRD}Current${NONE} Branch? ${CL_LGN}[y/n]${NONE}\n"; gimme_info "syncrt";
    ST="Sync ${CL_LRD}Current${NONE} Branch"; shut_my_mouth C "$ST";
    echo -e "Sync with ${CL_LRD}clone-bundle${NONE} ${CL_LGN}[y/n]${NONE}?\n"; gimme_info "clnbun";
    ST="Use ${CL_LRD}clone-bundle${NONE}"; shut_my_mouth B "$ST";
    echo -e "${CL_LRD}=====================================================================${NONE}\n";
    #Sync-Options
    if [[ "$DMS" == "y" ]]; then SILENT=-q; else SILENT=" " ; fi;
    if [[ "$DMF" == "y" ]]; then FORCE=--force-sync; else FORCE=" " ; fi;
    if [[ "$DMC" == "y" ]]; then SYNC_CRNT=-c; else SYNC_CRNT=" "; fi;
    if [[ "$DMB" == "y" ]]; then CLN_BUN=" "; else CLN_BUN=--no-clone-bundle; fi;
    echo -e "${CL_LGN}Let's Sync!${NONE}\n";
    repo sync -j${DMJOBS} ${SILENT} ${FORCE} ${SYNC_CRNT} ${CLN_BUN}  #2>&1 | tee $RTMP;
    echo;
    the_response COOL Sync;
    echo -e "\n${CL_PNK}Done.${NONE}!\n";
    echo -e "${CL_LRD}=====================================================================${NONE}\n";
    if [ -z "$automate" ]; then quick_menu; fi;
} # sync

function rom_select
{
    echo -e "${CL_PNK}=======================================================${NONE}\n";
    echo -e "Which ROM are you trying to build?
Choose among these (Number Selection)

1.${CL_LGN} AICP ${NONE}
2.${CL_LRD} AOKP ${NONE}
3.${CL_PNK} AOSiP ${NONE}
4.${CL_LGN} AOSP-CAF ${NONE}
5.${CL_DGR} AOSP-RRO ${NONE}
6.${CL_LBL} BlissRoms${NONE}
7.${CL_LGN} CandyRoms ${NONE}
8.${CL_YEL} crDroid ${NONE}
9.${CL_LBL} Cyanide-L${NONE}
10.${CL_LCN} CyanogenMod ${NONE}
11.${CL_LRD} DirtyUnicorns ${NONE}
12.${CL_YEL} Flayr OS ${NONE}
13.${CL_LBL} Krexus${NONE}-${CL_GRN}CAF${NONE}
14.${CL_LGN} OmniROM ${NONE}
15.${CL_PNK} Orion OS ${NONE}
16.${CL_YEL} OwnROM ${NONE}
17.${CL_LBL} PAC-ROM ${NONE}
18.${CL_LGN} AOSPA ${NONE}
19.${CL_LRD} Resurrection Remix ${NONE}
20.${CL_LBL} SlimRoms ${NONE}
21.${CL_LRD} Temasek ${NONE}
22.${CL_LBL} GZR Tesla ${NONE}
23.${CL_YEL} Tipsy OS ${NONE}
24.${CL_PNK} GZR Validus ${NONE}
25.${CL_LCN} XenonHD ${NONE}
26.${CL_LBL} XOSP ${NONE}
27.${CL_LGN} Zephyr-Os ${NONE}

${CL_PNK}=======================================================${NONE}\n";
    if [ -z "$automate" ]; then read ROMNO; fi;
    rom_names "$ROMNO";
} # rom_select

function init
{
    if [ ! -z "$automate" ]; then teh_action 1; fi;
    rom_select;
    echo -e "\nYou have chosen ${CL_LCN}->${NONE} $ROM_FN\n";
    sleep 1;
    echo -e "${CL_WYT}Detecting Available Branches in ${ROM_FN} Repository...${NONE}\n";
    git ls-remote -h https://github.com/${ROM_NAME}/${MAN} |\
        awk '{print $2}' | awk -F "/" '{if (length($4) != 0) {print $3"/"$4} else {print $3}}';
    echo -e "\nThese Branches are available at the moment\n${CL_LRD}Specify the Branch${NONE} you're going to sync\n";
    ST="${CL_LRD}Branch${NONE}"; shut_my_mouth BR "$ST";
    echo -e "Any ${CL_LRD}Source you have already synced?${NONE} ${CL_LGN}[Y/N]${NONE}\n"; gimme_info "refer";
    ST="Use Reference Source"; shut_my_mouth RF "$ST";
    if [[ "$DMRF" == [Yy] ]]; then
        echo -e "\nProvide me the ${CL_LRD}Synced Source's Location${NONE} from ${CL_LRD}/${NONE}\n";
        ST="Reference ${CL_LRD}Location${NONE}"; shut_my_mouth RFL "$ST";
        REF=--reference\=\"${DMRFL}\";
    else
        REF=" ";
    fi
    echo -e "Set ${CL_LRD}clone-depth${NONE} ? ${CL_LGN}[y/n]${NONE}\n"; gimme_info "cldp";
    ST="Use ${CL_LRD}clone-depth${NONE}"; shut_my_mouth CD "$ST";
    echo -e "Depth ${CL_LRD}Value${NONE}? (Default ${CL_LRD}1${NONE})\n";
    ST="clone-depth ${CL_LRD}Value${NONE}"; shut_my_mouth DEP "$ST";
    if [ -z "$DMDEP" ]; then DMDEP=1; fi
    #Check for Presence of Repo Binary
    if [[ ! $(which repo) ]]; then
        echo -e "Looks like the Repo binary isn't installed. Let's Install it.\n";
        if [ ! -d "${HOME}/bin" ]; then mkdir -p ${HOME}/bin; fi;
        curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo;
        chmod a+x ~/bin/repo;
        echo -e "Repo Binary Installed\nAdding ~/bin to PATH\n";
        echo -e "# set PATH so it includes user's private bin if it exists" >> ~/.profile;
        echo -e "if [ -d \"\$HOME/bin\" ] ; then" >> ~/.profile;
        echo -e "\tPATH=\"\$HOME/bin:\$PATH\" "; >> ~/.profile;
        echo -e "fi"; >> ~/.profile;
        . ~/.profile;
        echo -e "${CL_LGN}DONE!${NONE}. Ready to Init Repo\n";
    fi
    echo -e "${CL_LBL}=========================================================${NONE}\n";
    echo -e "Let's Initialize the ROM Repo\n";
    repo init ${REF} -u https://github.com/${ROM_NAME}/${MAN} -b ${DMBR} ;
    echo -e "\n${ROM_NAME} Repo Initialized\n";
    echo -e "${CL_LBL}=========================================================${NONE}\n";
    mkdir .repo/local_manifests;
    if [ -z "$automate" ]; then
        echo -e "A folder \"local_manifests\" has been created for you.";
        echo -e "Create a Device Specific manifest and Press ENTER to start sync\c";
        read ENTER;
        echo;
    fi
    export inited="y";
    sync;
} # init

function device_info
{
    echo -e "${CL_LCN}====================== DEVICE INFO ======================${NONE}\n";
    echo -e "What's your ${CL_LRD}Device's CodeName${NONE} ${CL_LGN}[Refer Device Tree - All Lowercases]${NONE}?\n";
    ST="Your Device ${CL_LRD}Name${NONE} is"; shut_my_mouth DEV "$ST";
    echo -e "Your ${CL_LRD}Device's Company/Vendor${NONE} ${CL_LGN}(All Lowercases)${NONE}?\n";
    ST="Device's ${CL_LRD}Vendor${NONE}"; shut_my_mouth CM "$ST";
    echo -e "The ${CL_LRD}Build type${NONE}? ${CL_LGN}[userdebug/user/eng]${NONE}\n";
    ST="Build ${CL_LRD}type${NONE}"; shut_my_mouth BT "$ST";
    echo -e "Choose your ${CL_LRD}Device type${NONE} among these. Explainations of each file given in README.md"; gimme_info "device-type";
    TYPES=( common_full_phone common_mini_phone common_full_hybrid_wifionly \
    common_full_tablet_lte common_full_tablet_wifionly common_mini_tablet_wifionly common_tablet \
    common_full_tv common_mini_tv );
    CNT=0;
    for TYP in ${TYPES[*]}
    do
        if [ -f ${CNF}/${TYP}.mk ]; then echo -e "${CL_PNK}${CNT}. $TYP${NONE}"; ((CNT++)); fi;
    done
    echo;
    ST="Device Type"; shut_my_mouth DTP "$ST";
    if [ -z $DMDTP ]; then DMDTP=common; else DMDTP="${TYPES[${DMDTP}]}"; fi
    echo -e "${CL_LCN}=========================================================${NONE}\n\n";
} # device_info

function init_bld
{
    echo -e "\n${CL_YEL}=========================================================${NONE}";
    echo -e "             ${CL_CYN}Initializing Build Environment${NONE}\n";
    . build/envsetup.sh;
    echo -e "\n${CL_YEL}=========================================================${NONE}\n";
    echo -e "${CL_PNK}Done.${NONE}.\n";
} # init_bld

function pre_build
{
    if [ ! -z "$automate" ]; then teh_action 3; fi
    if [ -z "$inited" ]; then rom_select; fi;
    init_bld;
    if [ ! -z "${ROMV}" ]; then export ROMNIS="${ROMV}"; fi; # Change ROMNIS
    if [ -d ${CALL_ME_ROOT}/vendor/${ROMNIS}/config ]; then
        CNF="vendor/${ROMNIS}/config";
    elif [ -d ${CALL_ME_ROOT}/vendor/${ROMNIS}/configs ]; then
        CNF="vendor/${ROMNIS}/configs";
    else
        CNF="vendor/${ROMNIS}";
    fi
    rom_names "$ROMNO"; # Restore ROMNIS
    device_info;

    function find_ddc # For Finding Default Device Configuration file
    {
        ROMS=( aicp aokp aosp bliss candy crdroid cyanide cm du orion ownrom slim tesla tipsy validus xenonhd xosp );
        for ROM in ${ROMS[*]}
        do
            # Possible Default Device Configuration (DDC) Files
            DDCS=( ${ROM}_${DMDEV}.mk aosp_${DMDEV}.mk full_${DMDEV}.mk ${ROM}.mk );
            # Inherit DDC
            for ACTUAL_DDC in ${DDCS[*]}
            do
                if [ -f $ACTUAL_DDC ]; then export DDC="$ACTUAL_DDC"; fi;
            done
        done
    } # find_ddc

    interactive_mk()
    {
        init_bld;
        echo -e "\n${CL_PRP}Creating Interactive Makefile for getting Identified by the ROM's BuildSystem...${NONE}\n";
        sleep 2;
        cd device/${DMCM}/${DMDEV};
        INTM="interact.mk";
        if [ -z "$INTF" ]; then INTF="${ROMNIS}.mk"; fi;
        echo "#                ##### Interactive Makefile #####
#
# Licensed under the Apache License, Version 2.0 (the \"License\");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an \"AS IS\" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License." >> ${INTM};
        find_ddc;
        echo -e "\n# Inherit ${ROMNIS} common stuff\n\$(call inherit-product, ${CNF}/${VNF}.mk)" >> ${INTM};
        # Inherit Vendor specific files
        if [[ $(grep -c 'nfc_enhanced' $DDC) == "1" ]] && [ -f ${CALL_ME_ROOT}/${CNF}/nfc_enhanced.mk ]; then
            echo -e "\n# Enhanced NFC\n\$(call inherit-product, ${CNF}/nfc_enhanced.mk)" >> ${INTM};
        fi
        echo -e "\n# Calling Default Device Configuration File" >> ${INTM};
        echo -e "\$(call inherit-product, device/${DMCM}/${DMDEV}/${DDC})" >> ${INTM};
        # To prevent Missing Vendor Calls in DDC-File
        sed -i -e 's/inherit-product, vendor\//inherit-product-if-exists, vendor\//g' $DDC;
        # Add User-desired Makefile Calls
        echo -e "Missed some Makefile calls? Enter number of Desired Makefile calls... [0 if none]";
        ST="No of Makefile Calls"; shut_my_mouth NMK "$ST";
        for (( CNT=1; CNT<="$DMNMK"; CNT++ ))
        do
            echo -e "\nEnter Makefile location from Root of BuildSystem";
            ST="Makefile"; shut_my_mouth LOC[$CNT] "$ST" array;
            if [ -f ${CALL_ME_ROOT}/${DMLOC[$CNT]} ]; then
                echo -e "\n${CL_LGN}Adding Makefile $CNT ...${NONE}";
                echo -e "\n\$(call inherit-product, ${LOC[$CNT]})" >> ${INTM};
            else
                echo -e "${CL_LRD}Makefile ${LOC[$CNT]} not Found. Aborting...${NONE}";
            fi
        done
        echo -e "\n# ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${DMDEV}" >> ${INTM};
        # Make it Identifiable
        mv ${INTM} ${INTF};
        echo -e "${CL_GRN}Renaming .dependencies file...${NONE}\n";
        if [ ! -f ${ROMNIS}.dependencies ]; then
            mv -f *.dependencies ${ROMNIS}.dependencies;
        fi
        echo -e "${CL_LRD}Done.${NONE}";
        croot;
    } # interactive_mk

    function vendor_strat_all
    {
        case "$ROMNO" in
            12|27) cd vendor/${ROMV} ;;
            *) cd vendor/${ROMNIS} ;;
        esac
        echo -e "${CL_PNK}=========================================================${NONE}\n";

        function dtree_add
        {   # AOSP-CAF/RRO/OmniROM/Flayr/Zephyr
            croot;
            echo -e "Moving to D-Tree\n\n And adding Lunch Combo..";
            cd device/${DMCM}/${DMDEV};
            if [ ! -f vendorsetup.sh ]; then touch vendorsetup.sh; fi;
            if [[ $(grep -c "${ROMNIS}_${DMDEV}" vendorsetup.sh ) == "0" ]]; then
                echo -e "add_lunch_combo ${ROMNIS}_${DMDEV}-${DMBT}" >> vendorsetup.sh;
            else
                echo -e "Lunch combo already added to vendorsetup.sh\n";
            fi
        } # dtree_add

        echo -e "${CL_LBL}Adding Device to ROM Vendor...${NONE}";
        STRTS=( "${ROMNIS}.devices" "${ROMNIS}-device-targets" vendorsetup.sh );
        for STRT in ${STRTS[*]}
        do #     Found file   &&  Strat Not Performed
            if [ -f "$STRT" ] && [ -z "$STDN" ]; then
                if [[ $(grep -c "${DMDEV}" $STRT) == "0" ]]; then
                    case "$STRT" in
                        ${ROMNIS}.devices)
                            echo -e "${DMDEV}" >> $STRT ;;
                        ${ROMNIS}-device-targets)
                            echo -e "${ROMNIS}_${DMDEV}-${DMBT}" >> $STRT;;
                        vendorsetup.sh)
                            echo -e "add_lunch_combo ${ROMNIS}_${DMDEV}-${DMBT}" >> $STRT ;;
                    esac
                else
                    echo -e "Device already added to $STRT";
                fi
                export STDN="y"; # File Found, Strat Performed
            fi
        done
        if [ -z "$STDN" ]; then dtree_add; fi; # If none of the Strats Worked
        echo -e "${CL_LGN}Done.${NONE}\n";
        croot;
        echo -e "${CL_PNK}=========================================================${NONE}";
    } # vendor_strat

    function vendor_strat_kpa # AOKP-4.4, AICP, PAC-5.1, Krexus-CAF, PA
    {
        croot;
        cd vendor/${ROMNIS}/products;
        echo -e "About Device's Resolution...\n";
        if [ ! -z "$automate" ]; then
            echo -e "Among these Values - Select the one which is nearest or almost Equal to that of your Device\n";
            echo -e "Resolutions which are available for a ROM is shown by it's name. All Res are available for PAC-5.1";
            echo -e "
${CL_PNK}240${NONE}x400
${CL_PNK}320${NONE}x480 (AOKP)
${CL_PNK}480${NONE}x800 and ${CL_PNK}480${NONE}x854 (AOKP & PA)
${CL_PNK}540${NONE}x960 (AOKP)
${CL_PNK}600${NONE}x1024
${CL_PNK}720${NONE}x1280 (AOKP & PA)
${CL_PNK}768${NONE}x1024 and ${CL_PNK}768${NONE}x1280 (AOKP)
${CL_PNK}800${NONE}x1280 (AOKP)
${CL_PNK}960${NONE}x540
${CL_PNK}1080${NONE}x1920 (AOKP & PA)
${CL_PNK}1200${NONE}x1920
${CL_PNK}1280${NONE}x800
${CL_PNK}1440${NONE}x2560 (PA)
${CL_PNK}1536${NONE}x2048
${CL_PNK}1600${NONE}x2560
${CL_PNK}1920${NONE}x1200
${CL_PNK}2560${NONE}x1600\n";
            echo -e "Enter the Desired Highlighted Number...\n";
            read BOOTRES;
        else
            echo -e "${CL_RED}*${NONE}${CL_PNK}AutoBot${NONE}${CL_RED}*${NONE} Resolution Choosed : ${BOOTRES}";
        fi
        #Vendor-Calls
        case "$ROMNIS" in
            "aicp")
                VENF="${DMDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${DMDEV}.mk" >> AndroidProducts.mk;
                echo -e "\n# Inherit telephony stuff\n\$(call inherit-product, vendor/${ROMNIS}/configs/telephony.mk)" >> $VENF;
                echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> $VENF;
            ;;
            "aokp")
                VENF="${DMDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${DMDEV}.mk" >> AndroidProducts.mk;
                echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> $VENF;
                echo -e "\nPRODUCT_COPY_FILES += \ " >> $VENF;
                echo -e "\tvendor/aokp/prebuilt/bootanimation/bootanimation_${BOOTRES}.zip:system/media/bootanimation.zip" >> $VENF;
            ;;
            "krexus")
                VENF="krexus_${DMDEV}.mk";
                echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/common.mk)" >> $VENF;
                echo -e "\n\$( call inherit-product, vendor/${ROMNIS}/products/vendorless.mk)" >> $VENF;
            ;;
            "pa")
                VENF="${DMDEV}/pa_${DMDEV}.mk";
                echo -e "# ${DMCM} ${DMDEV}" >> AndroidProducts.mk
                echo -e "\nifeq (pa_${DMDEV},\$(TARGET_PRODUCT))" >> AndroidProducts.mk;
                echo -e "\tPRODUCT_MAKEFILES += \$(LOCAL_DIR)/${DMDEV}/pa_${DMDEV}.mk\nendif" >> AndroidProducts.mk;
                echo -e "\ninclude vendor/${ROMNIS}/main.mk" >> $VENF;
                mv ${CALL_ME_ROOT}/device/${DMCM}/${DMDEV}/*.dependencies ${DMDEV}/pa.dependencies;
            ;;
            "pac")
                VENF="pac_${DMDEV}.mk";
                echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/pac_common.mk)" >> $VENF;
                echo "PAC_BOOTANIMATION_NAME := ${BOOTRES};" >> $VENF;
            ;;
        esac
        find_ddc;
        echo -e "\n# Calling Default Device Configuration File" >> $VENF;
        echo -e "\$(call inherit-product, device/${DMCM}/${DMDEV}/${DDC})" >> $VENF;
        # PRODUCT_NAME is the only ROM-specific Identifier, setting it here is better.
        echo -e "\n#ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${DMDEV}" >> $VENF;
    } # vendor_strat_kpa

    if [ -d vendor/${ROMNIS}/products ] && [ ! -d vendor/aosip ]; then
        if [ ! -f vendor/${ROMNIS}/products/${ROMNIS}_${DMDEV}.mk ||
             ! -f vendor/${ROMNIS}/products/${DMDEV}.mk ||
             ! -f vendor/${ROMNIS}/products/${DMDEV}/${ROMNIS}_${DMDEV}.mk ]; then
            vendor_strat_kpa; #if found products folder
        else
            echo -e "Looks like ${DMDEV} has been already added to ${ROM_FN} vendor. Good to go\n";
        fi
    else
        vendor_strat_all; #if not found
    fi
    croot;
    echo -e "\n${CL_LBL}${ROMNIS}-fying Device Tree...${NONE}\n";
    NOINT=$(echo -e "${CL_LGN}Interactive Makefile Unneeded, continuing...${NONE}");

    function need_for_int
    {
        if [ -f ${CALL_ME_ROOT}/device/${DMCM}/${DMDEV}/${INTF} ]; then
            echo "$NOINT";
        else
            interactive_mk "$ROMNO";
        fi
    } # need_for_int

    case "$ROMNO" in
        4|5|12|14|27) # AOSP-CAF/RRO | Flayr | OmniROM | Zephyr
            VNF="common";
            INTF="${ROMNIS}_${DMDEV}.mk";
            need_for_int;
            DEVDIR="device/${DMCM}/${DMDEV}";
            rm -rf ${DEVDIR}/AndroidProducts.mk;
            echo -e "PRODUCT_MAKEFILES :=  \\ \n\t\$(LOCAL_DIR)/${ROMNIS}_${DMDEV}.mk" >> AndroidProducts.mk;
        ;;
        3) # AOSiP-CAF
            if [ ! -f vendor/${ROMNIS}/products ]; then
                VNF="common";
                need_for_int;
            else
                echo "$NOINT";
            fi
        ;;
        2|17) # AOKP-4.4 | PAC-5.1
            if [ ! -f vendor/${ROMNIS}/products ]; then
                VNF="$DMDTP";
                need_for_int;
            else
                echo "$NOINT";
            fi
        ;;
        1|13|18) # AICP | Krexus-CAF | AOSPA
            echo "$NOINT";
        ;;
        *) # Rest of the ROMs
            VNF="$DMDTP";
            need_for_int;
        ;;
    esac
    sleep 2;
    export preblded="y";
    export inited="y";
    if [ ! -z "$automate" ]; then quick_menu; fi;
} # pre_build

function build
{
    if [ -d .repo ]; then
        if [ ! -z "$automate" ]; then teh_action 4; fi;
        if [ -z "$preblded" ]; then device_info; fi
        if [ -z "$inited" ]; then rom_select; fi;
    else
        echo -e "ROM Source Not Found (Synced)... \nPls perform an init and sync before doing this";
        exitScriBt;
    fi

    function make_it # Part of make_module
    {
        echo -e "${CL_LCN}ENTER${NONE} the Directory where the Module is made from : \c";
        read MODDIR;
        echo -e "\nDo you want to ${CL_LRD}push the Module${NONE} to the ${CL_LRD}Device${NONE} ? (Running the Same ROM) ${CL_LGN}[y/n]${NONE} : \c";
        read PMOD;
        echo;
        case "$PMOD" in
            [yY]) mmmp -B $MODDIR ;;
            [nN]) mmm -B $MODDIR ;;
            *) echo -e "${CL_LRD}Invalid Selection.${NONE} Going Back.\n"; make_it ;;
        esac
    } # make_it

    make_module ()
    {
        if [ -z "$1" ]; then
            echo -e "\nKnow the Location of the Module? : \c";
            read KNWLOC;
        fi
        if [[ "$KNWLOC" == "y" || "$1" == "y" ]]; then
            make_it;
        else
            echo -e "Do either of these two actions:\n1. ${CL_BLU}G${NONE}${CL_RED}o${NONE}${CL_YEL}o${NONE}${CL_BLU}g${NONE}${CL_GRN}l${NONE}${CL_RED}e${NONE} it (Easier)\n2. Run this command in terminal : ${CL_LBL}sgrep \"LOCAL_MODULE := <Insert_MODULE_NAME_Here> \"${NONE}.\n\n Press ${CL_LCN}ENTER${NONE} after it's ${CL_PNK}Done.${NONE}.\n";
            read ENTER;
            make_it;
        fi
    } # make_module

    function post_build
    {
        if [[ $(tac $RMTMP | grep -c -m 1 '#### make completed successfully') == "1" ]]; then
            echo -e "\nBuild Completed ${CL_LGN}Successfully!${NONE} Cool. Now make it ${CL_LRD}Boot!${NONE}\n";
            the_response COOL Build;
            teh_action 6 COOL;
        elif [[ $(tac $RMTMP | grep -c -m 1 'No rule to make target') == "1" ]]; then
#           WiP
            if [ ! -z "$automate" ]; then
                teh_action 6 FAIL;
                the_response FAIL Build;
            fi
        fi
    } # post_build

    build_make ()
    {
        if [[ "$1" != "brunch" ]]; then
            start=$(date +"%s");
            case "$DMMK" in
                "make") BCORES=$(grep -c ^processor /proc/cpuinfo) ;;
                *) BCORES="" ;;
            esac
            if [ $(grep -q "^${ROMNIS}:" "${CALL_ME_ROOT}/build/core/Makefile") ]; then
                $DMMK $ROMNIS $BCORES 2>&1 | tee $RMTMP;
            elif [ $(grep -q "^bacon:" "${CALL_ME_ROOT}/build/core/Makefile") ]; then
                $DMMK bacon $BCORES 2>&1 | tee $RMTMP;
            else
                $DMMK otapackage $BCORES 2>&1 | tee $RMTMP;
            fi
            echo;
            post_build;
            end=$(date +"%s");
            sec=$(($end - $start));
            echo -e "${CL_YEL}Build took $(($sec / 3600)) hour(s), $(($sec / 60 % 60)) minute(s) and $(($sec % 60)) second(s).${NONE}" | tee -a rom_compile.txt;
        fi
    } # build_make

    function hotel_menu
    {
        echo -e "${CL_LBL}======================${NONE}${CL_RED}[*]${NONE} ${CL_GRN}HOTEL MENU${NONE} ${CL_RED}[*]${NONE}${CL_LBL}=======================${NONE}";
        echo -e "${CL_LRD} Menu is only for your Device, not for you. No Complaints pls.${NONE}\n";
        echo -e "[*] ${CL_RED}lunch${NONE} - Setup Build Environment for the Device [*]";
        echo -e "[*] ${CL_YEL}breakfast${NONE} - Download Device Dependencies and ${CL_RED}lunch${NONE} [*]";
        echo -e "[*] ${CL_GRN}brunch${NONE} - ${CL_YEL}breakfast${NONE} + ${CL_RED}lunch${NONE} then ${CL_GRN}Start Build${NONE} [*]\n";
        echo -e "Type in the Option you want to select\n";
        echo -e "${CL_YEL}Tip!${NONE} - Building for the first time ? select ${CL_RED}lunch${NONE}";
        echo -e "${CL_LBL}===============================================================${NONE}\n";
        ST="Selected Option"; shut_my_mouth SLT "$ST";
        case "$DMSLT" in
            "lunch") ${DMSLT} ${ROMNIS}_${DMDEV}-${DMBT} ;;
            "breakfast") ${DMSLT} ${DMDEV} ${DMBT} ;;
            "brunch")
                echo -e "\n${CL_LGN}Starting Compilation - ${ROM_FN} for ${DMDEV}${NONE}\n";
                ${DMSLT} ${DMDEV};
            ;;
            *)  echo -e "${CL_LRD}Invalid Selection.${NONE} Going Back."; hotel_menu ;;
        esac
        echo;
    } # hotel_menu

    function build_menu
    {
        init_bld;
        echo -e "${CL_PNK}=========================================================${NONE}\n";
        echo -e "Select the Build Option:\n";
        echo -e "${CL_LCN}1. Start Building ROM (ZIP output) (Clean Options Available)${NONE}";
        echo -e "${CL_LGN}2. Make a Particular Module${NONE}";
        echo -e "${CL_LBL}3. Setup CCACHE for Faster Builds ${NONE}\n";
        echo -e "${CL_PNK}=========================================================${NONE}\n"
        ST="Option Selected"; shut_my_mouth BO "$ST";
    }

    build_menu;
    case "$DMBO" in
        1)
            echo -e "\nShould i use '${CL_YEL}make${NONE}' or '${CL_RED}mka${NONE}' ?\n";
            ST="Selected Method"; shut_my_mouth MK "$ST";
            echo -e "Wanna Clean the ${CL_PNK}/out${NONE} before Building? ${CL_LGN}[1 - Remove Staging Dirs / 2 - Full Clean]${NONE}\n";
            ST="Option Selected"; shut_my_mouth CL "$ST";
            if [[ $(tac ${CALL_ME_ROOT}/build/core/build_id.mk | grep -c 'BUILD_ID=M\|BUILD_ID=N') == "1" ]]; then
                echo -e "Use ${CL_LRD}Jack Toolchain${NONE} ? ${CL_LGN}[y/n]${NONE}\n";
                ST="Use ${CL_LRD}Jacky${NONE}"; shut_my_mouth JK "$ST";
                case "$DMJK" in
                     [yY]) export ANDROID_COMPILE_WITH_JACK=true ;;
                     [nN]) export ANDROID_COMPILE_WITH_JACK=false ;;
                esac
            fi
            if [[ $(tac ${CALL_ME_ROOT}/build/core/build_id.mk | grep -c 'BUILD_ID=N') == "1" ]]; then
                echo -e "Use Ninja to build Android ? [y/n]";
                ST="Use Ninja"; shut_my_mouth NJ "$ST";
                case "$DMNJ" in
                    [yY])
                        echo -e "\nBuilding Android with Ninja BuildSystem";
                        export USE_NINJA=true ;;
                    [nN])
                        echo -e "\nBuilding Android with the Non-Ninja BuildSystem\n";
                        export USE_NINJA=false; unset BUILDING_WITH_NINJA ;;
                    *) echo -e "${CL_LRD}Invalid Selection${NONE}. RE-Answer this."; shut_my_mouth NJ "$ST" ;;
                esac
            fi
            case "$DMCL" in
                1) lunch ${ROMNIS}_${DMDEV}-${DMBT}; $DMMK installclean ;;
                2) lunch ${ROMNIS}_${DMDEV}-${DMBT}; $DMMK clean ;;
                *) echo -e "${CL_LRD}Invalid Selection.${NONE} Going Back."; shut_my_mouth CL "$ST";;
            esac
            hotel_menu;
            build_make "$DMSLT";
        ;;
        2) make_module ;;
        3) set_ccvars ;;
        *)
            echo -e "${CL_LRD}Invalid Selection.${NONE} Going back.\n";
            build;
        ;;
    esac
} # build

teh_action ()
{
    case "$1" in
    1)
        if [ -z "$automate" ]; then init; fi;
        echo -ne '\033]0;ScriBt : Init\007';
    ;;
    2)
        if [ -z "$automate" ]; then sync; fi;
        echo -ne "\033]0;ScriBt : Syncing ${ROM_FN}\007";
    ;;
    3)
        if [ -z "$automate" ]; then pre_build; fi;
        echo -ne '\033]0;ScriBt : Pre-Build\007';
    ;;
    4)
        if [ -z "$automate" ]; then build; fi;
        echo -ne "\033]0;${ROMNIS}_${DMDEV} : In Progress\007";
    ;;
    5)
        if [ -z "$automate" ]; then tools; fi;
        echo -ne '\033]0;ScriBt : Installing Dependencies\007';
    ;;
    6)
        if [ -z "$automate" ]; then exitScriBt; fi;
        case "$2" in
            "COOL") echo -ne "\033]0;${ROMNIS}_${DMDEV} : Success\007" ;;
            "FAIL") echo -ne "\033]0;${ROMNIS}_${DMDEV} : Fail\007" ;;
        esac
    ;;
    *)
        echo -e "\n${CL_LRD}Invalid Selection.${NONE} Going back.\n";
        case "$2" in
            "qm") quick_menu ;;
            "mm") main_menu ;;
        esac
    ;;
    esac
} # teh_action

function the_start
{
    #   tempfile      repo sync log       rom build log
    TMP=temp.txt; RTMP=repo_log.txt; RMTMP=rom_compile.txt;
    rm -rf ${TMP} ${RTMP} ${RMTMP};
    touch ${TMP} ${RTMP} ${RMTMP};
    # Load the ROM Database and Color Codes
    if [ -f ROM.rc ]; then
        . $(pwd)/ROM.rc;
    else
        echo "${CL_LRD}ROM.rc isn't present in ${PWD}${NONE}, please make sure repo is cloned correctly";
        exit 1;
    fi
    #CHEAT CHEAT CHEAT!
    if [ -f PREF.rc ]; then
        . $(pwd)/PREF.rc;
        echo -e "\n${CL_RED}*${NONE}${CL_PNK}AutoBot${NONE}${CL_RED}*${NONE} Cheat Code shut_my_mouth applied. I won't ask questions anymore\n";
    else
        echo -e "Using this for first time?\nTake a look on PREF.rc and shut_my_mouth";
    fi
    echo -e "\n=======================================================";
    echo -e "Before I can start, do you like a \033[1;31mC\033[0m\033[0;32mo\033[0m\033[0;33ml\033[0m\033[0;34mo\033[0m\033[0;36mr\033[0m\033[1;33mf\033[0m\033[1;32mu\033[0m\033[0;31ml\033[0m life? [y/n]";
    echo -e "=======================================================\n";
    ST="Colored ScriBt"; shut_my_mouth COL "$ST";
    color_my_life $DMCOL;
    echo -e "\n${CL_LBL}Prompting for Root Access...${NONE}\n";
    sudo echo -e "\n${CL_LGN}Root access OK. You won't be asked again${NONE}";
    apt_check;
    export CALL_ME_ROOT="$(pwd)";
    sleep 3;
    clear;
    echo -ne '\033]0;ScriBt\007';
    echo -e "\n\n                 ${CL_LRD}╔═╗${NONE}${CL_YEL}╦═╗${NONE}${CL_LCN}╔═╗${NONE}${CL_LGN} ╦${NONE}${CL_LCN}╔═╗${NONE}${CL_YEL}╦╔═${NONE}${CL_LRD}╔╦╗${NONE}";
    echo -e "                 ${CL_LRD}╠═╝${NONE}${CL_YEL}╠╦╝${NONE}${CL_LCN}║ ║${NONE}${CL_LGN} ║${NONE}${CL_LCN}║╣ ${NONE}${CL_YEL}╠╩╗${NONE}${CL_LRD} ║ ${NONE}";
    echo -e "                 ${CL_LRD}╩  ${NONE}${CL_YEL}╩╚═${NONE}${CL_LCN}╚═╝${NONE}${CL_LGN}╚╝${NONE}${CL_LCN}╚═╝${NONE}${CL_YEL}╩ ╩${NONE}${CL_LRD} ╩${NONE}";
    echo -e "      ${CL_LRD}███████${NONE}${CL_RED}╗${NONE} ${CL_LRD}██████${NONE}${CL_RED}╗${NONE}${CL_LRD}██████${NONE}${CL_RED}╗${NONE} ${CL_LRD}██${NONE}${CL_RED}╗${NONE}${CL_LRD}██████${NONE}${CL_RED}╗${NONE} ${CL_LRD}████████${NONE}${CL_RED}╗${NONE}";
    echo -e "      ${CL_LRD}██${NONE}${CL_RED}╔════╝${NONE}${CL_LRD}██${NONE}${CL_RED}╔════╝${NONE}${CL_LRD}██${NONE}${CL_RED}╔══${NONE}${CL_LRD}██${NONE}${CL_RED}╗${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██${NONE}${CL_RED}╔══${NONE}${CL_LRD}██${NONE}${CL_RED}╗╚══${NONE}${CL_LRD}██${NONE}${CL_RED}╔══╝${NONE}";
    echo -e "      ${CL_LRD}███████${NONE}${CL_RED}╗${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}     ${CL_LRD}██████${NONE}${CL_RED}╔╝${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██████${NONE}${CL_RED}╔╝${NONE}   ${CL_LRD}██${NONE}${CL_RED}║${NONE}";
    echo -e "      ${CL_RED}╚════${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}     ${CL_LRD}██${NONE}${CL_RED}╔══${NONE}${CL_LRD}██${NONE}${CL_RED}╗${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██${NONE}${CL_RED}╔══${NONE}${CL_LRD}██${NONE}${CL_RED}╗${NONE}   ${CL_LRD}██${NONE}${CL_RED}║${NONE}";
    echo -e "      ${CL_LRD}███████${NONE}${CL_RED}║╚${NONE}${CL_LRD}██████${NONE}${CL_RED}╗${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}  ${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██████${NONE}${CL_RED}╔╝${NONE}   ${CL_LRD}██${NONE}${CL_RED}║${NONE}";
    echo -e "      ${CL_RED}╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═════╝    ╚═╝${NONE}\n";
    sleep 1;
    echo -e "${CL_LCN}~#~#~#~#~#~#~#~#~#${NONE} ${CL_LRD}By Arvind7352${NONE} - ${CL_YEL}XDA${NONE} ${CL_LCN}#~#~#~#~#~#~#~#~${NONE}\n\n";
    sleep 3;
} # the_start

# VROOM!
if [[ "$1" == "automate" ]]; then
    the_start; # Pre-Initial Stage
    echo -e "${CL_RED}*${NONE}${CL_PNK}AutoBot${NONE}${CL_RED}*${NONE} Thanks for Selecting Me. Lem'me do your work";
    export automate="yus_do_eet";
    automate; # Initiate the Build Sequence - Actual "VROOM!"
elif [ -z $1 ]; then
    the_start; # Pre-Initial Stage
    main_menu;
else
    echo -e "Incorrect Parameter: \"$1\"";
    echo -e "Usage:\nbash ROM.sh (Interactive Usage)\nbash ROM.sh automate (For Automated Builds)";
    exit 1;
fi
