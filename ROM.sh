#!/bin/bash
#========================< Projekt ScriBt >============================#
#===========< Copyright 2016, Arvindraj Thangaraj - "a7r3" >===========#
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
# https://github.com/a7r3/ScriBt - I live here                         #
#                                                                      #
# Feel free to enter your modifications and submit it to me with       #
# a Pull Request, such Contributions are WELCOME                       #
#                                                                      #
# Contributors:                                                        #
# Arvindraj "a7r3" (Myself)                                            #
# Adrian DC "AdrianDC"                                                 #
# Akhil Narang "akhilnarang"                                           #
# Tom Radtke "CubeDev"                                                 #
# nosedive                                                             #
#======================================================================#

function cherrypick() # Automated Use only
{
    echo -ne '\033]0;ScriBt : Picking Cherries\007';
    echo -e "${CL_WYT}=======================${NONE} ${CL_LRD}Pick those Cherries${NONE} ${CL_WYT}======================${NONE}\n";
    echo -e "${EXE} ${ATBT} Attempting to Cherry-Pick Provided Commits\n";
    git fetch ${URL/\/tree\// };
    git cherry-pick $1;
    echo -e "\n${INF} It's possible that the pick may have conflicts. Solve those and then continue.";
    echo -e "${CL_WYT}==================================================================${NONE}";
} # cherrypick

function exitScriBt() # ID
{
    function prefGen()
    {
        echo -e "\n\n${EXE} Deleting old Configs...";
        sed -e '/SB.*/d' -e '/function configs()/d' -e '/{ # as on.*/d' -e '/} # configs/d' -i PREF.rc;
        echo -e "\n${EXE} Saving Current Configuration to PREF.rc...";
        (set -o posix; set) > ${TV2};
        echo -e "function configs()\n{ # as on $DNT" >> PREF.rc
        diff ${TV1} ${TV2} | grep SB | sed -e 's/[<>] /    /g' | awk '{print $0";"}' >> PREF.rc;
        echo -e "} # configs" >> PREF.rc;
        echo -e "\n${SCS} PREF.rc for the current Configuration created successfully\nYou may automate ScriBt next time...";
    } # prefGen

    [[ "$RQ_PGN" == [Yy] ]] && prefGen;
    echo -e "\n\n${SCS} Thanks for using ScriBt.\n\n";
    [[ "$1" == "0" ]] && echo -e "${CL_LGN}[${NONE}${CL_LRD}<3${NONE}${CL_LGN}]${NONE} Peace! :)" || echo -e "${CL_LRD}[${NONE}${CL_RED}<${NONE}${CL_LGR}/${NONE}${CL_RED}3${NONE}${CL_LRD}]${NONE} Failed somewhere :(";
    exit $1;
} # exitScriBt

function main_menu()
{
    echo -ne '\033]0;ScriBt : Main Menu\007';
    echo -e "${CL_WYT}===================${NONE}${SCS} ${CL_LBL}Main Menu${NONE} ${SCS}${CL_WYT}===================${NONE}\n";
    echo -e "1                 Choose ROM & Init*                  1";
    echo -e "2                       Sync                          2";
    echo -e "3                     Pre-Build                       3";
    echo -e "4                       Build                         4";
    echo -e "5                   Various Tools                     5\n";
    echo -e "6                        EXIT                         6\n";
    echo -e "* - Sync will Automatically Start after Init'ing Repo";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    echo -e "\n${QN} Select the Option you want to start with : \c";
    read ACTION;
    teh_action $ACTION "mm";
} # main_menu

function pkgmgr_check() # ID
{
    if which apt &> /dev/null; then
        echo -e "\n${SCS} Package manager apt detected.\033[0m\n";
        PKGMGR="apt";
    elif which pacman &> /dev/null; then
        echo -e "\n${SCS} Package manager pacman detected.\033[0m\n";
        PKGMGR="pacman";
    else
        echo -e "\n${FLD} No supported package manager has been found.";
        echo -e "\n${INF} Arch Linux or a Debian/Ubuntu based Distribution is required to run ScriBt.";
    exitScriBt 1;
    fi
} # pkgmgr_check

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

function rom_select() # D 1,2
{
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    echo -e "${CL_YEL}[?]${NONE} ${CL_WYT}Which ROM are you trying to build\nChoose among these (Number Selection)\n";
    for RNO in {1..30}; do
        rom_names $RNO;
        echo -e "$RNO. $ROM_FN";
    done
    echo -e "\n=======================================================${NONE}\n";
    [ -z "$automate" ] && read -p $'\033[1;36m[>]\033[0m ' SBRN;
    rom_names "$SBRN";
    echo -e "\n${INF} You have chosen -> ${ROM_FN}\n";
} # rom_select

function shut_my_mouth() # ID
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

function set_ccache() # D set_ccvars
{
    echo -e "\n${EXE} Setting up CCACHE\n";
    ccache -M ${CCSIZE}G;
    echo -e "\n${SCS} CCACHE Setup Successful.\n";
} # set_ccache

function set_ccvars() # D 4,5
{
    echo -e "${INF} \nCCACHE Size must be >50 GB.\n Specify the Size (Number) for Reservation of CCACHE (in GB) : \n";
    read -p $'\033[1;36m[>]\033[0m ' CCSIZE;
    echo -e "${INF} Create a New Folder for CCACHE and Specify it's location from / : \n";
    read -p $'\033[1;36m[>]\033[0m ' CCDIR;
    for RC in .bashrc .profile; do
        if [ -f ${HOME}/${RC} ] && [[ $(grep -c 'USE_CCACHE\|CCACHE_DIR') != "1" ]]; then
            echo -e "export USE_CCACHE=1\nexport CCACHE_DIR=${CCDIR}" >> ${HOME}/${RC};
            . ${HOME}/${RC};
        fi
    done
    set_ccache;
} # set_ccvars

function tranScriBt() # ID
{
    function transIt()
    {
        echo -e "${EXE} Transferring ScriBt to the Specified Directory\n";
        for FILE in `ls`; do
            cp -rf ${FILE} $1/${FILE};
        done
        echo -e "${SCS} Successfully Transferred\n";
        sleep 2;
        echo -e "${EXE} Starting ScriBt in $1\n";
        sleep 0.5;
        echo -e "${CL_WYT}===============================================${NONE}\n";
        cd $1;
        exec bash ROM.sh $2;
    } # transIt

    echo -e "${EXE} Checking Directory Existence\n";
    if [ ! -f $1 ]; then
        echo -e "${FLD} Directory does not exist\n";
        echo -e "${EXE} Trying to create directory\n";
        TDIR=`mkdir $1 | echo "$?"`;
        if [[ "$TDIR" == 0 ]]; then
            echo -e "${SCS} Directory created\n";
            transIt $1 $2;
        else
            echo -e "${FLD} Invalid Directory specified\n";
            exitScriBt 1;
        fi
    else
        echo -e "${SCS} Directory Exists\n";
        transIt $1 $2;
    fi
} # tranScriBt

function the_response() # D ALL
{
    case "$1" in
        "COOL") echo -e "\n${SCS} ${ATBT} Automated $2 Successful! :)" ;;
        "FAIL") echo -e "\n${FLD} ${ATBT} Automated $2 Failed :(" ;;
    esac
} # the_response

function init() # 1
{
    [ ! -z "$automate" ] && teh_action 1;
    rom_select;
    sleep 1;
    echo -e "${EXE} Detecting Available Branches in ${ROM_FN} Repository...";
    RCT=$[ ${#ROM_NAME[*]} - 1 ];
    for RC in `eval echo "{0..$RCT}"`; do
        echo -e "\nOn ${ROM_NAME[$RC]} (ID->$RC)...\n";
        git ls-remote -h https://github.com/${ROM_NAME[$RC]}/${MAN[$RC]} |\
            awk '{print $2}' | awk -F "/" '{if (length($4) != 0) {print $3"/"$4} else {print $3}}';
    done
    echo -e "\n${INF} These Branches are available at the moment\n${QN} Specify the ID and Branch you're going to sync\n${INF} Format : [ID] [BRANCH]\n";
    ST="Branch"; shut_my_mouth NBR "$ST";
    RC=`echo "$SBNBR" | awk '{print $1}'`; SBBR=`echo "$SBNBR" | awk '{print $2}'`;
    MNF=`echo "${MAN[$RC]}"`;
    RNM=`echo "${ROM_NAME[$RC]}"`;
    echo -e "${QN} Any Source you have already synced ${CL_WYT}[y/n]${NONE}\n"; gimme_info "refer";
    ST="Use Reference Source"; shut_my_mouth RF "$ST";
    if [[ "$SBRF" == [Yy] ]]; then
        echo -e "\n${QN} Provide me the Synced Source's Location from /\n";
        ST="Reference Location"; shut_my_mouth RFL "$ST";
        REF=--reference\=\"${SBRFL}\";
    else
        REF=" ";
    fi
    echo -e "${QN} Set clone-depth ${CL_WYT}[y/n]${NONE}\n"; gimme_info "cldp";
    ST="Use clone-depth"; shut_my_mouth CD "$ST";
    if [[ "$SBCD" == [Yy] ]]; then
        echo -e "${QN} Depth Value [1]\n";
        ST="clone-depth Value"; shut_my_mouth DEP "$ST";
        [ -z "$SBDEP" ] && SBDEP=1;
        CDP=--depth\=\"${SBDEP}\";
    fi
    # Check for Presence of Repo Binary
    if [[ ! $(which repo) ]]; then
        echo -e "${EXE} Looks like the Repo binary isn't installed. Let's Install it.\n";
        [ ! -d "${HOME}/bin" ] && mkdir -p ${HOME}/bin;
        curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo;
        chmod a+x ~/bin/repo;
        echo -e "${SCS} Repo Binary Installed\n${EXE} Adding ~/bin to PATH\n";
        echo -e "# set PATH so it includes user's private bin if it exists" >> ~/.profile;
        echo -e "if [ -d \"\$HOME/bin\" ] ; then" >> ~/.profile;
        echo -e "\tPATH=\"\$HOME/bin:\$PATH\" "; >> ~/.profile;
        echo -e "fi"; >> ~/.profile;
        . ~/.profile;
        echo -e "${SCS} Done. Ready to Init Repo.\n";
    fi
    echo -e "${CL_WYT}=========================================================${NONE}\n";
    echo -e "${EXE} Initializing the ROM Repo\n";
    repo init ${REF} ${CDP} -u https://github.com/${RNM}/${MNF} -b ${SBBR};
    echo -e "\n${SCS} ${ROM_NAME[$RC]} Repo Initialized\n";
    echo -e "${CL_WYT}=========================================================${NONE}\n";
    mkdir .repo/local_manifests;
    if [ -z "$automate" ]; then
        echo -e "${INF} A folder \"local_manifests\" has been created for you.";
        echo -e "${INF} Create a Device Specific manifest and Press ENTER to start sync\n";
        read ENTER;
        echo;
    fi
    export action_1="init";
    sync;
} # init

function sync() # 2
{
    [ ! -z "$automate" ] && teh_action 2;
    if [ ! -f .repo/manifest.xml ]; then init; elif [ -z "$action_1" ]; then rom_select; fi;
    echo -e "\n${EXE} Preparing for Sync\n";
    echo -e "${QN} Number of Threads for Sync \n"; gimme_info "jobs";
    ST="Number of Threads"; shut_my_mouth JOBS "$ST";
    echo -e "${QN} Force Sync needed ${CL_WYT}[y/n]${NONE}\n"; gimme_info "fsync";
    ST="Force Sync"; shut_my_mouth F "$ST";
    echo -e "${QN} Need some Silence in the Terminal ${CL_WYT}[y/n]${NONE}\n"; gimme_info "ssync";
    ST="Silent Sync"; shut_my_mouth S "$ST";
    echo -e "${QN} Sync only Current Branch ${CL_WYT}[y/n]${NONE}\n"; gimme_info "syncrt";
    ST="Sync Current Branch"; shut_my_mouth C "$ST";
    echo -e "${QN} Sync with clone-bundle ${CL_WYT}[y/n]${NONE}\n"; gimme_info "clnbun";
    ST="Use clone-bundle"; shut_my_mouth B "$ST";
    echo -e "${CL_WYT}=====================================================================${NONE}\n";
    #Sync-Options
    [[ "$SBS" == "y" ]] && SILENT=-q || SILENT=" ";
    [[ "$SBF" == "y" ]] && FORCE=--force-sync || FORCE=" ";
    [[ "$SBC" == "y" ]] && SYNC_CRNT=-c || SYNC_CRNT=" ";
    [[ "$SBB" == "y" ]] && CLN_BUN=" " || CLN_BUN=--no-clone-bundle;
    echo -e "${EXE} Let's Sync!\n";
    repo sync -j${SBJOBS:-1} ${SILENT:--q} ${FORCE} ${SYNC_CRNT:--c} ${CLN_BUN};  #2>&1 | tee $STMP;
    [[ $(echo "$?") == "0" ]] && the_response COOL Sync || the_response FAIL Sync;
    echo -e "\n${SCS} Done.\n";
    echo -e "${CL_WYT}=====================================================================${NONE}\n";
    [ -z "$automate" ] && quick_menu;
} # sync

function device_info() # D 3,4
{
    [[ "${SBRN}" =~ 13|30 ]] && export ROMNIS="${ROMV}"; # Change ROMNIS if Zephyr or Flayr
    if [ -d ${CALL_ME_ROOT}/vendor/${ROMNIS}/config ]; then
        CNF="vendor/${ROMNIS}/config";
    elif [ -d ${CALL_ME_ROOT}/vendor/${ROMNIS}/configs ]; then
        CNF="vendor/${ROMNIS}/configs";
    else
        CNF="vendor/${ROMNIS}";
    fi
    rom_names "$SBRN"; # Restore ROMNIS
    echo -e "${CL_WYT}======================${NONE} ${CL_PRP}Device Info${NONE} ${CL_WYT}======================${NONE}\n";
    echo -e "${QN} What's your Device's CodeName \n${INF} Refer Device Tree - All Lowercases\n";
    ST="Your Device Name is"; shut_my_mouth DEV "$ST";
    echo -e "${QN} Your Device's Company/Vendor \n${INF} All Lowercases\n";
    ST="Device's Vendor"; shut_my_mouth CM "$ST";
    echo -e "${QN} Build type \n${INF} [userdebug/user/eng]\n";
    ST="Build type"; shut_my_mouth BT "$ST";
    echo -e "${QN} Choose your Device type among these. Explainations of each file given in README.md\n"; gimme_info "device-type";
    TYPES=( common_full_phone common_mini_phone common_full_hybrid_wifionly \
    common_full_tablet_lte common_full_tablet_wifionly common_mini_tablet_wifionly common_tablet \
    common_full_tv common_mini_tv );
    CNT=0;
    for TYP in ${TYPES[*]}; do
        if [ -f ${CNF}/${TYP}.mk ]; then echo -e "${CNT}. $TYP"; ((CNT++)); fi;
    done
    echo;
    ST="Device Type"; shut_my_mouth DTP "$ST";
    [ -z $SBDTP ] && SBDTP="common" || SBDTP="${TYPES[${SBDTP}]}";
    echo -e "${CL_WYT}=========================================================${NONE}\n";
} # device_info

function init_bld() # D 3,4
{
    echo -e "\n${CL_WYT}===========================================${NONE}";
    echo -e "${EXE} Initializing Build Environment\n";
    . build/envsetup.sh;
    echo -e "\n${CL_WYT}===========================================${NONE}\n";
    echo -e "${SCS} Done\n";
} # init_bld

function pre_build() # 3
{
    [ ! -z "$automate" ] && teh_action 3;
    [ -z "$action_1" ] && rom_select;
    init_bld;
    device_info;
    DEVDIR="device/${SBCM}/${SBDEV}";

    function vendor_strat_all()
    {
        case "$SBRN" in
            13|30) cd vendor/${ROMV} ;;
            *) cd vendor/${ROMNIS} ;;
        esac
        echo -e "${CL_WYT}=========================================================${NONE}\n";

        function dtree_add()
        {   # AOSP-CAF|RRO|OmniROM|Flayr|Zephyr
            echo -e "${EXE} Adding Lunch Combo in Device Tree";
            [ ! -f vendorsetup.sh ] && touch vendorsetup.sh;
            if [[ $(grep -c "${ROMNIS}_${SBDEV}" ${DEVDIR}/vendorsetup.sh ) == "0" ]]; then
                echo -e "add_lunch_combo ${ROMNIS}_${SBDEV}-${SBBT:-userdebug}" >> vendorsetup.sh;
            else
                echo -e "${SCS} Lunch combo already added to vendorsetup.sh\n";
            fi
        } # dtree_add

        echo -e "${EXE} Adding Device to ROM Vendor...";
        STRTS=( "${ROMNIS}.devices" "${ROMNIS}-device-targets" vendorsetup.sh );
        for STRT in ${STRTS[*]}; do
            #    Found file   &&  Strat Not Performed
            if [ -f "$STRT" ] && [ -z "$STDN" ]; then
                if [[ $(grep -c "${SBDEV}" $STRT) == "0" ]]; then
                    case "$STRT" in
                        ${ROMNIS}.devices)
                            echo -e "${SBDEV}" >> $STRT ;;
                        ${ROMNIS}-device-targets)
                            echo -e "${ROMNIS}_${SBDEV}-${SBBT:-userdebug}" >> $STRT ;;
                        vendorsetup.sh)
                            echo -e "add_lunch_combo ${ROMNIS}_${SBDEV}-${SBBT:-userdebug}" >> $STRT ;;
                    esac
                else
                    echo -e "${INF} Device already added to $STRT";
                fi
                export STDN="y"; # File Found, Strat Performed
            fi
        done
        [ -z "$STDN" ] && dtree_add; # If none of the Strats Worked
        echo -e "${SCS} Done.\n";
        croot;
        echo -e "${CL_WYT}=========================================================${NONE}";
    } # vendor_strat

    function vendor_strat_kpa() # AOKP-4.4|AICP|PAC-5.1|Krexus-CAF|AOSPA
    {
        croot;
        cd vendor/${ROMNIS}/products;
        echo -e "${INF} About Device's Resolution...\n";
        if [ ! -z "$automate" ]; then
            gimme_info "bootres";
            echo -e "${QN} Enter the Desired Highlighted Number\n";
            read -p $'\033[1;36m[>]\033[0m ' SBBTR;
        else
            echo -e "${INF} ${ATBT} Resolution Choosed : ${SBBTR}";
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
                mv ${CALL_ME_ROOT}/${DEVDIR}/*.dependencies ${SBDEV}/pa.dependencies;
                ;;
            "pac")
                VENF="${ROMNIS}_${SBDEV}.mk";
                echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/pac_common.mk)" >> $VENF;
                echo -e "\nPAC_BOOTANIMATION_NAME := ${SBBTR};" >> $VENF;
                ;;
        esac
        find_ddc "pb";
        echo -e "\n# Inherit from ${DDC}" >> $VENF;
        echo -e "\$(call inherit-product, ${DEVDIR}/${DDC})" >> $VENF;
        # PRODUCT_NAME is the only ROM-specific Identifier, setting it here is better.
        echo -e "\n#ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${SBDEV}" >> $VENF;
    } # vendor_strat_kpa

    function find_ddc() # For Finding Default Device Configuration file
    {
        ROMS=( aicp aokp aosp bliss candy carbon crdroid cyanide cm du orion \
                ownrom slim tesla tipsy to validus vanir xenonhd xosp );
        for ROM in ${ROMS[*]}; do
            # Possible Default Device Configuration (DDC) Files
            DDCS=( ${ROM}_${SBDEV}.mk full_${SBDEV}.mk aosp_${SBDEV}.mk ${ROM}.mk );
            # Makefiles are arranged according to their priority of Usage. ROM.mk is the most used, ROM_DEVICE.mk is the least used.
            # Inherit DDC
            for ACTUAL_DDC in ${DDCS[*]}; do
                if [ -f ${DEVDIR}/${ACTUAL_DDC} ]; then
                    case "$1" in
                        "pb") export DDC="$ACTUAL_DDC" ;;
                        "intm") # Interactive Makefile not found -vv
                            if [[ $(grep -c '##### Interactive' ${DEVDIR}/${ACTUAL_DDC}) == "0" ]] \
                            && [[ "$ACTUAL_DDC" != "${ROMNIS}.mk" ]]; then # ROM Specific Makefile not Present
                                export DDC="$ACTUAL_DDC"; # Interactive makefile not present for that particular ROMNIS
                                continue; # searching for more relevant makefile
                            else
                                export DDC="NULL"; # Interactive Makefile already created, under ROMNIS name
                                break; # What now ? Get out!
                            fi
                            ;;
                    esac
                fi
            done
            [[ "$DDC" == "NULL" ]] && break; # It's Done, Get out!
        done
    } # find_ddc

    function interactive_mk()
    {
        init_bld;
        echo -e "\n${EXE} Creating Interactive Makefile for getting Identified by the ROM's BuildSystem...\n";
        sleep 2;

        function create_imk()
        {
            cd ${DEVDIR};
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
            echo -e "\n# Inherit ${ROMNIS} common stuff\n\$(call inherit-product, ${CNF}/${VNF}.mk)" >> ${INTM};
            # Inherit Vendor specific files
            if [[ $(grep -c 'nfc_enhanced' $DDC) == "1" ]] && [ -f ${CALL_ME_ROOT}/${CNF}/nfc_enhanced.mk ]; then
                echo -e "\n# Enhanced NFC\n\$(call inherit-product, ${CNF}/nfc_enhanced.mk)" >> ${INTM};
            fi
            echo -e "\n# Calling Default Device Configuration File" >> ${INTM};
            echo -e "\$(call inherit-product, ${DEVDIR}/${DDC})" >> ${INTM};
            # To prevent Missing Vendor Calls in DDC-File
            sed -i -e 's/inherit-product, vendor\//inherit-product-if-exists, vendor\//g' $DDC;
            # Add User-desired Makefile Calls
            echo -e "${QN} Missed some Makefile calls\n${INF} Enter number of Desired Makefile calls\n${INF} Enter 0 if none";
            ST="No of Makefile Calls"; shut_my_mouth NMK "$ST";
            for (( CNT=0; CNT<"${SBNMK}"; CNT++ )); do
                echo -e "\n${QN} Enter Makefile location from Root of BuildSystem";
                ST="Makefile"; shut_my_mouth LOC[$CNT] "$ST" array;
                if [ -f ${CALL_ME_ROOT}/${SBLOC[$CNT]} ]; then
                    echo -e "\n${EXE} Adding Makefile `$[ $CNT + 1 ]` ...";
                    echo -e "\n\$(call inherit-product, ${SBLOC[$CNT]})" >> ${INTM};
                else
                    echo -e "${FLD} Makefile ${SBLOC[$CNT]} not Found. Aborting...";
                fi
            done
            echo -e "\n# ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${SBDEV}" >> ${INTM};
            # Make it Identifiable
            mv ${INTM} ${INTF};
            echo -e "${EXE} Renaming .dependencies file...\n";
            [ ! -f ${ROMNIS}.dependencies ] && mv -f *.dependencies ${ROMNIS}.dependencies;
            echo -e "${SCS} Done.";
            croot;
        } # create_imk

        find_ddc "intm";
        if [[ "$DDC" != "NULL" ]]; then create_imk; else echo "$NOINT"; fi;
    } # interactive_mk

    function need_for_int()
    {
        if [ -f ${CALL_ME_ROOT}/${DEVDIR}/${INTF} ]; then
            echo "$NOINT";
        else
            interactive_mk "$SBRN";
        fi
    } # need_for_int

    echo -e "\n${EXE} ${ROMNIS}-fying Device Tree...\n";
    NOINT=$(echo -e "${SCS} Interactive Makefile Unneeded, continuing...");

    case "$SBRN" in
        4|5|13|16|30) # AOSP-CAF/RRO | Flayr | OmniROM | Zephyr
            VNF="common";
            INTF="${ROMNIS}_${SBDEV}.mk";
            need_for_int;
            rm -rf ${DEVDIR}/AndroidProducts.mk;
            echo -e "PRODUCT_MAKEFILES :=  \\ \n\t\$(LOCAL_DIR)/${ROMNIS}_${SBDEV}.mk" >> AndroidProducts.mk;
            ;;
        3) # AOSiP-CAF
            if [ ! -f vendor/${ROMNIS}/products ]; then
                VNF="common";
                INTF="${ROMNIS}.mk";
                need_for_int;
            else
                echo "$NOINT";
            fi
            ;;
        2|19) # AOKP-4.4 | PAC-5.1
            if [ ! -f vendor/${ROMNIS}/products ]; then
                VNF="$SBDTP";
                INTF="${ROMNIS}.mk"
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
            INTF="${ROMNIS}.mk"
            need_for_int;
            ;;
    esac

    if [ -d vendor/${ROMNIS}/products ] && [ ! -d vendor/aosip ]; then
        if [ ! -f vendor/${ROMNIS}/products/${ROMNIS}_${SBDEV}.mk ||
             ! -f vendor/${ROMNIS}/products/${SBDEV}.mk ||
             ! -f vendor/${ROMNIS}/products/${SBDEV}/${ROMNIS}_${SBDEV}.mk ]; then
            vendor_strat_kpa; #if found products folder
        else
            echo -e "\n${SCS} Looks like ${SBDEV} has been already added to ${ROM_FN} vendor. Good to go\n";
        fi
    else
        vendor_strat_all; #if not found
    fi
    croot;
    sleep 2;
    export action_1="init" action_2="pre_build";
    [ -z "$automate" ] && quick_menu;
} # pre_build

function build() # 4
{
    if [ -d .repo ]; then
        [ ! -z "$automate" ] && teh_action 4;
        [ -z "$action_1" ] && rom_select;
        [ -z "$action_2" ] && device_info;
    else
        echo -e "${FLD} ROM Source Not Found (Synced)\n${FLD} Please perform an init and sync before doing this";
        exitScriBt 1;
    fi

    function hotel_menu()
    {
        echo -e "${CL_WYT}=========================${NONE} ${CL_LBL}Hotel Menu${NONE} ${CL_WYT}==========================${NONE}";
        echo -e " Menu is only for your Device, not for you. No Complaints pls.\n";
        echo -e "[*] lunch - Setup Build Environment for the Device";
        echo -e "[*] breakfast - Download Device Dependencies and lunch";
        echo -e "[*] brunch - breakfast + lunch then Start Build\n";
        echo -e "${QN} Type in the Option you want to select\n";
        echo -e "${INF} Building for the first time ? select lunch";
        echo -e "${CL_WYT}===============================================================${NONE}\n";
        ST="Selected Option"; shut_my_mouth SLT "$ST";
        case "$SBSLT" in
            "lunch") ${SBSLT} ${ROMNIS}_${SBDEV}-${SBBT:-userdebug} ;;
            "breakfast") ${SBSLT} ${SBDEV} ${SBBT:-userdebug} ;;
            "brunch")
                echo -e "\n${EXE} Starting Compilation - ${ROM_FN} for ${SBDEV}\n";
                ${SBSLT} ${SBDEV};
                ;;
            *) echo -e "${FLD} Invalid Selection.\n"; hotel_menu ;;
        esac
        echo;
    } # hotel_menu

    function post_build()
    {
        NRT_0=`tac $RMTMP | grep -m 1 'No rule to make target\|no known rule to make it'`;
        if [[ $(tac $RMTMP | grep -c -m 1 '#### make completed successfully') == "1" ]]; then
            echo -e "\n${SCS} Build completed successfully! Cool. Now make it Boot!";
            the_response COOL Build;
            teh_action 6 COOL;
        elif [[ ! -z "$NRT_0" ]]; then
#           if [[ ! -z "$DMNJ" ]]; then
#               # ninja: error: 'A', needed by 'B', missing and no known rule to make it
# W             NRT_1=(`echo "$NRT_0" | awk '{print $3 $6}' | awk -F "'" '{print $2" "$4}'`);
# i         else
# P             # make[X]: *** No rule to make target 'A', needed by 'B'.
#               NRT_1=(`echo "$NRT_0" | awk -F "No rule to make target" '{print $2}' | awk -F "'" '{print $2" "$4}'`);
#           fi
            if [ ! -z "$automate" ]; then
                teh_action 6 FAIL;
                the_response FAIL Build;
            fi
        fi
    } # post_build

    function build_make()
    {
        if [[ "$1" != "brunch" ]]; then
            START=$(date +"%s");
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
            END=$(date +"%s");
            SEC=$(($END - $START));
            echo -e "${INF} Build took $(($SEC / 3600)) hour(s), $(($SEC / 60 % 60)) minute(s) and $(($SEC % 60)) second(s)." | tee -a rom_compile.txt;
        fi
    } # build_make

    function make_it() # Part of make_module
    {
        echo -e "${QN} ENTER the Directory where the Module is made from : \n";
        read -p $'\033[1;36m[>]\033[0m ' MODDIR;
        echo -e "\n${QN} Do you want to push the Module to the Device (Running the Same ROM) ${CL_WYT}[y/n]${NONE} : \n";
        read -p $'\033[1;36m[>]\033[0m ' PMOD;
        echo;
        case "$PMOD" in
            [yY]) mmmp -B $MODDIR ;;
            [nN]) mmm -B $MODDIR ;;
            *) echo -e "${FLD}Invalid Selection.\n"; make_it ;;
        esac
    } # make_it

    function make_module()
    {
        if [ -z "$1" ]; then
            echo -e "\n${QN} Know the Location of the Module : \n";
            read -p $'\033[1;36m[>]\033[0m ' KNWLOC;
        fi
        if [[ "$KNWLOC" == "y" || "$1" == "y" ]]; then
            make_it;
        else
            echo -e "${INF} Do either of these two actions:\n1. Google it (Easier)\n2. Run this command in terminal : sgrep \"LOCAL_MODULE := <Insert_MODULE_NAME_Here> \".\n\n Press ENTER after it's Done..\n";
            read ENTER;
            make_it;
        fi
    } # make_module

    function build_menu()
    {
        init_bld;
        echo -e "${CL_WYT}=========================================================${NONE}\n";
        echo -e "${QN} Select a Build Option:\n";
        echo -e "1. Start Building ROM (ZIP output) (Clean Options Available)";
        echo -e "2. Make a Particular Module";
        echo -e "3. Setup CCACHE for Faster Builds \n";
        echo -e "${CL_WYT}=========================================================\n";
        ST="Option Selected"; shut_my_mouth BO "$ST";
    }

    build_menu;
    case "$SBBO" in
        1)
            echo -e "\n${QN} Should i use 'make' or 'mka'\n";
            ST="Selected Method"; shut_my_mouth MK "$ST";
            echo -e "${QN} Wanna Clean the /out before Building\n${INF} 1 - Remove Staging Dirs | 2 - Full Clean\n";
            ST="Option Selected"; shut_my_mouth CL "$ST";
            if [[ $(grep -c 'BUILD_ID=M\|BUILD_ID=N' ${CALL_ME_ROOT}/build/core/build_id.mk) == "1" ]]; then
                echo -e "${QN} Use Jack Toolchain ${CL_WYT}[y/n]${NONE}\n";
                ST="Use Jacky"; shut_my_mouth JK "$ST";
                case "$SBJK" in
                     [yY]) export ANDROID_COMPILE_WITH_JACK=true ;;
                     [nN]) export ANDROID_COMPILE_WITH_JACK=false ;;
                esac
            fi
            if [[ $(grep -c 'BUILD_ID=N' ${CALL_ME_ROOT}/build/core/build_id.mk) == "1" ]]; then
                echo -e "${QN} Use Ninja to build Android ${CL_WYT}[y/n]${NONE}";
                ST="Use Ninja"; shut_my_mouth NJ "$ST";
                case "$SBNJ" in
                    [yY])
                        echo -e "\n${INF} Building Android with Ninja BuildSystem";
                        export USE_NINJA=true;
                        ;;
                    [nN])
                        echo -e "\n${INF} Building Android with the Non-Ninja BuildSystem\n";
                        export USE_NINJA=false;
                        unset BUILDING_WITH_NINJA;
                        ;;
                    *) echo -e "${FLD} Invalid Selection.\n" ;;
                esac
            fi
            case "$SBCL" in
                1) lunch ${ROMNIS}_${SBDEV}-${SBBT:-userdebug}; $SBMK installclean ;;
                2) lunch ${ROMNIS}_${SBDEV}-${SBBT:-userdebug}; $SBMK clean ;;
                *) echo -e "${INF} No Clean Option Selected.\n" ;;
            esac
            hotel_menu;
            build_make "$SBSLT";
            ;;
        2) make_module ;;
        3) set_ccvars ;;
        *)
            echo -e "${FLD} Invalid Selection.\n";
            build;
            ;;
    esac
    export action_3="build";
} # build

function tools() # 5
{
    [ ! -z "$automate" ] && teh_action 5;

    function installdeps()
    {
        echo -e "${EXE} Analyzing Distro";
        PACK="/etc/apt/sources.list.d/official-package-repositories.list";
        DISTROS=( precise quantal raring saucy trusty utopic vivid wily xenial );
        for DIST in ${DISTROS[*]}; do
            if [[ $(grep -c "${DIST}" "${PACK}") != "0" ]]; then
                export DISTRO="${DIST}";
            fi
        done
        echo -e "\n${EXE} Installing Build Dependencies\n";
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
        sudo -p $'\033[1;35m[#]\033[0m ' apt-get install -y ${COMMON_PKGS[*]} ${DISTRO_PKGS[*]};
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
                echo -e "\n${FLD} no AUR manager found\n";
                exitScriBt 1;
            fi
            # look for conflicting packages and uninstall them
            for item in ${PKGS_CONFLICT}; do
                if pacman -Qq ${item} &> /dev/null; then
                    sudo -p $'\033[1;35m[#]\033[0m ' pacman -Rddns --noconfirm ${item};
                    sleep 3;
                fi
            done
            # install required packages
            for item in ${PKGSREQ}; do
                ${AURMGR} -S --noconfirm $item;
            done
        else
            echo -e "\n${SCS} You already have all required packages\n";
        fi
    } # installdeps_arch

    function java_select()
    {
        echo -e "${INF} If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)";
        echo -e "${INF} You may now select the Version of Java which is to be used BY-DEFAULT\n";
        echo -e "${CL_WYT}================================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt")
                sudo -p $'\033[1;35m[#]\033[0m ' update-alternatives --config java;
                echo -e "\n${CL_WYT}================================================================${NONE}\n";
                sudo -p $'\033[1;35m[#]\033[0m ' update-alternatives --config javac;
                ;;
            "pacman")
                archlinux-java status;
                read -p "${INF} Please enter desired version (ie. \"java-7-openjdk\"): " ARCHJA;
                sudo -p $'\033[1;35m[#]\033[0m ' archlinux-java set ${ARCHJA};
                ;;
        esac
        echo -e "\n${CL_WYT}================================================================${NONE}";
    } # java_select

    function java()
    {
        echo -ne "\033]0;ScriBt : Java $1\007";
        echo -e "\n${EXE} Installing OpenJDK-$1 (Java 1.$1.0)";
        echo -e "\n${INF} Remove other Versions of Java ${CL_WYT}[y/n]${NONE}? : \n";
        read -p $'\033[1;36m[>]\033[0m ' REMOJA;
        echo;
        case "$REMOJA" in
            [yY])
                case "${PKGMGR}" in
                    "apt") sudo -p $'\033[1;35m[#]\033[0m ' apt-get purge openjdk-* icedtea-* icedtea6-* ;;
                    "pacman") sudo -p $'\033[1;35m[#]\033[0m ' pacman -Rddns $( pacman -Qqs ^jdk ) ;;
                esac
                echo -e "\n${SCS} Removed Other Versions successfully"
                ;;
            [nN]) echo -e "${EXE} Keeping them Intact" ;;
            *)
                echo -e "${FLD} Invalid Selection.\n";
                java $1;
                ;;
        esac
        echo -e "${CL_WYT}==========================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt") sudo -p $'\033[1;35m[#]\033[0m ' apt-get update -y ;;
            "pacman") sudo -p $'\033[1;35m[#]\033[0m ' pacman -Sy ;;
        esac
        echo -e "\n${CL_WYT}==========================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt") sudo -p $'\033[1;35m[#]\033[0m ' apt-get install openjdk-$1-jdk -y ;;
            "pacman") sudo -p $'\033[1;35m[#]\033[0m ' pacman -S jdk$1-openjdk ;;
        esac
        echo -e "\n${CL_WYT}==========================================================${NONE}";
        if [[ $( java -version > $TMP && grep -c "java version \"1\.$1" $TMP ) == "1" ]]; then
            echo -e "${SCS} OpenJDK-$1 or Java 1.$1.0 has been successfully installed";
            echo -e "${CL_WYT}==========================================================${NONE}";
        fi
    } # java

    function java_ppa()
    {
        if [[ ! $(which add-apt-repository) ]]; then
            echo -e "${EXE} add-apt-repository not present. Installing it...";
            sudo -p $'\033[1;35m[#]\033[0m ' apt-get install software-properties-common;
        fi
        sudo -p $'\033[1;35m[#]\033[0m ' add-apt-repository ppa:openjdk-r/ppa -y;
        sudo -p $'\033[1;35m[#]\033[0m ' apt-get update -y;
        sudo -p $'\033[1;35m[#]\033[0m ' apt-get install openjdk-$1-jdk -y;
    } # java_ppa

    function java_menu()
    {
        echo -e "${CL_WYT}=============${NONE} ${CL_YEL}JAVA${NONE} Installation ${CL_WYT}============${NONE}\n";
        echo -e "1. Install Java";
        echo -e "2. Switch Between Java Versions / Providers\n";
        echo -e "0. Quick Menu\n";
        echo -e "${INF} ScriBt installs Java by OpenJDK";
        echo -e "\n${CL_WYT}============================================\n${NONE}";
        read -p $'\033[1;36m[>]\033[0m ' JAVAS;
        case "$JAVAS" in
            0)  quick_menu ;;
            1)
                echo -ne '\033]0;ScriBt : Java\007';
                echo -e "\n${QN} Android Version of the ROM you're building";
                echo -e "1. Java 1.6.0 (4.4.x Kitkat)";
                echo -e "2. Java 1.7.0 (5.x.x Lollipop && 6.x.x Marshmallow)";
                echo -e "3. Java 1.8.0 (7.x.x Nougat)\n";
                [[ "${PKGMGR}" == "apt" ]] && echo -e "4. Ubuntu 16.04 & Want to install Java 7\n5. Ubuntu 14.04 & Want to install Java 8";
                read -p $'\033[1;36m[>]\033[0m ' JAVER;
                case "$JAVER" in
                    1) java 6 ;;
                    2) java 7 ;;
                    3) java 8 ;;
                    4) java_ppa 7 ;;
                    5) java_ppa 8 ;;
                    *)
                        echo -e "\n${FLD} Invalid Selection.\n";
                        java_menu;
                        ;;
                esac # JAVER
                ;;
            2) java_select ;;
            *)
                echo -e "\n${FLD} Invalid Selection.\n";
                java_menu;
                ;;
        esac # JAVAS
    } # java_menu

    function udev_rules()
    {
        echo -e "\n${CL_WYT}==========================================================${NONE}\n";
        echo -e "${EXE} Updating / Creating Android USB udev rules (51-android)\n";
        sudo -p $'\033[1;35m[#]\033[0m ' curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules;
        sudo -p $'\033[1;35m[#]\033[0m ' chmod a+r /etc/udev/rules.d/51-android.rules;
        sudo -p $'\033[1;35m[#]\033[0m ' service udev restart;
        echo -e "\n${SCS} Done";
        echo -e "\n${CL_WYT}==========================================================${NONE}\n";
    } # udev_rules

    function make_me_old()
    {
        MKVR=$(make -v | head -1 | awk '{print $3}');
        case "${MKVR}" in
            "3.81") echo -e "\n${SCS} make 3.81 has already been installed" ;;
            *)
                echo "\n${EXE} Installing make 3.81...";
                sudo -p $'\033[1;35m[#]\033[0m ' install utils/make /usr/bin/;
                ;;
        esac
        [[ "$MKVR" == "3.81" ]] && echo -e "\n${SCS} make 3.81 present";
    } # make_me_old

    function git_creds()
    {
        echo -e "\n${INF} Enter the Details with reference to your ${CL_WYT}GitHub account${NONE}\n\n";
        sleep 2;
        echo -e "${QN} Enter the Username";
        echo -e "${INF} Username is the one which appears on the GitHub Account URL\n${INF} Ex. https://github.com/[ACCOUNT_NAME]\n";
        read -p $'\033[1;36m[>]\033[0m ' GIT_U;
        echo -e "\n${QN} Enter the E-mail ID\n";
        read -p $'\033[1;36m[>]\033[0m ' GIT_E;
        git config --global user.name "${GIT_U}";
        git config --global user.email "${GIT_E}";
        echo -e "\n${SCS} Done.\n"
        quick_menu;
    } # git_creds

    function tool_menu()
    {
        echo -e "\n${CL_WYT}===================${NONE} ${CL_LBL}Tools${NONE} ${CL_WYT}====================${NONE}\n";
        echo -e "     1. Install Build Dependencies\n";
        echo -e "     2. Install Java (OpenJDK 6/7/8)";
        echo -e "     3. Install and/or Set-up CCACHE";
        echo -e "     4. Install/Update ADB udev rules";
        echo -e "     5. Install/Revert to make 3.81";
        echo -e "     6. Add/Update Git Credentials${CL_WYT}*${NONE}";
# TODO: echo -e "     X. Find an Android Module's Directory";
        echo -e "\n     0. Quick Menu"
        echo -e "\n${CL_WYT}*${NONE} Create a GitHub account before using this option";
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
            5) make_me_old ;;
            6) git_creds ;;
# TODO:     X) find_mod ;;
            *) echo -e "${FLD} Invalid Selection.\n"; tool_menu ;;
        esac
        [ -z "$automate" ] && quick_menu;
    } # tool_menu

    tool_menu;
} # tools

function teh_action() # Takes ya Everywhere within ScriBt
{
    case "$1" in
    1)
        echo -ne '\033]0;ScriBt : Init\007';
        [ -z "$automate" ] && init;
        ;;
    2)
        echo -ne "\033]0;ScriBt : Syncing ${ROM_FN}\007";
        [ -z "$automate" ] & sync;
        ;;
    3)
        echo -ne '\033]0;ScriBt : Pre-Build\007';
        [ -z "$automate" ] && pre_build;
        ;;
    4)
        echo -ne "\033]0;${ROMNIS}_${SBDEV} : In Progress\007";
        [ -z "$automate" ] && build;
        ;;
    5)
        echo -ne '\033]0;ScriBt : Installing Dependencies\007';
        [ -z "$automate" ] && tools;
        ;;
    6)
        case "$2" in
            "COOL") echo -ne "\033]0;${ROMNIS}_${SBDEV} : Success\007" ;;
            "FAIL") echo -ne "\033]0;${ROMNIS}_${SBDEV} : Fail\007" ;;
        esac
        [ -z "$automate" ] && exitScriBt 0;
        ;;
    *)
        echo -e "\n${FLD} Invalid Selection.\n";
        case "$2" in
            "qm") quick_menu ;;
            "mm") main_menu ;;
        esac
        ;;
    esac
} # teh_action

function the_start() # 0
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
        echo -e "\n${INF} Using this for first time?\nTake a look on PREF.rc and shut_my_mouth";
    fi
    echo -e "\n${QN} Before Starting off, shall I remember the responses you'll enter from now \n${INF} So that it can be Automated next time\n";
    read -p $'\033[1;36m[>]\033[0m ' RQ_PGN;
    (set -o posix; set) > ${TV1};
#   echo -e "\n${EXE} Prompting for Root Access\n";
#   sudo -p $'\033[1;35m[#]\033[0m ' echo -e "\n${SCS} Root access OK. You won't be asked again";
    [[ "$(pwd)" != "/" ]] && export CALL_ME_ROOT="$(pwd)" || export CALL_ME_ROOT="";
    echo -e "\n${EXE} ./action${CL_LRD}.SHOW_LOGO${NONE}";
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
    echo -e "                     ${CL_WYT}Version 1.34${NONE}\n";
} # the_start

# VROOM!
DNT=`date +'%d/%m/%y %r'`;
# Load RIDb and Colors
if [ -f ROM.rc ]; then
    . $(pwd)/ROM.rc;
    color_my_life;
else
    echo "[ERROR] ROM.rc isn't present in ${PWD}, please make sure repo is cloned correctly";
    exitScriBt 1;
fi

# Relevant_Coloring
INF="${CL_LBL}[!]${NONE}";
SCS="${CL_LGN}[!]${NONE}";
FLD="${CL_LRD}[!]${NONE}";
EXE="${CL_YEL}[!]${NONE}";
QN="${CL_LRD}[?]${NONE}";

# Update the Updater!
LUSB_VER=`grep 'USB_VER' upScriBt.sh | awk '{print $3}'`;
curl -o up.sh https://raw.githubusercontent.com/a7r3/ScriBt/master/upScriBt.sh;
RUSB_VER=`grep 'USB_VER' up.sh | awk '{print $3}'`;
if [[ "$RUSB_VER" > "$LUSB_VER" ]]; then
    mv -f up.sh upScriBt.sh;
else
    rm -rf up.sh;
fi

# Update us now
source upScriBt.sh $@;

# Where am I ?
echo -e "\n${INF} ${CL_WYT}I'm in $(pwd)${NONE}\n";

# Point of Execution
if [[ "$1" == "automate" ]]; then
    the_start; # Pre-Initial Stage
    echo -e "${INF} ${ATBT} Thanks for Selecting Me. Lem'me do your work";
    export automate="yus_do_eet";
    automate; # Initiate the Build Sequence - Actual "VROOM!"
elif [ -z $1 ]; then
    the_start; # Pre-Initial Stage
    main_menu;
elif [[ "$1" == "cd" ]] && [ ! -z $2 ]; then
    tranScriBt $2 $3;
else
    echo -e "${FLD} Incorrect Parameter: \"$1\"";
    echo -e "${INF} Usage:\n\tbash ROM.sh (Interactive Usage)\n\tbash ROM.sh automate (For Automated Builds)";
    exitScriBt 1;
fi
