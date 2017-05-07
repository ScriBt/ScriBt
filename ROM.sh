#!/bin/bash
#========================< Projekt ScriBt >============================#
#=========< Copyright 2016-2017, Arvindraj Thangaraj - "a7r3" >========#
#======================================================================#
#                                                                      #
# This software is licensed under the terms of the GNU General Public  #
# License version 3, as published by the Free Software Foundation, and #
# may be copied, distributed, and modified under those terms.          #
#                                                                      #
# This program is distributed in the hope that it will be useful,      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of       #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
# GNU General Public License [LICENSE file in this repository] for     #
# more details.                                                        #
#                                                                      #
#======================================================================#
#                                                                      #
# https://github.com/a7r3/ScriBt - I live here                         #
#                                                                      #
# Feel free to enter your modifications and submit it to me with       #
# a Pull Request, Contributions are WELCOME                            #
#                                                                      #
# Contributors:                                                        #
# Arvindraj Thangaraj "a7r3"                                           #
# Adrian DC "AdrianDC"                                                 #
# Akhil Narang "akhilnarang"                                           #
# Łukasz "JustArchi" Domeradzki                                        #
# Tim Schumacher (TimSchumi)                                           #
# Tom Radtke "CubeDev"                                                 #
# nosedive                                                             #
#======================================================================#

function cmdprex() # D ALL
{
    # Replace Space with '#' in individual parameter
    # Remove First Parameter v--(Needs to be refined)--v
    ARGS=( $(echo "${@// /#}" | sed -e 's/--out=.*txt//') );
    # Argument (Parameter) Array
    # If Parameter is empty, Element value would be 'NULL'
    # This is useful to prevent echoing Parameter Description
    # if Parameter itself is empty
    ARG=( `echo ${ARGS[*]/*<->/NULL}` );
    # Argument Description Array
    ARGD=( `echo ${ARGS[*]/<->*/}` );
    # Splash some colors!
    for ((CT=0;CT<${#ARG[*]};CT++)); do
        echo -en "\033[1;3${CT}m`eval echo \${ARG[${CT}]}` " | sed -e 's/NULL//g' -e 's/execroot/sudo/g' -e 's/#/ /g';
    done
    echo -e "\n";
    for ((CT=0;CT<${#ARGD[*]};CT++)); do
        [[ `eval echo \${ARG[${CT}]}` != "NULL" ]] && \
         echo -en "\033[1;3${CT}m`eval echo \${ARGD[${CT}]}`\033[0m " | sed 's/#/ /g';
    done
    echo -e "\n";
    # Make up the command, restore '#' back to spaces
    # If --out is mentioned add the tee redirection statement
    [[ "$1" =~ --out=* ]] && TEE=`echo "2>&1 | tee -a ${1/*=/}"`;
    CMD=`echo "${ARG[*]} ${TEE}" | sed -e 's/NULL//g' -e 's/#/ /g'`;
    # Execute the command
    eval $CMD;
    if [[ "$?" == "0" ]]; then
        echo -e "${SCS} Command Execution Successful\n";
        unset STS;
    else
        echo -e "${FLD} Command Execution Failed\n";
        STS="1";
    fi
    unset -v CMD CT ARG{,S,D};
} # cmdprex


function cherrypick() # Automated Use only
{
    echo -ne '\033]0;ScriBt : Picking Cherries\007';
    echo -e "${CL_WYT}=======================${NONE} ${CL_LRD}Pick those Cherries${NONE} ${CL_WYT}======================${NONE}\n";
    echo -e "${EXE} ${ATBT} Attempting to Cherry-Pick Provided Commits\n";
    cd ${CALL_ME_ROOT}$1;
    git fetch ${2/\/tree\// };
    git cherry-pick $3;
    cd ${CALL_ME_ROOT};
    echo -e "\n${INF} It's possible that the pick may have conflicts. Solve those and then continue.";
    echo -e "${CL_WYT}==================================================================${NONE}";
} # cherrypick

function interrupt() # ID
{
    cd ${CALL_ME_ROOT};
    echo -e "\n\n*** Ouch! Plz don't kill me! ***";
    exitScriBt 0;
} # interrupt

function exitScriBt() # ID
{
    function prefGen()
    {
        echo -e "\n${EXE} Saving Current Configuration";
        echo -e "\n${QN} Name of the Config\n${INF} Default : ${ROMNIS:-scribt}_${SBDEV:-config}\n";
        prompt NOC --no-repeat;
        [[ -z "$NOC" ]] && NOC="${ROMNIS}_${SBDEV}";
        if [[ -f "${NOC}.rc" ]]; then
            echo -e "\n${FLD} Configuration ${NOC} exists";
            echo -e "\n${QN} Overwrite it ${CL_WYT}[y/n]${NONE}";
            prompt OVRT;
            case "$OVRT" in
                [Yy]) echo -e "\n${EXE} Deleting ${NOC}"; rm -rf ${NOC}.rc ;;
                [Nn]) prefGen ;;
            esac
        fi
        (set -o posix; set) > ${TV2};
        echo -e "# ScriBt Automation Config File" >> ${NOC}.rc;
        echo -e "# ${ROM_FN} for ${SBDEV}\nAUTOMATE=\"true_dat\"\n" >> ${NOC}.rc;
        echo -e "#################\n#  Information  #\n#################\n\n" >> ${NOC}.rc;
        diff ${TV1} ${TV2} | grep SB | sed -e 's/[<>] /    /g' | awk '{print $0";"}' >> ${NOC}.rc;
        echo -e "\n\n#################\n#  Sequencing  #\n##################\n" >> ${NOC}.rc;
        echo -e "# Your Code goes here\n\ninit;\npre_build;\nbuild;\n\n# Some moar code eg. Uploading the ROM" >> ${NOC}.rc;
        echo -e "\n${SCS} Configuration file ${NOC} created successfully\n\n${INF} You may modify the config, and automate ScriBt next time";
    } # prefGen

    if type patcher &>/dev/null; then # Assume the patchmgr was used if this function is loaded
        if show_patches | grep -q '[Y]'; then # Some patches are still applied
            echo -e "\n${SCS} Applied Patches detected\n${QN} Do you want to reverse them ${CL_WYT}[y/n]${NONE}\n"
            prompt ANSWER;
            [[ "$ANSWER" == [Yy] ]] && patcher;
        fi
    fi
    if [[ "$RQ_PGN" == [Yy] ]]; then
         prefGen;
    else
        set -o posix;
        set > ${TV2};
    fi
    echo -e "\n${EXE} Unsetting all variables";
    VARS=$(diff ${TV1} ${TV2} | grep SB | sed -e 's/[<>] /    /g' | awk -F "=" '{print $1}');
    unset $VARS;
    echo -e "\n${SCS:-[:)]} Thanks for using ScriBt.\n";
    [[ "$1" == "0" ]] && echo -e "${CL_LGN}[${NONE}${CL_LRD}<3${NONE}${CL_LGN}]${NONE} Peace! :)\n" ||\
        echo -e "${CL_LRD}[${NONE}${CL_RED}<${NONE}${CL_LGR}/${NONE}${CL_RED}3${NONE}${CL_LRD}]${NONE} Failed somewhere :(\n";
    rm ${TV1} ${TV2} ${TEMP};
    [ -f ${PATHDIR}update_message.txt ] && rm ${PATHDIR}update_message.txt
    [ -s "${STMP}" ] || rm "${STMP}"; # If temp_sync.txt is empty, delete it
    [ -s "${RMTMP}" ] || rm ${RMTMP}; # If temp_compile.txt is empty, delete it
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
    echo -e "\n${QN} Select the Option you want to start with\n";
    prompt ACTION;
    teh_action $ACTION "mm";
} # main_menu

function pkgmgr_check() # ID
{
    if which apt &> /dev/null; then
        echo -e "\n${SCS} Package manager ${CL_WYT}apt${NONE} detected.\033[0m";
        PKGMGR="apt";
    elif which pacman &> /dev/null; then
        echo -e "\n${SCS} Package manager ${CL_WYT}pacman${NONE} detected.\033[0m";
        PKGMGR="pacman";
    else
        echo -e "${FLD} No supported package manager has been found.";
        echo -e "\n${INF} Arch Linux or a Debian/Ubuntu based Distribution is required to run ScriBt.";
        exitScriBt 1;
    fi
} # pkgmgr_check

function quick_menu()
{
    echo -ne '\033]0;ScriBt : Quick Menu\007';
    echo -e "${CL_WYT}\n=====================${NONE} ${CL_PNK}Quick-Menu${NONE} ${CL_WYT}======================${NONE}";
    echo -e "1. Init | 2. Sync | 3. Pre-Build | 4. Build | 5. Tools";
    echo -e "                      6. Exit";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    prompt ACTION;
    teh_action $ACTION "qm";
} # quick_menu

function rom_select() # D 1,2
{
    export ROMS=( "NullROM" "AICP" "AOKP" "AOSiP" "AOSP-CAF" "AOSP-OMS" "BlissRoms" \
        "CandyRoms" "CarbonROM" "crDroid" "Cyanide" "CyanogenMod" "DirtyUnicorns" \
        "Euphoria" "F-AOSP" "FlayrOS" "Krexus" "Lineage Android" "OctOs" \
        "OmniROM" "OrionOS" "OwnROM" "PAC ROM" "Parallax OS" "Paranoid Android"\
        "Resurrection Remix" "SlimRoms" "Temasek" "GZR Tesla" "TipsyOs" \
        "GZR Validus" "VanirAOSP" "XenonHD" "XOSP" "Zephyr-OS" "ABC ROM" \
        "DirtyUnicorns" "Krexus" "Nitrogen OS" "PureNexus" );
    echo -e "\n${CL_WYT}=======================================================${NONE}\n";
    echo -e "${CL_YEL}[?]${NONE} ${CL_WYT}Which ROM are you trying to build\nChoose among these (Number Selection)\n";
    for CT in {1..34}; do
        echo -e "${CT}. ${ROMS[$CT]}";
    done | pr -t -2
    echo -e "\n${INF} ${CL_WYT}Non-CAF / Nexus-Family ROMs${NONE}";
    echo -e "${INF} ${CL_WYT}Choose among these ONLY if you're building for a Nexus Device\n"
    for CT in {35..39}; do
        echo -e "${CT}. ${ROMS[$CT]}";
    done | pr -t -2
    unset CT CNS; # Unset these
    [ -z "$automate" ] && unset SBRN;
    echo -e "\n=======================================================${NONE}\n";
    [ -z "$automate" ] && prompt SBRN;
    rom_names "$SBRN";
    if [[ "${SBRN}" == "Invalid" ]]; then
        echo -e "\n${LRED}Invalid Selection.${NONE} Going back."; rom_select;
    else
        echo -e "\n${INF} You have chosen -> ${ROM_FN}\n";
    fi
} # rom_select

function shut_my_mouth() # ID
{
    if [ ! -z "$automate" ]; then
        RST="SB$1";
        echo -e "${CL_PNK}[!]${NONE} ${ATBT} $2 : ${!RST}";
    else
        prompt SB2;
        [ -z "$3" ] && read "SB$1" <<< "${SB2}" || eval SB$1=${SB2};
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
    echo -e "\n${INF} Specify the Size (Number) for Reservation of CCACHE (in GB)\n${INF} CCACHE Size must be >15-20 GB for ONE ROM\n";
    prompt CCSIZE;
    echo -e "\n${INF} Create a New Folder for CCACHE and Specify it's location from /\n";
    prompt CCDIR;
    for RC in .profile .bashrc; do
        if [ -f ${HOME}/${RC} ]; then
            if [[ $(grep -c 'USE_CCACHE\|CCACHE_DIR' ${HOME}/${RC}) == 0 ]]; then
                echo -e "export USE_CCACHE=1\nexport CCACHE_DIR=${CCDIR}" >> ${HOME}/${RC};
                . ${HOME}/${RC};
                echo -e "\n${SCS} CCACHE Specific exports added in ${CL_WYT}${RC}${NONE}";
            else
                echo -e "\n${SCS} CCACHE Specific exports already enabled in ${CL_WYT}${RC}${NONE}";
            fi
            break; # One file, and its done
        fi
    done
    set_ccache;
} # set_ccvars

function init() # 1
{
    # change terminal title
    [ ! -z "$automate" ] && teh_action 1;
    rom_select;
    sleep 1;
    echo -e "${EXE} Detecting Available Branches in ${ROM_FN} Repository";
    RCT=$[ ${#ROM_NAME[*]} - 1 ];
    for CT in `eval echo "{0..$RCT}"`; do
        echo -e "\nOn ${ROM_NAME[$CT]} (ID->$CT)\n";
        BRANCHES=`git ls-remote -h https://github.com/${ROM_NAME[$CT]}/${MAN[$CT]} |\
            awk '{print $2}' | awk -F "/" '{if (length($4) != 0) {print $3"/"$4} else {print $3}}'`;
        if [[ ! -z "$CNS" && "$SBRN" -lt "35" ]]; then
            echo "$BRANCHES" | grep --color=never 'caf' | column;
        else
            echo "$BRANCHES" | column;
        fi
    done
    unset CT;
    echo -e "\n${INF} These Branches are available at the moment\n${QN} Specify the ID and Branch you're going to sync\n${INF} Format : [ID] [BRANCH]\n";
    ST="Branch"; shut_my_mouth NBR "$ST";
    CT=`echo "${SBNBR/ */}"`; # Count
    SBBR=`echo "${SBNBR/* /}"`; # Branch
    MNF=`echo "${MAN[$CT]}"`; # Orgn manifest name at count
    RNM=`echo "${ROM_NAME[$CT]}"`; # Orgn name at count
    echo -e "${QN} Any Source you have already synced ${CL_WYT}[y/n]${NONE}\n"; gimme_info "refer";
    ST="Use Reference Source"; shut_my_mouth RF "$ST";
    if [[ "$SBRF" == [Yy] ]]; then
        echo -e "\n${QN} Provide me the Synced Source's Location from /\n";
        ST="Reference Location"; shut_my_mouth RFL "$ST";
        REF=--reference\=\"${SBRFL}\";
    fi
    echo -e "${QN} Set clone-depth ${CL_WYT}[y/n]${NONE}\n"; gimme_info "cldp";
    ST="Use clone-depth"; shut_my_mouth CD "$ST";
    if [[ "$SBCD" == [Yy] ]]; then
        echo -e "${QN} Depth Value ${CL_WYT}[Default - 1]${NONE}\n";
        ST="clone-depth Value"; shut_my_mouth DEP "$ST";
        CDP=--depth\=${SBDEP:-1};
    fi
    # Check for Presence of Repo Binary
    if [[ ! $(which repo) ]]; then
        echo -e "${FLD} ${CL_WYT}repo${NONE} binary isn't installed\n\n${EXE} Installing ${CL_WYT}repo${CL_WYT}\n";
        [ ! -d "${HOME}/bin" ] && mkdir -pv ${HOME}/bin;
        curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo;
        chmod a+x ~/bin/repo;
        echo -e "${SCS} Repo Binary Installed\n${EXE} Adding ~/bin to PATH\n";
        if [[ $(grep 'PATH=*' ~/.profile | grep -c '$HOME/bin') != "0" ]]; then
            echo -e "${SCS} $HOME/bin is in PATH";
        else
            echo -e "\n# set PATH so it includes user's private bin if it exists" >> ~/.profile;
            echo -e "if [ -d \"\$HOME/bin\" ]; then\n\tPATH=\"\$HOME/bin:\$PATH\"\nfi" >> ~/.profile;
            . ~/.profile;
            echo -e "${SCS} $HOME/bin added to PATH"
        fi
        echo -e "${SCS} Done. Ready to Init Repo.\n";
    fi
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    MURL="https://github.com/${RNM}/${MNF}";
    export CMD="repo init ";
    cmdprex --out="${STMP}" \
        "CommandName<->repo init" \
        "Reference Source<->${REF}" \
        "Clone Depth<->${CDP}" \
        "Manifest URL<->-u ${MURL}" \
        "Manifest Branch<->-b ${SBBR}";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    if [ -z "$STS" ]; then
        [ ! -f .repo/local_manifests ] && mkdir -pv .repo/local_manifests;
        if [ -z "$automate" ]; then
            echo -e "${INF} Create a Device Specific manifest and Press ENTER to start sync\n";
            read;
            echo;
        fi
        export action_1="init";
    else
        unset STS;
    fi
    [ -z "$automate" ] && quick_menu;
} # init

function sync() # 2
{
    # Change terminal title
    [ ! -z "$automate" ] && teh_action 2;
    # if   repo not inited          then do it else                        get rom info
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
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    #Sync-Options
    [[ "$SBS" == "y" ]] && SILENT="-q";
    [[ "$SBF" == "y" ]] && FORCE=--force-sync;
    [[ "$SBC" == "y" ]] && SYNC_CRNT=-c;
    [[ "$SBB" == "y" ]] || CLN_BUN=--no-clone-bundle;
    echo -e "${EXE} Let's Sync!\n";
    cmdprex --out="${STMP}" \
        "CommandName<->repo sync" \
        "No. of Jobs<->-j${SBJOBS:-1}" \
        "Silent Sync<->${SILENT}" \
        "Force Sync<->${FORCE}" \
        "Sync Current Branches Only<->${SYNC_CRNT}" \
        "Use Clone Bundle<->${CLN_BUN}";
    echo -e "\n${SCS} Done.\n";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    [ -z "$automate" ] && quick_menu;
} # sync

function device_info() # D 3,4
{
    echo -ne "\033]0;ScriBt : Device Info\007";
    [[ ! -z ${ROMV} ]] && export ROMNIS="${ROMV}"; # Change ROMNIS to ROMV if ROMV is non-zero
    if [ -d ${CALL_ME_ROOT}vendor/${ROMNIS}/config ]; then
        CNF="vendor/${ROMNIS}/config";
    elif [ -d ${CALL_ME_ROOT}vendor/${ROMNIS}/configs ]; then
        CNF="vendor/${ROMNIS}/configs";
    else
        CNF="vendor/${ROMNIS}";
    fi
    rom_names "$SBRN"; # Restore ROMNIS
    echo -e "${CL_WYT}=====================${NONE} ${CL_PRP}Device Info${NONE} ${CL_WYT}=====================${NONE}\n";
    echo -e "${QN} What's your Device's CodeName \n${INF} Refer Device Tree - All Lowercases\n";
    ST="Your Device Name is"; shut_my_mouth DEV "$ST";
    echo -e "${QN} Your Device's Company/Vendor \n${INF} All Lowercases\n";
    ST="Device's Vendor"; shut_my_mouth CM "$ST";
    echo -e "${QN} Build type \n${INF} [userdebug/user/eng]\n";
    ST="Build type"; shut_my_mouth BT "$ST";
    if [ -z "$SBBT" ]; then SBBT="userdebug"; fi;
    echo -e "${QN} Choose your Device type among these. Explainations of each file given in README.md\n"; gimme_info "device-type";
    TYPES=( common_full_phone common_mini_phone common_full_hybrid_wifionly \
    common_full_tablet_lte common_full_tablet_wifionly common_mini_tablet_wifionly common_tablet \
    common_full_tv common_mini_tv );
    CT=0;
    for TYP in ${TYPES[*]}; do
        if [ -f ${CNF}/${TYP}.mk ]; then echo -e "${CT}. $TYP"; ((CT++)); fi;
    done
    unset CT;
    echo;
    ST="Device Type"; shut_my_mouth DTP "$ST";
    [ -z $SBDTP ] && SBDTP="common" || SBDTP="${TYPES[${SBDTP}]}";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
} # device_info

function init_bld() # D 3,4
{
    echo -e "\n${CL_WYT}=======================================================${NONE}";
    echo -e "${EXE} Initializing Build Environment\n";
    cmdprex \
        "Execute in Current Shell<->." \
        "EnvSetup Script<->build/envsetup.sh";
    echo -e "\n${CL_WYT}=======================================================${NONE}\n";
    echo -e "${SCS} Done\n";
} # init_bld

function choose_target() # D 3,4
{
    case "$ROMNIS" in
        eos|pure) TARGET="${SBDEV}-${SBBT}" ;;
        *) TARGET="${ROMNIS}_${SBDEV}-${SBBT}" ;;
    esac
} # choose_target

function pre_build() # 3
{
    # To prevent missing information, if user starts directly from here
    [ -z "$action_1" ] && rom_select;
    init_bld;
    device_info;
    # Change terminal title
    [ ! -z "$automate" ] && teh_action 3;
    DEVDIR="device/${SBCM}/${SBDEV}";

    function vendor_strat_all()
    {
        [[ ! -z "$ROMV" ]] && cd vendor/${ROMV} || cd vendor/${ROMNIS};
        echo -e "${CL_WYT}=======================================================${NONE}\n";

        function dtree_add()
        {   # AOSP-CAF|RRO|F-AOSP|Flayr|OmniROM|Zephyr
            echo -e "${EXE} Adding Lunch Combo in Device Tree";
            [ ! -f vendorsetup.sh ] && touch vendorsetup.sh;
            if [[ $(grep -c "${ROMNIS}_${SBDEV}" ${DEVDIR}/vendorsetup.sh ) == "0" ]]; then
                echo -e "add_lunch_combo ${ROMNIS}_${SBDEV}-${SBBT}" >> vendorsetup.sh;
            else
                echo -e "${SCS} Lunch combo already added to vendorsetup.sh\n";
            fi
        } # dtree_add

        [[ "$ROMNIS" == "du" && "$CNS" == "y" ]] && VSTP="caf-vendorsetup.sh" || VSTP="vendorsetup.sh";
        echo -e "${EXE} Adding Device to ROM Vendor";
        for STRT in "${ROMNIS}.devices" "${ROMNIS}-device-targets" "${VSTP}"; do
            #    Found file   &&  Strat Not Performed
            if [ -f "$STRT" ] && [ -z "$STDN" ]; then
                if [[ $(grep -c "${SBDEV}" $STRT) == "0" ]]; then
                    case "$STRT" in
                        ${ROMNIS}.devices)
                            echo -e "${SBDEV}" >> $STRT ;;
                        ${ROMNIS}-device-targets)
                            echo -e "${TARGET}" >> $STRT ;;
                        ${VSTP})
                            echo -e "add_lunch_combo ${TARGET}" >> $STRT ;;
                    esac
                else
                    echo -e "${INF} Device already added to $STRT";
                fi
                export STDN="y"; # File Found, Strat Performed
            fi
        done
        [ -z "$STDN" ] && dtree_add; # If none of the Strats Worked
        echo -e "${SCS} Done.\n";
        cd ${CALL_ME_ROOT};
        echo -e "${CL_WYT}=======================================================${NONE}";
    } # vendor_strat

    function vendor_strat_kpa() # AOKP-4.4|AICP|PAC-5.1|Krexus-CAF|AOSPA|Non-CAFs
    {
        cd ${CALL_ME_ROOT};
        cd vendor/${ROMNIS}/products;

        function bootanim()
        {
            echo -e "${INF} Device Resolution\n";
            if [ ! -z "$automate" ]; then
                gimme_info "bootres";
                echo -e "${QN} Enter the Desired Highlighted Number\n";
                prompt SBBTR;
            else
                echo -e "${INF} ${ATBT} Resolution Chosen : ${SBBTR}";
            fi
        } # bootanim

        #Vendor-Calls
        case "$ROMNIS" in
            "aicp")
                VENF="${SBDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${VENF}" >> AndroidProducts.mk;
                echo -e "\n# Inherit telephony stuff\n\$(call inherit-product, vendor/${ROMNIS}/configs/telephony.mk)" >> $VENF;
                echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> $VENF;
                ;;
            "aokp")
                bootanim;
                VENF="${SBDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${VENF}" >> AndroidProducts.mk;
                echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)" >> $VENF;
                echo -e "\nPRODUCT_COPY_FILES += \\ " >> $VENF;
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
                mv -f ${CALL_ME_ROOT}${DEVDIR}/*.dependencies ${SBDEV}/pa.dependencies;
                ;;
            "pac")
                bootanim;
                VENF="${ROMNIS}_${SBDEV}.mk";
                echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/pac_common.mk)" >> $VENF;
                echo -e "\nPAC_BOOTANIMATION_NAME := ${SBBTR};" >> $VENF;
                ;;
            "pure") # PureNexus and ABC rom
                VENF="${SBDEV}.mk";
                echo -e "# Include pure configuration\ninclude vendor/pure/configs/pure_phone.mk" >> $VENF;
                ;;
        esac
        find_ddc "pb";
        echo -e "\n# Inherit from ${DDC}" >> $VENF;
        echo -e "\$(call inherit-product, ${DEVDIR}/${DDC})" >> $VENF;
        # PRODUCT_NAME is the only ROM-specific Identifier, setting it here is better.
        echo -e "\n# ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${SBDEV}" >> $VENF;
    } # vendor_strat_kpa

    function find_ddc() # For Finding Default Device Configuration file
    {
        # Get all the ROMNIS values - Duplicates doesn't matter
        ROMC=( `for CT in {1..39}; do rom_names "${SBRN}"; echo "${ROMNIS}"; done` );
        for ROM in ${ROMC[*]}; do
            # Possible Default Device Configuration (DDC) Files
            DDCS=( ${ROM}_${SBDEV}.mk full_${SBDEV}.mk aosp_${SBDEV}.mk ${ROM}.mk );
            # Makefiles are arranged according to their priority of Usage
            # ROM.mk is the most used, ROM_DEVICE.mk is the least used.
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
        echo -e "\n${EXE} Creating Interactive Makefile for getting Identified by the ROM's BuildSystem\n";
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
            echo -e "\n# Calling Default Device Configuration File" >> ${INTM};
            echo -e "\$(call inherit-product, ${DEVDIR}/${DDC})" >> ${INTM};
            # To prevent Missing Vendor Calls in DDC-File
            sed -i -e 's/inherit-product, vendor\//inherit-product-if-exists, vendor\//g' $DDC;
            # Add User-desired Makefile Calls
            echo -e "${QN} Missed some Makefile calls\n${INF} Enter number of Desired Makefile calls\n${INF} Enter 0 if none";
            ST="No of Makefile Calls"; shut_my_mouth NMK "$ST";
            for (( CT=0; CNT<"${SBNMK}"; CT++ )); do
                echo -e "\n${QN} Enter Makefile location from Root of BuildSystem";
                ST="Makefile"; shut_my_mouth LOC[$CNT] "$ST" array;
                if [ -f ${CALL_ME_ROOT}${SBLOC[$CNT]} ]; then
                    echo -e "\n${EXE} Adding Makefile `$[ $CNT + 1 ]` ";
                    echo -e "\n\$(call inherit-product, ${SBLOC[$CNT]})" >> ${INTM};
                else
                    echo -e "${FLD} Makefile ${SBLOC[$CNT]} not Found. Aborting";
                fi
            done
            unset CT;
            echo -e "\n# ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${SBDEV}" >> ${INTM};
            # Make it Identifiable
            mv ${INTM} ${INTF};
            echo -e "${EXE} Renaming .dependencies file\n";
            [ ! -f ${ROMNIS}.dependencies ] && mv -f *.dependencies ${ROMNIS}.dependencies;
            echo -e "${SCS} Done.";
            cd ${CALL_ME_ROOT};
        } # create_imk

        find_ddc "intm";
        if [[ "$DDC" != "NULL" ]]; then create_imk; else echo "$NOINT"; fi;
    } # interactive_mk

    function need_for_int()
    {
        if [ -f ${CALL_ME_ROOT}${DEVDIR}/${INTF} ]; then
            echo "$NOINT";
        else
            interactive_mk "$SBRN";
        fi
    } # need_for_int

    echo -e "\n${EXE} ${ROMNIS}-fying Device Tree\n";
    NOINT=$(echo -e "${SCS} Interactive Makefile Unneeded, continuing");

    case "$SBRN" in
        aosp|eos|omni|zos) # AOSP-CAF/RRO|Euphoria|F-AOSP|Flayr|OmniROM|Parallax|Zephyr
            VNF="common";
            [[ "$SBRN" == "13" ]] && INTF="${ROMNIS}.mk" || INTF="${ROMNIS}_${SBDEV}.mk";
            need_for_int;
            rm -rf ${DEVDIR}/AndroidProducts.mk;
            echo -e "PRODUCT_MAKEFILES :=  \\ \n\t\$(LOCAL_DIR)/${INTF}" >> AndroidProducts.mk;
            ;;
        aosip) # AOSiP-CAF
            if [ ! -f vendor/${ROMNIS}/products ]; then
                VNF="common";
                INTF="${ROMNIS}.mk";
                need_for_int;
            else
                echo "$NOINT";
            fi
            ;;
        aokp|pac) # AOKP-4.4|PAC-5.1
            if [ ! -f vendor/${ROMNIS}/products ]; then
                VNF="$SBDTP";
                INTF="${ROMNIS}.mk"
                need_for_int;
            else
                echo "$NOINT";
            fi
            ;;
        aicp|krexus|pa|pure|krexus|nitrogen|pure) # AICP|Krexus-CAF|AOSPA|Non-CAFs except DU
            echo "$NOINT";
            ;;
        *) # Rest of the ROMs
            VNF="$SBDTP";
            INTF="${ROMNIS}.mk"
            need_for_int;
            ;;
    esac

    choose_target;
    if [ -d vendor/${ROMNIS}/products ]; then # [ -d vendor/aosip ] <- Temporarily commented
        if [ ! -f vendor/${ROMNIS}/products/${ROMNIS}_${SBDEV}.mk ] ||
            [ ! -f vendor/${ROMNIS}/products/${SBDEV}.mk ] ||
             [ ! -f vendor/${ROMNIS}/products/${SBDEV}/${ROMNIS}_${SBDEV}.mk ]; then
            vendor_strat_kpa; # if found products folder, go ahead
        else
            echo -e "\n${SCS} Looks like ${SBDEV} has been already added to ${ROM_FN} vendor. Good to go\n";
        fi
    else
        vendor_strat_all; # if not found, normal strategies
    fi
    cd ${CALL_ME_ROOT};
    sleep 2;
    export action_1="init" action_2="pre_build";
    [ -z "$automate" ] && quick_menu;
} # pre_build

function build() # 4
{
    # Change terminal title
    [ ! -z "$automate" ] && teh_action 4;

    function hotel_menu()
    {
        echo -e "${CL_WYT}=====================${NONE} ${CL_LBL}Hotel Menu${NONE} ${CL_WYT}======================${NONE}\n";
        echo -e "[*] ${CL_WYT}lunch${NONE} - Setup Build Environment for the Device";
        echo -e "[*] ${CL_WYT}breakfast${NONE} - Download Device Dependencies and lunch";
        echo -e "[*] ${CL_WYT}brunch${NONE} - breakfast + lunch then Start Build\n";
        echo -e "${QN} Type in the desired option\n";
        echo -e "${INF} Building for a new Device ? select ${CL_WYT}lunch${NONE}";
        echo -e "${CL_WYT}=======================================================${NONE}\n";
        ST="Selected Option"; shut_my_mouth SLT "$ST";
        case "$SBSLT" in
            "lunch")
                cmdprex \
                    "CommandName<->${SBSLT}" \
                    "Target Name<->${TARGET}";
                ;;
            "breakfast")
                cmdprex \
                    "CommandName<->${SBSLT}" \
                    "Device Codename<->${SBDEV}" \
                    "ROM BuildType<->${SBBT}";
                ;;
            "brunch")
                echo -e "\n${EXE} Starting Compilation - ${ROM_FN} for ${SBDEV}\n";
                cmdprex \
                    "CommandName<->${SBSLT}" \
                    "Device Codename<->${SBDEV}";
                ;;
            *) echo -e "${FLD} Invalid Selection.\n"; hotel_menu ;;
        esac
        echo;
    } # hotel_menu

    function build_make()
    {
        if [[ "$1" != "brunch" ]]; then
            START=$(date +"%s"); # Build start time
            # Showtime!
            [[ "$SBMK" != "mka" ]] && BCORES="-j${BCORES}";
            # Sequence - GZRs | AOKP | AOSiP | A lot of ROMs | All ROMs
            for MAKECOMMAND in ${ROMNIS} rainbowfarts kronic bacon otapackage; do
                if [[ $(grep -c "^${MAKECOMMAND}:" "${CALL_ME_ROOT}build/core/Makefile") == "1" ]]; then
                    cmdprex --out="${RMTMP}" \
                    "Command<->${SBMK}" \
                    "Zip target name<->${MAKECOMMAND}" \
                    "No. of cores<->${BCORES}";
                    break;  # Building one target is enough
                fi
            done
            END=$(date +"%s"); # Build end time
            SEC=$(($END - $START)); # Difference gives Build Time
            if [ -z "$STS" ]; then
                echo -e "\n${FLD} Build Status : Failed";
            else
                echo -e "\n${SCS} Build Status : Success";
            fi
            echo -e "\n${INF} ${CL_WYT}Build took $(($SEC / 3600)) hour(s), $(($SEC / 60 % 60)) minute(s) and $(($SEC % 60)) second(s).${NONE}" | tee -a rom_compile.txt;
        fi
    } # build_make

    function make_module()
    {
        if [ -z "$1" ]; then
            echo -e "\n${QN} Know the Location of the Module : \n";
            prompt KNWLOC;
        fi
        if [[ "$KNWLOC" == "y" || "$1" == "y" ]]; then
            echo -e "${QN} Specify the directory which builds the module\n";
            prompt MODDIR;
            echo -e "\n${QN} Push module to the Device (through ADB, running the same ROM) ${CL_WYT}[y/n]${NONE}\n";
            prompt PMOD;
            echo;
            case "$PMOD" in
                [Yy])
                    cmdprex \
                     "make module and push it to device<->mmmp" \
                     "Force Rebuild the module<->-B" \
                     "Module Directory<->${MODDIR}"
                     ;;
                [Nn])
                    cmdprex \
                     "make-module<->mmm" \
                     "Force Rebuild the module<->-B" \
                     "Module Directory<->$MODDIR"
                     ;;
                *) echo -e "${FLD}Invalid Selection.\n"; make_it ;;
            esac
        else
            echo -e "${INF} Do either of these two actions:\n1. Google it (Easier)\n2. Run this command in terminal : grep \"LOCAL_MODULE := <Insert_MODULE_NAME_Here> \".\n\n Press ENTER after it's Done..\n";
            read;
            make_it;
        fi
    } # make_module

    function custuserhost()
    {
        echo -e "\n${QN} Enter the User name [$(whoami)]\n";
        ST="Custom Username"; shut_my_mouth CU "$ST";
        cmdprex \
            "Mark variable to be Inherited by child processes<->export" \
            "Variable to Set Custom User<->KBUILD_BUILD_USER=${SBCU:-$(whoami)}";
        echo -e "\n${QN} Enter the Host name [$(hostname)]\n";
        ST="Custom Hostname"; shut_my_mouth CH "$ST";
        cmdprex \
            "Mark variable to be Inherited by child processes<->export" \
            "Variable to Set Custom Host<->KBUILD_BUILD_HOST=${SBCH:-$(hostname)}";
        echo -e "\n${INF} You're building on ${CL_WYT}${KBUILD_BUILD_USER}@${KBUILD_BUILD_HOST}${NONE}";
        echo -e "\n${SCS} Done\n";
        [ -z "$automate" ] && [ "$SBKO" != "5" ] && kbuild;
    } # custuserhost

    function kbuild()
    {
        function kinit()
        {
            echo -e "${QN} Enter the location of the Kernel source\n";
            ST="Kernel Location"; shut_my_mouth KL "$ST";
            if [ -f ${SBKL}/Makefile ]; then
                echo -e "\n${SCS} Kernel Makefile found";
                cd ${SBKL};
            else
                echo -e "\n${FLD} Kernel Makefile not found. Aborting";
                quick_menu;
            fi
            echo -e "\n${QN} Enter the codename of your device\n";
            ST="Codename"; shut_my_mouth DEV "$ST";
            KDEFS=( `ls arch/*/configs/*${SBDEV}*_defconfig` );
            for((CT=0;CT<${#KDEFS[*]};CT++)); do
                echo -e "$((${CT}+1)). ${KDEFS[$CT]}";
            done
            unset CT;
            echo -e "\n${INF} These are the available Kernel Configurations\n\n${QN} Select the one according to the CPU Architecture\n";
            if [ -z "$automate" ]; then
                prompt CT;
                SBKD=`eval echo "\${KDEFS[$(($CT-1))]}" | awk -F "/" '{print $4}'`;
                SBKA=`eval echo "\${KDEFS[$(($CT-1))]}" | awk -F "/" '{print $2}'`;
            fi
            echo -e "\n${INF} Arch : ${SBKA}";
            echo -e "\n${QN} Number of Jobs / Threads\n";
            BCORES=$(grep -c ^processor /proc/cpuinfo); # CPU Threads/Cores
            echo -e "${INF} Maximum No. of Jobs -> ${CL_WYT}${BCORES}${NONE}\n";
            ST="Number of Jobs"; shut_my_mouth NT "$ST";
            if [[ "$SBNT" > "$BCORES" ]]; then # Y u do dis
                echo -e "\n${FLD} Invalid Response\n";
                SBNT="$BCORES";
                echo -e "${INF} Using Maximum no of threads : $BCORES";
            fi
            export action_kinit="done";
            [ -z "$automate" ] && [ "$SBKO" != "5" ] && kbuild;
        } # kinit

        function settc()
        {
            echo -e "\n${INF} Make sure you have downloaded (synced) a Toolchain for compiling the kernel";
            echo -e "\n${QN} Point me to the location of the toolchain\n";
            ST="Toolchain Location"; shut_my_mouth KTL "$ST";
            if [[ -d "${SBKTL}" ]]; then
                KCCP=$(ls ${SBKTL}/bin/${SBKA}*gcc | sed -e 's/gcc//g' -e 's/.*bin\///g');
                if [[ ! -z "${KCCP}" ]]; then
                    echo -e "\n${SCS} Toolchain Detected\n";
                    echo -e "${INF} Toolchain Prefix : ${KCCP}\n";
                else
                    echo -e "${FLD} Toolchain Binaries not found\n";
                fi
            else
                echo -e "${FLD} Directory not found\n";
            fi
            [ -z "$automate" ] && [ "$SBKO" != "5" ] && kbuild;
        } # settc

        function kclean()
        {
            export ARCH="${SBKA}" CROSS_COMPILE="${SBKTL}/bin/${KCCP}";
            echo -e "\n${INF} Cleaning Levels\n";
            echo -e "1. Clean Intermediate files";
            echo -e "2. 1 + Clean the Current Kernel Configuration\n";
            ST="Clean Method"; shut_my_mouth CK "$ST";
            case "${SBCK}" in
                1)
                    cmdprex \
                        "CommandName<->make" \
                        "TargetName<->clean" \
                        "No. of Jobs<->-j${SBNT}" \
                    ;;
                2)
                    cmdprex \
                        "CommandName<->make" \
                        "TargetName<->mrproper" \
                        "No. of Jobs<->-j${SBNT}" \
                    ;;
            esac
            echo -e "\n${SCS} Kernel Cleaning done\n\n${INF} Check output for details\n";
            export action_kcl="done";
            [ -z "$automate" ] && [ "$SBKO" != "5" ] && kbuild;
        } # kclean

        function mkkernel()
        {
            # Execute these before building kernel
            [ -z "${action_kinit}" ] && kinit;
            [ -z "${KCCP}" ] && settc;
            [ -z "${action_kcl}" ] && kclean;
            [ ! -z "${SBCUH}" ] && custuserhost;

            echo -e "\n${EXE} Compiling the Kernel\n";
            cmdprex \
                "Mark variable to be Inherited by child processes<->export" \
                "Set CPU Architecture<->ARCH=\"${SBKA}\"" \
                "Set Toolchain Location<->CROSS_COMPILE=\"${SBKTL}/bin/${KCCP}\"";
            [ ! -z "$SBNT" ] && SBNT="-j${SBNT}";
            cmdprex \
                "CommandName<->make" \
                "Defconfig to be Initialized<->${SBKD}";
            cmdprex \
                "CommandName<->make" \
                "No. of Jobs<->${SBNT}";
            if [[ ! -z "${STS}" ]]; then
                echo -e "\n${SCS} Compiled Successfully\n";
            else
                echo -e "\n${FLD} Compilation failed\n";
            fi
            [ -z "$automate" ] && kbuild;
        } # mkkernel

        echo -ne "\033]0;ScriBt : KernelBuilding\007";
        echo -e "===============${CL_LCN}[!]${NONE} ${CL_WYT}Kernel Building${NONE} ${CL_LCN}[!]${NONE}=================";
        echo -e "Building on : ${KBUILD_BUILD_USER:-$(whoami)}@${KBUILD_BUILD_HOST:-$(hostname)}";
        echo -e "Arch : ${SBKA:-Not Set}";
        echo -e "Definition Config : ${SBKD:-Not Set}";
        echo -e "Toolchain : ${SBKTL:-Not Set}\n";
        echo -e "1. Initialize the Kernel";
        echo -e "2. Setup Toolchain";
        echo -e "3. Clean Kernel output";
        echo -e "4. Set Custom User and Host Names";
        echo -e "5. Build the kernel";
#       echo -e "X. Setup Custom Toolchain";
        echo -e "0. Quick Menu";
        echo -e "=======================================================\n";
        ST="Selected Option"; shut_my_mouth KO "$ST";
        case "$SBKO" in
            0)
                cd ${CALL_ME_ROOT};
                quick_menu;
                ;;
            1) kinit ;;
            2) settc ;;
            3) kclean ;;
            4) custuserhost ;;
            5) mkkernel ;;
#           X) dwntc ;;
            *) echo -e "${FLD} Invalid Selection" ;;
        esac
    } # kbuild

    function patchmgr()
    {
        function check_patch()
        {
            (patch -p1 -N --dry-run < $1 1> /dev/null 2>&1 && echo -n 0) || # Patch is not applied but can be applied
            (patch -p1 -R --dry-run < $1 1> /dev/null 2>&1 && echo -n 1) || # Patch is applied
            echo -n 2; # Patch can not be applied
        } # check_patch

        function apply_patch()
        {
            case $(check_patch "$1") in
                0) echo -en "\n${EXE} Patch is being applied\n";
                   patch -p1 -N < $1 > /dev/null;
                   ([ "$?" == 0 ] && echo -e "${SCS} Patch Successfully Applied") || echo -e "${FLD} Patch Application Failed";; # Patch is being applied
                1) echo -en "\n${EXE} Patch is being reversed\n";
                   patch -p1 -R < $1 > /dev/null;
                   ([ "$?" == 0 ] && echo -e "${SCS} Patch Successfully Reversed") || echo -e "${FLD} Patch Reverse Failed";  # Patch is being reversed
                   ;;
                2) echo -e "\n${EXE} Patch can't be applied." ;; # Patch can not be applied
            esac
        } # apply_patch

        function visual_check_patch()
        {
            case $(check_patch "$1") in
                0) echo -en "[${CL_RED}N${NONE}]" ;; # Patch is not applied but can be applied
                1) echo -en "[${CL_GRN}Y${NONE}]" ;; # Patch is applied
                2) echo -en "[${CL_BLU}X${NONE}]" ;; # Patch can not be applied
            esac
        } # visual_check_patch

        function show_patches()
        {
            cd $CALL_ME_ROOT;
            unset PATCHES;
            unset PATCHDIRS;
            PATCHDIRS=("device/*/*/patch" "patch");
            echo -e "\n${EXE} Searching for patches\n";
            echo -e "==================== ${CL_LRD}Patch Manager${NONE} ====================\n";
            echo -e "0. Exit the Patch Manager";
            echo -e "1. Launch the Patch Creator";
            CT=2;
            for PATCHDIR in "${PATCHDIRS[@]}"; do
                if find ${PATCHDIR}/* 1> /dev/null 2>&1; then
                    while read PATCH; do
                        if [ -s "$PATCH" ]; then
                            PATCHES[$CT]=$PATCH;
                            echo -e ${CT}. $(visual_check_patch "$PATCH") $PATCH;
                            ((CT++));
                        fi
                    done <<< "$(find ${PATCHDIR}/* | grep -v '\/\*')";
                fi
            done
        } # show_patches

        function patch_creator()
        {
            if [ ! -d ".repo" ]; then # We are not inside a repo
                echo -e "\n${FLD} You are not inside a repo (or the .repo folder was not found)";
            else
                echo -e "\n${QN} Do you want to generate a patch file out of unstaged changes (May take a long time)";
                echo -e "${INF} WARNING: Changes outside of the repos listed in the manifest will NOT be recognized!\n";
                prompt CREATE_PATCH;
                if [[ "$CREATE_PATCH" =~ [Yy] ]]; then
                    echo -e "\n${INF} Where do you want to save the patch?\n${INF} Make sure the directory exists\n\n";
                    prompt PATCH_PATH;
                    PROJECTS="$(repo list -p)"; # Get all teh projects
                    PROJECT_COUNT=$(wc -l <<< "$PROJECTS"); # Count all teh projects
                    [ -f "${CALL_ME_ROOT}${PATCH_PATH}" ] && rm -rf ${CALL_ME_ROOT}${PATCH_PATH} # Delete existing patch
                    CT=1;
                    echo "";
                    while read PROJECT; do # repo foreach does not work, as it seems to spawn a subshell
                        cd ${CALL_ME_ROOT}${PROJECT};
                        git diff |
                          sed -e "s@ a/@ a/${PROJECT}/@g" |
                          sed -e "s@ b/@ b/${PROJECT}/@g" >> ${CALL_ME_ROOT}${PATCH_PATH}; # Extend a/ and b/ with the project's path, as git diff only outputs the paths relative to the git repository's root
                        echo -en "\033[KGenerated patch for repo $CT of $PROJECT_COUNT\r";  # Count teh processed repos
                        ((CT++));
                    done <<< "$PROJECTS";
                    cd ${CALL_ME_ROOT};
                    echo -e "\n\n${SCS} Done.";
                    [ ! -s "${CALL_ME_ROOT}${PATCH_PATH}" ] &&
                      rm ${CALL_ME_ROOT}${PATCH_PATH} &&
                      echo -e "${INF} Patch was empty, so it was deleted";
                fi
            fi
        } # patch_creator

        function patcher()
        {
            show_patches;
            echo -e "\n=======================================================\n";
            prompt PATCHNR;
            case "$PATCHNR" in # Process śpecial actions
                0) quick_menu ;; # Exit the Patch Manager and return to Quick Menu
                1)
                    patch_creator;
                    patcher;
                    ;;
                *)
                    [ "${PATCHES[$PATCHNR]}" ] && apply_patch "${PATCHES[$PATCHNR]}" ||
                    echo -e "\n${FLD} Invalid selection: $PATCHNR";
                    patcher;
                    ;;
            esac
        } # patcher

        patcher;
    } # patchmgr

    function build_menu()
    {
        echo -e "\n${CL_WYT}=======================================================${NONE}\n";
        echo -e "${QN} Select a Build Option:\n";
        echo -e "1. Start Building ROM (ZIP output) (Clean Options Available)";
        echo -e "2. Make a Particular Module";
        echo -e "3. Setup CCACHE for Faster Builds";
        echo -e "4. Kernel Building";
        echo -e "5. Patch Manager";
        echo -e "0. Quick Menu\n";
        echo -e "${CL_WYT}=======================================================\n";
        ST="Option Selected"; shut_my_mouth BO "$ST";
    } # build_menu

    build_menu;
    case "$SBBO" in
        0) quick_menu ;;
        1)
            if [ -d .repo ]; then
                # Get Missing Information
                [ -z "$action_1" ] && rom_select;
                [ -z "$action_2" ] && device_info;
                # Change terminal title
                [ ! -z "$automate" ] && teh_action 4;
            else
                echo -e "${FLD} ROM Source Not Found (Synced)\n${FLD} Please perform an init and sync before doing this";
                exitScriBt 1;
            fi
            init_bld;
            choose_target;
            echo -e "\n${QN} Should i use 'make' or 'mka'\n"; gimme_info "make";
            ST="Selected Method"; shut_my_mouth MK "$ST";
            case "$SBMK" in
                "make")
                    echo -e "\n${QN} Number of Jobs / Threads";
                    BCORES=$(grep -c ^processor /proc/cpuinfo); # CPU Threads/Cores
                    echo -e "${INF} Maximum No. of Jobs -> ${CL_WYT}${BCORES}${NONE}";
                    ST="Number of Jobs"; shut_my_mouth NT "$ST";
                    if [[ "$SBNT" > "$BCORES" ]]; then # Y u do dis
                        echo -e "\n${FLD} Invalid Response\n";
                        echo -e "\n${INF} Restart ScriBt from here\n"
                        exitScriBt 1;
                    fi
                    ;;
                "mka") BCORES="" ;; # mka utilizes max resources
                *)
                    echo -e "\n${FLD} No response received\n";
                    echo -e "${EXE} Using ${CL_WYT}mka${NONE}";
                    SBMK="mka"; BCORES="";
                    ;;
            esac
            echo -e "${QN} Want to keep /out in another directory ${CL_WYT}[y/n]${NONE}\n"; gimme_info "outdir";
            ST="Another /out dir ?"; shut_my_mouth OD "$ST";
            case "$SBOD" in
                [Yy])
                    echo -e "${INF} Enter the Directory location from /  -  an ${CL_WYT}out${NONE} folder will be created under that directory\n";
                    ST="/out location"; shut_my_mouth OL "$ST";
                    if [ -d "$SBOL" ]; then
                        [ ! -d out ] && mkdir -pv out;
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Set Custom Output Directory<->OUT_DIR=\"${SBOL}/out\"";
                    else
                        echo -e "${INF} /out location is unchanged";
                    fi
                    ;;
                [Nn])
                    echo -e "${INF} /out location is unchanged";
                    ;;
            esac
            echo -e "${QN} Want to Clean the /out before Building\n"; gimme_info "outcln";
            ST="Option Selected"; shut_my_mouth CL "$ST";
            if [[ $(grep -c 'BUILD_ID=M' ${CALL_ME_ROOT}build/core/build_id.mk) == "1" ]]; then
                echo -e "${QN} Use Jack Toolchain ${CL_WYT}[y/n]${NONE}\n"; gimme_info "jack";
                ST="Use Jacky"; shut_my_mouth JK "$ST";
                case "$SBJK" in
                    [yY])
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Enable Jack<->ANDROID_COMPILE_WITH_JACK=true"
                        ;;
                    [nN])
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Disable Jack<->ANDROID_COMPILE_WITH_JACK=false"
                        ;;
                esac
            fi
            if [[ $(grep -c 'BUILD_ID=N' ${CALL_ME_ROOT}build/core/build_id.mk) == "1" ]]; then
                echo -e "${QN} Use Ninja to build Android ${CL_WYT}[y/n]${NONE}\n"; gimme_info "ninja";
                ST="Use Ninja"; shut_my_mouth NJ "$ST";
                case "$SBNJ" in
                    [yY])
                        echo -e "\n${INF} Building Android with Ninja BuildSystem";
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Use Ninja<->USE_NINJA=true";
                        ;;
                    [nN])
                        echo -e "\n${INF} Building Android with the Non-Ninja BuildSystem\n";
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Disable Ninja<->USE_NINJA=false";
                        cmdprex \
                            "CommandName<->unset" \
                            "Unsetting this Var removes Ninja temp files<->BUILDING_WITH_NINJA";
                        ;;
                    *) echo -e "${FLD} Invalid Selection.\n" ;;
                esac
            fi
            case "$SBCL" in
                1)
                    cmdprex \
                        "CommandName<->lunch" \
                        "Build Target Name<->${TARGET}";
                    cmdprex \
                        "CommandName<->$SBMK" \
                        "TargetName to Remove Staging Files<->installclean";
                    ;;
                2)
                    cmdprex \
                        "CommandName<->lunch" \
                        "Build Target Name<->${TARGET}";
                    cmdprex \
                        "CommandName<->$SBMK" \
                        "TargetName to Remove Entire Build Output<->clean";
                    ;;
                *) echo -e "${INF} No Clean Option Selected.\n" ;;
            esac
            echo -e "${QN} Set a custom user/host ${CL_WYT}[y/n]${NONE}";
            ST="Custom user@host"; shut_my_mouth CUH "$ST";
            [[ "$SBCUH" =~ (Y|y) ]] && custuserhost;
            hotel_menu;
            build_make "$SBSLT";
            ;;
        2) make_module ;;
        3) set_ccvars ;;
        4) kbuild ;;
        5) patchmgr ;;
        *)
            echo -e "${FLD} Invalid Selection.\n";
            build;
            ;;
    esac
    export action_3="build";
} # build

function tools() # 5
{
    # change terminal title
    [ ! -z "$automate" ] && teh_action 5;

    function installdeps()
    {
        echo -e "\n${EXE} Analyzing Distro";
        for REL in lsb-release os-release debian-release; do
            if [ -f "/etc/${REL}" ]; then
                source /etc/${REL};
                case "$REL" in
                    "lsb-release") DID="${DISTRIB_ID}"; VER="${DISTRIB_RELEASE}" ;;
                    "os-release") DID="${ID}"; VER="${VERSION_ID}" ;; # Most of the Newer Distros
                    "debian-release") DID="debian" VER=`cat /etc/debian-release` ;;
#                   "other-release") DID="Distro Name (Single Worded)"; VER="Version (Single numbered)" ;;
                esac
            fi
        done
        dist_db "$DID" "$VER"; # Determination of Distro by a Database
        [[ ! -z "$DID"  && ! -z "$VER" ]] && \
        echo -e "\n${SCS} Distro Detected Successfully" || \
        (echo -e "\n${FLD} Distro not present in supported Distros\n\n${INF} Contact the Developer for Support\n"; quick_menu);

        echo -e "\n${EXE} Installing Build Dependencies\n";
        # Common Packages
        COMMON_PKGS=( git-core git gnupg flex bison gperf build-essential zip curl \
        libxml2-utils xsltproc g++-multilib squashfs-tools zlib1g-dev \
        pngcrush schedtool python lib32z1-dev lib32z-dev lib32z1 \
        libxml2 optipng python-networkx python-markdown make unzip );
        case "$DYR" in
            D12)
                DISTRO_PKGS=( libc6-dev libncurses5-dev:i386 x11proto-core-dev \
                libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
                libgl1-mesa-dev libwxgtk2.8-dev mingw32 tofrodos zlib1g-dev:i386 ) ;;
            D13)
                DISTRO_PKGS=( zlib1g-dev:i386 libc6-dev lib32ncurses5 \
                lib32bz2-1.0 lib32ncurses5-dev x11proto-core-dev \
                libx11-dev:i386 libreadline6-dev:i386 \
                libgl1-mesa-glx:i386 libgl1-mesa-dev libwxgtk2.8-dev \
                mingw32 tofrodos readline-common libreadline6-dev libreadline6 \
                lib32readline-gplv2-dev libncurses5-dev lib32readline5 \
                lib32readline6 libreadline-dev libreadline6-dev:i386 \
                libreadline6:i386 bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev \
                lib32bz2-dev libsdl1.2-dev libesd0-dev ) ;;
            D14)
                DISTRO_PKGS=( libc6-dev-i386 lib32ncurses5-dev liblz4-tool \
                x11proto-core-dev libx11-dev libgl1-mesa-dev maven maven2 libwxgtk2.8-dev) ;;
            D15)
                DISTRO_PKGS=( libesd0-dev liblz4-tool libncurses5-dev \
                libsdl1.2-dev libwxgtk2.8-dev lzop maven maven2 \
                lib32ncurses5-dev lib32readline6-dev liblz4-tool ) ;;
            D16)
                DISTRO_PKGS=( automake lzop libesd0-dev maven \
                liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev \
                lzop lib32ncurses5-dev lib32readline6-dev lib32z1-dev \
                libbz2-dev libbz2-1.0 libghc-bzlib-dev ) ;;
        esac
        # Install 'em all
        cmdprex \
            "Command Execution as 'root'<->execroot" \
            "Commandline Package Manager<->apt-get" \
            "Keyword for Installing Package<->install" \
            "Answer 'yes' to prompts<->-y" \
            "Packages list<->${COMMON_PKGS[*]} ${DISTRO_PKGS[*]}";
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
                    execroot pacman -Rddns --noconfirm ${item};
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
        echo -e "${CL_WYT}=======================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt")
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Maintains symlinks for default commands<->update-alternatives"
                    "Configure command symlink<->--config" \
                    "Command to Configure<->java";
                echo -e "\n${CL_WYT}=======================================================${NONE}\n";
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Maintains symlinks for default commands<->update-alternatives"
                    "Configure command symlink<->--config" \
                    "Command to Configure<->javac";
                ;;
            "pacman")
                archlinux-java status;
                echo -e "${QN} Please enter desired version (eg. \"java-7-openjdk\")\n";
                prompt ARCHJA;
                execroot archlinux-java set ${ARCHJA};
                ;;
        esac
        echo -e "\n${CL_WYT}=======================================================${NONE}";
    } # java_select

    function java_check()
    {
      if [[ $( java -version &> $TMP; grep -c "version \"1.$1" $TMP ) == "1" ]]; then
          echo -e "\n${CL_WYT}=======================================================${NONE}";
          echo -e "${SCS} OpenJDK-$1 or Java 1.$1.0 has been successfully installed";
          echo -e "${CL_WYT}=======================================================${NONE}";
      fi
    } # java_check

    function java_install()
    {
        echo -ne "\033]0;ScriBt : Java $1\007";
        echo -e "\n${EXE} Installing OpenJDK-$1 (Java 1.$1.0)";
        echo -e "\n${INF} Remove other Versions of Java ${CL_WYT}[y/n]${NONE}? : \n";
        prompt REMOJA;
        echo;
        case "$REMOJA" in
            [yY])
                case "${PKGMGR}" in
                    "apt")
                        cmdprex \
                            "Command Execution as 'root'<->execroot" \
                            "Commandline Package Manager<->apt-get" \
                            "Keyword to Remove Packages<->purge" \
                            "Packages to be purged<->openjdk-* icedtea-* icedtea6-*"
                            ;;
                    "pacman") execroot pacman -Rddns $( pacman -Qqs ^jdk ) ;;
                esac
                echo -e "\n${SCS} Removed Other Versions successfully"
                ;;
            [nN]) echo -e "${EXE} Keeping them Intact" ;;
            *)
                echo -e "${FLD} Invalid Selection.\n";
                java_install $1;
                ;;
        esac
        echo -e "\n${CL_WYT}=======================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt")
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Commandline Package Manager<->apt-get" \
                    "Answer 'yes' to prompts<->-y" \
                    "Update Packages List<->update";
                ;;
            "pacman") execroot pacman -Sy ;;
        esac
        echo -e "\n${CL_WYT}=======================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt")
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Commandline Package Manager<->apt-get" \
                    "Keyword for Installing Package<->install" \
                    "Answer 'yes' to prompts<->-y" \
                    "OpenJDK PackageName<->openjdk-$1-jdk";
                ;;
            "pacman") execroot pacman -S jdk$1-openjdk ;;
        esac
        java_check $1;
    } # java_install

    function java_ppa()
    {
        if [[ ! $(which add-apt-repository) ]]; then
            echo -e "${EXE} add-apt-repository not present. Installing it";
            cmdprex \
                "Command Execution as 'root'<->execroot" \
                "Commandline Package Manager<->apt-get" \
                "Keyword for Installing Package<->install" \
                "WiP<->software-properties-common";
        fi
        cmdprex \
            "Command Execution as 'root'<->execroot" \
            "Add PPA for apt<->add-apt-repository" \
            "OpenJDK PPA<->ppa:openjdk-r/ppa" \
            "Answer 'yes' to prompts<->-y";
        cmdprex \
            "Command Execution as 'root'<->execroot" \
            "Commandline Package Manager<->apt-get" \
            "Answer 'yes' to prompts<->-y" \
            "Update Packages List<->update";
        cmdprex \
            "Command Execution as 'root'<->execroot" \
            "Commandline Package Manager<->apt-get" \
            "Keyword for Installing Package<->install" \
            "Answer 'yes' to prompts<->-y" \
            "OpenJDK PackageName<->openjdk-$1-jdk";
        java_check $1;
    } # java_ppa

    function java_menu()
    {
        echo -e "\n${CL_WYT}===================${NONE} ${CL_YEL}JAVA${NONE} Installation ${CL_WYT}=================${NONE}\n";
        echo -e "1. Install Java";
        echo -e "2. Switch Between Java Versions / Providers\n";
        echo -e "0. Quick Menu\n";
        echo -e "${INF} ScriBt installs Java by OpenJDK";
        echo -e "\n${CL_WYT}=======================================================\n${NONE}";
        prompt JAVAS;
        case "$JAVAS" in
            0)  quick_menu ;;
            1)
                echo -ne '\033]0;ScriBt : Java\007';
                echo -e "\n${QN} Android Version of the ROM you're building";
                echo -e "1. Java 1.6.0 (4.4.x Kitkat)";
                echo -e "2. Java 1.7.0 (5.x.x Lollipop && 6.x.x Marshmallow)";
                echo -e "3. Java 1.8.0 (7.x.x Nougat)\n";
                [[ "${PKGMGR}" == "apt" ]] && echo -e "4. Ubuntu 16.04 & Want to install Java 7\n5. Ubuntu 14.04 & Want to install Java 8\n";
                prompt JAVER;
                case "$JAVER" in
                    1) java_install 6 ;;
                    2) java_install 7 ;;
                    3) java_install 8 ;;
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
        echo -e "\n${CL_WYT}=======================================================${NONE}\n";
        echo -e "${EXE} Updating / Creating Android USB udev rules (51-android)\n";
        execroot curl -s --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules;
        execroot chmod a+r /etc/udev/rules.d/51-android.rules;
        execroot service udev restart;
        echo -e "\n${SCS} Done";
        echo -e "\n${CL_WYT}=======================================================${NONE}\n";
    } # udev_rules


    function git_creds()
    {
        echo -e "\n${INF} Enter the Details with reference to your ${CL_WYT}GitHub account${NONE}\n\n";
        sleep 2;
        echo -e "${QN} Enter the Username";
        echo -e "${INF} Username is the one which appears on the GitHub Account URL\n${INF} Ex. https://github.com/[ACCOUNT_NAME]\n";
        prompt GIT_U;
        echo -e "\n${QN} Enter the E-mail ID\n";
        prompt GIT_E;
        cmdprex \
            "git commandline<->git" \
            "Configure git<->config" \
            "Apply changes to all users<->--global" \
            "Configuration<->user.name" \
            "Value<->${GIT_U}";
        cmdprex \
            "git commandline<->git" \
            "Configure git<->config" \
            "Apply changes to all users<->--global" \
            "Configuration<->user.email" \
            "Value<->${GIT_E}";
        echo -e "\n${SCS} Done.\n"
        quick_menu;
    } # git_creds

    function check_utils_version()
    {
        # If util is repo then concatenate the file else execute it as a binary
        [[ "$1" == "repo" ]] && CAT="cat " || unset CAT;
        case "$2" in
            "utils") BIN="${CAT}utils/$1" ;; # Util Version that ScriBt has under utils folder
            "installed") BIN="${CAT}$(which $1)" ;; # Util Version that has been installed in the System
        esac
        case "$1" in # Installed Version
            "ccache") VER=`${BIN} --version | head -1 | awk '{print $3}'` ;;
            "make") VER=`${BIN} -v | head -1 | awk '{print $3}'` ;;
            "ninja") VER=`${BIN} --version` ;;
            # since repo is a python script and not a binary
            "repo") VER=`${BIN} | grep -m 1 VERSION |\
                        awk -F "= " '{print $2}' |\
                        sed -e 's/[()]//g' |\
                        awk -F ", " '{print $1"."$2}'`;
                    ;;
        esac
    } # check_utils_version

    function installer()
    {
        echo -e "\n${EXE}Checking presence of ~/bin folder\n";
        if [ -d ${HOME}/bin ]; then
            echo -e "${SCS} ${HOME}/bin present";
        else
            echo -e "${FLD} ${HOME}/bin absent\n${EXE} Creating folder ${HOME}/bin\n${EXE} `mkdir -pv ${HOME}/bin`";
        fi
        check_utils_version "$1" "utils"; # Check Binary Version by ScriBt
        echo -e "\n${EXE} Installing $1 $VER\n";
        echo -e "${QN} Do you want $1 to be Installed for";
        echo -e "\n1. This user only (${HOME}/bin)\n2. All users (/usr/bin)\n";
        prompt UIC; # utility installation choice
        case "$UIC" in
            1) IDIR="${HOME}/bin/" ;;
            2) IDIR="/usr/bin/" ;;
            *) echo -e "\n${FLD} Invalid Selection\n"; installer "$@" ;;
        esac
        cmdprex \
            "Command Execution as 'root'<->execroot" \
            "Install to directory<->install" \
            "Source Directory<->utils/$1" \
            "Destination Directory<->${IDIR}";
        check_utils_version "$1" "installed"; # Check Installed Version
        echo -e "\n${INF} Installed Version of $1 : $VER";
        if [[ "$1" == "ninja" ]]; then
            echo -e "\n${INF} To make use of Host versions of Ninja, make sure the build repo contains the following change\n";
            echo -e "https://github.com/CyanogenMod/android_build/commit/e572919037726eff75fddd68c5f18668c6d24b30";
            echo -e "\n${INF} Cherry-Pick this commit under the ${CL_WYT}build${NONE} folder/repo of the ROM you're building";
        fi
        echo -e "\n${SCS} Done\n";
    } # installer

    function scribtofy()
    {
        echo -e "\n${INF} This Function allows ScriBt to be executed under any directory";
        echo -e "${INF} Temporary Files would be present at working directory itself";
        echo -e "${INF} Older ScriBtofications, if present, would be overwritten";
        echo -e "\n${QN} Shall I ScriBtofy ${CL_WYT}[y/n]${NONE}\n";
        prompt SBFY;
        case "$SBFY" in
            [Yy])
                    echo -e "\n${EXE} Adding ScriBt to PATH";
                    echo -e "# ScriBtofy\nexport PATH=\"${CALL_ME_ROOT}:\$PATH\";" > ${HOME}/.scribt;
                    [[ $(grep 'source ${HOME}/.scribt' ${HOME}/.bashrc) ]] && echo -e "\n#ScriBtofy\nsource \${HOME}/.scribt;" >> ${HOME}/.bashrc;
                    echo -e "\n${EXE} Executing ~/.bashrc";
                    source ~/.bashrc;
                    echo -e "\n${SCS} Done\n\n${INF} Now you can ${CL_WYT}bash ROM.sh${NONE} under any directory";
                ;;
            [Nn])
                echo -e "${FLD} ScriBtofication cancelled";
                ;;
        esac
    } # scribtofy

    function update_creator() # Dev Only
    {
        [ -f ${PATHDIR}update_message.txt ] && rm ${PATHDIR}update_message.txt
        cd ${PATHDIR};

        if [ ! -d ${PATHDIR}.git ]; then # tell the user to re-clone ScriBt
            echo -e "\n${FLD} Folder ${CL_WYT}.git${NONE} not found";
            echo -e "${INF} ${CL_WYT}Re-clone${NONE} ScriBt for the update creator to work properly\n";
        else
            echo -e "\n${INF} This Function creates a new Update for ScriBt.";
            echo -e "${INF} Please make sure you are on the right commit which should be the last in the new update!";
            echo -e "${QN} Do you want to continue?\n"
            prompt CORRECT;
            if [[ "$CORRECT" =~ (y|yes) ]]; then
                CORRECT=n
                while [[ ! "$CORRECT" =~ (y|yes) ]]; do
                    echo -e "\n${INF} Please enter the version number (without the prefix v, it will be added automatically)\n";
                    prompt UPDATE_VERSION;
                    echo -e "\n${INF} The new version number is \"${UPDATE_VERSION}\"";
                    echo -e "${QN} Is this correct?\n";
                    prompt CORRECT;
                done;

                CORRECT=n
                while [[ ! "$CORRECT" =~ (y|yes) ]]; do
                    echo -e "\n${INF} Please enter the update message [Press ENTER]";
                    read
                    nano ${PATHDIR}update_message.txt;
                    echo -e "\n${INF} The new update message is\n";
                    cat ${PATHDIR}update_message.txt
                    echo -e "\n${QN} Is this correct?\n";
                    prompt CORRECT;
                done;

                echo -e "\n${QN} Do you want to sign the tag?";
                echo -e "${INF} Do it only if you have a git-compatible GPG setup\n";
                prompt QN_SIGN
                if [[ "${QN_SIGN}" =~ (y|yes) ]]; then
                    RESULT_SIGN=" -s";
                fi

                if git tag -a${RESULT_SIGN} -F "${PATHDIR}update_message.txt" "v${UPDATE_VERSION}" &> /dev/null; then
                    echo -e "\n${INF} Tag was created successfully";
                    echo -e "${QN} Do you want to upload it to the server (origin)?\n";
                    prompt QN_UPLOAD
                    if [[ "${QN_UPLOAD}" =~ (y|yes) ]]; then
                        if git push origin master && git push origin v${UPDATE_VERSION}; then
                            echo -e "\n${INF} Upload successful";
                        else
                            echo -e "\n${FLD} Upload failed";
                        fi
                    fi
                else
                    echo -e "${FLD} Failed to create the tag";
                fi
            fi
        fi
        unset CORRECT;
        unset UPDATE_VERSION;
        unset RESULT_SIGN;
        unset QN_SIGN;
        unset QN_UPLOAD;
        [ -f ${PATHDIR}update_message.txt ] && rm ${PATHDIR}update_message.txt
        cd ${CALL_ME_ROOT};
    } # update_creator

    function tool_menu()
    {
        echo -e "\n${CL_WYT}=======================${NONE} ${CL_LBL}Tools${NONE} ${CL_WYT}=========================${NONE}\n";
        echo -e "         1. Install Build Dependencies\n";
        echo -e "         2. Install Java (OpenJDK 6/7/8)";
        echo -e "         3. Setup ccache (After installing it)";
        echo -e "         4. Install/Update ADB udev rules";
        echo -e "         5. Add/Update Git Credentials${CL_WYT}*${NONE}";
        echo -e "         6. Install make ${CL_WYT}~${NONE}";
        echo -e "         7. Install ninja ${CL_WYT}~${NONE}";
        echo -e "         8. Install ccache ${CL_WYT}~${NONE}";
        echo -e "         9. Install repo ${CL_WYT}~${NONE}";
        echo -e "        10. Add ScriBt to PATH";
        echo -e "        11. Create a ScriBt Update [DEV]";
# TODO: echo -e "         X. Find an Android Module's Directory";
        echo -e "\n         0. Quick Menu";
        echo -e "\n${CL_WYT}*${NONE} Create a GitHub account before using this option";
        echo -e "${CL_WYT}~${NONE} These versions are recommended to use...\n...If you have any issue in higher versions";
        echo -e "${CL_WYT}=======================================================${NONE}\n";
        prompt TOOL;
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
            5) git_creds ;;
            6) installer "make" ;;
            7) installer "ninja" ;;
            8) installer "ccache" ;;
            9) installer "repo" ;;
            10) scribtofy ;;
            11) update_creator ;;
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
        [ -z "$automate" ] && sync;
        ;;
    3)
        echo -ne '\033]0;ScriBt : Pre-Build\007';
        [ -z "$automate" ] && pre_build;
        ;;
    4)
        if [[ -z "$ROMNIS" ]] || [[ -z "$SBDEV" ]]; then
            echo -ne "\033]0;ScriBt : Build\007";
        else
            echo -ne "\033]0;${ROMNIS}_${SBDEV} : In Progress\007";
        fi
        [ -z "$automate" ] && build;
        ;;
    5)
        echo -ne '\033]0;ScriBt : Various Tools\007';
        [ -z "$automate" ] && tools;
        ;;
    6)
        case "$2" in
            "COOL") echo -ne "\033]0;${ROMNIS}_${SBDEV} : Success\007"; [ -z "$automate" ] && exitScriBt 0 ;;
            "FAIL") echo -ne "\033]0;${ROMNIS}_${SBDEV} : Fail\007"; [ -z "$automate" ] && exitScriBt 1 ;;
            [qm]m) exitScriBt 0 ;;
        esac
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
    # VROOM!
    echo -ne "\033]0;ScriBt : The Beginning\007";

    #   tempfile      repo sync log       rom build log        vars b4 exe     vars after exe
    TMP=${CALL_ME_ROOT}temp.txt; STMP=${CALL_ME_ROOT}temp_sync.txt; RMTMP=${CALL_ME_ROOT}temp_compile.txt; TV1=${CALL_ME_ROOT}temp_v1.txt; TV2=${CALL_ME_ROOT}temp_v2.txt;
    rm -f "$TMP" "$STMP" "$RMTMP" "$TV1" "$TV2";
    touch "$TMP" "$STMP" "$RMTMP" "$TV1" "$TV2";

    # Load RIDb and Colors
    if ! source ${CALL_ME_ROOT}ROM.rc &> /dev/null; then # Load Local ROM.rc
        if ! source ${PATHDIR}ROM.rc &> /dev/null; then # Load ROM.rc from PATHDIR
            echo "[F] ROM.rc isn't present in ${CALL_ME_ROOT} OR PATH. Please make sure repo is cloned correctly";
            exitScriBt 1;
        fi
    fi
    color_my_life;

    # Relevant_Coloring
    if [[ $(tput colors) -lt 2 ]]; then
        export INF="[I]" SCS="[S]" FLD="[F]" EXE="[!]" QN="[?]";
    else
        export INF="${CL_LBL}[!]${NONE}" SCS="${CL_LGN}[!]${NONE}" \
               FLD="${CL_LRD}[!]${NONE}" EXE="${CL_YEL}[!]${NONE}" \
               QN="${CL_LRD}[?]${NONE}";
    fi

    # is the distro supported ??
    pkgmgr_check;

    if [ ! -d ${PATHDIR}.git ]; then # tell the user to re-clone ScriBt
        echo -e "\n${FLD} Folder ${CL_WYT}.git${NONE} not found";
        echo -e "${INF} ${CL_WYT}Re-clone${NONE} ScriBt for upScriBt to work properly\n";
        echo -e "${FLD} Update-Check Cancelled\n\n${INF} No modifications have been done\n";
    else
        [ ! -z "${PATHDIR}" ] && cd ${PATHDIR};
        # Check Branch
        export BRANCH=`git rev-parse --abbrev-ref HEAD`;
        cd ${CALL_ME_ROOT};

        if [[ "${BRANCH}" == "master" ]]; then
            # Download the Remote Version of Updater, determine the Internet Connectivity by working of this command
            curl -fs -o ${PATHDIR}upScriBt.sh https://raw.githubusercontent.com/ScriBt/ScriBt/${BRANCH}/upScriBt.sh && \
                (echo -e "\n${SCS} Internet Connectivity : ONLINE"; bash ${PATHDIR}upScriBt.sh $0 $1) || \
                echo -e "\n${FLD} Internet Connectivity : OFFINE\n\n${INF} Please connect to the Internet for complete functioning of ScriBt";
        else
            echo -e "\n${INF} Current working branch is not ${CL_WYT}master${NONE} [${BRANCH}]\n";
            echo -e "${FLD} Update-Check Cancelled\n\n${INF} No modifications have been done";
        fi
    fi

    # Where am I ?
    echo -e "\n${INF} ${CL_WYT}I'm in ${CALL_ME_ROOT}${NONE}\n";

    # are we 64-bit ??
    if ! [[ $(uname -m) =~ (x86_64|amd64) ]]; then
        echo -e "\n\033[0;31m[!]\033[0m Your Processor is not supported\n";
        exitScriBt 1;
    fi

    # AutoBot
    ATBT="${CL_WYT}*${NONE}${CL_LRD}AutoBot${NONE}${CL_WYT}*${NONE}";

    # CHEAT CHEAT CHEAT!
    if [ -z "$automate" ]; then
        echo -e "${QN} Remember Responses for Automation ${CL_WYT}[y/n]${NONE}\n";
        prompt RQ_PGN;
        (set -o posix; set) > ${TV1};
    else
        echo -e "\n${CL_LRD}[${NONE}${CL_YEL}!${NONE}${CL_LRD}]${NONE} ${ATBT} Cheat Code shut_my_mouth applied. I won't ask questions anymore";
    fi
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
    cd ${PATHDIR};
    echo -e "                         ${CL_WYT}${VERSION}${NONE}\n";
    cd ${CALL_ME_ROOT};
} # the_start

function automator()
{
    echo -e "\n${EXE} Searching for Automatable Configs\n";
    for AF in *.rc; do
        grep 'AUTOMATOR\=\"true_dat\"' --color=never $AF -l >> ${TMP};
        sed -i -e 's/.rc//g' ${TMP}; # Remove the file format
    done
    if [[ $(echo "$?") ]]; then
        NO=1;
        # Adapted from lunch selection menu
        for CT in `cat ${TMP}`; do
            CMB[$NO]="$CT";
            ((NO++));
        done
        unset CT NO;
        for CT in `eval echo "{1..${#CMB[*]}}"`; do
            echo -e " $CT. ${CMB[$CT]} ";
        done | column
        unset CT;
        echo -e "\n${QN} Which would you like\n";
        prompt ANO;
        echo -e "\n${EXE} Running ScriBt on Automation Config ${CMB[$ANO]}\n";
        sleep 2;
        . ${CMB[${ANO}]}.rc;
    else
        echo -e "\n${FLD} No Automation Configs found\n";
        exitScriBt 1;
    fi
} # automator

# Some Essentials

# 'read' command with custom prompt '[>]' in Cyan
function prompt()
{
    read -p $'\033[1;36m[>]\033[0m ' $1;
    if [[ -z "$(eval echo \$$1)" ]] && [[ -z "$2" ]]; then
        echo -e "\n${FLD} No response provided\n";
        prompt $1;
    fi
}

# 'sudo' command with custom prompt '[#]' in Pink
function execroot(){ sudo -p $'\033[1;35m[#]\033[0m ' "$@"; };

function usage()
{
    [ ! -z "$1" ] && echo -e "\n\033[1;31m[!]\033[0m Incorrect Parameter : \"$1\"";
    echo -e "\n\033[1;34m[!]\033[0m Usage:\n";
    ZEROP=( ./ROM.sh ROM.sh );
    CT="0";
        for presence in "Current Directory" "PATH"; do
            echo -e "To use ScriBt situated in ${presence}\n";
            echo -e "\tbash ${ZEROP[$CT]} (Interactive Usage)";
            echo -e "\tbash ${ZEROP[$CT]} automate (Automated Usage)";
            echo -e "\tbash ${ZEROP[$CT]} version (For showing Version of ScriBt)";
            echo -e "\tbash ${ZEROP[$CT]} usage (To get these usage statements)\n";
            (( CT++ ));
        done
    unset CT ZEROP;
    [ ! -z "$1" ] && exitScriBt 1;
} # usage

# Point of Execution

# I ez Root
export CALL_ME_ROOT=`echo "$(pwd)/" | sed -e 's#//$#/#g'`

if [[ "$0" == "ROM.sh" ]] && [[ $(type -p ROM.sh) ]]; then
    export PATHDIR="$(type -p ROM.sh | sed 's/ROM.sh//g')";
else
    export PATHDIR="${CALL_ME_ROOT}"
fi

# Show Interrupt Acknowledgement message on receiving SIGINT
trap interrupt SIGINT;

# Version
if [ -d ${PATHDIR}.git ]; then
    cd ${PATHDIR};
    if [[ "`git rev-parse --abbrev-ref HEAD`" == "master" ]]; then
        VERSION=`git describe --tags $(git rev-list --max-count=1 HEAD)`;
    else
        VERSION="staging";
    fi
    cd ${CALL_ME_ROOT};
else
    VERSION="";
fi
if [[ "$1" == "automate" ]]; then
    export automate="yus_do_eet";
    the_start; # Pre-Initial Stage
    echo -e "${INF} ${ATBT} Lem'me do your work";
    automator;
elif [ -z $1 ]; then
    the_start; # Pre-Initial Stage
    main_menu;
elif [[ "$1" == "version" ]]; then
    if [ -n "$VERSION" ]; then
        echo -e "\n\033[1;34m[\033[1;31m~\033[1;34m]\033[0m Projekt ScriBt \033[1;34m[\033[1;31m~\033[1;34m]\033[0m\n     ${VERSION}\n";
    else
        echo -e "Not available. Please resync ScriBt through Git";
        exit 1;
    fi
elif [[ "$1" == "usage" ]]; then
    usage;
else
    usage "$1";
fi
