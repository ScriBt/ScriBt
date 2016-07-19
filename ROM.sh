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
        echo -e "\n${LRED}Alright, apt detected.${NONE}\n";
    else
        echo -e "\nApt configuration has not been found. A Debian/Ubuntu based Distribution is required to run ScriBt.\n";
        exit 1;
    fi
} # apt_check

function exitScriBt
{
    echo -e "\n\nThanks for using ${LRED}S${NONE}cri${GRN}B${NONE}t. Have a Nice Day\n\n";
    sleep 2;
    echo -e "${LRED}Bye!${NONE}";
    exit 0;
} # exitScriBt

the_response ()
{
    case "$1" in
    "COOL") echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Automated $2 ${LGRN}Successful! :)${NONE}" ;;
    "FAIL") echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Automated $2 ${LRED}Failed :(${NONE}" ;;
    esac
} # the_response

function main_menu
{
    echo -ne '\033]0;ScriBt : Main Menu\007';
    echo -e "${LRED}=======================================================${NONE}";
    echo -e "${LRED}====================${NONE}${CYAN}[*]${NONE}${PURP}MAIN MENU${NONE}${CYAN}[*]${NONE}${LRED}====================${NONE}";
    echo -e "${LRED}=======================================================${NONE}\n";
    echo -e "         Select the Action you want to perform\n";
    echo -e "${LBLU}1${NONE}${CYAN} ................${NONE}${RED}Choose ROM & Init*${NONE}${CYAN}.................${NONE} ${LBLU}1${NONE}";
    echo -e "${LBLU}2${NONE}${CYAN} .......................${NONE}${YELO}Sync${NONE}${CYAN}........................${NONE} ${LBLU}2${NONE}";
    echo -e "${LBLU}3${NONE}${CYAN} .....................${NONE}${GRN}Pre-Build${NONE}${CYAN}.....................${NONE} ${LBLU}3${NONE}";
    echo -e "${LBLU}4${NONE}${CYAN} .......................${NONE}${LGRN}Build${NONE}${CYAN}.......................${NONE} ${LBLU}4${NONE}";
    echo -e "${LBLU}5${NONE}${CYAN} ........${NONE}${PURP}Check and Install Build Dependencies${NONE}${CYAN}.......${NONE} ${LBLU}5${NONE}\n";
    echo -e "6 .......................EXIT........................ 6\n";
    echo -e "* - Sync will Automatically Start after Init'ing Repo";
    echo -e "${LRED}=======================================================${NONE}\n";
    read ACTION;
    teh_action $ACTION "mm";
} # main_menu

function quick_menu
{
    echo -ne '\033]0;ScriBt : Quick Menu\007';
    echo -e "${YELO}============================${NONE} ${LRED}QUICK-MENU${NONE} ${YELO}=============================${NONE}";
    echo -e "${RED}1. Init${NONE} | ${YELO}2. Sync${NONE} | ${GRN}3. Pre-Build${NONE} | ${LGRN}4. Build${NONE} | ${PURP}5. Install Dependencies${NONE}";
    echo -e "                               6. Exit";
    echo -e "${YELO}=====================================================================${NONE}";
    read ACTION;
    teh_action $ACTION "qm";
} # quick_menu

cherrypick ()
{
    echo -ne '\033]0;ScriBt : Picking Cherries\007';
    echo -e "${GRN}========================= Teh${NONE} ${LRED}Cherry${NONE} ${GRN}Picker========================${NONE}\n";
    echo -e "     ${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Attempting to Cherry-Pick Provided Commits\n";
    git fetch https://github.com/${REPOPK}/${REPONAME} ${CP_BRNC};
    git cherry-pick $1;
    echo -e "\nIT's possible that you may face conflicts while merging a C-Pick. Solve those and then Continue.";
    echo -e "${GRN}==================================================================${NONE}";
} # cherrypick

function installdeps
{
    if [ -f PREF.rc ]; then
        teh_action 5;
    fi
    function java_select
    {
        echo -e "If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)";
        echo -e "You may now select the Version of Java which is to be used BY-DEFAULT";
        echo -e "${BLU}================================================================${NONE}\n";
        sudo update-alternatives --config java;
        echo -e "\n${BLU}================================================================${NONE}\n";
        sudo update-alternatives --config javac;
        echo -e "\n${BLU}================================================================${NONE}";
    } # java_select

    java ()
    {
        echo -ne "\033]0;ScriBt : Java $1\007";
        echo -e "Installing OpenJDK-$1 (Java 1.$1.0)";
        echo -e "${LRED}Remove${NONE} other Versions of Java ${LGRN}[y/n]${NONE}? ( Removing them is Recommended)\n";
        read REMOJA;
        echo;
        case "$REMOJA" in
            "y")
               sudo apt-get purge openjdk-* icedtea-* icedtea6-*;
                echo -e "\nRemoved Other Versions successfully" ;;
            "n")
                echo -e "Keeping them Intact" ;;
            *)
                echo -e "${LRED}Invalid Selection.${NONE} RE-Answer it."
                java $1; 
            ;;
            esac
        echo -e "${RED}==========================================================${NONE}\n";
        sudo apt-get update;
        echo -e "\n${RED}==========================================================${NONE}\n";
        sudo apt-get install openjdk-$1-jdk;
        echo -e "\n${RED}==========================================================${NONE}";
        if [[ $( java -version &> $TMP && grep -c "java version \"1.$1" $TMP ) == "1" ]]; then
            echo -e "OpenJDK-$1 or Java 1.$1.0 has been successfully installed";
            echo -e "${RED}==========================================================${NONE}";
        fi
    } # java

    echo -e "${RED}==========================================================${NONE}\n";
    echo -e "Installing Build Dependencies...\n";
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
    echo -e "\n${RED}==========================================================${NONE}\n";
    echo -e "Updating / Creating Android ${LGRN}USB udev rules${NONE} (51-android)\n";
    sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules;
    sudo chmod a+r /etc/udev/rules.d/51-android.rules;
    sudo service udev restart;
    echo;

    function java_menu
    {
        echo -e "${RED}==========================================================${NONE}\n\n";
        echo -e "${LGRN}=====================${NONE} ${LPURP}JAVA Installation${NONE} ${LGRN}====================${NONE}\n";
        echo -e "1. Install Java";
        echo -e "2. Switch Between Java Versions / Providers\n";
        echo -e "3. Already Configured? Back to Main Menu";
        echo -e "${LGRN}==========================================================${NONE}\n";
        read JAVAS;
        echo;
        case "$JAVAS" in
            1)
                echo -ne '\033]0;ScriBt : Java\007';
                echo -e "Android Version of the ROM you're building ? ";
                echo -e "1. 4.4 KitKat ( Java 1.6.0 )";
                echo -e "2. 5.x.x Lollipop & 6.x.x Marshmallow ( Java 1.7.0 )";
                echo -e "3. 7.x.x Nougat ( Java 1.8.0 )\n";
                read ANDVER;
                echo;
                case "$ANDVER" in
                    1) java 6 ;;
                    2) java 7 ;;
                    3) java 8 ;;
                    *)
                        echo -e "\n${LRED}Invalid Selection${NONE}. Going back\n";
                        java_menu ;;
                esac # ANDVER
                ;;
            2)
                java_select ;;
            3)
                main_menu ;;
            *)
                echo -e "\n${LRED}Invalid Selection${NONE}. Going back\n"
                java_menu ;;
        esac # JAVAS
    } #java_menu

    java_menu;
} # installdeps

shut_my_mouth ()
{
    if [ -f PREF.rc ]; then
        RST="DM$1";
        echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} $2 : ${!RST}"
    else
        read DM2; #Value
        export DM$1="${DM2}";
    fi
    echo;
} # shut_my_mouth

gimme_info ()
{
    if [ ! -f PREF.rc ]; then
        case "$1" in
            "jobs") echo -e "${LBLU}(Slow Speed? Recommended value - 1. Else your wish)${NONE}\n";;
            "fsync") echo -e "${LBLU}(Overwrite Local Sources with Remote)${NONE}\n" ;;
            "ssync") echo -e "${LBLU}(Checkout output will appear)${NONE}\n" ;;
            "syncrt") echo -e "${LBLU}(If Enabled, syncs only the desired branch as specified in the manifest, instead of syncing all branches. Saves Space)${NONE}\n" ;;
            "clnbun") echo -e "${LBLU}(Works with AOSP repositories, Downloads a prepackaged bundle file instead of objects from the server (Less objects, better sync). Sync takes place faster coz Google!${NONE}\n" ;;
            "refer") echo -e "${LBLU}(If you have any ROM's source completely synced, giving this source a reference source, will avoid redownloading common projects, thus saving a lot of time)${NONE}\n" ;;
            "cldp") echo -e "${LBLU}(If unset, Syncs the Entire commit history of any repo which is better for future syncs)\n(Unless you know what you're doing,${NONE} ${LRED}Answer n${NONE})\n" ;;
        esac
    fi
} # gimme_info

function sync
{
    if [[ "${inited}" != "1" ]]; then init; fi;
    if [ -f PREF.rc ]; then teh_action 2; fi
    echo -e "\nPreparing for Sync\n";
    echo -e "${LRED}Number of Threads${NONE} for Sync?\n"; gimme_info "jobs";
    ST="${LRED}Number${NONE} of Threads";
    shut_my_mouth JOBS "$ST";
    echo -e "${LRED}Force Sync${NONE} needed? ${LGRN}[y/n]${NONE}\n"; gimme_info "fsync";
    ST="${LRED}Force${NONE} Sync";
    shut_my_mouth F "$ST";
    echo -e "Need some ${LRED}Silence${NONE} in teh Terminal? ${LGRN}[y/n]${NONE}\n"; gimme_info "ssync";
    ST="${LRED}Silent${NONE} Sync";
    shut_my_mouth S "$ST";
    echo -e "Sync only ${LRED}Current${NONE} Branch? ${LGRN}[y/n]${NONE}\n"; gimme_info "syncrt";
    ST="Sync ${LRED}Current${NONE} Branch";
    shut_my_mouth C "$ST";
    echo -e "Sync with ${LRED}clone-bundle${NONE} ${LGRN}[y/n]${NONE}?\n"; gimme_info "clnbun";
    ST="Use ${LRED}clone-bundle${NONE}";
    shut_my_mouth B "$ST";
    echo -e "${LRED}=====================================================================${NONE}\n";
    #Sync-Options
    if [[ "$DMS" == "y" ]]; then SILENT=-q; else SILENT=" " ; fi;
    if [[ "$DMF" == "y" ]]; then FORCE=--force-sync; else FORCE=" " ; fi;
    if [[ "$DMC" == "y" ]]; then SYNC_CRNT=-c; else SYNC_CRNT=" "; fi;
    if [[ "$DMB" == "y" ]]; then CLN_BUN=" "; else CLN_BUN=--no-clone-bundle; fi;
    echo -e "${LGRN}Let's Sync!${NONE}\n";
    repo sync -j${DMJOBS} ${SILENT} ${FORCE} ${SYNC_CRNT} ${CLN_BUN}  2>&1 | tee $RTMP;
    echo;
 #   if [[ $(tac $RTMP | grep -m 1 -c 'Syncing work tree: 100%') == 1 ]]; then
 #       echo -e "ROM Source synced successfully.\n";
 #       if [ -f PREF.rc ]; then
            the_response COOL Sync;
 #       fi
 #   else
 #       if [ -f PREF.rc ]; then
 #           the_response FAIL Sync;
 #       fi
        echo -e "\n${LPURP}Done.${NONE}!\n";
        echo -e "${LRED}=====================================================================${NONE}\n";
        if [ ! -f PREF.rc ]; then quick_menu; fi;
#    fi
} # sync

function rom_select
{
    echo -e "${LPURP}=======================================================${NONE}\n";
    echo -e "Which ROM are you trying to build?
Choose among these (Number Selection)

1.${LGRN} AICP ${NONE}
2.${LRED} AOKP ${NONE}
3.${LGRN} AOSP-RRO ${NONE}
4.${DGRAY} AOSP-CAF ${NONE}
5.${LBLU} BlissRoms by Team Bliss${NONE}
6.${LGRN} CandyRoms ${NONE}
7.${YELO} crDroid ${NONE}
8.${LBLU} Cyanide-L${NONE}
9.${LCYAN} CyanogenMod ${NONE}
10.${LRED} DirtyUnicorns ${NONE}
11.${YELO} Flayr OS ${NONE}
12.${LBLU} Krexus${NONE}-${GRN}CAF${NONE}
13.${LGRN} OmniROM ${NONE}
14.${LPURP} Orion OS ${NONE}
15.${YELO} OwnROM ${NONE}
16.${LBLU} PAC-ROM ${NONE}
17.${LGRN} Paranoid Android aka AOSPA ${NONE}
18.${LRED} Resurrection Remix ${NONE}
19.${LBLU} SlimRoms ${NONE}
20.${LRED} Temasek ${NONE}
21.${LBLU} GZR Tesla ${NONE}
22.${YELO} Tipsy OS ${NONE}
23.${LPURP} GZR Validus ${NONE}
24.${LCYAN} XenonHD by Team Horizon ${NONE}
25.${LBLU} Xperia Open Source Project aka XOSP ${NONE}

${LPURP}=======================================================${NONE}\n";
    if [ ! -f PREF.rc ]; then read ROMNO; fi;
    rom_names "$ROMNO";
}

function init
{
    if [ -f PREF.rc ]; then teh_action 1; fi;
    rom_select;
    echo -e "\nYou have chosen ${LCYAN}->${NONE} $ROM_FN\n";
    sleep 1;
    echo -e "Since Branches may live or die at any moment, ${LRED}Specify the Branch${NONE} you're going to sync\n";
    ST="${LRED}Branch${NONE}";
    shut_my_mouth BR "$ST";
    echo -e "Any ${LRED}Source you have already synced?${NONE} ${LGRN}[YES/NO]${NONE}\n"; gimme_info "refer";
    shut_my_mouth RF "$ST";
    if [[ "$DMRF" == "YES" ]]; then
        echo -e "\nProvide me the ${LRED}Synced Source's Location${NONE} from ${LRED}/${NONE}\n";
        ST="Reference ${LRED}Location${NONE}";
        shut_my_mouth RFL "$ST";
        REF=--reference\=\"${DMRFL}\";
    else
        REF=" " ;
    fi
    echo -e "Set ${LRED}clone-depth${NONE} ? ${LGRN}[y/n]${NONE}\n"; gimme_info "cldp";
    ST="Use ${LRED}clone-depth${NONE}";
    shut_my_mouth CD "$ST";
    echo -e "Depth ${LRED}Value${NONE}? (Default ${LRED}1${NONE})\n";
    ST="clone-depth ${LRED}Value${NONE}";
    shut_my_mouth DEP "$ST";
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
        echo -e "${LGRN}DONE!${NONE}. Ready to Init Repo\n";
    fi
    echo -e "${LBLU}=========================================================${NONE}\n";
    echo -e "Let's Initialize teh ROM Repo\n";
    repo init ${REF} -u https://github.com/${ROM_NAME}/${MAN} -b ${DMBR} ;
    echo -e "\n${ROM_NAME} Repo Initialized\n";
    echo -e "${LBLU}=========================================================${NONE}\n";
    mkdir .repo/local_manifests;
    if [ ! -f PREF.rc ]; then
        echo -e "A folder \"local_manifests\" has been created for you.";
        echo -e "Add either a ${LRED}local_manifest.xml${NONE} or ${LRED}roomservice.xml${NONE} as per your choice\n";
        echo -e "And add your Device-Specific Repos, essential for Building. Press ENTER to start Syncing.";
        read ENTER;
        echo;
    fi
    export inited=1;
    #Start Sync now
    sync;
} # init

function device_info
{
    echo -e "${LCYAN}====================== DEVICE INFO ======================${NONE}\n";
    echo -e "What's your ${LRED}Device's CodeName${NONE} ${LGRN}[Refer Device Tree - All Lowercases]${NONE}?\n";
    ST="Your Device ${LRED}Name${NONE} is";
    shut_my_mouth DEV "$ST";
    echo -e "Your ${LRED}Device's Company/Vendor${NONE} ${LGRN}(All Lowercases)${NONE}?\n";
    ST="Device's ${LRED}Vendor${NONE}";
    shut_my_mouth CM "$ST";
    echo -e "The ${LRED}Build type${NONE}? ${LGRN}[userdebug/user/eng]${NONE}\n";
    ST="Build ${LRED}type${NONE}";
    shut_my_mouth BT "$ST";
    echo -e "${LCYAN}=========================================================${NONE}\n\n";
} # device_info

function pre_build
{
    if [ -f PREF.rc ]; then teh_action 3; fi;
    echo -e "${CYAN}Initializing Build Environment${NONE}\n";
    . build/envsetup.sh;
    echo -e "\n${LPURP}Done.${NONE}.\n\n";
    device_info;
    if [[ "${inited}" != 1 ]]; then rom_select; fi;

    function find_ddc   # For Finding Default Device Configuration file
    {
        ROMS=( aicp aokp aosp bliss candy crdroid cyanide cm du orion ownrom slim tesla tipsy validus xenonhd xosp );
        for ROM in ${ROMS[*]}
        do
            # Possible Default Device Configuration (DDC) Files
            DDCS=( ${ROM}_${DMDEV}.mk aosp_${DMDEV}.mk full_${DMDEV}.mk ${ROM}.mk );
            # Inherit DDC
            for ACTUAL_DDC in ${DDCS[*]}
            do
                if [ -f $ACTUAL_DDC ]; then
                    export DDC="$ACTUAL_DDC";
                fi
            done
        done
    } # find_ddc

    interactive_mk()
    {
        echo -e "${YELO}Initializing Build Environment${NONE}\n";
        . build/envsetup.sh;
        echo -e "\n${PURP}Creating Interactive Makefile for getting Identified by the ROM's BuildSystem...${NONE}\n";
        sleep 2;
        cd device/${DMCM}/${DMDEV};
        INTF=interact.mk;
        echo "#                 ##### Interactive Makefile #####
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
# limitations under the License." >> $INTF;
        if [ -d ${ANDROID_BUILD_TOP}/vendor/${ROMNIS}/config ]; then
            CNF="vendor/${ROMNIS}/config";
        else
            CNF="vendor/${ROMNIS}/configs";
        fi
        find_ddc; # Find Default Device Configuration File
        # Work on Interactive Makefile Start
        echo -e "\n# Inherit ${ROMNIS} common stuff\n\$(call inherit-product, ${CNF}/${VNF}.mk)" >> $INTF;
        # Inherit Vendor specific files
        if [[ $(grep -c -q "nfc_enhanced" $DDC) == "1" ]] && [ -f ${ANDROID_BUILD_TOP}/${CNF}/nfc_enhanced.mk ]; then
            echo -e "\n# Enhanced NFC\n\$(call inherit-product, ${CNF}/nfc_enhanced.mk)" >> $INTF;
        fi
        if [[ $(grep -c -q "telephony" $DDC) == "1" ]] && [ -f ${ANDROID_BUILD_TOP}/${CNF}/telephony.mk ]; then
            echo -e "\n# Inherit telephony stuff\n\$(call inherit-product, ${CNF}/telephony.mk)" >> $INTF;
        fi
        echo -e "\n# Calling Default Device Configuration File" >> $INTF;
        echo -e "\$(call inherit-product, device/${DMCM}/${DMDEV}/${DDC})" >> $INTF;
        echo -e "\n# ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${DMDEV}" >> $INTF;
        # To prevent Missing Vendor Calls
        sed -i -e 's/inherit-product, vendor\//inherit-product-if-exists, vendor\//g' $DDC;
        # Work on Interactive Makefile Complete -- ^^
        # Add User-desired Makefile Calls -- vv
        echo -e "Missed some Makefile calls? Enter number of Desired Makefile calls... [0 if none]";
        if [ ! -f ${ANDROID_BUILD_TOP}/PREF.rc ]; then read NMK; fi;
        for (( CNT=1; CNT<="$NMK"; CNT++ ))
        do
            if [ ! -f ${ANDROID_BUILD_TOP}/PREF.rc ]; then
            echo -e "\nEnter Makefile location from Root of BuildSystem";
            read LOC[$CNT];
            fi
            if [ -f ${ANDROID_BUILD_TOP}/${LOC[$CNT]} ]; then
                echo -e "\n${LGRN}Adding Makefile $CNT ...${NONE}";
                echo -e "\$(call inherit-product, $MK)" >> $INTF;
            else
                echo -e "${LRED}Makefile ${LOC[$CNT]} not Found. Aborting...${NONE}";
            fi
        done
        # That's done..
        # Make it Identifiable
        if [ -f ${ANDROID_BUILD_TOP}/${CNF}/common.mk ]; then
            mv $INTF ${ROMNIS}_${DMDEV}.mk;
            echo -e "PRODUCT_MAKEFILES +=  \\ \n\t\$(LOCAL_DIR)/${ROMNIS}_${DMDEV}.mk" >> AndroidProducts.mk;
        else
            mv $INTF ${ROMNIS}.mk;
        fi
        echo -e "${GRN}Renaming .dependencies file...${NONE}\n";
        if [ ! -f ${ROMNIS}.dependencies ]; then
            mv -f *.dependencies ${ROMNIS}.dependencies;
        fi
        echo -e "${LRED}Done.${NONE}";
        croot;
    } # interactive_mk

    function vendor_strat_all
    {
        if  [[ "$ROMNO" == "10" ]]; then
            cd vendor/${ROMV};
        else
            cd vendor/${ROMNIS};
        fi
        echo -e "${LPURP}=========================================================${NONE}\n";

        function dtree_add
        {   # AOSP-CAF - AOSP-RRO - OmniROM
            croot;
            echo -e "Moving to D-Tree\n\n And adding Lunch Combo..";
            cd device/${DMCM}/${DMDEV};
            if [ ! -f vendorsetup.sh ]; then
                touch vendorsetup.sh;
            fi
            if [[ $(grep -c "${ROMNIS}_${DMDEV}" vendorsetup.sh ) == "0" ]]; then
                echo -e "add_lunch_combo ${ROMNIS}_${DMDEV}-${DMBT}" >> vendorsetup.sh;
            else
                echo -e "Lunch combo already added to vendorsetup.sh\n";
            fi
        } # dtree_add

        echo -e "Adding Device to ROM Vendor...";
        STRTS=( "${ROMNIS}.devices" "${ROMNIS}-device-targets" vendorsetup.sh )
        for STRT in ${STRTS[*]}
        do
            if [ -f $STRT ] && [[ "$STDN" != "y" ]]; then
                if [[ $(grep -c "${DMDEV}" $STRT) == "0" ]]; then
                    case "$STRT" in
                        ${ROMNIS}.devices)
                            echo -e "${DMDEV}" >> $STRT ;;
                        ${ROMNIS}-device-targets)
                            echo -e "${ROMNIS}_${DMDEV}-${DMBT}" >> $STRT;;
                        vendorsetup.sh)
                            echo -e "add_lunch_combo ${ROMNIS}_${DMDEV}-${DMBT}" >> $STRT ;;
                    esac
                    export STDN=y; # File Found, Strat Done
                else
                    echo -e "Device already added to $STRT"
                fi
            fi
        done
        if [[ "$STDN" != "y" ]]; then dtree_add; fi; # If none of the Strategies Worked
        echo -e "${LGRN}Done.${NONE}";
        croot;
        echo -e "${LPURP}=========================================================${NONE}";
    } # vendor_strat

    function vendor_strat_kpa # AOKP-4.4, AICP, PAC-5.1, Krexus-CAF, PA
    {
        croot;
        cd vendor/${ROMNIS}/products;
        echo -e "About Device's Resolution...\n";
        if [ ! -f ${ANDROID_BUILD_TOP}/PREF.rc ]; then
            echo -e "Among these Values - Select the one which is nearest or almost Equal to that of your Device\n";
            echo -e "Resolutions which are available for a ROM is shown by it's name. All Res are available for PAC-ROM ";
            echo -e "
${LPURP}240${NONE}x400
${LPURP}320${NONE}x480 (AOKP)
${LPURP}480${NONE}x800 and ${LPURP}480${NONE}x854 (AOKP & PA)
${LPURP}540${NONE}x960 (AOKP)
${LPURP}600${NONE}x1024
${LPURP}720${NONE}x1280 (AOKP & PA)
${LPURP}768${NONE}x1024 and ${LPURP}768${NONE}x1280 (AOKP)
${LPURP}800${NONE}x1280 (AOKP)
${LPURP}960${NONE}x540
${LPURP}1080${NONE}x1920 (AOKP & PA)
${LPURP}1200${NONE}x1920
${LPURP}1280${NONE}x800
${LPURP}1440${NONE}x2560 (PA)
${LPURP}1536${NONE}x2048
${LPURP}1600${NONE}x2560
${LPURP}1920${NONE}x1200
${LPURP}2560${NONE}x1600\n";
            echo -e "Enter the Desired Highlighted Number...";
            read BOOTRES;
        else
            echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Resolution Choosed : ${BOOTRES}";
        fi
        #Vendor-Calls
        case "$ROMNIS" in
            "krexus")
                VENF="${ROMNIS}_${DMDEV}.mk";
                echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/common.mk)" >> $VENF;
                echo -e "\n\$( call inherit-product, vendor/${ROMNIS}/products/vendorless.mk)" >> $VENF;
            ;;
            "pac")
                VENF="${ROMNIS}_${DMDEV}.mk";
                echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/pac_common.mk)" >> $VENF;
                echo "PAC_BOOTANIMATION_NAME := ${BOOTRES};" >> $VENF;
            ;;
            "aokp")
                VENF="${DMDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${DMDEV}.mk" >> AndroidProducts.mk;
                echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> $VENF;
                echo -e "\nPRODUCT_COPY_FILES += \ " >> $VENF;
                echo -e "\tvendor/aokp/prebuilt/bootanimation/bootanimation_${BOOTRES}.zip:system/media/bootanimation.zip" >> $VENF;
            ;;
            "pa")
                 VENF="${DMDEV}/pa_${DMDEV}.mk";
                echo -e "# ${DMCM} ${DMDEV}" >> AndroidProducts.mk
                echo -e "\nifeq (pa_${DMDEV},\$(TARGET_PRODUCT))" >> AndroidProducts.mk;
                echo -e "\tPRODUCT_MAKEFILES += $(LOCAL_DIR)/${DMDEV}/pa_${DMDEV}.mk\nendif" >> AndroidProducts.mk;
                echo -e "\ninclude vendor/${ROMNIS}/main.mk" >> $VENF;
            ;;
            "aicp")
                VENF="${DMDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${DMDEV}.mk" >> AndroidProducts.mk;
                echo -e "\n# Inherit telephony stuff\n\$(call inherit-product, vendor/${ROMNIS}/configs/telephony.mk)" >> $VENF;
                echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> $VENF;
            ;;
        esac
        find_ddc;
        echo -e "\n# Calling Default Device Configuration File" >> $VENF;
        echo -e "\$(call inherit-product, device/${DMCM}/${DMDEV}/${DDC})" >> $VENF;
        # PRODUCT_NAME is the only ROM-specific Identifier, setting it here is better.
        echo -e "\nPRODUCT_NAME := ${ROMNIS}_${DMDEV}" >> $VENF;
    } # vendor_strat_kpa

    if [ -d vendor/${ROMNIS}/products ]; then
        if [ ! -f vendor/${ROMNIS}/products/${ROMNIS}_${DMDEV}.mk || ! -f vendor/${ROMNIS}/products/${DMDEV}.mk ]; then
            vendor_strat_kpa; #if found products folder
        else
            echo -e "Looks like ${DMDEV} has been already added to ${ROM_FN} vendor. Good to go\n";
        fi
    else
        vendor_strat_all; #if not found
    fi
    croot;
    echo -e "\n${LBLU}${ROMNIS}-fying Device Tree...${NONE}\n";
    case "$ROMNO" in
        3|4) # AOSP-CAF/RRO
            VNF="common";
            CNF="vendor/${ROMNIS}";
            interactive_mk "$ROMNO"
        ;;
        13) # OmniROM
            VNF="common";
            interactive_mk "$ROMNO"
        ;;
        2|16) # AOKP-4.4 | PAC-5.1
            VNF="common_full_phone";
            if [[ "$DMBR" == "kitkat" || "$DMBR" == "pac-5.1" ]]; then
                echo -e "Interactive Makefile Unneeded, continuing...";
            else
                interactive_mk "$ROMNO";
            fi
        ;;
        1|12|17) # AICP | Krexus-CAF | PA
            echo -e "Interactive Makefile Unneeded, continuing...";
        ;;
        *) # Rest of the ROMs
            VNF="common_full_phone";
            interactive_mk "$ROMNO" 
        ;;
    esac
    sleep 2;
    export prebuilded=1;
    if [ ! -f ${ANDROID_BUILD_TOP}/PREF.rc ]; then
        quick_menu;
    fi
} # pre_build

function build
{
    if [ -f PREF.rc ]; then teh_action 4; fi;
    if [[ "${prebuilded}" != "1" ]]; then device_info; fi
    if [[ "${inited}" != 1 ]]; then rom_select; fi;

    function make_it #Part of make_module
    {
        echo -e "${LCYAN}ENTER${NONE} the Directory where the Module is made from\n";
        read MODDIR;
        echo -e "Do you want to ${LRED}push the Module${NONE} to the ${LRED}Device${NONE} ? (Running the Same ROM) ${LGRN}[y/n]${NONE}\n";
        read PMOD;
        echo;
        case "$PMOD" in
            "y") mmmp -B $MODDIR ;;
            "n") mmm -B $MODDIR ;;
            *) echo -e "${LRED}Invalid Selection.${NONE} Going Back."; make_it ;;
        esac
    } # make_it

    make_module ()
    {
        if [ -z "$1" ]; then
        echo;
        read KNWLOC;
        echo -e "\nKnow the Location of the Module?";
        fi
        if [[ "$KNWLOC" == "y" || "$1" == "y" ]]; then
            make_it;
        else
            echo -e "Do either of these two actions: \n1. ${BLU}G${NONE}${RED}o${NONE}${YELO}o${NONE}${BLU}g${NONE}${GRN}l${NONE}${RED}e${NONE} it (Easier)\n2. Run this command in terminal : ${LBLU}sgrep \"LOCAL_MODULE := Insert_MODULE_NAME_Here \"${NONE}.\n\n Press ${LCYAN}ENTER${NONE} after it's ${LPURP}Done.${NONE}.\n";
            read ENTER;
            make_it;
        fi
    } # make_module

    function post_build
    {
        if [[ $(tac $RMTMP | grep -c -m 1 '#### make completed successfully') == "1" ]]; then
            echo -e "\nBuild Completed ${LGRN}Successfully!${NONE} Cool. Now make it ${LRED}Boot!${NONE}\n";
            the_response COOL Build;
            teh_action 6 COOL;
        elif [[ $(tac $RMTMP | grep -c -m 1 'No rule to make target') == "1" ]]; then
            if [ ! -f PREF.rc ]; then
                echo -e "Looks like a Module isn't getting built / Missing\n";
                echo -e "You'll see a line like this:";
                echo -e "No rule to make target '$(pwd)/out/....../${LRED}<MODULE_NAME>${NONE}_intermediates'\n";
                echo -e "${LCYAN}Enter${NONE} whatever you see in place of ${LRED}<MODULE_NAME>${NONE} (Case-Sensitive please)\n";
                read MOD_NAME;
                echo -e "Let's Search for ${LRED}${MOD_NAME}${NONE} ! This will take time, but it's Valuable\n";
                sgrep "LOCAL_MODULE := ${MOD_NAME}" 2>&1 | tee mod.txt;
                if [[ $(grep -c -m 1 'LOCAL_MODULE') == "1" ]]; then
                    echo -e "Looks like we have found that location, let's make it\n";
                    echo -e "The location of the module is stored in ${LRED}mod.txt${NONE}. Take a look";
                    make_module y;
                else
                    echo -e "The Repo which builds that module is ${LRED}missing${NONE}\n";
                    echo -e "======================================================================================================\n";
                    echo -e "Let me search that module for you -> http://lmgtfy.com/?q=LOCAL_MODULE+%3A%3D+${MOD_NAME}\n";
                    echo -e "======================================================================================================\n";
                    echo -e "\nIF you found that module's repo, Sync it to the path as shown in the Repo URL\n";
                    echo -e "For Example https://github.com/CyanogenMod/android_bionic should be synced to $(pwd)/bionic\n";
                    make_module;
                fi
            else
                the_response FAIL Build;
                teh_action 6 FAIL;
            fi
        else
            echo -e "WEW. ${YELO}I_iz_Noob${NONE}. Probably you need to Search the Internet for Resolution of Above Error\n";
            if [ -f PREF.rc ]; then
                teh_action 6 FAIL;
                the_response FAIL Build;
            fi
        fi
    } # post_build

    function set_ccache
    {
        echo -e "Setting up CCACHE\n";
        prebuilts/misc/linux-x86/ccache/ccache -M ${CCSIZE}G;
        echo -e "\nCCACHE Setup ${GRN}Successful${NONE}.\n";
    } # set_ccache

    function set_ccvars
    {
        echo -e "\nCCACHE Size must be ${LRED}>50 GB${NONE}.\n Think about it and Specify the Size (Number) for Reservation of CCACHE (in GB)\n";
        read CCSIZE;
        echo -e "Create a New Folder for CCACHE and Specify it's location from / here\n";
        read CCDIR;
        if [ -f ${HOME}/.bashrc ]; then
            sudo echo "export USE_CCACHE=1" >> ${HOME}/.bashrc;
            sudo echo "export CCACHE_DIR=${CCDIR}" >> ${HOME}/.bashrc;
            . ${HOME}/.bashrc;
        elif [ -f ${HOME}/.profile ]; then
            sudo echo "export USE_CCACHE=1" >> ${HOME}/.profile;
            sudo echo "export CCACHE_DIR=${CCDIR}" >> ${HOME}/.profile;
            . ${HOME}/.profile;
        else
            echo -e "Strategies failed. If you have knowledge of finding .bashrc's equivalent in your Distro, then Paste these lines at the end of the File";
            echo -en "export USE_CCACHE=1";
            echo -en "export CCACHE_DIR=${CCDIR}";
            echo -e "Log-Out and Re-Login. Select Step B. The Changes will be considered after that.";
            sleep 2;
            exitScriBt;
        fi
        echo;
        set_ccache;
    } # set_ccvars

    build_make ()
    {
        if [[ "$1" != "brunch" ]]; then
            start=$(date +"%s");
            case "$DMMK" in
                "make") BCORES=$(grep -c ^processor /proc/cpuinfo) ;;
                *) BCORES="" ;;
            esac
            if [ $(grep -q "^${ROMNIS}:" "${ANDROID_BUILD_TOP}/build/core/Makefile") ]; then
                $DMMK $ROMNIS $BCORES 2>&1 | tee $RMTMP;
            elif [ $(grep -q "^bacon:" "${ANDROID_BUILD_TOP}/build/core/Makefile") ]; then
                $DMMK bacon $BCORES 2>&1 | tee $RMTMP;
            else
                $DMMK otapackage $BCORES 2>&1 | tee $RMTMP;
            fi
            echo;
            post_build;
        end=$(date +"%s");
        sec=$(($end - $start));
        echo -e "${YELO}Build took $(($sec / 3600)) hour(s), $(($sec / 60 % 60)) minute(s) and $(($sec % 60)) second(s).${NONE}" | tee -a rom_compile.txt;
        fi
    } # build_make

    function hotel_menu
    {
        echo -e "${LBLU}====================================${NONE}${RED}[*]${NONE} ${GRN}HOTEL MENU${NONE} ${RED}[*]${NONE}${LBLU}=====================================${NONE}\n";
        echo -e "${LRED}A SideNote : Menu is only for your Device, not for you. No Complaints plz.${NONE}\n";
        echo -e "[*] ${RED}lunch${NONE} - If your Device is not in the ROM's Devices list - ${ORNG}Unofficial${NONE} [*]";
        echo -e "[*] ${YELO}breakfast${NONE} - (If your Device is a ${GRN}Official Device${NONE} for that particular ROM - ${GRN}Official${NONE} [*]";
        echo -e "[*] ${GRN}brunch${NONE} - lunch + sync repos from ${ROMNIS}.dependencies + build - ${ORNG}Official/Unofficial${NONE} [*]\n";
        echo -e "Type in the Option you want to select";
        echo -e "${YELO}Tip!${NONE} - If you're building it for the first time, then select ${RED}lunch${NONE} (Recommended)";
        echo -e "${LBLU}===========================================================================================${NONE}\n";
        ST="Selected Option";
        shut_my_mouth SLT "$ST";
        case "$DMSLT" in
            "lunch") ${DMSLT} ${ROMNIS}_${DMDEV}-${DMBT} ;;
            "breakfast") ${DMSLT} ${DMDEV} ${DMBT} ;;
            "brunch")
                echo -e "\n${LGRN}Starting Compilation - ${ROM_FN} for ${DMDEV}${NONE}\n";
                ${DMSLT} ${DMDEV};
            ;;
            *)  echo -e "${LRED}Invalid Selection.${NONE} Going Back."; hotel_menu ;;
        esac
        echo;
    } # hotel_menu


    echo -e "\n${YELO}=========================================================${NONE}";
    echo -e "             ${CYAN}Initializing Build Environment${NONE}\n";
    . build/envsetup.sh;
    echo -e "\n${YELO}=========================================================${NONE}\n";
    echo -e "${LPURP}Done.${NONE}.\n";

    function build_menu
    {
        echo -e "${LPURP}=========================================================${NONE}\n";
        echo -e "Select the Build Option:\n";
        echo -e "${LCYAN}1. Start Building ROM (ZIP output) (Clean Options Available)${NONE}";
        echo -e "${LGRN}2. Make a Particular Module${NONE}";
        echo -e "${LBLU}3. Setup CCACHE for Faster Builds ${NONE}\n";
        echo -e "${LPURP}=========================================================${NONE}\n"
        ST="Option Selected";
        shut_my_mouth BO "$ST";
    }
    
    build_menu;
    case "$DMBO" in
        1)
            echo -e "\nShould i use '${YELO}make${NONE}' or '${RED}mka${NONE}' ?\n";
            ST="Selected Method";
            shut_my_mouth MK "$ST";
            echo -e "Wanna Clean the ${LPURP}/out${NONE} before Building? ${LGRN}[1 - Remove Staging Dirs / 2 - Full Clean]${NONE}\n";
            ST="Option Selected";
            shut_my_mouth CL "$ST";
            if [[ $(tac ${ANDROID_BUILD_TOP}/build/core/build_id.mk | grep -c 'BUILD_ID=M') == "1" ]]; then
                echo -e "Wanna use ${LRED}Jack Toolchain${NONE} ? ${LGRN}[y/n]${NONE}\n";
                ST="Use ${LRED}Jacky${NONE}";
                shut_my_mouth JK "$ST";
                case "$DMJK" in
                     "y")export ANDROID_COMPILE_WITH_JACK=true ;;
                     "n")export ANDROID_COMPILE_WITH_JACK=false ;;
                     *) echo -e "${LRED}Invalid Selection${NONE}. RE-Answer this."; shut_my_mouth JK "$ST" ;;
                esac
#           elif [[ $(tac ${ANDROID_BUILD_TOP}/build/core/build_id.mk | grep -c 'BUILD_ID=N') == "1" ]]; then
#               ST="Wanna use Ninja Toolchain ? [y/n]";
#               shut_my_mouth NJ "$ST";
#               case "$DMNJ" in
#                   n) export ANDROID_COMPILE_WITH_NINJA=false ;; # ??? WiP - When Builds start, It'll get Edited
#                   y) export ANDROID_COMPILE_WITH_NINJA=true ;;  # ???
#               esac
            fi
            case "$DMCL" in
                1)
                    # Temporarily lunching the Device for installclean to work
                    lunch ${ROMNIS}_${DMDEV}-${DMBT};
                    $DMMK installclean;
                ;;
                2) $DMMK clean ;;
                *) echo -e "${LRED}Invalid Selection.${NONE} Going Back.";;
            esac
            hotel_menu; # Launches Build Only For Brunchers.
            build_make "$DMSLT"; # Launch Build. For Non-Brunchers
        ;;
    2)
        make_module;
    ;;
    3)
        echo -e "Two Steps. Select one of them (If seeing this for first time - ${LCYAN}Enter${NONE} A)";
        echo -e "\tA. Enabling CCACHE Variables in .bashrc or it's equivalent";
        echo -e "\tB. Reserving Space for CCACHE\n";
        read CCOPT;
        case "$CCOPT" in
             "A") set_ccvars ;;
             "B") set_ccache ;;
               *) echo -e "\n${LRED}Invalid Selection.${NONE} Going back."; build ;;
        esac
    ;;
    *)
        echo -e "${LRED}Invalid Selection.${NONE} Going back.";
        build;
    ;;
    esac
} # build

teh_action ()
{
    case "$1" in
    1)
        if [ ! -f PREF.rc ]; then init; fi;
        echo -ne '\033]0;ScriBt : Init\007';
    ;;
    2)
        if [ ! -f PREF.rc ]; then sync; fi;
        echo -ne "\033]0;ScriBt : Syncing ${ROM_FN}\007";
    ;;
    3)
        if [ ! -f PREF.rc ]; then pre_build; fi;
        echo -ne '\033]0;ScriBt : Pre-Build\007';
    ;;
    4)
        if [ ! -f PREF.rc ]; then build; fi;
        echo -ne "\033]0;ScriBt : Building ${ROM_FN}\007";
    ;;
    5)
        if [ ! -f PREF.rc ]; then installdeps; fi;
        echo -ne '\033]0;ScriBt : Installing Dependencies\007';
    ;;
    6)
        if [ ! -f PREF.rc ]; then exitScriBt; fi;
        case "$2" in
            "COOL") echo -ne "\033]0;${ROM_FN} : Success\007" ;;
            "FAIL") echo -ne "\033]0;${ROM_FN} : Fail\007" ;;
        esac
    ;;
    *)
        echo -e "\n${LRED}Invalid Selection.${NONE} Going back.\n";
        case "$2" in
            "qm") quick_menu ;;
            "mm") main_menu ;;
        esac
    ;;
    esac
} # teh_action

function the_start
{
    # Create a Text file to Store Intermediate Outputs for Working on Some Commands
    TMP=temp.txt; # temp
    RTMP=repo_log.txt; # repo sync logs
    RMTMP=rom_compile.txt; # rom build Logs
    rm -rf ${TMP} ${RTMP} ${RMTMP};
    touch ${TMP} ${RTMP} ${RMTMP};
    # Load the Basic Variables
    if [ -f "${PWD}/ROM.rc" ]; then
        . $(pwd)/ROM.rc;
    else
        echo "${LRED}ROM.rc isn't present in ${PWD}${NONE}, please make sure repo is cloned correctly";
        exit 1;
    fi
    #CHEAT CHEAT CHEAT!
    if [ -f PREF.rc ]; then
        . $(pwd)/PREF.rc
        collector; # Get all Information!
        echo -e "\n${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Cheat Code shut_my_mouth applied. I won't ask questions anymore\n";
    else
        echo -e "Using this for first time?\nDon't lose patience the next time. Take a look on PREF.rc and shut_my_mouth\n";
    fi
    echo -e "\n=======================================================";
    echo -e "Before I can start, do you like a \033[1;31mC\033[0m\033[0;32mo\033[0m\033[0;33ml\033[0m\033[0;34mo\033[0m\033[0;36mr\033[0m\033[1;33mf\033[0m\033[1;32mu\033[0m\033[0;31ml\033[0m life? [y/n]";
    echo -e "=======================================================\n";
    if [ -f PREF.rc ]; then
        echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Coloured ScriBt : $COLOR "
    else
        read COLOR;
    fi
    echo;
    if [[ "$COLOR" == "y" ]]; then
        color_my_life;
        echo -e "Coloring ScriBt and AutoBot";
    else
        i_like_colourless;
    fi
    echo -e "\n${LBLU}Prompting for Root Access...${NONE}\n";
    sudo echo -e "\n${LGRN}Root access OK. You won't be asked again${NONE}";
    apt_check;
    sleep 3;
    clear;
    echo -ne '\033]0;ScriBt\007';
    echo -e "\n\n                 ${LRED}╔═╗${NONE}${YELO}╦═╗${NONE}${LCYAN}╔═╗${NONE}${LGRN} ╦${NONE}${LCYAN}╔═╗${NONE}${YELO}╦╔═${NONE}${LRED}╔╦╗${NONE}";
    echo -e "                 ${LRED}╠═╝${NONE}${YELO}╠╦╝${NONE}${LCYAN}║ ║${NONE}${LGRN} ║${NONE}${LCYAN}║╣ ${NONE}${YELO}╠╩╗${NONE}${LRED} ║ ${NONE}";
    echo -e "                 ${LRED}╩  ${NONE}${YELO}╩╚═${NONE}${LCYAN}╚═╝${NONE}${LGRN}╚╝${NONE}${LCYAN}╚═╝${NONE}${YELO}╩ ╩${NONE}${LRED} ╩${NONE}";
    echo -e "      ${LRED}███████${NONE}${RED}╗${NONE} ${LRED}██████${NONE}${RED}╗${NONE}${LRED}██████${NONE}${RED}╗${NONE} ${LRED}██${NONE}${RED}╗${NONE}${LRED}██████${NONE}${RED}╗${NONE} ${LRED}████████${NONE}${RED}╗${NONE}";
    echo -e "      ${LRED}██${NONE}${RED}╔════╝${NONE}${LRED}██${NONE}${RED}╔════╝${NONE}${LRED}██${NONE}${RED}╔══${NONE}${LRED}██${NONE}${RED}╗${NONE}${LRED}██${NONE}${RED}║${NONE}${LRED}██${NONE}${RED}╔══${NONE}${LRED}██${NONE}${RED}╗╚══${NONE}${LRED}██${NONE}${RED}╔══╝${NONE}";
    echo -e "      ${LRED}███████${NONE}${RED}╗${NONE}${LRED}██${NONE}${RED}║${NONE}     ${LRED}██████${NONE}${RED}╔╝${NONE}${LRED}██${NONE}${RED}║${NONE}${LRED}██████${NONE}${RED}╔╝${NONE}   ${LRED}██${NONE}${RED}║${NONE}";
    echo -e "      ${RED}╚════${NONE}$LRED██${NONE}${RED}║${NONE}${LRED}██${NONE}${RED}║${NONE}     ${LRED}██${NONE}${RED}╔══${NONE}${LRED}██${NONE}${RED}╗${NONE}${LRED}██${NONE}${RED}║${NONE}${LRED}██${NONE}${RED}╔══${NONE}${LRED}██${NONE}${RED}╗${NONE}   ${LRED}██${NONE}${RED}║${NONE}";
    echo -e "      ${LRED}███████${NONE}${RED}║╚${NONE}${LRED}██████${NONE}${RED}╗${NONE}${LRED}██${NONE}${RED}║${NONE}  ${LRED}██${NONE}${RED}║${NONE}${LRED}██${NONE}${RED}║${NONE}${LRED}██████${NONE}${RED}╔╝${NONE}   ${LRED}██${NONE}${RED}║${NONE}";
    echo -e "      ${RED}╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═════╝    ╚═╝${NONE}\n";
    sleep 1;
    echo -e "${LCYAN}~#~#~#~#~#~#~#~#~#${NONE} ${LRED}By Arvind7352${NONE} - ${YELO}XDA${NONE} ${LCYAN}#~#~#~#~#~#~#~#~${NONE}\n\n";
    sleep 3;
} # the_start

# All above parts are Functions - Line of Execution will start after these two lines
# START IT --- VROOM!
the_start; # Pre-Initial Stage
if [[ "$1" == "automate" ]]; then
    . $(pwd)/PREF.rc
    echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Thanks for Selecting Me. Lem'me do your work";
    automate; # Initiate the Build Sequence - Actual "VROOM"!
else
    main_menu;
fi
