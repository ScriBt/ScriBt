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
        echo -e "${LRED}Alright, apt detected.${NONE}";
    else
        echo -e "Apt configuration has not been found. A Debian/Ubuntu based Distribution is required to run ScriBt.";
        exit 1;
    fi
} # apt_check

function enter_the_root
{
    echo -e "Provide ${LRED}Root${LRED} access to ScriBt. No Hacks Honestly ${LGRN}(Check the Code)${NONE}\n";
    sudo -i;
    if [[ $(whoami) == "root" ]]; then
        echo -e "${LGRN}Root access OK.${NONE} Performing Changes.";
    else
        echo -e "No Root Access, Abort.";
        main_menu;
    fi
} # enter_the_root

function me_quit_root
{
    echo -e "Giving up Mah ${LRED}Powerz!${NONE}\n";
    exit;
    echo -e "Peace.";
} # me_quit_root

function exitScriBt
{
    echo -e "\n\nThanks for using ${LRED}S${NONE}cri${GRN}B${NONE}t. Have a Nice Day\n\n";
    sleep 2;
    echo -e "${LRED}Bye!${NONE}";
    exit 0;
} # exitScriBt

the_response ()
{
    if [[ "$1" == "COOL" ]]; then
        echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Automated $2 ${LGRN}Successful! :)${NONE}"
    elif [[ "$1" == "FAIL" ]]; then
        echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Automated $2 ${LRED}Failed :(${NONE}"
    fi
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
        enter_the_root;
        echo -e "${BLU}================================================================${NONE}\n";
        update-alternatives --config java;
        echo -e "\n${BLU}================================================================${NONE}\n";
        update-alternatives --config javac;
        echo -e "\n${BLU}================================================================${NONE}";
        me_quit_root;
    } # java_select

    java ()
    {
        echo -ne "\033]0;ScriBt : Java $1\007";
        echo -e "Installing OpenJDK-$1 (Java 1.$1.0)";
        echo -e "${LRED}Remove${NONE} other Versions of Java ${LGRN}[y/n]${NONE}? ( Removing them is Recommended)\n";
        read REMOJA;
        echo;
        enter_the_root;
        case "$REMOJA" in
            "y")
                apt-get purge openjdk-* icedtea-* icedtea6-*;
                echo -e "\nRemoved Other Versions successfully" ;;
            "n")
                echo -e "Keeping them Intact" ;;
            *)
                echo -e "${LRED}Invalid Selection.${NONE} RE-Answer it."
                java $1; 
            ;;
            esac
        echo -e "${RED}==========================================================${NONE}\n";
        ap-get update;
        echo -e "\n${RED}==========================================================${NONE}\n";
        apt-get install openjdk-$1-jdk;
        me_quit_root;
        echo -e "\n${RED}==========================================================${NONE}";
        if [[ $( java -version &> $TMP && grep -c "java version \"1.$1" $TMP ) == "1" ]]; then
            echo -e "OpenJDK-$1 or Java 1.$1.0 has been successfully installed";
            echo -e "${RED}==========================================================${NONE}";
        fi
    } # java

    enter_the_root;
    echo -e "${RED}==========================================================${NONE}\n";
    echo -e "Installing Build Dependencies...\n";
apt-get install git-core gnupg ccache lzop flex bison \
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
    curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules;
    chmod a+r /etc/udev/rules.d/51-android.rules;
    service udev restart;
    echo;
    me_quit_root;

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
                        echo -e "\n${LRED}Invalid Selection${NONE}. Going back\n"
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
}

function sync
{
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

function init
{
    if [ -f PREF.rc ]; then teh_action 1; fi;
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
17.${LRED} Resurrection Remix ${NONE}
18.${LBLU} SlimRoms ${NONE}
19.${LRED} Temasek ${NONE}
20.${LBLU} GZR Tesla ${NONE}
21.${YELO} Tipsy OS ${NONE}
22.${LPURP} GZR Validus ${NONE}
23.${LCYAN} XenonHD by Team Horizon ${NONE}
24.${LBLU} Xperia Open Source Project aka XOSP ${NONE}

${LPURP}=======================================================${NONE}\n";
    if [ ! -f PREF.rc ]; then
        read ROMN;
        export ROMNO=$ROMN; # Only for Manual Usage
    fi
    #
    rom_names $ROMNO;
    #
    echo -e "\nYou have chosen ${LCYAN}->${NONE} $ROM_FN\n";
    sleep 1;
    echo -e "Since Branches may live or die at any moment, ${LRED}Specify the Branch${NONE} you're going to sync\n";
    ST="${LRED}Branch${NONE}";
    shut_my_mouth BR "$ST";
    echo -e "Any ${LRED}Source you have already synced?${NONE} ${LGRN}[YES/NO]${NONE}\n"; gimme_info "refer";
    shut_my_mouth RF "$ST";
    if [[ "$DMRF" == YES ]]; then
        echo -e "\nProvide me the ${LRED}Synced Source's Location${NONE} from ${LRED}/${NONE} \n";
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
        echo -e "Repo Binary Installed\n";
        echo "Adding ~/bin to PATH\n";
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
    #Start Sync now
    sync;
} # init

function pre_build
{
    if [ -f PREF.rc ]; then teh_action 3; fi;
    echo -e "${CYAN}Initializing Build Environment${NONE}\n";
    . build/envsetup.sh;
    echo -e "\n${LPURP}Done.${NONE}.\n\n";
    echo -e "${LCYAN}====================== DEVICE INFO ======================${NONE}\n";
    echo -e "What's your ${LRED}Device's CodeName${NONE} ${LGRN}[Refer Device Tree - All Lowercases]${NONE}?\n";
    ST="Your Device ${LRED}Name${NONE} is";
    shut_my_mouth DEV "$ST";
    echo -e "The ${LRED}Build type${NONE}? ${LGRN}[userdebug/user/eng]${NONE}\n";
    ST="Build ${LRED}type${NONE}";
    shut_my_mouth BT "$ST";
    echo -e "Your ${LRED}Device's Company/Vendor${NONE} ${LGRN}(All Lowercases)${NONE}?\n";
    ST="Device's ${LRED}Vendor${NONE}";
    shut_my_mouth CM "$ST";
    echo -e "${LCYAN}=========================================================${NONE}\n\n";
    rom_names $ROMNO;

    function vendor_strat_all
    {
        if  [[ "$ROMNO" == "3" || "$ROMNO" == "4" || "$ROMNO" == "10" ]]; then
            cd vendor/${ROMV};
        else
            cd vendor/${ROMNIS};
        fi
        echo -e "${LPURP}=========================================================${NONE}\n";
        if [ -f ${ROMNIS}.devices ]; then
            echo -e "Adding your Device to ROM Vendor ${LGRN}(Strategy 1)${NONE}\n";
            if [[ $(grep -c '${DMDEV}' ${ROMNIS}.devices) == "0" ]]; then
                echo "${DMDEV}" >> ${ROMNIS}.devices;
            else
                echo -e "Device was already added to ${ROMNIS} vendor";
            fi
        elif [ -f ${ROMNIS}-device-targets ]; then
            echo -e "Adding your Device to ROM Vendor ${LGRN}(Strategy 4)${NONE}\n";
            if [[ $(grep -c '${DMDEV}' ${ROMNIS}-device-targets) == "0" ]]; then
                echo -e "${ROMNIS}_${DMDEV}-${DMBT}" >> ${ROMNIS}-device-targets;
            else
                echo -e "Device was already added to ${ROM_FN} vendor";
            fi
        elif [ -f vendorsetup.sh ]; then
            echo -e "Adding your Device to ROM Vendor ${LGRN}(Strategy 2)${NONE}\n";
            if [[ $(grep -c '${DMDEV}' vendorsetup.sh) == "0" ]]; then
                echo "add_lunch_combo ${ROMNIS}_${DMDEV}-${DMBT}" >> vendorsetup.sh;
            else
                echo -e "Device was already added to ${ROMNIS} vendor";
            fi
        else
            croot;
            echo "Adding your Device to ROM Vendor ${LGRN}(Strategy 3)${NONE}\n";
            echo -e "Let's go to teh ${LRED}Device Directory!${NONE}\n";
            cd device/${DMCM}/${DMDEV};
            echo -e "Creating vendorsetup.sh if absent in tree";
                if [ ! -f vendorsetup.sh ]; then
                    touch vendorsetup.sh;
                    echo -e "Done [1/2]";
                fi
                if [[ $(grep -c '${ROMNIS}_${DMDEV}' vendorsetup.sh ) == "0" ]]; then
                    echo -e "add_lunch_combo ${ROMNIS}_${DMDEV}-${DMBT}" >> vendorsetup.sh;
                else
                    echo -e "Device already added to vendorsetup.sh\n";
                fi
        fi
        echo -e "${LGRN}DONE!${NONE}!";
        croot;
        echo -e "${LPURP}=========================================================${NONE}";
    } # vendor_strat

    function vendor_strat_kpa #for ROMs having products folder
    {
        croot;
        cd vendor/${ROMNIS}/products;
        # SHUT_MY_MOUTH
        if [ ! -f PREF.rc ]; then
            if [[ "$ROMNIS" == "pac" || "$ROMNIS" == "krexus" ]]; then
                THE_FILE=${ROMNIS}_${DMDEV}.mk;
            else
                #AOKP
                THE_FILE=${DMDEV}.mk;
                echo -e '\n' >> AndroidProducts.mk;
                echo "PRODUCT_MAKEFILES := \ " >> AndroidProducts.mk;
                echo -e "\t$(LOCAL_DIR)/${DMDEV}.mk" >> AndroidProducts.mk;
            fi
        else
            echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Device-Vendor Conjunction File : ${THE_FILE}";
        fi
        #Create Device-Vendor Conjuctor
        touch ${THE_FILE};
        echo -e "Name your Device Specific Configuration File ( eg. ${ROMNIS}.mk / full_${DMDEV}.mk as in your device tree)\n";
        ST="Device Configuration file";
        shut_my_mouth DCON "$ST";
        echo -e "\$(call inherit-product, device/${DMCM}/${DMDEV}/${DMDCON})" >> ${THE_FILE};
        echo -e "Specify your Device's Resolution in the format ${LCYAN}HORIZONTAL${NONE}${LRED}x${NONE}${LCYAN}VERTICAL${NONE} (eg. 1280x720)";
        if [ ! -f PREF.rc ]; then
            echo -e "Among these Values - Select the one which is nearest or almost Equal to that of your Device\n";
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
${LPURP}2560${NONE}x1600\n";
            echo -e "Type only the First (Highlighted in ${LPURP}Purple${NONE}) Number (eg. if 720x1280 then type in 720)";
            read BOOTRES;
        else
            echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Resolution Choosed : ${BOOTRES}";
        fi
        #Vendor-Calls
        case "$ROMNIS" in
        "krexus")
            echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/common.mk)" >> ${THE_FILE};
            echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/vendorless.mk)" >> ${THE_FILE}; 
            ;;
        "pac")
            echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/pac_common.mk)" >> ${THE_FILE};
            echo "PAC_BOOTANIMATION_NAME := ${BOOTRES};" >> ${THE_FILE}; 
            ;;
        "aokp")
            # Boot animation
            echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> ${THE_FILE};
            echo "PRODUCT_COPY_FILES += \ " >> ${THE_FILE};
            echo -e "\tvendor/aokp/prebuilt/bootanimation/bootanimation_${BOOTRES}.zip:system/media/bootanimation.zip" >> ${THE_FILE};
            ;;
        esac
        #PRODUCT_NAME is the only ROM-dependent variable, setting it here is better.
        echo "PRODUCT_NAME := ${ROMNIS}_${DMDEV}" >> ${THE_FILE};
    } # vendor_strat_kpa

    if [ -f vendor/${ROMNIS}/products ]; then
        if [ ! -f vendor/${ROMNIS}/products/${ROMNIS}_${DMDEV}.mk || ! -f vendor/${ROMNIS}/products/${DMDEV}.mk ]; then
            vendor_strat_kpa; #if found products folder
        else
            echo -e "Looks like ${DMDEV} has been already added to ${ROM_FN} vendor. Good to go\n";
        fi
    else
        vendor_strat_all; #if not found
    fi
        croot;
    if [ ! -f PREF.rc ]; then
        echo -e "${PURP}=========================================================${NONE}\n";
        if  [[ "$ROMNO" == "3" || "$ROMNO" == "4" || "$ROMNO" == "10" ]]; then
            echo -e "Now, ${ROMV}ify your Device Tree. Press ${LCYAN}Enter${NONE}, when ${LGRN}done${NONE}\n";
        else
            echo -e "Now, ${ROMNIS}-(i)-fy your Device Tree. Press ${LCYAN}Enter${NONE}, when ${LGRN}done${NONE}\n";
        fi
        echo -e "${PURP}=========================================================${NONE}";
        read ENTER;
        quick_menu;
    else
    the_response COOL Pre-Build;
    fi
} # pre_build

function build
{
    if [ -f PREF.rc ]; then teh_action 4; fi;

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
        rootcheck;
        echo -e "\nCCACHE Size must be ${LRED}>50 GB${NONE}.\n Think about it and Specify the Size (Number) for Reservation of CCACHE (in GB)\n";
        read CCSIZE;
        echo -e "Create a New Folder for CCACHE and Specify it's location from / here\n";
        read CCDIR;
        if [ -f ${HOME}/.bashrc ]; then
                echo "export USE_CCACHE=1" >> ${HOME}/.bashrc;
                echo "export CCACHE_DIR=${CCDIR}" >> ${HOME}/.bashrc;
                . ${HOME}/.bashrc;
        elif [ -f ${HOME}/.profile ]; then
            echo "export USE_CCACHE=1" >> ${HOME}/.profile;
            echo "export CCACHE_DIR=${CCDIR}" >> ${HOME}/.profile;
            . ${HOME}/.profile;
#        elif [[ $( -f SOME_FILE )]]; then
#            echo "export USE_CCACHE=1" >> /SOME_LOC/SOME_FILE;
#            echo "export CCACHE_DIR=${CCDIR}" >> /SOME_LOC/SOME_FILE;
#            echo "Restart your PC and Select Step 'B'";
        else
            echo -e "Strategies failed. If you have knowledge of finding .bashrc's equivalent in your Distro, then Paste these lines at the end of the File";
            echo -en "export USE_CCACHE=1";
            echo -en "export CCACHE_DIR=${CCDIR}";
            echo -e "Now Log-Out and Re-Login. Select Step B. The Changes will be considered after that.";
            echo -e "Alternatively run . ~/.profile";
            sleep 2;
            exitScriBt;
        fi
        me_quit_root;
        echo;
        set_ccache;
    } # set_ccvars

    function build_make
    {
        start=$(date +"%s");
        echo -e "${LGRN}Starting Compilation - ${ROM_FN} for ${DMDEV}${NONE}";
        # For Brunchers
        if [[ "$DMSLT" == "brunch" ]]; then
            clean_build;
            ${DMSLT} ${DMDEV};
        else
            # For Mka-s/Make-rs
            case "$DMMK" in
                "make") BCORES=$(grep -c ^processor /proc/cpuinfo) ;;
                *) BCORES="" ;;
            esac
            if [[ "$ROMNIS" == "tipsy" || "$ROMNIS" == "validus" || "$ROMNIS" == "tesla" ]]; then
                $DMMK $ROMNIS $BCORES 2>&1 | tee $RMTMP;
            elif [[ $(grep -q "^bacon:" "${ANDROID_BUILD_TOP}/build/core/Makefile") ]]; then
                $DMMK bacon $BCORES 2>&1 | tee $RMTMP;
            else
                $DMMK otapackage $BCORES 2>&1 | tee $RMTMP;
            fi
            echo;
            post_build;
        fi
        end=$(date +"%s");
        sec=$(($end - $start));
        echo -e "${YELO}Build took $(($sec / 3600)) hour(s), $(($sec / 60 % 60)) minute(s) and $(($sec % 60)) second(s).${NONE}" | tee -a rom_compile.txt;
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
            "breakfast") ${DMSLT} ${DMDEV} ;;
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
    
    if [[ "$ERR" == "0" ]]; then build_menu; fi;
    
    case "$DMBO" in
        1)
            hotel_menu;
            echo -e "\nShould i use '${YELO}make${NONE}' or '${RED}mka${NONE}' ?"
            ST="Selected Method";
            shut_my_mouth MK "$ST";
            echo -e "Wanna Clean the ${LPURP}/out${NONE} before Building? ${LGRN}[1 - Remove Staging / 2 - Full Clean]${NONE}\n"
            ST="Option Selected";
            shut_my_mouth CL "$ST";
            case "$DMCL" in 
                1) $DMMK installclean ;;
                2) $DMMK clean ;;
                *) echo -e "${LRED}Invalid Selection.${NONE} Going Back."; ERR="1"; build_menu ;;
            esac
            echo;
            if [[ $(tac ${ANDROID_BUILD_TOP}/build/core/build_id.mk | grep -c 'BUILD_ID=M') == "1" ]]; then
                echo -e "Wanna use ${LRED}Jack Toolchain${NONE} ? ${LGRN}[y/n]${NONE}";
                ST="Use ${LRED}Jacky${NONE}";
                shut_my_mouth JK "$ST";
                case "$USEJK" in
                     "y")export ANDROID_COMPILE_WITH_JACK=true ;;
                     "n")export ANDROID_COMPILE_WITH_JACK=false ;;
                     *) echo -e "${LRED}Invalid Selection${NONE}. RE-Answer this."; shut_my_mouth JK "$ST" ;;
                esac
#           elif [[ $(tac ${ANDROID_BUILD_TOP}/build/core/build_id.mk | grep -c 'BUILD_ID=N') == "1" ]]; then
#               ST="Wanna use Ninja Toolchain ? [y/n]";
#               shut_my_mouth NJ "$ST";
#               if [[ "$DMNJ" == n ]]; then
#                  export ANDROID_COMPILE_WITH_NINJA=false; # ??? WiP - When Builds start, It'll get Edited
#               else
#                  export ANDROID_COMPILE_WITH_NINJA=true;  # ???
#               fi
            fi
             build_make; #Start teh Build!
        ;;
    2)
        make_module;
    ;;
    3)
        echo -e "Two Steps. Select one of them (If seeing this for first time - ${LCYAN}Enter${NONE} A)";
        echo -e "\tA. Enabling CCACHE Variables in .bashrc or it's equivalent"
        echo -e "\tB. Reserving Space for CCACHE\n";
        read CCOPT;
        case "$CCOPT" in
             "A") set_ccvars ;;
             "B") set_ccache ;;
               *) echo -e "\n${LRED}Invalid Selection.${NONE} Going back."; build ;;
        esac
    ;;   
    *)
        echo -e "${LRED}Invalid Selection.${NONE} Going back."
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
    touch ${RTMP} ${RMTMP} ${TMP};
    # Load the Basic Variables
    if [ -f "${PWD}/ROM.rc" ]; then
        . $(pwd)/ROM.rc;
    else
        echo "ROM.rc isn't present in ${PWD}, please make sure repo is cloned correctly";
        exit 1;
    fi
    #CHEAT CHEAT CHEAT!
    if [ -f PREF.rc ]; then
        . $(pwd)/PREF.rc
        collector; # Get all Information!
        echo -e "\n${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Cheat Code SHUT_MY_MOUTH applied. I won't ask questions anymore\n";
    else
        echo -e "Using this for first time?\nDon't lose patience the next time. ${LCYAN}Enter${NONE} your Values in PREF.rc and Shut my Mouth! lol\n";
        echo -e "PREF.rc is the file"
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
    sleep 2;
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
    sleep 5;
} # the_start

# All above parts are Functions - Line of Execution will start after these two lines
#START IT --- VROOM!
the_start; # Pre-Initial Stage
apt_check;
if [[ "$1" == "automate" ]]; then
    . $(pwd)/PREF.rc
    echo -e "${RED}*${NONE}${LPURP}AutoBot${NONE}${RED}*${NONE} Thanks for Selecting Me. Lem'me do your work";
    automate; # Initiate the Build Sequence - Actual "VROOM"!
else
    main_menu;
fi
