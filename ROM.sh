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
# Feel free to enter your modifications and submit it to me with       #
# a Pull Request, such Contributions are WELCOME                       #
#                                                                      #
# CONTRIBUTORS FOR THIS PROJECT:                                       #
# Arvind Raj (Myself)                                                  #
# Adrian DC                                                            #
# Akhil Narang                                                         #
# CubeDev                                                              #
# nosedive                                                             #
#======================================================================#

function pkgmgr_check()
{
    if [ -d "/etc/apt" ]; then
        echo -e "\n\033[0;31m${CL_LBL}[!]${NONE} Alright, apt detected.\033[0m\n";
        PKGMGR="apt";
    elif [ -d "/etc/pacman.d" ]; then
        echo -e "\n$\033[0;31m${CL_LBL}[!]${NONE} Alright, pacman detected.\033[0m\n";
        PKGMGR="pacman";
    else
        echo -e "\n${CL_LRD}[!]${NONE} Neither apt nor pacman configuration has been found.";
        echo -e "\n${CL_LBL}[!]${NONE} A Debian/Ubuntu based Distribution or Archlinux is required to run ScriBt.";
        exitScriBt 1;
    fi
} # pkgmgr_check

function exitScriBt()
{
    function prefGen()
    {
        echo -e "\n\n${CL_YEL}[!]${NONE} Deleting old Configs...";
        sed -e '/SB.*/d' -e '/function configs()/d' -e '/{ # as on.*/d' -e '/} # configs/d' -i PREF.rc;
        echo -e "\n${CL_YEL}[!]${NONE} Saving Current Configuration to PREF.rc...";
        (set -o posix; set) > ${TV2};
        echo -e "function configs()\n{ # as on $DNT" >> PREF.rc
        diff ${TV1} ${TV2} | grep SB | sed -e 's/[<>] /    /g' | awk '{print $0";"}' >> PREF.rc;
        echo -e "} # configs" >> PREF.rc;
        echo -e "\n${CL_LGN}[!]${NONE} PREF.rc for the current Configuration created successfully\nYou may automate ScriBt next time...";
    } # prefGen

    [[ "$RQ_PGN" == [Yy] ]] && prefGen;
    echo -e "\n\n${CL_LGN}[!]${NONE} Thanks for using ScriBt.\n\n";
    [[ "$1" == "0" ]] && echo -e "${CL_LGN}[${NONE}${CL_LRD}<3${NONE}${CL_LGN}]${NONE} Peace! :)" || echo -e "${CL_LRD}[${NONE}${CL_RED}<${NONE}${CL_LGR}/${NONE}${CL_RED}3${NONE}${CL_LRD}]${NONE} Failed somewhere :(";
    exit $1;
} # exitScriBt

function the_response()
{
    case "$1" in
        "COOL") echo -e "${CL_LGN}[!]${NONE} ${ATBT} Automated $2 Successful! :)" ;;
        "FAIL") echo -e "${CL_LRD}[!]${NONE} ${ATBT} Automated $2 Failed :(" ;;
    esac
} # the_response

function main_menu()
{
    echo -ne '\033]0;ScriBt : Main Menu\007';
    echo -e "${CL_WYT}===================${NONE}${CL_LGN}[!]${NONE} ${CL_LBL}Main Menu${NONE} ${CL_LGN}[!]${NONE}${CL_WYT}===================${NONE}\n";
    echo -e "1                 Choose ROM & Init*                  1";
    echo -e "2                       Sync                          2";
    echo -e "3                     Pre-Build                       3";
    echo -e "4                       Build                         4";
    echo -e "5                   Various Tools                     5\n";
    echo -e "6                        EXIT                         6\n";
    echo -e "* - Sync will Automatically Start after Init'ing Repo";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    echo -e "\n${CL_LRD}[?]${NONE} Select the Option you want to start with : \c";
    read ACTION;
    teh_action $ACTION "mm";
} # main_menu

function quick_menu()
{
    echo -ne '\033]0;ScriBt : Quick Menu\007';
    echo -e "${CL_WYT}\n====================${NONE} ${CL_PNK}Quick-Menu${NONE} ${CL_WYT}======================${NONE}";
    echo -e "1. Init | 2. Sync | 3. Pre-Build | 4. Build | 5. Tools";
    echo -e "                      6. Exit";
    echo -e "${CL_WYT}======================================================${NONE}\n";
    read -p $'\033[1;36m[>]\033[0m ' ACTION;
    teh_action $ACTION "qm";
} # quick_menu

function cherrypick()
{
    echo -ne '\033]0;ScriBt : Picking Cherries\007';
    echo -e "${CL_WYT}=======================${NONE} ${CL_LRD}Pick those Cherries${NONE} ${CL_WYT}======================${NONE}\n";
    echo -e "${CL_YEL}[!]${NONE} ${ATBT} Attempting to Cherry-Pick Provided Commits\n";
    git fetch https://github.com/${REPOPK}/${REPONAME} ${CP_BRNC};
    git cherry-pick $1;
    echo -e "\n${CL_LBL}[!]${NONE} IT's possible that you may face conflicts while merging a C-Pick. Solve those and then Continue.";
    echo -e "${CL_WYT}==================================================================${NONE}";
} # cherrypick

function set_ccache()
{
    echo -e "\n${CL_YEL}[!]${NONE} Setting up CCACHE\n";
    ccache -M ${CCSIZE}G;
    echo -e "\n${CL_LGN}[!]${NONE} CCACHE Setup Successful.\n";
} # set_ccache

function set_ccvars()
{
    echo -e "${CL_LBL}[!]${NONE} \nCCACHE Size must be >50 GB.\n Specify the Size (Number) for Reservation of CCACHE (in GB) : \n";
    read -p $'\033[1;36m[>]\033[0m ' CCSIZE;
    echo -e "${CL_LBL}[!]${NONE} Create a New Folder for CCACHE and Specify it's location from / : \n";
    read -p $'\033[1;36m[>]\033[0m ' CCDIR;
    for RC in bashrc profile; do
        if [ -f ${HOME}/.${RC} ] && [[ $(grep -c 'USE_CCACHE\|CCACHE_DIR') != "1" ]]; then
            sudo echo -e "export USE_CCACHE=1\nexport CCACHE_DIR=${CCDIR}" >> ${HOME}/.${RC};
            . ${HOME}/.${RC};
        fi
    done
    set_ccache;
} # set_ccvars

function tools()
{
    [ ! -z "$automate" ] && teh_action 5;

    function java_select()
    {
        echo -e "${CL_LBL}[!]${NONE} If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)";
        echo -e "${CL_LBL}[!]${NONE} You may now select the Version of Java which is to be used BY-DEFAULT\n";
        echo -e "${CL_WYT}================================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt")
                sudo update-alternatives --config java;
                echo -e "\n${CL_WYT}================================================================${NONE}\n";
                sudo update-alternatives --config javac ;;
            "pacman")
                archlinux-java status;
                read -p "${CL_LBL}[!]${NONE} Please enter desired version (ie. \"java-7-openjdk\"): " ARCHJA;
                sudo archlinux-java set ${ARCHJA} ;;
        esac
        echo -e "\n${CL_WYT}================================================================${NONE}";
    } # java_select

    function java()
    {
        echo -ne "\033]0;ScriBt : Java $1\007";
        echo -e "\n${CL_YEL}[!]${NONE} Installing OpenJDK-$1 (Java 1.$1.0)";
        echo -e "\n${CL_LBL}[!]${NONE} Remove other Versions of Java ${CL_WYT}[y/n]${NONE}? : \n";
        read -p $'\033[1;36m[>]\033[0m ' REMOJA;
        echo;
        case "$REMOJA" in
            [yY])
                case "${PKGMGR}" in
                    "apt") sudo apt-get purge openjdk-* icedtea-* icedtea6-* ;;
                    "pacman") sudo pacman -Rddns $( pacman -Qqs ^jdk ) ;;
                esac
                echo -e "\n${CL_LGN}[!]${NONE} Removed Other Versions successfully" ;;
            [nN])
                echo -e "${CL_YEL}[!]${NONE} Keeping them Intact" ;;
            *)
                echo -e "${CL_LRD}[!]${NONE} Invalid Selection.\n";
                java $1;
            ;;
        esac
        echo -e "${CL_WYT}==========================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt") sudo apt-get update -y ;;
            "pacman") sudo pacman -Sy ;;
        esac
        echo -e "\n${CL_WYT}==========================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt") sudo apt-get install openjdk-$1-jdk -y ;;
            "pacman") sudo pacman -S jdk$1-openjdk ;;
        esac
        echo -e "\n${CL_WYT}==========================================================${NONE}";
        if [[ $( java -version > $TMP && grep -c "java version \"1\.$1" $TMP ) == "1" ]]; then
            echo -e "${CL_LGN}[!]${NONE} OpenJDK-$1 or Java 1.$1.0 has been successfully installed";
            echo -e "${CL_WYT}==========================================================${NONE}";
        fi
    } # java

    function java_ppa()
    {
        if [[ ! $(which add-apt-repository) ]]; then
            echo -e "${CL_YEL}[!]${NONE} add-apt-repository not present. Installing it...";
            sudo apt-get install software-properties-common;
        fi
        sudo add-apt-repository ppa:openjdk-r/ppa -y;
        sudo apt-get update -y;
        sudo apt-get install openjdk-7-jdk -y;
    } # java_ppa

    function tool_menu()
    {
        echo -e "\n${CL_WYT}===================${NONE} ${CL_LBL}Tools${NONE} ${CL_WYT}====================${NONE}\n";
        echo -e "     1. Install Build Dependencies\n";
        echo -e "     2. Install Java (OpenJDK 6/7/8)";
        echo -e "     3. Install and/or Set-up CCACHE";
        echo -e "     4. Install/Update ADB udev rules";
# TODO: echo -e "     6. Find an Android Module's Directory";
        echo -e "     5. Install/Revert to make 3.81";
        echo -e "\n     0. Quick Menu"
        echo -e "${CL_WYT}==============================================${NONE}\n";
        read -p $'\033[1;36m[>]\033[0m ' TOOL;
        case "$TOOL" in
            0) quick_menu ;;
            1) case "${PKGMGR}" in
                   "apt") installdeps ;;
                   "pacman") installdeps_arch ;;
               esac
            ;;
            2) java_menu ;;
            3) set_ccvars ;;
            4) udev_rules ;;
# TODO:     6) find_mod ;;
            5) make_me_old "do_it"; make_me_old "chk_it" ;;
            *) echo -e "${CL_LRD}[!]${NONE} Invalid Selection.\n"; tool_menu ;;
        esac
        [ -z "$automate" ] && quick_menu;
    } # tool_menu

    function installdeps()
    {
        echo -e "${CL_YEL}[!]${NONE} Analyzing Distro";
        PACK="/etc/apt/sources.list.d/official-package-repositories.list";
        DISTROS=( precise quantal raring saucy trusty utopic vivid wily xenial );
        for DIST in ${DISTROS[*]}; do
            if [[ $(grep -c "${DIST}" "${PACK}") != "0" ]]; then
                export DISTRO="${DIST}";
            fi
        done
        echo -e "\n${CL_YEL}[!]${NONE} Installing Build Dependencies\n";
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
    } # installdeps

    function installdeps_arch()
    {
        # common packages
        PKGS="git gnupg flex bison gperf sdl wxgtk squashfs-tools curl ncurses zlib schedtool perl-switch zip unzip libxslt python2-virtualenv bc rsync maven";
        PKGS64="$( pacman -Sgq multilib-devel ) lib32-zlib lib32-ncurses lib32-readline";
        PKGSJAVA="jdk6 jdk7-openjdk";
        PKGS_CONFLICT="gcc gcc-libs";
        # sort out already installed pkgs
        for item in ${PKGS} ${PKGS64} ${PKGSJAVA}; do
            if ! pacman -Qq ${item} &> /dev/null; then
                PKGSREQ="${item} ${PKGSREQ}";
            fi
        done
        # if there are required packages, run the installer
        if [ ${#PKGSREQ} -ge 4 ]; then
            # choose an AUR package manager instead of pacman
            for item in yaourt pacaur packer; do
                if which ${item} &> /dev/null; then
                    AURMGR="${item}";
                fi
            done
            if [ -z ${AURMGR} ]; then
                echo -e "\n${CL_LRD}[!]${NONE} no AUR manager found\n";
                exitScriBt 1;
            fi
            # look for conflicting packages and uninstall them
            for item in ${PKGS_CONFLICT}; do
                if pacman -Qq ${item} &> /dev/null; then
                    sudo pacman -Rddns --noconfirm ${item};
                    sleep 3;
                fi
            done
            # install required packages
            for item in ${PKGSREQ}; do
                ${AURMGR} -S --noconfirm $item;
            done
        else
            echo -e "\n${CL_LGN}[!]${NONE} You already have all required packages\n";
        fi
    } # installdeps_arch

    function java_menu()
    {
        echo -e "${CL_WYT}=============${NONE} ${CL_YEL}JAVA${NONE} Installation ${CL_WYT}============${NONE}\n";
        echo -e "1. Install Java";
        echo -e "2. Switch Between Java Versions / Providers\n";
        echo -e "0. Quick Menu\n";
        echo -e "${CL_LBL}[!]${NONE} ScriBt installs Java by OpenJDK";
        echo -e "\n${CL_WYT}============================================\n${NONE}";
        read -p $'\033[1;36m[>]\033[0m ' JAVAS;
        case "$JAVAS" in
            0)  quick_menu ;;
            1)
                echo -ne '\033]0;ScriBt : Java\007';
                echo -e "\n${CL_LRD}[?]${NONE} Android Version of the ROM you're building";
                echo -e "1. Java 1.6.0 (4.4 Kitkat)";
                echo -e "2. Java 1.7.0 (5.x.x Lollipop && 6.x.x Marshmallow)";
                echo -e "3. Java 1.8.0 (7.x.x Nougat)\n";
                [[ "${PKGMGR}" == "apt" ]] && echo -e "4. Ubuntu 16.04 & Want to install Java 7";
                read -p $'\033[1;36m[>]\033[0m ' JAVER;
                case "$JAVER" in
                    1) java 6 ;;
                    2) java 7 ;;
                    3) java 8 ;;
                    4) java_ppa ;;
                    *)
                        echo -e "\n${CL_LRD}[!]${NONE} Invalid Selection.\n";
                        java_menu ;;
                esac # JAVER
            ;;
            2) java_select ;;
            *)
                echo -e "\n${CL_LRD}[!]${NONE} Invalid Selection.\n"
                java_menu ;;
        esac # JAVAS
    } # java_menu

    function udev_rules()
    {
        echo -e "\n${CL_WYT}==========================================================${NONE}\n";
        echo -e "${CL_YEL}[!]${NONE} Updating / Creating Android USB udev rules (51-android)\n";
        sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules;
        sudo chmod a+r /etc/udev/rules.d/51-android.rules;
        sudo service udev restart;
        echo -e "${CL_LGN}[!]${NONE} Done";
        echo -e "\n${CL_WYT}==========================================================${NONE}\n";
    } # udev_rules

    function make_me_old()
    {
        MKVR=$(make -v | head -1 | awk '{print $3}');
        case "$1" in
            "do_it")
                case "${MKVR}" in
                    "3.81")
                        echo -e "\n${CL_LGN}[!]${NONE} make 3.81 has already been installed" ;;
                    *)
                        echo "\n${CL_YEL}[!]${NONE} Installing make 3.81...";
                        sudo install utils/make /usr/bin/;
                    ;;
                esac
            ;;
            "chk_it")
                [[ "$MKVR" == "3.81" ]] && echo -e "\n${CL_LGN}[!]${NONE} make 3.81 present";
            ;;
        esac
    } # make_me_old

    tool_menu;
} # tools

function shut_my_mouth()
{
    if [ ! -z "$automate" ]; then
        RST="SB$1";
        echo -e "${CL_PRP}[!]${NONE} ${ATBT} $2 : ${!RST}";
    else
        read -p $'\033[1;36m[>]\033[0m ' SB2;
        [ -z "$3" ] && export SB$1="${SB2}" || eval SB$1=${SB2};
    fi
    echo;
} # shut_my_mouth

function sync()
{
    [ ! -z "$automate" ] && teh_action 2;
    if [ ! -f .repo/manifest.xml ]; then init; elif [ -z "$action_1" ]; then rom_select; fi;
    echo -e "\n${CL_YEL}[!]${NONE} Preparing for Sync\n";
    echo -e "${CL_LRD}[?]${NONE} Number of Threads for Sync \n"; gimme_info "jobs";
    ST="Number of Threads"; shut_my_mouth JOBS "$ST";
    echo -e "${CL_LRD}[?]${NONE} Force Sync needed ${CL_WYT}[y/n]${NONE}\n"; gimme_info "fsync";
    ST="Force Sync"; shut_my_mouth F "$ST";
    echo -e "${CL_LRD}[?]${NONE} Need some Silence in the Terminal ${CL_WYT}[y/n]${NONE}\n"; gimme_info "ssync";
    ST="Silent Sync"; shut_my_mouth S "$ST";
    echo -e "${CL_LRD}[?]${NONE} Sync only Current Branch ${CL_WYT}[y/n]${NONE}\n"; gimme_info "syncrt";
    ST="Sync Current Branch"; shut_my_mouth C "$ST";
    echo -e "${CL_LRD}[?]${NONE} Sync with clone-bundle ${CL_WYT}[y/n]${NONE}\n"; gimme_info "clnbun";
    ST="Use clone-bundle"; shut_my_mouth B "$ST";
    echo -e "${CL_WYT}=====================================================================${NONE}\n";
    #Sync-Options
    [[ "$SBS" == "y" ]] && SILENT=-q || SILENT=" ";
    [[ "$SBF" == "y" ]] && FORCE=--force-sync || FORCE=" ";
    [[ "$SBC" == "y" ]] && SYNC_CRNT=-c || SYNC_CRNT=" ";
    [[ "$SBB" == "y" ]] && CLN_BUN=" " || CLN_BUN=--no-clone-bundle;
    echo -e "${CL_YEL}[!]${NONE} Let's Sync!\n";
    repo sync -j${SBJOBS} ${SILENT} ${FORCE} ${SYNC_CRNT} ${CLN_BUN}  #2>&1 | tee $STMP;
    echo;
    the_response COOL Sync;
    echo -e "\n${CL_LGN}[!]${NONE} Done.\n";
    echo -e "${CL_WYT}=====================================================================${NONE}\n";
    [ -z "$automate" ] && quick_menu;
} # sync

function rom_select()
{
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    echo -e "${CL_YEL}[?]${NONE} ${CL_WYT}Which ROM are you trying to build
Choose among these (Number Selection)

1. AICP
2. AOKP
3. AOSiP
4. AOSP-CAF
5. AOSP-RRO
6. BlissRoms
7. CandyRoms
8. CarbonROM
9. crDroid
10. Cyanide-L
11. CyanogenMod
12. DirtyUnicorns
13. Flayr OS
14. Krexus-CAF
15. OctOs
16. OmniROM
17. Orion OS
18. OwnROM
19. PAC-ROM
20. AOSPA
21. Resurrection Remix
22. SlimRoms
23. Temasek
24. GZR Tesla
25. Tipsy OS
26. GZR Validus
27. VanirAOSP
28. XenonHD
29. XOSP
30. Zephyr-Os

=======================================================${NONE}\n";
    [ -z "$automate" ] && read -p $'\033[1;36m[>]\033[0m ' SBRN;
    rom_names "$SBRN";
} # rom_select

function init()
{
    [ ! -z "$automate" ] && teh_action 1;
    rom_select;
    echo -e "\n${CL_LBL}[!]${NONE} You have chosen -> $ROM_FN\n";
    sleep 1;
    echo -e "${CL_YEL}[!]${NONE} Detecting Available Branches in ${ROM_FN} Repository...";
    RCT=$[ ${#ROM_NAME[*]} - 1 ];
    for RC in `eval echo "{0..$RCT}"`; do
        echo -e "\nOn ${ROM_NAME[$RC]} (ID->$RC)...\n";
        git ls-remote -h https://github.com/${ROM_NAME[$RC]}/${MAN[$RC]} |\
            awk '{print $2}' | awk -F "/" '{if (length($4) != 0) {print $3"/"$4} else {print $3}}';
    done
    echo -e "\n${CL_LBL}[!]${NONE} These Branches are available at the moment\n${CL_LRD}[?]${NONE} Specify the ID and Branch you're going to sync\n${CL_LBL}[!]${NONE} Format : [ID] [BRANCH]\n";
    ST="Branch"; shut_my_mouth NBR "$ST";
    RC=`echo "$SBNBR" | awk '{print $1}'`; SBBR=`echo "$SBNBR" | awk '{print $2}'`;
    MNF=`echo "${MAN[$RC]}"`;
    RNM=`echo "${ROM_NAME[$RC]}"`
    echo -e "${CL_LRD}[?]${NONE} Any Source you have already synced ${CL_WYT}[y/n]${NONE}\n"; gimme_info "refer";
    ST="Use Reference Source"; shut_my_mouth RF "$ST";
    if [[ "$SBRF" == [Yy] ]]; then
        echo -e "\n${CL_LRD}[?]${NONE} Provide me the Synced Source's Location from /\n";
        ST="Reference Location"; shut_my_mouth RFL "$ST";
        REF=--reference\=\"${SBRFL}\";
    else
        REF=" ";
    fi
    echo -e "${CL_LRD}[?]${NONE} Set clone-depth ${CL_WYT}[y/n]${NONE}\n"; gimme_info "cldp";
    ST="Use clone-depth"; shut_my_mouth CD "$ST";
    if [[ "$SBCD" == [Yy] ]]; then
        echo -e "${CL_LRD}[?]${NONE} Depth Value [1]\n";
        ST="clone-depth Value"; shut_my_mouth DEP "$ST";
        [ -z "$SBDEP" ] && SBDEP=1;
    fi
    #Check for Presence of Repo Binary
    if [[ ! $(which repo) ]]; then
        echo -e "${CL_YEL}[!]${NONE} Looks like the Repo binary isn't installed. Let's Install it.\n";
        [ ! -d "${HOME}/bin" ] && mkdir -p ${HOME}/bin;
        curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo;
        chmod a+x ~/bin/repo;
        echo -e "${CL_LGN}[!]${NONE} Repo Binary Installed\n${CL_YEL}[!]${NONE} Adding ~/bin to PATH\n";
        echo -e "# set PATH so it includes user's private bin if it exists" >> ~/.profile;
        echo -e "if [ -d \"\$HOME/bin\" ] ; then" >> ~/.profile;
        echo -e "\tPATH=\"\$HOME/bin:\$PATH\" "; >> ~/.profile;
        echo -e "fi"; >> ~/.profile;
        . ~/.profile;
        echo -e "${CL_LGN}[!]${NONE} Done. Ready to Init Repo.\n";
    fi
    echo -e "${CL_WYT}=========================================================${NONE}\n";
    echo -e "${CL_YEL}[!]${NONE} Initializing the ROM Repo\n";
    repo init ${REF} -u https://github.com/${RNM}/${MNF} -b ${SBBR} ;
    echo -e "\n${CL_LGN}[!]${NONE} ${ROM_NAME[$RC]} Repo Initialized\n";
    echo -e "${CL_WYT}=========================================================${NONE}\n";
    mkdir .repo/local_manifests;
    if [ -z "$automate" ]; then
        echo -e "${CL_LBL}[!]${NONE} A folder \"local_manifests\" has been created for you.";
        echo -e "${CL_LBL}[!]${NONE} Create a Device Specific manifest and Press ENTER to start sync\n";
        read ENTER;
        echo;
    fi
    export action_1="init";
    sync;
} # init

function device_info()
{
    echo -e "${CL_WYT}======================${NONE} ${CL_PRP}Device Info${NONE} ${CL_WYT}======================${NONE}\n";
    echo -e "${CL_LRD}[?]${NONE} What's your Device's CodeName \n${CL_LBL}[!]${NONE} Refer Device Tree - All Lowercases\n";
    ST="Your Device Name is"; shut_my_mouth DEV "$ST";
    echo -e "${CL_LRD}[?]${NONE} Your Device's Company/Vendor \n${CL_LBL}[!]${NONE} All Lowercases\n";
    ST="Device's Vendor"; shut_my_mouth CM "$ST";
    echo -e "${CL_LRD}[?]${NONE} Build type \n${CL_LBL}[!]${NONE} [userdebug/user/eng]\n";
    ST="Build type"; shut_my_mouth BT "$ST";
    echo -e "${CL_LRD}[?]${NONE} Choose your Device type among these. Explainations of each file given in README.md"; gimme_info "device-type";
    TYPES=( common_full_phone common_mini_phone common_full_hybrid_wifionly \
    common_full_tablet_lte common_full_tablet_wifionly common_mini_tablet_wifionly common_tablet \
    common_full_tv common_mini_tv );
    CNT=0;
    for TYP in ${TYPES[*]}; do
        [ -f ${CNF}/${TYP}.mk ] && ( echo -e "${CNT}. $TYP"; ((CNT++)) );
    done
    echo;
    ST="Device Type"; shut_my_mouth DTP "$ST";
    [ -z $SBDTP ] && SBDTP=common || SBDTP="${TYPES[${SBDTP}]}";
    echo -e "${CL_WYT}=========================================================${NONE}\n";
} # device_info

function init_bld()
{
    echo -e "\n${CL_WYT}===========================================${NONE}";
    echo -e "${CL_YEL}[!]${NONE} Initializing Build Environment\n";
    . build/envsetup.sh;
    echo -e "\n${CL_WYT}===========================================${NONE}\n";
    echo -e "${CL_LGN}[!]${NONE} Done\n";
} # init_bld

function pre_build()
{
    [ ! -z "$automate" ] && teh_action 3;
    [ -z "$action_1" ] && rom_select;
    init_bld;
    [ ! -z "${ROMV}" ] && export ROMNIS="${ROMV}"; # Change ROMNIS
    if [ -d ${CALL_ME_ROOT}/vendor/${ROMNIS}/config ]; then
        CNF="vendor/${ROMNIS}/config";
    elif [ -d ${CALL_ME_ROOT}/vendor/${ROMNIS}/configs ]; then
        CNF="vendor/${ROMNIS}/configs";
    else
        CNF="vendor/${ROMNIS}";
    fi
    rom_names "$SBRN"; # Restore ROMNIS
    device_info;

    function find_ddc() # For Finding Default Device Configuration file
    {
        ROMS=( aicp aokp aosp bliss candy carbon crdroid cyanide cm du orion ownrom slim tesla tipsy to validus vanir xenonhd xosp );
        for ROM in ${ROMS[*]}; do
            # Possible Default Device Configuration (DDC) Files
            DDCS=( ${ROM}_${SBDEV}.mk aosp_${SBDEV}.mk full_${SBDEV}.mk ${ROM}.mk );
            # Inherit DDC
            for ACTUAL_DDC in ${DDCS[*]}; do
                [ -f $ACTUAL_DDC ] && export DDC="$ACTUAL_DDC";
            done
        done
    } # find_ddc

    function interactive_mk()
    {
        init_bld;
        echo -e "\n${CL_YEL}[!]${NONE} Creating Interactive Makefile for getting Identified by the ROM's BuildSystem...\n";
        sleep 2;
        cd device/${SBCM}/${SBDEV};
        INTM="interact.mk";
        [ -z "$INTF" ] && INTF="${ROMNIS}.mk";
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
        echo -e "\$(call inherit-product, device/${SBCM}/${SBDEV}/${DDC})" >> ${INTM};
        # To prevent Missing Vendor Calls in DDC-File
        sed -i -e 's/inherit-product, vendor\//inherit-product-if-exists, vendor\//g' $DDC;
        # Add User-desired Makefile Calls
        echo -e "${CL_LRD}[?]${NONE} Missed some Makefile calls\n${CL_LBL}[!]${NONE} Enter number of Desired Makefile calls [0 if none]";
        ST="No of Makefile Calls"; shut_my_mouth NMK "$ST";
        for CNT in `eval echo "{1..${SBNMK}}"`; do
            echo -e "\n${CL_LRD}[?]${NONE} Enter Makefile location from Root of BuildSystem";
            ST="Makefile"; shut_my_mouth LOC[$CNT] "$ST" array;
            if [ -f ${CALL_ME_ROOT}/${SBLOC[$CNT]} ]; then
                echo -e "\n${CL_YEL}[!]${NONE} Adding Makefile $CNT ...";
                echo -e "\n\$(call inherit-product, ${LOC[$CNT]})" >> ${INTM};
            else
                echo -e "${CL_LRD}[!]${NONE} Makefile ${LOC[$CNT]} not Found. Aborting...";
            fi
        done
        echo -e "\n# ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${SBDEV}" >> ${INTM};
        # Make it Identifiable
        mv ${INTM} ${INTF};
        echo -e "${CL_YEL}[!]${NONE} Renaming .dependencies file...\n";
        [ ! -f ${ROMNIS}.dependencies ] && mv -f *.dependencies ${ROMNIS}.dependencies;
        echo -e "${CL_LGN}[!]${NONE} Done.";
        croot;
    } # interactive_mk

    function vendor_strat_all()
    {
        case "$SBRN" in
            12|27) cd vendor/${ROMV} ;;
            *) cd vendor/${ROMNIS} ;;
        esac
        echo -e "${CL_WYT}=========================================================${NONE}\n";

        function dtree_add()
        {   # AOSP-CAF|RRO|OmniROM|Flayr|Zephyr
            echo -e "${CL_YEL}[!]${NONE} Adding Lunch Combo in Device Tree";
            DTREE_DIR="device/${SBCM}/${SBDEV}";
            [ ! -f vendorsetup.sh ] && touch vendorsetup.sh;
            if [[ $(grep -c "${ROMNIS}_${SBDEV}" ${DTREE_DIR}/vendorsetup.sh ) == "0" ]]; then
                echo -e "add_lunch_combo ${ROMNIS}_${SBDEV}-${SBBT}" >> vendorsetup.sh;
            else
                echo -e "${CL_LGN}[!]${NONE} Lunch combo already added to vendorsetup.sh\n";
            fi
        } # dtree_add

        echo -e "${CL_YEL}[!]${NONE} Adding Device to ROM Vendor...";
        STRTS=( "${ROMNIS}.devices" "${ROMNIS}-device-targets" vendorsetup.sh );
        for STRT in ${STRTS[*]}; do
            #    Found file   &&  Strat Not Performed
            if [ -f "$STRT" ] && [ -z "$STDN" ]; then
                if [[ $(grep -c "${SBDEV}" $STRT) == "0" ]]; then
                    case "$STRT" in
                        ${ROMNIS}.devices)
                            echo -e "${SBDEV}" >> $STRT ;;
                        ${ROMNIS}-device-targets)
                            echo -e "${ROMNIS}_${SBDEV}-${SBBT}" >> $STRT;;
                        vendorsetup.sh)
                            echo -e "add_lunch_combo ${ROMNIS}_${SBDEV}-${SBBT}" >> $STRT ;;
                    esac
                else
                    echo -e "${CL_LBL}[!]${NONE} Device already added to $STRT";
                fi
                export STDN="y"; # File Found, Strat Performed
            fi
        done
        [ -z "$STDN" ] && dtree_add; # If none of the Strats Worked
        echo -e "${CL_LGN}[!]${NONE} Done.\n";
        croot;
        echo -e "${CL_WYT}=========================================================${NONE}";
    } # vendor_strat

    function vendor_strat_kpa() # AOKP-4.4|AICP|PAC-5.1|Krexus-CAF|AOSPA
    {
        croot;
        cd vendor/${ROMNIS}/products;
        echo -e "${CL_LBL}[!]${NONE} About Device's Resolution...\n";
        if [ ! -z "$automate" ]; then
            echo -e "${CL_LBL}[!]${NONE} Among these Values - Select the one which is nearest or almost Equal to that of your Device\n";
            echo -e "${CL_LBL}[!]${NONE} Resolutions which are available for a ROM is shown by it's name. All Res are available for PAC-5.1";
            echo -e "${CL_PNK}240${NONE}x400
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
            echo -e "${CL_LRD}[?]${NONE} Enter the Desired Highlighted Number\n";
            read -p $'\033[1;36m[>]\033[0m ' SBBTR;
        else
            echo -e "${CL_LBL}[!]${NONE} ${ATBT} Resolution Choosed : ${SBBTR}";
        fi
        #Vendor-Calls
        case "$ROMNIS" in
            "aicp")
                VENF="${SBDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${VENF}" >> AndroidProducts.mk;
                echo -e "\n# Inherit telephony stuff\n\$(call inherit-product, vendor/${ROMNIS}/configs/telephony.mk)" >> $VENF;
                echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> $VENF;
            ;;
            "aokp")
                VENF="${SBDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${VENF}" >> AndroidProducts.mk;
                echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> $VENF;
                echo -e "\nPRODUCT_COPY_FILES += \ " >> $VENF;
                echo -e "\tvendor/${ROMNIS}/prebuilt/bootanimation/bootanimation_${SBBTR}.zip:system/media/bootanimation.zip" >> $VENF;
            ;;
            "krexus")
                VENF="${ROMNIS}_${SBDEV}.mk";
                echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/common.mk)" >> $VENF;
                echo -e "\n\$( call inherit-product, vendor/${ROMNIS}/products/vendorless.mk)" >> $VENF;
            ;;
            "pa")
                VENF="${SBDEV}/${ROMNIS}_${SBDEV}.mk";
                echo -e "# ${SBCM} ${SBDEV}" >> AndroidProducts.mk
                echo -e "\nifeq (${ROMNIS}_${SBDEV},\$(TARGET_PRODUCT))" >> AndroidProducts.mk;
                echo -e "\tPRODUCT_MAKEFILES += \$(LOCAL_DIR)/${VENF}\nendif" >> AndroidProducts.mk;
                echo -e "\ninclude vendor/${ROMNIS}/main.mk" >> $VENF;
                mv ${CALL_ME_ROOT}/device/${SBCM}/${SBDEV}/*.dependencies ${SBDEV}/pa.dependencies;
            ;;
            "pac")
                VENF="${ROMNIS}_${SBDEV}.mk";
                echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/pac_common.mk)" >> $VENF;
                echo -e "\nPAC_BOOTANIMATION_NAME := ${SBBTR};" >> $VENF;
            ;;
        esac
        find_ddc;
        echo -e "\n# Inherit from ${DDC}" >> $VENF;
        echo -e "\$(call inherit-product, device/${SBCM}/${SBDEV}/${DDC})" >> $VENF;
        # PRODUCT_NAME is the only ROM-specific Identifier, setting it here is better.
        echo -e "\n#ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${SBDEV}" >> $VENF;
    } # vendor_strat_kpa

    if [ -d vendor/${ROMNIS}/products ] && [ ! -d vendor/aosip ]; then
        if [ ! -f vendor/${ROMNIS}/products/${ROMNIS}_${SBDEV}.mk ||
             ! -f vendor/${ROMNIS}/products/${SBDEV}.mk ||
             ! -f vendor/${ROMNIS}/products/${SBDEV}/${ROMNIS}_${SBDEV}.mk ]; then
            vendor_strat_kpa; #if found products folder
        else
            echo -e "\n${CL_LGN}[!]${NONE} Looks like ${SBDEV} has been already added to ${ROM_FN} vendor. Good to go\n";
        fi
    else
        vendor_strat_all; #if not found
    fi
    croot;
    echo -e "\n${CL_YEL}[!]${NONE} ${ROMNIS}-fying Device Tree...\n";
    NOINT=$(echo -e "${CL_LGN}[!]${NONE} Interactive Makefile Unneeded, continuing...");

    function need_for_int()
    {
        if [ -f ${CALL_ME_ROOT}/device/${SBCM}/${SBDEV}/${INTF} ]; then
            echo "$NOINT";
        else
            interactive_mk "$SBRN";
        fi
    } # need_for_int

    case "$SBRN" in
        4|5|13|16|30) # AOSP-CAF/RRO | Flayr | OmniROM | Zephyr
            VNF="common";
            INTF="${ROMNIS}_${SBDEV}.mk";
            need_for_int;
            DEVDIR="device/${SBCM}/${SBDEV}";
            rm -rf ${DEVDIR}/AndroidProducts.mk;
            echo -e "PRODUCT_MAKEFILES :=  \\ \n\t\$(LOCAL_DIR)/${ROMNIS}_${SBDEV}.mk" >> AndroidProducts.mk;
        ;;
        3) # AOSiP-CAF
            if [ ! -f vendor/${ROMNIS}/products ]; then
                VNF="common";
                need_for_int;
            else
                echo "$NOINT";
            fi
        ;;
        2|19) # AOKP-4.4 | PAC-5.1
            if [ ! -f vendor/${ROMNIS}/products ]; then
                VNF="$SBDTP";
                need_for_int;
            else
                echo "$NOINT";
            fi
        ;;
        1|14|20) # AICP | Krexus-CAF | AOSPA
            echo "$NOINT";
        ;;
        *) # Rest of the ROMs
            VNF="$SBDTP";
            need_for_int;
        ;;
    esac
    sleep 2;
    export action_1="init" action_2="pre_build";
    [ ! -z "$automate" ] && quick_menu;
} # pre_build

function build()
{
    if [ -d .repo ]; then
        [ ! -z "$automate" ] && teh_action 4;
        [ -z "$action_2" ] && device_info;
        [ -z "$action_1" ] && rom_select;
    else
        echo -e "${CL_LRD}[!]${NONE} ROM Source Not Found (Synced)\n${CL_LRD}[!]${NONE} Please perform an init and sync before doing this";
        exitScriBt 1;
    fi

    function make_it() # Part of make_module
    {
        echo -e "${CL_LRD}[?]${NONE} ENTER the Directory where the Module is made from : \n";
        read -p $'\033[1;36m[>]\033[0m ' MODDIR;
        echo -e "\n${CL_LRD}[?]${NONE} Do you want to push the Module to the Device (Running the Same ROM) ${CL_WYT}[y/n]${NONE} : \n";
        read -p $'\033[1;36m[>]\033[0m ' PMOD;
        echo;
        case "$PMOD" in
            [yY]) mmmp -B $MODDIR ;;
            [nN]) mmm -B $MODDIR ;;
            *) echo -e "${CL_LRD}[!]${NONE}Invalid Selection.\n"; make_it ;;
        esac
    } # make_it

    function make_module()
    {
        if [ -z "$1" ]; then
            echo -e "\n${CL_LRD}[?]${NONE} Know the Location of the Module : \n";
            read -p $'\033[1;36m[>]\033[0m ' KNWLOC;
        fi
        if [[ "$KNWLOC" == "y" || "$1" == "y" ]]; then
            make_it;
        else
            echo -e "${CL_LBL}[!]${NONE} Do either of these two actions:\n1. Google it (Easier)\n2. Run this command in terminal : sgrep \"LOCAL_MODULE := <Insert_MODULE_NAME_Here> \".\n\n Press ENTER after it's Done..\n";
            read ENTER;
            make_it;
        fi
    } # make_module

    function post_build()
    {
        if [[ $(tac $RMTMP | grep -c -m 1 '#### make completed successfully') == "1" ]]; then
            echo -e "\n${CL_LGN}[!]${NONE} Build Completed Successfully! Cool. Now make it Boot!\n";
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

    function build_make()
    {
        if [[ "$1" != "brunch" ]]; then
            start=$(date +"%s");
            case "$SBMK" in
                "make") BCORES=$(grep -c ^processor /proc/cpuinfo) ;;
                *) BCORES="" ;;
            esac
            if [ $(grep -q "^${ROMNIS}:" "${CALL_ME_ROOT}/build/core/Makefile") ]; then
                $SBMK $ROMNIS $BCORES 2>&1 | tee $RMTMP;
            elif [ $(grep -q "^bacon:" "${CALL_ME_ROOT}/build/core/Makefile") ]; then
                $SBMK bacon $BCORES 2>&1 | tee $RMTMP;
            else
                $SBMK otapackage $BCORES 2>&1 | tee $RMTMP;
            fi
            echo;
            post_build;
            end=$(date +"%s");
            sec=$(($end - $start));
            echo -e "${CL_LBL}[!]${NONE} Build took $(($sec / 3600)) hour(s), $(($sec / 60 % 60)) minute(s) and $(($sec % 60)) second(s)." | tee -a rom_compile.txt;
        fi
    } # build_make

    function hotel_menu()
    {
        echo -e "${CL_WYT}=========================${NONE} ${CL_LBL}Hotel Menu${NONE} ${CL_WYT}==========================${NONE}";
        echo -e " Menu is only for your Device, not for you. No Complaints pls.\n";
        echo -e "[*] lunch - Setup Build Environment for the Device";
        echo -e "[*] breakfast - Download Device Dependencies and lunch";
        echo -e "[*] brunch - breakfast + lunch then Start Build\n";
        echo -e "${CL_LRD}[?]${NONE} Type in the Option you want to select\n";
        echo -e "${CL_LBL}[!]${NONE} Building for the first time ? select lunch";
        echo -e "${CL_WYT}===============================================================${NONE}\n";
        ST="Selected Option"; shut_my_mouth SLT "$ST";
        case "$SBSLT" in
            "lunch") ${SBSLT} ${ROMNIS}_${SBDEV}-${SBBT} ;;
            "breakfast") ${SBSLT} ${SBDEV} ${SBBT} ;;
            "brunch")
                echo -e "\n${CL_YEL}[!]${NONE} Starting Compilation - ${ROM_FN} for ${SBDEV}\n";
                ${SBSLT} ${SBDEV};
            ;;
            *)  echo -e "${CL_LRD}[!]${NONE} Invalid Selection.\n"; hotel_menu ;;
        esac
        echo;
    } # hotel_menu

    function build_menu()
    {
        init_bld;
        echo -e "${CL_WYT}=========================================================${NONE}\n";
        echo -e "${CL_LRD}[?]${NONE} Select a Build Option:\n";
        echo -e "1. Start Building ROM (ZIP output) (Clean Options Available)";
        echo -e "2. Make a Particular Module";
        echo -e "3. Setup CCACHE for Faster Builds \n";
        echo -e "${CL_WYT}=========================================================\n"
        ST="Option Selected"; shut_my_mouth BO "$ST";
    }

    build_menu;
    case "$SBBO" in
        1)
            echo -e "\n${CL_LRD}[?]${NONE} Should i use 'make' or 'mka'\n";
            ST="Selected Method"; shut_my_mouth MK "$ST";
            echo -e "${CL_LRD}[?]${NONE} Wanna Clean the /out before Building\n${CL_LBL}[!]${NONE} [1 - Remove Staging Dirs / 2 - Full Clean]\n";
            ST="Option Selected"; shut_my_mouth CL "$ST";
            if [[ $(grep -c 'BUILD_ID=M\|BUILD_ID=N' ${CALL_ME_ROOT}/build/core/build_id.mk) == "1" ]]; then
                echo -e "${CL_LRD}[?]${NONE} Use Jack Toolchain ${CL_WYT}[y/n]${NONE}\n";
                ST="Use Jacky"; shut_my_mouth JK "$ST";
                case "$SBJK" in
                     [yY]) export ANDROID_COMPILE_WITH_JACK=true ;;
                     [nN]) export ANDROID_COMPILE_WITH_JACK=false ;;
                esac
            fi
            if [[ $(grep -c 'BUILD_ID=N' ${CALL_ME_ROOT}/build/core/build_id.mk) == "1" ]]; then
                echo -e "${CL_LRD}[?]${NONE} Use Ninja to build Android ${CL_WYT}[y/n]${NONE}";
                ST="Use Ninja"; shut_my_mouth NJ "$ST";
                case "$SBNJ" in
                    [yY])
                        echo -e "\n${CL_LBL}[!]${NONE} Building Android with Ninja BuildSystem";
                        export USE_NINJA=true ;;
                    [nN])
                        echo -e "\n${CL_LBL}[!]${NONE} Building Android with the Non-Ninja BuildSystem\n";
                        export USE_NINJA=false; unset BUILDING_WITH_NINJA ;;
                    *) echo -e "${CL_LRD}[!]${NONE} Invalid Selection.\n" ;;
                esac
            fi
            case "$SBCL" in
                1) lunch ${ROMNIS}_${SBDEV}-${SBBT}; $SBMK installclean ;;
                2) lunch ${ROMNIS}_${SBDEV}-${SBBT}; $SBMK clean ;;
                *) echo -e "${CL_LRD}[!]${NONE} Invalid Selection.\n" ;;
            esac
            hotel_menu;
            build_make "$SBSLT";
        ;;
        2) make_module ;;
        3) set_ccvars ;;
        *)
            echo -e "${CL_LRD}[!]${NONE} Invalid Selection.\n";
            build;
        ;;
    esac
    export action_3="build";
} # build

function teh_action()
{
    case "$1" in
    1)
        [ -z "$automate" ] && init;
        echo -ne '\033]0;ScriBt : Init\007';
    ;;
    2)
        [ -z "$automate" ] & sync;
        echo -ne "\033]0;ScriBt : Syncing ${ROM_FN}\007";
    ;;
    3)
        [ -z "$automate" ] && pre_build;
        echo -ne '\033]0;ScriBt : Pre-Build\007';
    ;;
    4)
        [ -z "$automate" ] && build;
        echo -ne "\033]0;${ROMNIS}_${SBDEV} : In Progress\007";
    ;;
    5)
        [ -z "$automate" ] && tools;
        echo -ne '\033]0;ScriBt : Installing Dependencies\007';
    ;;
    6)
        [ -z "$automate" ] && exitScriBt 0;
        case "$2" in
            "COOL") echo -ne "\033]0;${ROMNIS}_${SBDEV} : Success\007" ;;
            "FAIL") echo -ne "\033]0;${ROMNIS}_${SBDEV} : Fail\007" ;;
        esac
    ;;
    *)
        echo -e "\n${CL_LRD}[!]${NONE} Invalid Selection.\n";
        case "$2" in
            "qm") quick_menu ;;
            "mm") main_menu ;;
        esac
    ;;
    esac
} # teh_action

function the_start()
{
    # are we 64-bit ??
    if ! [[ $(uname -m) =~ (x86_64|amd64) ]]; then
        echo -e "\n\033[0;31m[!]\033[0m Your Processor is not supported\n";
        exitScriBt 1;
    fi
    # is the distro supported ??
    pkgmgr_check;
    #   tempfile      repo sync log       rom build log        vars b4 exe     vars after exe
    TMP=temp.txt; STMP=temp_sync.txt; RMTMP=temp_compile.txt; TV1=temp_v1.txt; TV2=temp_v2.txt;
    rm -rf temp{,_sync,_compile,_v{1,2}}.txt;
    touch temp{,_sync,_compile,_v{1,2}}.txt;
    ATBT="${CL_WYT}*${NONE}${CL_LRD}AutoBot${NONE}${CL_WYT}*${NONE}";
    # CHEAT CHEAT CHEAT!
    if [ ! -z "$automate" ]; then
        . $(pwd)/PREF.rc;
        echo -e "\n${CL_LRD}[${NONE}${CL_YEL}!${NONE}${CL_LRD}]${NONE} ${ATBT} Cheat Code shut_my_mouth applied. I won't ask questions anymore";
    else
        echo -e "\n${CL_LBL}[!]${NONE} Using this for first time?\nTake a look on PREF.rc and shut_my_mouth";
    fi
    echo -e "\n${CL_LRD}[?]${NONE} Before Starting off, shall I remember the responses you'll enter from now \n${CL_LBL}[!]${NONE} So that it can be Automated next time\n";
    read -p $'\033[1;36m[>]\033[0m ' RQ_PGN;
    (set -o posix; set) > ${TV1};
    echo -e "\n${CL_YEL}[!]${NONE} Prompting for Root Access\n";
    sudo echo -e "\n${CL_LGN}[!]${NONE} Root access OK. You won't be asked again";
    export CALL_ME_ROOT="$(pwd)";
    echo -e "\n${CL_YEL}[!]${NONE} ./action${CL_LRD}.SHOW_LOGO${NONE}";
    sleep 2;
    clear;
    echo -e "\n\n                 ${CL_LRD}╔═╗${NONE}${CL_YEL}╦═╗${NONE}${CL_LCN}╔═╗${NONE}${CL_LGN} ╦${NONE}${CL_LCN}╔═╗${NONE}${CL_YEL}╦╔═${NONE}${CL_LRD}╔╦╗${NONE}";
    echo -e "                 ${CL_LRD}╠═╝${NONE}${CL_YEL}╠╦╝${NONE}${CL_LCN}║ ║${NONE}${CL_LGN} ║${NONE}${CL_LCN}║╣ ${NONE}${CL_YEL}╠╩╗${NONE}${CL_LRD} ║ ${NONE}";
    echo -e "                 ${CL_LRD}╩  ${NONE}${CL_YEL}╩╚═${NONE}${CL_LCN}╚═╝${NONE}${CL_LGN}╚╝${NONE}${CL_LCN}╚═╝${NONE}${CL_YEL}╩ ╩${NONE}${CL_LRD} ╩${NONE}";
    echo -e "      ${CL_LRD}███████${NONE}${CL_RED}╗${NONE} ${CL_LRD}██████${NONE}${CL_RED}╗${NONE}${CL_LRD}██████${NONE}${CL_RED}╗${NONE} ${CL_LRD}██${NONE}${CL_RED}╗${NONE}${CL_LRD}██████${NONE}${CL_RED}╗${NONE} ${CL_LRD}████████${NONE}${CL_RED}╗${NONE}";
    echo -e "      ${CL_LRD}██${NONE}${CL_RED}╔════╝${NONE}${CL_LRD}██${NONE}${CL_RED}╔════╝${NONE}${CL_LRD}██${NONE}${CL_RED}╔══${NONE}${CL_LRD}██${NONE}${CL_RED}╗${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██${NONE}${CL_RED}╔══${NONE}${CL_LRD}██${NONE}${CL_RED}╗╚══${NONE}${CL_LRD}██${NONE}${CL_RED}╔══╝${NONE}";
    echo -e "      ${CL_LRD}███████${NONE}${CL_RED}╗${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}     ${CL_LRD}██████${NONE}${CL_RED}╔╝${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██████${NONE}${CL_RED}╔╝${NONE}   ${CL_LRD}██${NONE}${CL_RED}║${NONE}";
    echo -e "      ${CL_RED}╚════${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}     ${CL_LRD}██${NONE}${CL_RED}╔══${NONE}${CL_LRD}██${NONE}${CL_RED}╗${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██${NONE}${CL_RED}╔══${NONE}${CL_LRD}██${NONE}${CL_RED}╗${NONE}   ${CL_LRD}██${NONE}${CL_RED}║${NONE}";
    echo -e "      ${CL_LRD}███████${NONE}${CL_RED}║╚${NONE}${CL_LRD}██████${NONE}${CL_RED}╗${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}  ${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██${NONE}${CL_RED}║${NONE}${CL_LRD}██████${NONE}${CL_RED}╔╝${NONE}   ${CL_LRD}██${NONE}${CL_RED}║${NONE}";
    echo -e "      ${CL_RED}╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═════╝    ╚═╝${NONE}\n";
    sleep 1.5;
} # the_start

# VROOM!
DNT=`date +'%d/%m/%y %r'`;
# Load RIDb and Colors
if [ -f ROM.rc ]; then
    . $(pwd)/ROM.rc;
    color_my_life;
else
    echo "[Error] ROM.rc isn't present in ${PWD}, please make sure repo is cloned correctly";
    exitScriBt 1;
fi
if [[ "$1" == "automate" ]]; then
    the_start; # Pre-Initial Stage
    echo -e "${CL_LBL}[!]${NONE} ${ATBT} Thanks for Selecting Me. Lem'me do your work";
    export automate="yus_do_eet";
    automate; # Initiate the Build Sequence - Actual "VROOM!"
elif [ -z $1 ]; then
    the_start; # Pre-Initial Stage
    main_menu;
else
    echo -e "${CL_LRD}[!]${NONE} Incorrect Parameter: \"$1\"";
    echo -e "${CL_LBL}[!]${NONE} Usage:\n\tbash ROM.sh (Interactive Usage)\n\tbash ROM.sh automate (For Automated Builds)";
    exitScriBt 1;
fi
