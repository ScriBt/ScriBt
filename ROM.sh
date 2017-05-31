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
# Arvindraj Thangaraj (a7r3/Arvind7352)                                #
# Adrian DC (AdrianDC)                                                 #
# Akhil Narang (akhilnarang)                                           #
# Caio Oliveira (Caio99BR)                                             #
# Łukasz "JustArchi" Domeradzki                                        #
# Nathan Chancellor (nathanchance/The Flash)                           #
# Tim Schumacher (TimSchumi)                                           #
# Tom Radtke "CubeDev"                                                 #
# nosedive                                                             #
#======================================================================#

function cmdprex() # D ALL
{
    # shellcheck disable=SC2001
    ARGS=( $(echo "${@// /#}" | sed -e 's/--out=.*txt//') );
    # Argument (Parameter) Array
    ARG=( ${ARGS[*]/*<->/NULL} );
    # Argument Description Array
    ARGD=( ${ARGS[*]/<->*/} );
    # Splash some colors!
    for (( CT=0; CT<${#ARG[*]}; CT++ )); do
        echo -en "\033[1;3${CT}m$(eval "echo \${ARG[${CT}]}") " | sed -e 's/NULL//g' -e 's/execroot/sudo/g' -e 's/#/ /g';
    done
    echo -e "\n";
    for (( CT=0; CT<${#ARGD[*]}; CT++ )); do
        [[ $(eval "echo \${ARG[${CT}]}") != "NULL" ]] && \
         echo -en "\033[1;3${CT}m$(eval "echo \${ARGD[${CT}]}")\033[0m\n" | sed 's/#/ /g';
    done
    echo;
    sleep 2; # Give some time for the user to read it
    [[ "$1" =~ --out=* ]] && TEE="2>&1 | tee -a ${1/*=/}";
    CMD=$(echo "${ARG[*]} ${TEE}" | sed -e 's/NULL//g' -e 's/#/ /g');
    # Execute the command
    if eval "${CMD}"; then
        echo -e "\n${SCS} Command Execution Successful\n";
        unset STS;
    else
        echo -e "\n${FLD} Command Execution Failed\n";
        STS="1";
    fi
    unset -v CMD CT ARG{,S,D};
} # cmdprex

function cherrypick() # Automated Use only
{
    echo -ne '\033]0;ScriBt : Picking Cherries\007';
    echo -e "${CL_WYT}=======================${NONE} ${CL_LRD}Pick those Cherries${NONE} ${CL_WYT}======================${NONE}\n";
    echo -e "${EXE} ${ATBT} Attempting to Cherry-Pick Provided Commits\n";
    cd "${CALL_ME_ROOT}$1" || exitScriBt 1;
    git fetch ${2/\/tree\// };
    git cherry-pick "$3";
    cd "${CALL_ME_ROOT}";
    echo -e "\n${INF} It's possible that the pick may have conflicts. Solve those and then continue.";
    echo -e "${CL_WYT}==================================================================${NONE}";
} # cherrypick

function interrupt() # ID
{
    cd "${CALL_ME_ROOT}";
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
        [[ -z "$NOC" ]] && NOC="${ROMNIS:-scribt}_${SBDEV:-config}";
        if [[ -f "${NOC}.rc" ]]; then
            echo -e "\n${FLD} Configuration ${NOC} exists";
            echo -e "\n${QN} Overwrite it ${CL_WYT}[y/n]${NONE}";
            prompt OVRT;
            case "$OVRT" in
                [Yy]) echo -e "\n${EXE} Deleting ${NOC}"; rm -rf "${NOC}.rc" ;;
                [Nn]) prefGen ;;
            esac
            unset OVRT;
        fi
        {
            echo -e "# ScriBt Automation Config File";
            echo -e "# ${ROM_FN} for ${SBDEV:-"Some Device"}\nAUTOMATE=\"true_dat\"\n";
            echo -e "#################\n#  Information  #\n#################\n\n";
            cat varlist;
            echo -e "\n\n#################\n#  Sequencing  #\n##################\n";
            echo -e "# Your Code goes here\n\ninit;\nsync;\npre_build;\nbuild;\n\n# Some moar code eg. Uploading the ROM";
        } >> "${NOC}.rc";
        echo -e "\n${SCS} Configuration file ${NOC} created successfully";
        echo -e "\n${INF} You may modify the config, and automate ScriBt next time";
        unset NOC;
    } # prefGen

    if type patcher &>/dev/null; then # Assume the patchmgr was used if this function is loaded
        if show_patches | grep -q '[Y]'; then # Some patches are still applied
            echo -e "\n${SCS} Applied Patches detected";
            echo -e "\n${QN} Do you want to reverse them ${CL_WYT}[y/n]${NONE}\n";
            prompt ANSWER;
            [[ "$ANSWER" == [Yy] ]] && patcher;
            unset ANSWER;
        fi
    fi

    # Fetching ScriBt variables
    set -o posix;
    set > "${TV2}";
    diff "${TV1}" "${TV2}" | grep SB | sed -e 's/[<>] //g' > varlist;
    while read -r line; do
        VARS="${VARS}${line//=*/} ";
    done <<< "$(cat varlist)";

    if [[ "${RQ_PGN}" == [Yy] ]]; then
         prefGen;
    fi
    rm -f varlist;
    echo -e "\n${EXE} Unsetting all variables";
    unset ${VARS:-SB2} VARS RQ_PGN;
    if [[ ! -z "${ACTIVE_VENV}" ]]; then
        stop_venv;
    fi
    echo -e "\n${SCS:-[:)]} Thanks for using ScriBt.\n";
    if [[ "$1" == "0" ]]; then
        echo -e "${CL_LGN}[${NONE}${CL_LRD}<3${NONE}${CL_LGN}]${NONE} Peace! :)\n";
    else
        echo -e "${CL_LRD}[${NONE}${CL_RED}<${NONE}${CL_LGR}/${NONE}${CL_RED}3${NONE}${CL_LRD}]${NONE} Failed somewhere :(\n";
    fi
    rm -f "${TV1}" "${TV2}" "${TEMP}";
    [ -f "${PATHDIR}update_message.txt" ] && rm "${PATHDIR}update_message.txt";
    [ -s "${STMP}" ] || rm "${STMP}"; # If temp_sync.txt is empty, delete it
    [ -s "${RMTMP}" ] || rm "${RMTMP}"; # If temp_compile.txt is empty, delete it
    exit "$1";
} # exitScriBt

function main_menu()
{
    echo -ne '\033]0;ScriBt : Main Menu\007';
    echo -e "${CL_WYT}===================${NONE}${SCS} ${CL_LBL}Main Menu${NONE} ${SCS}${CL_WYT}===================${NONE}\n";
    echo -e "1                 Choose ROM & Init                   1";
    echo -e "2                       Sync                          2";
    echo -e "3                     Pre-Build                       3";
    echo -e "4                       Build                         4";
    echo -e "5                   Various Tools                     5\n";
    echo -e "6                        EXIT                         6\n";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    echo -e "\n${QN} Select the Option you want to start with\n";
    prompt ACTION;
    teh_action "${ACTION}" "mm";
} # main_menu

function manifest_gen() # D 1,5
{
    function listremotes()
    {
        echo -en "\n${INF} Following are the list of Remotes\n";
        echo -en "\n${INF} Format : ${CL_WYT}Name${NONE}\t${CL_DGR}(Fetch URL)\n";
        for (( CT=0; CT<"${#REMN[*]}"; CT++ )); do
            eval echo "\${CL_WYT}\${REMN[$CT]} \${CL_DGR}(\${REMF[$CT]})";
            echo -e "${NONE}";
        done
        echo -e "\n${QN} Enter the desired remote name\n";
    } # listremotes

    if [[ ! -d .repo ]]; then
        echo -e "\n${FLD} ROM Source not initialized\n";
        quick_menu;
    else
        FILE=".repo/local_manifests/file.xml";
        while read -r line; do
            eval $line;
            REMN=( ${REMN} $name );
            REMF=( ${REMF} $fetch );
        done <<< $(repo manifest | grep '<remote' | sed -e 's/<remote//g' -e 's/\/>//g' -e 's/<//g');
        echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<manifest>" > "${FILE}";
        echo -e "===============${CL_LGN}[!]${NONE} Manifest Generator ${CL_LGN}[!]${NONE}==============";
        echo -e "1) Add a repository";
        echo -e "2) Remove a repository";
        echo -e "3) Add a remote";
        echo -e "4) Save Custom Manifest && Return to Quick-Menu";
        echo -e "\nReplacing a repo ? Remove the repo, then add it's replacement";
        echo -e "=======================================================\n";
        prompt OP;
        unset CT repo_path;
        unset {repo,remote}_{name,revision,remote};
        unset line{,Start,End};
        case "${OP}" in
            1)
                export lineStart="<project" lineEnd="/>";
                echo -e "Please enter the following one by one\n";
                echo -e "If any of them are not needed, please just enter a blank value (repository name and repository path CANNOT be blank).";
                echo -en "\n${QN} Repository Name : "; prompt repo_name;
                echo -en "\n${QN} Repository Path : "; prompt repo_path;
                echo -en "\n${QN} Branch : "; prompt repo_revision --no-repeat;
                listremotes;
                prompt repo_remote --no-repeat;
                line="name=\"${repo_name}\" path=\"${repo_path}\"";
                [ ! -z "${repo_revision}" ] && line="${line} revision=\"${repo_revision}\"";
                [ ! -z "${repo_remote}" ] && line="${line} remote=\"${repo_remote}\"";
                line="${lineStart} ${line} ${lineEnd}";
                echo "${line}" >> "${CALL_ME_ROOT}${FILE}";
                ;;
            2)
                export lineStart="<remove-project" lineEnd="/>";
                echo -e "${QN} Please enter the Repository Name";
                prompt repo_name;
                if grep -q "${repo_name}" .repo/manifest.xml; then
                    line="${lineStart} name=\"${repo_name}\" ${lineEnd}";
                    echo "${line}" >> "${CALL_ME_ROOT}${FILE}";
                else
                    echo -e "${FLD} Project ${name} not found. Bailing out.";
                fi
                ;;
            3)
                export lineStart="<remote"; export lineEnd="/>";
                echo -e "${INF} Please enter the following one by one\n";
                echo -e "${INF} If some of them are not needed, hit ENTER key [remote name and remote URL CANNOT be blank]\n";
                echo -en "\n${QN} Remote Name : "; prompt remote_name;
                echo -en "\n${QN} Remote URL : "; prompt remote_url;
                echo -en "\n${QN} Revision : "; prompt remote_revision;
                for CT in ${REMN[*]}; do
                    if [[ "${CT}" == "${remote_name}" ]]; then
                        echo -e "${FLD} Remote ${remote_name} already exists";
                        echo -e "${INF} Try again\n";
                        break && manifest_gen;
                    fi
                done
                line="name=\"${remote_name}\" fetch=\"${remote_url}\"";
                [ ! -z "${remote_revision}" ] || line="${line} revision=\"${remote_revision}\"";
                line="${lineStart} ${line} ${lineEnd}";
                echo "${line}" >> "${CALL_ME_ROOT}${FILE}";
                ;;
            4)
                echo -e "${QN} Provide a name for this manifest [Just the name]\n";
                prompt NAME;
                echo -e "</manifest>" >> file.xml;
                mv -f "${FILE}" ".repo/local_manifests/${NAME}.xml";
                echo -e "${SCS} Custom Manifest successfully saved\n";
                unset CT repo_path;
                unset {repo,remote}_{name,revision,remote};
                unset line{,Start,End};
                quick_menu;
                ;;
        esac
    fi
} # manifest_gen

function pkgmgr_check() # ID
{
    if which apt &> /dev/null; then
        echo -e "\n${SCS} Package manager ${CL_WYT}apt${NONE} detected.\033[0m";
        PKGMGR="apt";
    elif which apt-get &> /dev/null; then
        echo -e "\n${SCS} Package manager ${CL_WYT}apt-get${NONE} detected.\033[0m";
        PKGMGR="apt-get";
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
    export ROMS=( "NullROM" "AICP" "AOKP" "AOSiP" "AOSP-CAF" "AOSP-Extended" "AOSP-OMS" \
        "BlissRoms" "CandyRoms" "CarbonROM" "crDroid" "Cyanide" "CyanogenMod" "DirtyUnicorns" \
        "Euphoria" "F-AOSP" "FlayrOS" "Krexus" "Lineage Android" "Nitrogen OS" "OctOs" \
        "OmniROM" "OrionOS" "OwnROM" "PAC ROM" "Parallax OS" "Paranoid Android"\
        "Resurrection Remix" "SlimRoms" "Temasek" "GZR Tesla" "TipsyOs" \
        "GZR Validus" "VanirAOSP" "XenonHD" "XOSP" "Zephyr-OS" "ABC ROM" \
        "Copperhead OS" "DirtyUnicorns" "Krexus" "Nitrogen OS" "PureNexus" );
    echo -e "\n${CL_WYT}=======================================================${NONE}\n";
    echo -e "${CL_YEL}[?]${NONE} ${CL_WYT}Which ROM are you trying to build\nChoose among these (Number Selection)\n";
    for CT in {1..36}; do
        echo -e "${CT}. ${ROMS[$CT]}";
    done | pr -t -2
    echo -e "\n${INF} ${CL_WYT}Non-CAF / Google-Family ROMs${NONE}";
    echo -e "${INF} ${CL_WYT}Choose among these ONLY if you're building for a Nexus/Pixel Device\n"
    for CT in {37..42}; do
        echo -e "${CT}. ${ROMS[$CT]}";
    done | pr -t -2
    echo -e "\n=======================================================${NONE}\n";
    [ -z "$automate" ] && unset SBRN && prompt SBRN;
    rom_names "$SBRN";
    if [[ "${SBRN}" == "Invalid" ]]; then
        echo -e "\n${LRED}Invalid Selection.${NONE} Going back.";
        rom_select;
    else
        echo -e "\n${INF} You have chosen -> ${ROM_FN}\n";
    fi
    unset CT; # Unset these
} # rom_select

function shut_my_mouth() # ID
{
    if [ ! -z "$automate" ]; then
        RST="SB$1";
        echo -e "${CL_PNK}[!]${NONE} ${ATBT} $2 : ${!RST}";
    else
        prompt SB2;
        if [ -z "$3" ]; then
            read -r "SB$1" <<< "${SB2}";
        else
            eval SB$1="${SB2}";
        fi
        export "SB$1";
        unset SB2;
    fi
    echo;
} # shut_my_mouth

function set_ccvars() # D 4,5
{
    echo -e "\n${INF} Specify the Size (Number) for Reservation of CCACHE (in GB)";
    echo -e "\n${INF} CCACHE Size must be >15-20 GB for ONE ROM\n";
    prompt CCSIZE;
    echo -e "\n${INF} Create a New Folder for CCACHE and Specify it's location from /\n";
    prompt CCDIR;
    for RC in .profile .bashrc; do
        if [ -f "${HOME}/${RC}" ]; then
            if [[ $(grep -c 'USE_CCACHE\|CCACHE_DIR' "${HOME}/${RC}") == 0 ]]; then
                echo -e "export USE_CCACHE=1\nexport CCACHE_DIR=${CCDIR}" >> "${HOME}/${RC}";
                source "${HOME}/${RC}";
                echo -e "\n${SCS} CCACHE Specific exports added in ${CL_WYT}${RC}${NONE}";
            else
                echo -e "\n${SCS} CCACHE Specific exports already enabled in ${CL_WYT}${RC}${NONE}";
            fi
            break; # One file, and its done
        fi
    done
    echo -e "\n${EXE} Setting up CCACHE\n";
    ccache -M "${CCSIZE}G";
    echo -e "\n${SCS} CCACHE Setup Successful.\n";
    unset CCSIZE CCDIR;
} # set_ccvars

function init() # 1
{
    # change terminal title
    [ ! -z "$automate" ] && teh_action 1;
    rom_select;
    sleep 1;
    echo -e "${EXE} Detecting Available Branches in ${ROM_FN} Repository";
    RCT=$(( ${#ROM_NAME[*]} - 1 ));
    for CT in $(eval echo "{0..$RCT}"); do
        echo -e "\nOn ${ROM_NAME[$CT]} (ID->$CT)\n";
        BRANCHES=$(git ls-remote -h "https://github.com/${ROM_NAME[$CT]}/${MAN[$CT]}" |\
            awk '{print $2}' | awk -F "/" '{if (length($4) != 0) {print $3"/"$4} else {print $3}}');
        if [[ ! -z "$CNS" && "$SBRN" -lt "37" ]]; then
            echo "$BRANCHES" | grep --color=never 'caf' | column;
        else
            echo "$BRANCHES" | column;
        fi
    done
    unset CT;
    echo -e "\n${INF} These Branches are available at the moment\n${QN} Specify the ID and Branch you're going to sync";
    echo -e "\n${INF} Format : [ID] [BRANCH]\n";
    ST="Branch"; shut_my_mouth NBR "$ST";
    CT="${SBNBR/ */}"; # Count
    SBBR="${SBNBR/* /}"; # Branch
    MNF="${MAN[$CT]}"; # Orgn manifest name at count
    RNM="${ROM_NAME[$CT]}"; # Orgn name at count
    echo -e "${QN} Any Source you have already synced ${CL_WYT}[y/n]${NONE}\n"; gimme_info "refer";
    ST="Use Reference Source"; shut_my_mouth RF "$ST";
    if [[ "$SBRF" == [Yy] ]]; then
        echo -e "\n${QN} Provide me the Synced Source's Location from /\n";
        ST="Reference Location"; shut_my_mouth RFL "$ST";
        REF="--reference=\"${SBRFL}\"";
    fi
    echo -e "${QN} Set clone-depth ${CL_WYT}[y/n]${NONE}\n"; gimme_info "cldp";
    ST="Use clone-depth"; shut_my_mouth CD "$ST";
    if [[ "$SBCD" == [Yy] ]]; then
        echo -e "${QN} Depth Value ${CL_WYT}[Default - 1]${NONE}\n";
        ST="clone-depth Value"; shut_my_mouth DEP "$ST";
        CDP="--depth\=${SBDEP:-1}";
    fi
    # Check for Presence of Repo Binary
    if [[ ! $(which repo) ]]; then
        echo -e "${FLD} ${CL_WYT}repo${NONE} binary isn't installed\n\n${EXE} Installing ${CL_WYT}repo${CL_WYT}\n";
        [ ! -d "${HOME}/bin" ] && mkdir -pv ${HOME}/bin;
        cmdprex \
            "Tool/Lib to transfer data with URL syntax<->curl" \
            "repo dwnld URL<->https://storage.googleapis.com/git-repo-downloads/repo" \
            "Output Redirection Operator<->>" \
            "Redirection file<->~/bin/repo";
        cmdprex \
            "Change Permissions on an Entity<->chmod" \
            "Add executable permission<->a+x" \
            "File to be chmod-ed<->~/bin/repo";
        echo -e "${SCS} Repo Binary Installed";
        echo -e "\n${EXE} Adding ~/bin to PATH\n";
        if [[ $(grep 'PATH=["]*' ~/.profile | grep -c '$HOME/bin') != "0" ]]; then
            echo -e "${SCS} $HOME/bin is in PATH";
        else
            {
                echo -e "\n# set PATH so it includes user's private bin if it exists";
                echo -e "if [ -d \"\$HOME/bin\" ]; then\n\tPATH=\"\$HOME/bin:\$PATH\"\nfi";
            } >> ~/.profile;
            source ~/.profile;
            echo -e "${SCS} $HOME/bin added to PATH";
        fi
        echo -e "${SCS} Done. Ready to Init Repo.\n";
    fi
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    MURL="https://github.com/${RNM}/${MNF}";
    cmdprex --out="${STMP}" \
        "repository management tool<->repo" \
        "initialze in current dir<->init" \
        "reference source dir<->${REF}" \
        "clone depth<->${CDP}" \
        "manifest URL<->-u ${MURL}" \
        "manifest branch<->-b ${SBBR}";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    if [ -z "$STS" ]; then
        [ ! -f .repo/local_manifests ] && mkdir -pv .repo/local_manifests;
        if [ -z "$automate" ]; then
            echo -e "${QN} Generate a Custom manifest ${CL_WYT}[y/n]${NONE}\n";
            prompt SBGCM;
            [[ "$SBGCM" == [Yy] ]] && manifest_gen;
        fi
        export action_1="init";
    else
        unset STS;
    fi
    unset BRANCHES MURL CDP REF MNF CT;
    [ -z "$automate" ] && quick_menu;
} # init

function sync() # 2
{
    # Change terminal title
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
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    #Sync-Options
    [[ "$SBS" == "y" ]] && SILENT="-q";
    [[ "$SBF" == "y" ]] && FORCE="--force-sync";
    [[ "$SBC" == "y" ]] && SYNC_CRNT="-c";
    [[ "$SBB" == "y" ]] || CLN_BUN="--no-clone-bundle";
    echo -e "${EXE} Let's Sync!\n";
    cmdprex --out="${STMP}" \
        "repository management tool<->repo" \
        "update working tree<->sync" \
        "no. of jobs<->-j${SBJOBS:-1}" \
        "silent sync<->${SILENT}" \
        "force sync<->${FORCE}" \
        "sync current branch only<->${SYNC_CRNT}" \
        "use clone.bundle<->${CLN_BUN}";
    echo -e "\n${SCS} Done.\n";
    echo -e "${CL_WYT}=======================================================${NONE}\n";
    unset SILENT FORCE SYNC_CRNT CLN_BUN;
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
    elif [ -d ${CALL_ME_ROOT}vendor/${ROMNIS}/products ]; then
        CNF="vendor/${ROMNIS}/products";
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
        if [ -f "${CNF}/${TYP}.mk" ]; then echo -e "${CT}. $TYP"; (( CT++ )); fi;
    done
    unset CT;
    echo;
    ST="Device Type"; shut_my_mouth DTP "$ST";
    if [ -z "${SBDTP}" ]; then SBDTP="common"; else SBDTP="${TYPES[${SBDTP}]}"; fi;
    echo -e "${CL_WYT}=======================================================${NONE}\n";
} # device_info

function start_venv()
{
    # Create a Virtual Python2 Environment
    if [[ "${PKGMGR}" == "pacman" ]] && [[ -z "${ACTIVE_VENV}" ]]; then
        if python -V | grep -i -q "Python 3."; then
            echo -e "${INF} Python 3 is detected, looking for Python 2 fallback\n";
            echo -e "${INF} Android BuildSystem requires a Python 2.x Environment to function properly\n";
            if ! which virtualenv2 &> /dev/null; then
                echo -e "${FLD} Python2 not found\n";
                echo -e "${EXE} Attempting to install Python2\n";
                cmdprex \
                    "Execute command as 'root'<->execroot" \
                    "Arch Linux Package Mgr.<->${PKGMGR}" \
                    "Sync Pkgs.<->-S" \
                    "Answer 'yes' to prompts<->-y" \
                    "Python2 package<->python2";
            fi
            echo -e "${EXE} Creating Python2 virtual environment\n";
            cmdprex \
                "Python2 Virtual EnvSetup<->virtualenv2" \
                "Location of Virtual Env<->${HOME}/venv";
            if [[ -z "$STS" ]]; then
                cmdprex \
                    "Execute in current shell<->source" \
                    "Shell script to activate Virtual Env<->${HOME}/venv/bin/activate";
                 echo -e "\n${SCS} Python2 environment created\n";
                 ACTIVE_VENV="true";
            else
                echo -e "${FLD} An error occured while trying to start the Environment\n";
                echo -e "${EXE} Aborting\n";
                exitScriBt 1;
            fi
        fi
    fi
} # start_venv

function stop_venv()
{
    if [[ "${ACTIVE_VENV}" == "true" ]]; then
        echo -e "\n${EXE} Exiting virtual environment\n";
        deactivate && rm -rf ${HOME}/venv;
        if [[ ! -d "${HOME}/venv" ]]; then
            echo -e "${SCS} Python2 virtual environment deactivated";
        fi
    fi
} # stop_venv

function init_bld() # D 3,4
{
    echo -e "\n${CL_WYT}=======================================================${NONE}";
    echo -e "${EXE} Initializing Build Environment\n";
    cmdprex \
        "Execute in current shell<->source" \
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
        if [[ ! -z "$ROMV" ]]; then cd "vendor/${ROMV}"; else cd "vendor/${ROMNIS}"; fi;
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

        if [[ "$ROMNIS" == "du" ]] && [[ "$CNS" == "y" ]]; then
            VSTP="caf-vendorsetup.sh";
        else
            VSTP="vendorsetup.sh";
        fi
        echo -e "${EXE} Adding Device to ROM Vendor";
        for STRT in "${ROMNIS}.devices" "${ROMNIS}-device-targets" "${VSTP}"; do
            #    Found file   &&  Strat Not Performed
            if [ -f "${STRT}" ] && [ -z "$STDN" ]; then
                if [[ $(grep -c "${SBDEV}" "${STRT}") == "0" ]]; then
                    case "${STRT}" in
                        "${ROMNIS}.devices")
                            echo -e "${SBDEV}" >> "${STRT}" ;;
                        "${ROMNIS}-device-targets")
                            echo -e "${TARGET}" >> "${STRT}" ;;
                        "${VSTP}")
                            echo -e "add_lunch_combo ${TARGET}" >> "${STRT}" ;;
                    esac
                else
                    echo -e "${INF} Device already added to ${STRT}";
                fi
                export STDN="y"; # File Found, Strat Performed
            fi
        done
        [ -z "$STDN" ] && dtree_add; # If none of the Strats Worked
        echo -e "${SCS} Done.\n";
        cd "${CALL_ME_ROOT}";
        echo -e "${CL_WYT}=======================================================${NONE}";
    } # vendor_strat

    function vendor_strat_kpa() # AOKP-4.4|AICP|PAC-5.1|Krexus-CAF|AOSPA|Non-CAFs
    {
        cd "${CALL_ME_ROOT}vendor/${ROMNIS}/products";

        function bootanim()
        {
            echo -e "${INF} Device Resolution\n";
            if [ ! -z "$automate" ]; then
                gimme_info "bootres";
                echo -e "\n${QN} Enter the Desired Highlighted Number\n";
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
                {
                    echo -e "\n# Inherit telephony stuff\n\$(call inherit-product, vendor/${ROMNIS}/configs/telephony.mk)";
                    echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)";
                } >> "${VENF}";
                ;;
            "aokp")
                bootanim;
                VENF="${SBDEV}.mk";
                echo -e "\t\$(LOCAL_DIR)/${VENF}" >> AndroidProducts.mk;
                {
                    echo -e "\$(call inherit-product, vendor/${ROMNIS}/configs/common.mk)";
                    echo -e "\nPRODUCT_COPY_FILES += \\ ";
                    echo -e "\tvendor/${ROMNIS}/prebuilt/bootanimation/bootanimation_${SBBTR}.zip:system/media/bootanimation.zip";
                } >> "${VENF}";
                ;;
            "krexus")
                VENF="${ROMNIS}_${SBDEV}.mk";
                {
                    echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/common.mk)";
                    echo -e "\n\$( call inherit-product, vendor/${ROMNIS}/products/vendorless.mk)";
                } >> "${VENF}";
                ;;
            "pa")
                VENF="${SBDEV}/${ROMNIS}_${SBDEV}.mk";
                {
                    echo -e "# ${SBCM} ${SBDEV}";
                    echo -e "\nifeq (${ROMNIS}_${SBDEV},\$(TARGET_PRODUCT))";
                    echo -e "\tPRODUCT_MAKEFILES += \$(LOCAL_DIR)/${VENF}\nendif";
                } >> AndroidProducts.mk;
                echo -e "\ninclude vendor/${ROMNIS}/main.mk" >> "${VENF}";
                mv -f "${CALL_ME_ROOT}${DEVDIR}"/*.dependencies "${SBDEV}/pa.dependencies";
                ;;
            "pac")
                bootanim;
                VENF="${ROMNIS}_${SBDEV}.mk";
                {
                    echo -e "\$( call inherit-product, vendor/${ROMNIS}/products/pac_common.mk)";
                    echo -e "\nPAC_BOOTANIMATION_NAME := ${SBBTR};";
                } >> "${VENF}";
                ;;
            "pure") # PureNexus and ABC rom
                VENF="${SBDEV}.mk";
                echo -e "# Include pure configuration\ninclude vendor/pure/configs/pure_phone.mk" >> "${VENF}";
                ;;
        esac
        find_ddc "pb";
        {
            echo -e "\n# Inherit from ${DDC}";
            echo -e "\$(call inherit-product, ${DEVDIR}/${DDC})";
            # PRODUCT_NAME is the only ROM-specific Identifier, setting it here is better.
            echo -e "\n# ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${SBDEV}";
        } >> "${VENF}";
    } # vendor_strat_kpa

    function find_ddc() # For Finding Default Device Configuration file
    {
        # Get all the ROMNIS values - Duplicates doesn't matter
        ROMC=( $(for CT in {1..42}; do rom_names "${SBRN}"; echo "${ROMNIS}"; done) );
        for ROM in ${ROMC[*]}; do
            # Possible Default Device Configuration (DDC) Files
            DDCS=( "${ROM}_${SBDEV}.mk" "full_${SBDEV}.mk" "aosp_${SBDEV}.mk" "${ROM}.mk" );
            for ACTUAL_DDC in ${DDCS[*]}; do
                if [ -f "${DEVDIR}/${ACTUAL_DDC}" ]; then
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
            cd "${DEVDIR}";
            INTM="interact.mk";
            [ -z "$INTF" ] && INTF="${ROMNIS}.mk";
            {
                echo -e "#                ##### Interactive Makefile ######";
                echo -e "#";
                echo -e "# Licensed under the Apache License, Version 2.0 (the \"License\");";
                echo -e "# you may not use this file except in compliance with the License.";
                echo -e "# You may obtain a copy of the License at";
                echo -e "#";
                echo -e "#      http://www.apache.org/licenses/LICENSE-2.0";
                echo -e "#";
                echo -e "# Unless required by applicable law or agreed to in writing, software";
                echo -e "# distributed under the License is distributed on an \"AS IS\" BASIS,";
                echo -e "# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.";
                echo -e "# See the License for the specific language governing permissions and";
                echo -e "# limitations under the License.";
                echo -e "\n# Inherit ${ROMNIS} common stuff\n\$(call inherit-product, ${CNF}/${VNF}.mk)";
                echo -e "\n# Calling Default Device Configuration File";
                echo -e "\$(call inherit-product, ${DEVDIR}/${DDC})";
            } >> "${INTM}";
            # To prevent Missing Vendor Calls in DDC-File
            sed -i -e 's/inherit-product, vendor\//inherit-product-if-exists, vendor\//g' "$DDC";
            # Add User-desired Makefile Calls
            echo -e "${QN} Missed some Makefile calls\n${INF} Enter number of Desired Makefile calls\n${INF} Enter 0 if none";
            ST="No of Makefile Calls"; shut_my_mouth NMK "$ST";
            for (( CT=0; CT<"${SBNMK}"; CT++ )); do
                echo -e "\n${QN} Enter Makefile location from Root of BuildSystem";
                ST="Makefile"; shut_my_mouth LOC[$CT] "$ST" array;
                if [ -f "${CALL_ME_ROOT}${SBLOC[$CT]}" ]; then
                    echo -e "\n${EXE} Adding Makefile $(( CT + 1 ))";
                    echo -e "\n\$(call inherit-product, ${SBLOC[$CT]})" >> "${INTM}";
                else
                    echo -e "${FLD} Makefile ${SBLOC[$CT]} not Found. Aborting";
                fi
            done
            unset CT;
            echo -e "\n# ROM Specific Identifier\nPRODUCT_NAME := ${ROMNIS}_${SBDEV}" >> "${INTM}";
            # Make it Identifiable
            mv "${INTM}" "${INTF}";
            echo -e "${EXE} Renaming .dependencies file\n";
            [ ! -f "${ROMNIS}.dependencies" ] && mv -f ./*.dependencies "${ROMNIS}.dependencies";
            echo -e "${SCS} Done.";
            cd "${CALL_ME_ROOT}";
        } # create_imk

        find_ddc "intm";
        if [[ "$DDC" != "NULL" ]]; then create_imk; else echo "$NOINT"; fi;
    } # interactive_mk

    function need_for_int()
    {
        if [ -f "${CALL_ME_ROOT}${DEVDIR}/${INTF}" ]; then
            echo "$NOINT";
        else
            interactive_mk "$SBRN";
        fi
    } # need_for_int

    echo -e "\n${EXE} ${ROMNIS}-fying Device Tree\n";
    NOINT=$(echo -e "${SCS} Interactive Makefile Unneeded, continuing");

    case "$ROMNIS" in
        aosp|eos|nitrogen|omni|zos) # AEX|AOSP-CAF/RRO|Euphoria|F-AOSP|Flayr|Nitrogen|OmniROM|Parallax|Zephyr
            VNF="common";
            if [[ "$ROMNIS" == "eos" ]]; then
                INTF="${ROMNIS}.mk";
            else
                INTF="${ROMNIS}_${SBDEV}.mk";
            fi
            need_for_int;
            rm -rf "${DEVDIR}/AndroidProducts.mk";
            echo -e "PRODUCT_MAKEFILES :=  \\ \n\t\$(LOCAL_DIR)/${INTF}" >> AndroidProducts.mk;
            ;;
        aosip) # AOSiP-CAF
            if [ ! -f "vendor/${ROMNIS}/products" ]; then
                VNF="common";
                INTF="${ROMNIS}.mk";
                need_for_int;
            else
                echo "$NOINT";
            fi
            ;;
        aokp|pac) # AOKP-4.4|PAC-5.1
            if [ ! -f "vendor/${ROMNIS}/products" ]; then
                VNF="$SBDTP";
                INTF="${ROMNIS}.mk";
                need_for_int;
            else
                echo "$NOINT";
            fi
            ;;
        aicp|krexus|pa|pure|krexus|pure) # AICP|Krexus-CAF|AOSPA|Non-CAFs except DU
            echo "$NOINT";
            ;;
        *) # Rest of the ROMs
            VNF="$SBDTP";
            INTF="${ROMNIS}.mk";
            need_for_int;
            ;;
    esac

    choose_target;
    if [ -d vendor/${ROMNIS}/products ]; then # [ -d vendor/aosip ] <- Temporarily commented
        if [ ! -f "vendor/${ROMNIS}/products/${ROMNIS}_${SBDEV}.mk" ] ||
            [ ! -f "vendor/${ROMNIS}/products/${SBDEV}.mk" ] ||
             [ ! -f "vendor/${ROMNIS}/products/${SBDEV}/${ROMNIS}_${SBDEV}.mk" ]; then
            vendor_strat_kpa; # if found products folder, go ahead
        else
            echo -e "\n${SCS} Looks like ${SBDEV} has been already added to ${ROM_FN} vendor. Good to go\n";
        fi
    else
        vendor_strat_all; # if not found, normal strategies
    fi
    cd "${CALL_ME_ROOT}";
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
            SEC=$(( END - START )); # Difference gives Build Time
            if [ -z "$STS" ]; then
                echo -e "\n${FLD} Build Status : Failed";
            else
                echo -e "\n${SCS} Build Status : Success";
            fi
            echo -e "\n${INF} ${CL_WYT}Build took $(( SEC / 3600 )) hour(s), $(( SEC / 60 % 60 )) minute(s) and $(( SEC % 60 )) second(s).${NONE}" | tee -a rom_compile.txt;
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
                     "Module Directory<->${MODDIR}"
                     ;;
                *) echo -e "${FLD} Invalid Selection.\n"; make_it ;;
            esac
        else
            echo -e "${INF} Do either of these two actions:\n1. Google it (Easier)\n2. Run this command in terminal : grep \"LOCAL_MODULE := <Insert_MODULE_NAME_Here> \".\n\n Press ENTER after it's Done..\n";
            read -r;
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
                cd "${SBKL}";
            else
                echo -e "\n${FLD} Kernel Makefile not found. Aborting";
                quick_menu;
            fi
            echo -e "\n${QN} Enter the codename of your device\n";
            ST="Codename"; shut_my_mouth DEV "$ST";
            KDEFS=( $(ls arch/*/configs/*${SBDEV}*_defconfig) );
            for (( CT=0; CT<${#KDEFS[*]}; CT++ )); do
                echo -e "$(( CT + 1 )). ${KDEFS[$CT]}";
            done
            unset CT;
            echo -e "\n${INF} These are the available Kernel Configurations";
            echo -e "\n${QN} Select the one according to the CPU Architecture\n";
            if [ -z "$automate" ]; then
                prompt CT;
                SBKD=$(eval echo "\${KDEFS[$(( CT - 1 ))]}" | awk -F "/" '{print $4}');
                SBKA=$(eval echo "\${KDEFS[$(( CT - 1 ))]}" | awk -F "/" '{print $2}');
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
            echo -e "\n${QN} Point me to the location of the toolchain [ from \"/\" ]\n";
            ST="Toolchain Location"; shut_my_mouth KTL "$ST";
            if [[ -d "${SBKTL}" ]]; then
                KCCP=$(find bin/${SBKA}*gcc | grep -v 'androidkernel' | sed -e 's/gcc//g' -e 's/.*bin\///g');
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
                cd "${CALL_ME_ROOT}";
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
            (patch -p1 -N --dry-run < "$1" 1> /dev/null 2>&1 && echo -n 0) || # Patch is not applied but can be applied
            (patch -p1 -R --dry-run < "$1" 1> /dev/null 2>&1 && echo -n 1) || # Patch is applied
            echo -n 2; # Patch can not be applied
        } # check_patch

        function apply_patch()
        {
            case $(check_patch "$1") in
                0)
                    echo -en "\n${EXE} Patch is being applied\n";
                    if patch -p1 -N < "$1" > /dev/null; then # Patch is being applied
                        echo -e "${SCS} Patch Successfully Applied";
                    else
                        echo -e "${FLD} Patch Application Failed";
                    fi
                    ;;
                1)
                    echo -en "\n${EXE} Patch is being reversed\n";
                    if patch -p1 -R < "$1" > /dev/null; then # Patch is being reversed
                        echo -e "${SCS} Patch Successfully Reversed";
                    else
                        echo -e "${FLD} Patch Reverse Failed";
                    fi
                    ;;
                2) echo -e "\n${EXE} Patch can't be applied." ;; # Patch can not be applied
            esac
        } # apply_patch

        function visual_check_patch()
        {
            case $(check_patch "$1") in
                0) echo -en "[${CL_LRD}N${NONE}]" ;; # Patch is not applied but can be applied
                1) echo -en "[${CL_LGN}Y${NONE}]" ;; # Patch is applied
                2) echo -en "[${CL_LBL}X${NONE}]" ;; # Patch can not be applied
            esac
        } # visual_check_patch

        function show_patches()
        {
            cd "${CALL_ME_ROOT}";
            unset PATCHES;
            unset PATCHDIRS;
            PATCHDIRS=("device/*/*/patch" "patch");
            echo -e "\n${EXE} Searching for patches\n";
            echo -e "==================== ${CL_LRD}Patch Manager${NONE} ====================\n";
            echo -e "0. Exit the Patch Manager";
            echo -e "1. Launch the Patch Creator";
            CT=2;
            for PATCHDIR in "${PATCHDIRS[@]}"; do
                if find "${PATCHDIR}"/* 1> /dev/null 2>&1; then
                    while read -r PATCH; do
                        if [ -s "$PATCH" ]; then
                            PATCHES[$CT]="$PATCH";
                            echo -e "${CT}. $(visual_check_patch "$PATCH") $PATCH";
                            (( CT++ ));
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
                    [ -f "${CALL_ME_ROOT}${PATCH_PATH}" ] && rm -rf "${CALL_ME_ROOT}${PATCH_PATH}"; # Delete existing patch
                    CT=1;
                    echo;
                    while read -r PROJECT; do # repo foreach does not work, as it seems to spawn a subshell
                        cd "${CALL_ME_ROOT}${PROJECT}";
                        git diff |
                          sed -e "s@ a/@ a/${PROJECT}/@g" |
                          sed -e "s@ b/@ b/${PROJECT}/@g" >> "${CALL_ME_ROOT}${PATCH_PATH}"; # Extend a/ and b/ with the project's path, as git diff only outputs the paths relative to the git repository's root
                        echo -en "\033[KGenerated patch for repo $CT of $PROJECT_COUNT\r";  # Count teh processed repos
                        (( CT++ ));
                    done <<< "$PROJECTS";
                    cd "${CALL_ME_ROOT}";
                    echo -e "\n\n${SCS} Done.";
                    [ ! -s "${CALL_ME_ROOT}${PATCH_PATH}" ] &&
                      rm "${CALL_ME_ROOT}${PATCH_PATH}" &&
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
            if [ -d ".repo" ]; then
                # Get Missing Information
                [ -z "$action_1" ] && rom_select;
                [ -z "$action_2" ] && device_info;
                # Change terminal title
                [ ! -z "$automate" ] && teh_action 4;
            else
                echo -e "${FLD} ROM Source Not Found (Synced)\n";
                echo -e "${FLD} Please perform an init and sync before doing this";
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
            if [[ $(grep -c 'BUILD_ID=M' "${CALL_ME_ROOT}build/core/build_id.mk") == "1" ]]; then
                echo -e "${QN} Use Jack Toolchain ${CL_WYT}[y/n]${NONE}\n"; gimme_info "jack";
                ST="Use Jacky"; shut_my_mouth JK "$ST";
                case "$SBJK" in
                    [yY])
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Enable Jack<->ANDROID_COMPILE_WITH_JACK=true";
                        ;;
                    [nN])
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Disable Jack<->ANDROID_COMPILE_WITH_JACK=false";
                        ;;
                esac
            fi
            if [[ $(grep -c 'BUILD_ID=N' "${CALL_ME_ROOT}build/core/build_id.mk") == "1" ]]; then
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
                # Jack cannot be disabled in N
                # Jack workaround prompt is asked if this is set to y/Y
                SBJK="y";
            fi
            if [[ "${SBJK}" == [Yy] ]] && [[ "$(free -m | awk '/^Mem:/{print $2}')" -lt "4096" ]]; then
                echo -e "${INF} Your system has less than 4GB RAM\n";
                echo -e "${INF} Jack's Java VM requires >8GB of RAM to function properly\n";
                echo -e "${QN} Use Jack workarounds for proper functioning\n";
                echo -e "${INF} Unless you know what you're doing - ${CL_LBL}Answer y${NONE}\n";
                ST="Use Jack Workaround"; shut_my_mouth JWA "$ST";
                case "${SBJWA}" in
                    [Yy])
                        export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx3G";
                        if [[ -f "${HOME}/.jack-server/config.properties" ]]; then
                            if [[ "$(grep -c 'jack.server.max-service=1' ${HOME}/.jack-server/config.properties)" == "0" ]]; then
                                sed -i "/jack.server.max-service=*/c\jack.server.max-service=1" ~/.jack-server/config.properties;
                            fi
                        fi
                        if [[ -f "${HOME}/.jack" ]]; then
                            if [[ "$(grep -c 'SERVER_NB_COMPILE=1' ${HOME}/.jack)" == "0" ]]; then
                                sed -i "/SERVER_NB_COMPILE=*/c\SERVER_NB_COMPILE=1" ~/.jack;
                            fi
                        fi
                        echo "${EXE} Cleaning old JACK Session";
                        rm -rf /tmp/jack-*;
                        jack-admin kill-server;
                        ;;
                    *)
                        echo -e "${INF} Not using Jack Workarounds\n";
                        ;;
                esac
            fi
            case "$SBCL" in
                1)
                    cmdprex \
                        "Setup Device-Specific BuildEnv<->lunch" \
                        "Build Target Name<->${TARGET}";
                    cmdprex \
                        "GNU make<->$SBMK" \
                        "TargetName to Remove Staging Files<->installclean";
                    ;;
                2)
                    cmdprex \
                        "Setup Device-Specific BuildEnv<->lunch" \
                        "Build Target Name<->${TARGET}";
                    cmdprex \
                        "GNU make<->$SBMK" \
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
                source "/etc/${REL}";
                case "$REL" in
                    "lsb-release") DID="${DISTRIB_ID}"; VER="${DISTRIB_RELEASE}" ;;
                    "os-release") DID="${ID}"; VER="${VERSION_ID}" ;; # Most of the Newer Distros
                    "debian-release") DID="debian" VER=$(cat /etc/debian-release) ;;
#                   "other-release") DID="Distro Name (Single Worded)"; VER="Version (Single numbered)" ;;
                esac
            fi
        done
        dist_db "$DID" "$VER"; # Determination of Distro by a Database
        if [[ ! -z "$DID" && ! -z "$VER" ]]; then
            echo -e "\n${SCS} Distro Detected Successfully";
        else
            echo -e "\n${FLD} Distro not present in supported Distros\n\n${INF} Contact the Developer for Support\n";
            quick_menu;
        fi

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
            D16|D17)
                # Seperate D17 list when testing other Distros
                # Ubuntu 17.04 installed these packages successfully
                DISTRO_PKGS=( automake lzop libesd0-dev maven \
                liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev \
                lzop lib32ncurses5-dev lib32readline6-dev lib32z1-dev \
                libbz2-dev libbz2-1.0 libghc-bzlib-dev ) ;;
        esac
        # Install 'em all
        cmdprex \
            "Command Execution as 'root'<->execroot" \
            "Commandline Package Manager<->${PKGMGR}" \
            "Keyword for Installing Package<->install" \
            "Answer 'yes' to prompts<->-y" \
            "Packages list<->${COMMON_PKGS[*]} ${DISTRO_PKGS[*]}";
        unset DISTRO_PKGS COMMON_PKGS;
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
            if ! pacman -Qq "${item}" &> /dev/null; then
                PKGSREQ="${item} ${PKGSREQ}";
            fi
        done
        # if there are required packages, run the installer
        if [ ${#PKGSREQ} -ge 4 ]; then
            # choose an AUR package manager instead of pacman
            for item in yaourt pacaur packer; do
                if which "${item}" &> /dev/null; then
                    AURMGR="${item}";
                fi
            done
            if [ -z "${AURMGR}" ]; then
                echo -e "\n${FLD} no AUR manager found\n";
                exitScriBt 1;
            fi
            # look for conflicting packages and uninstall them
            for item in ${PKGS_CONFLICT}; do
                if pacman -Qq "${item}" &> /dev/null; then
                    cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Arch Package Mgr<->pacman" \
                    "Remove<->-R" \
                    "Skip all Dependency Checks<->-dd" \
                    "WiP<->-n" \
                    "WiP<->-s" \
                    "Answer 'yes' to prompts<->--noconfirm" \
                    "Conflicting Packages list<->${item}";
                    sleep 3;
                fi
            done
            # install required packages
            for item in ${PKGSREQ}; do
                cmdprex \
                "Arch Package Mgr.<->${AURMGR}" \
                "Sync Pkgs<->-S" \
                "Answer 'yes' to prompts<->--noconfirm" \
                "Packages List<->${item}";
            done
        else
            echo -e "\n${SCS} You already have all required packages\n";
        fi
        unset item AURMGR PKGSREQ;
    } # installdeps_arch

    function java_select()
    {
        echo -e "${INF} If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)";
        echo -e "${INF} You may now select the Version of Java which is to be used BY-DEFAULT\n";
        echo -e "${CL_WYT}=======================================================${NONE}\n";
        case "${PKGMGR}" in
            apt{,-get})
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
                echo -e "\n${QN} Please enter desired version [eg. \"java-7-openjdk\"]\n";
                prompt ARCHJA;
                execroot archlinux-java set "${ARCHJA}";
                ;;
        esac
        echo -e "\n${CL_WYT}=======================================================${NONE}";
    } # java_select

    function java_check()
    {
      if [[ $( java -version &> "$TMP"; grep -c "version \"1.$1" "$TMP" ) == "1" ]]; then
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
                    apt{,-get})
                        cmdprex \
                            "Command Execution as 'root'<->execroot" \
                            "Commandline Package Manager<->${PKGMGR}" \
                            "Keyword to Remove Packages<->purge" \
                            "Packages to be purged<->openjdk-* icedtea-* icedtea6-*"
                            ;;
                    "pacman")
                        cmdprex \
                            "Commad Execution as 'root'<->execroot" \
                            "Arch Package Mgr.<->pacman" \
                            "Remove Package<->-R" \
                            "Skip all Dependency Checks<->-dd" \
                            "WiP<->-n" \
                            "WiP<->-s" \
                            "PackageName<->$( pacman -Qqs ^jdk )" ;;
                esac
                echo -e "\n${SCS} Removed Other Versions successfully";
                ;;
            [nN]) echo -e "${EXE} Keeping them Intact" ;;
            *)
                echo -e "${FLD} Invalid Selection.\n";
                java_install "$1";
                ;;
        esac
        echo -e "\n${CL_WYT}=======================================================${NONE}\n";
        case "${PKGMGR}" in
            "apt"|"apt-get")
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Commandline Package Manager<->${PKGMGR}" \
                    "Answer 'yes' to prompts<->-y" \
                    "Update Packages List<->update";
                ;;
            "pacman")
                cmdprex \
                    "Execute command as 'root'<->execroot" \
                    "Arch Package Mgr.<->pacman" \
                    "Sync Pkgs<->-S" \
                    "Answer 'yes' to prompts<->-y" ;;
        esac
        echo -e "\n${CL_WYT}=======================================================${NONE}\n";
        case "${PKGMGR}" in
            apt{,-get})
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Commandline Package Manager<->${PKGMGR}" \
                    "Keyword for Installing Package<->install" \
                    "Answer 'yes' to prompts<->-y" \
                    "OpenJDK PackageName<->openjdk-$1-jdk";
                ;;
            "pacman")
                cmdprex \
                    "Execute command as 'root'<->execroot" \
                    "Arch Package Mgr.<->pacman" \
                    "Sync Pkgs<->-S" \
                    "Answer 'yes' to prompts<->-y"
                    "OpenJDK PackageName<->jdk$1-openjdk" ;;
        esac
        java_check "$1";
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
        java_check "$1";
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
                [[ "${PKGMGR}" =~ apt(|-get) ]] && echo -e "4. Ubuntu 16.04 & Want to install Java 7\n5. Ubuntu 14.04 & Want to install Java 8\n";
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
        cmdprex \
            "Execute Command as 'root'<->execroot" \
            "Tool/Lib to transfer data with URL syntax<->curl" \
            "Be silent<->-s" \
            "Create non-existent dirs<->--create-dirs" \
            "Follow URL redirections<->-L" \
            "Output Directory<->-o /etc/udev/rules.d/51-android.rules" \
            "Name file as specified in remote<->-O" \
            "URL<->https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules";
        cmdprex \
            "Execute command as 'root'<->execroot" \
            "Change Permissions on an Entity<->chmod" \
            "Add read Permissions<->a+r" \
            "file to be chmod-ed<->/etc/udev/rules.d/51-android.rules";
        if [[ "$PKGMGR" =~ apt(|-get) ]]; then
            cmdprex \
                "Execute command as 'root'<->execroot" \
                "Service mgmt tool<->service" \
                "Device Mgr 'userspace /dev'<->udev" \
                "Restart the service<->restart";
        elif [[ "$PKGMGR" == "pacman" ]]; then
            cmdprex \
                "Execute command as 'root'<->execroot" \
                "Device Mgr<->udevadm" \
                "Perform Operation with udev daemon<->control" \
                "Reload udev rules<->--reload-rules";
        fi
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
            "Apply changes to all local repositories<->--global" \
            "Configuration<->user.name" \
            "Value<->${GIT_U}";
        cmdprex \
            "git commandline<->git" \
            "Configure git<->config" \
            "Apply changes to all local repositories<->--global" \
            "Configuration<->user.email" \
            "Value<->${GIT_E}";
        echo -e "\n${SCS} Done.\n"
        quick_menu;
    } # git_creds

    function check_utils_version()
    {
        # If util is repo then concatenate the file else execute it as a binary
        CAT="cat ";
        [[ "$1" == "repo" ]] || unset CAT;
        case "$2" in
            "utils") BIN="${CAT}utils/$1" ;; # Util Version that ScriBt has under utils folder
            "installed") BIN="${CAT}$(which $1)" ;; # Util Version that has been installed in the System
        esac
        case "$1" in # Installed Version
            "ccache") VER=$(${BIN} --version | head -1 | awk '{print $3}') ;;
            "make") VER=$(${BIN} -v | head -1 | awk '{print $3}') ;;
            "ninja") VER=$(${BIN} --version) ;;
            # since repo is a python script and not a binary
            "repo")
                VER=$(${BIN} | grep -m 1 VERSION |\
                    awk -F "= " '{print $2}' |\
                    tr -d ')(' |\
                    awk -F ", " '{print $1"."$2}')
                ;;
        esac
    } # check_utils_version

    function installer()
    {
        echo -e "\n${EXE}Checking presence of ~/bin folder\n";
        if [ -d "${HOME}/bin" ]; then
            echo -e "${SCS} ${HOME}/bin present";
        else
            echo -e "${FLD} ${HOME}/bin absent\n${EXE} Creating folder ${HOME}/bin\n";
            mkdir -pv "${HOME}/bin";
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
        unset VER IDIR UIC;
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
                    echo -e "# ScriBtofy\nexport PATH=\"${CALL_ME_ROOT}:\$PATH\";" > "${HOME}/.scribt";
                    grep -q 'source ${HOME}/.scribt' ${HOME}/.bashrc || echo -e "\n#ScriBtofy\nsource \${HOME}/.scribt;" >> "${HOME}/.bashrc";
                    echo -e "\n${EXE} Executing ~/.bashrc";
                    source ~/.bashrc;
                    echo -e "\n${SCS} Done\n\n${INF} Now you can ${CL_WYT}bash ROM.sh${NONE} under any directory";
                ;;
            [Nn])
                echo -e "${FLD} ScriBtofication cancelled";
                ;;
        esac
        unset SBFY;
    } # scribtofy

    function update_creator() # Dev Only
    {
        [ -f "${PATHDIR}update_message.txt" ] && rm "${PATHDIR}update_message.txt";
        cd "${PATHDIR}";

        if [ ! -d "${PATHDIR}.git" ]; then # tell the user to re-clone ScriBt
            echo -e "\n${FLD} Folder ${CL_WYT}.git${NONE} not found";
            echo -e "${INF} ${CL_WYT}Re-clone${NONE} ScriBt for the update creator to work properly\n";
        else
            echo -e "\n${INF} This Function creates a new Update for ScriBt.";
            echo -e "${INF} Please make sure you are on the right commit which should be the last in the new update!";
            echo -e "${QN} Do you want to continue?\n"
            prompt CORRECT;
            if [[ "$CORRECT" =~ (y|yes) ]]; then
                CORRECT="n";
                while [[ ! "$CORRECT" =~ (y|yes) ]]; do
                    echo -e "\n${INF} Please enter the version number (without the prefix v, it will be added automatically)\n";
                    prompt UPDATE_VERSION;
                    echo -e "\n${INF} The new version number is \"${UPDATE_VERSION}\"";
                    echo -e "${QN} Is this correct?\n";
                    prompt CORRECT;
                done;

                CORRECT="n";
                while [[ ! "$CORRECT" =~ (y|yes) ]]; do
                    echo -e "\n${INF} Please enter the update message [Press ENTER]";
                    read -r;
                    nano "${PATHDIR}update_message.txt";
                    echo -e "\n${INF} The new update message is\n";
                    cat "${PATHDIR}update_message.txt";
                    echo -e "\n${QN} Is this correct?\n";
                    prompt CORRECT;
                done;

                echo -e "Version ${UPDATE_VERSION}\n\n" | cat - update_message.txt > temp && mv temp update_message.txt;

                echo -e "\n${QN} Do you want to sign the tag?";
                echo -e "${INF} Do it only if you have a git-compatible GPG setup\n";
                prompt QN_SIGN;
                if [[ "${QN_SIGN}" =~ (y|yes) ]]; then
                    RESULT_SIGN=" -s";
                fi

                if [[ "${QN_SIGN}" =~ (y|yes) ]]; then
                    RESULT_SIGN=" -s";
                fi

                if git tag -a"${RESULT_SIGN}" -F "${PATHDIR}update_message.txt" "v${UPDATE_VERSION}" &> /dev/null; then
                    echo -e "\n${INF} Tag was created successfully";
                    echo -e "${QN} Do you want to upload it to the server (origin)?\n";
                    prompt QN_UPLOAD;
                    if [[ "${QN_UPLOAD}" =~ (y|yes) ]]; then
                        if git push origin master && git push origin v"${UPDATE_VERSION}"; then
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
        unset CORRECT UPDATE_VERSION RESULT_SIGN QN_SIGN QN_UPLOAD;
        [ -f "${PATHDIR}update_message.txt" ] && rm "${PATHDIR}update_message.txt";
        cd "${CALL_ME_ROOT}";
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
        echo -e "        12. Generate a Custom Manifest";
# TODO: echo -e "         X. Find an Android Module's Directory";
        echo -e "\n         0. Quick Menu";
        echo -e "\n${CL_WYT}*${NONE} Create a GitHub account before using this option";
        echo -e "${CL_WYT}~${NONE} These versions are recommended to use...\n...If you have any issue in higher versions";
        echo -e "${CL_WYT}=======================================================${NONE}\n";
        prompt TOOL;
        case "$TOOL" in
            0) quick_menu ;;
            1) case "${PKGMGR}" in
                   apt{,get}) installdeps ;;
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
            12) manifest_gen ;;
# TODO:     X) find_mod ;;
            *) echo -e "${FLD} Invalid Selection.\n"; tool_menu ;;
        esac
        unset TOOL;
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

    TMP="${CALL_ME_ROOT}temp.txt"; # tempfile
    STMP="${CALL_ME_ROOT}temp_sync.txt"; # repo sync log
    RMTMP="${CALL_ME_ROOT}temp_compile.txt"; # rom build log
    TV1="${CALL_ME_ROOT}temp_v1.txt"; # variable list before ScriBt starts
    TV2="${CALL_ME_ROOT}temp_v2.txt"; # variable list after using ScriBt

    rm -f "$TMP" "$STMP" "$RMTMP" "$TV1" "$TV2";
    touch "$TMP" "$STMP" "$RMTMP" "$TV1" "$TV2";

    # Load RIDb and Colors
    if ! source "${CALL_ME_ROOT}ROM.rc" &> /dev/null; then # Load Local ROM.rc
        if ! source "${PATHDIR}ROM.rc" &> /dev/null; then # Load ROM.rc from PATHDIR
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

    if [ ! -d "${PATHDIR}.git" ]; then # tell the user to re-clone ScriBt
        echo -e "\n${FLD} Folder ${CL_WYT}.git${NONE} not found";
        echo -e "${INF} ${CL_WYT}Re-clone${NONE} ScriBt for upScriBt to work properly\n";
        echo -e "${FLD} Update-Check Cancelled\n\n${INF} No modifications have been done\n";
    else
        [ ! -z "${PATHDIR}" ] && cd "${PATHDIR}";

        cd "${CALL_ME_ROOT}";

        if [[ "${BRANCH}" == "master" ]]; then
            # Download the Remote Version of Updater, determine the Internet Connectivity by working of this command
            curl -fs -o "${PATHDIR}upScriBt.sh" https://raw.githubusercontent.com/ScriBt/ScriBt/${BRANCH}/upScriBt.sh && \
                (echo -e "\n${SCS} Internet Connectivity : ONLINE"; bash "${PATHDIR}upScriBt.sh" "$0" "$1") || \
                echo -e "\n${FLD} Internet Connectivity : OFFINE\n\n${INF} Please connect to the Internet for complete functioning of ScriBt";
        else
            echo -e "\n${INF} Current working branch is not ${CL_WYT}master${NONE} [${BRANCH}]";
            echo -e "\n${FLD} Update-Check Cancelled";
            echo -e "\n${INF} No modifications have been done";
        fi
    fi

    # Where am I ?
    echo -e "\n${INF} ${CL_WYT}I'm in ${CALL_ME_ROOT}${NONE}\n";

    # are we 64-bit ??
    if ! [[ $(uname -m) =~ (x86_64|amd64) ]]; then
        echo -e "\n\033[0;31m[!]\033[0m Your Processor is not supported\n";
        exitScriBt 1;
    fi

    # Start a python2 virtualenv
    start_venv;

    # AutoBot
    ATBT="${CL_WYT}*${NONE}${CL_LRD}AutoBot${NONE}${CL_WYT}*${NONE}";

    # CHEAT CHEAT CHEAT!
    if [ -z "$automate" ]; then
        echo -e "${QN} Remember Responses for Automation ${CL_WYT}[y/n]${NONE}\n";
        prompt RQ_PGN;
        set -o posix;
        set > "${TV1}";
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
    cd "${PATHDIR}";
    # Spaces
    SP=$(( 27 - $(( $(echo ${VERSION} | wc -L) / 2 ))));
    SPCS=$(for ((i=0;i<"${SP}";i++)); do echo -en " "; done);
    unset SP;
    echo -e "${SPCS}${CL_WYT}${VERSION}${NONE}\n";
    unset SPCS;
    cd "${CALL_ME_ROOT}";
} # the_start

function automator()
{
    echo -e "\n${EXE} Searching for Automatable Configs\n";
    for AF in *.rc; do
        grep 'AUTOMATOR\=\"true_dat\"' --color=never "$AF" -l >> "${TMP}";
        sed -i -e 's/.rc//g' "${TMP}"; # Remove the file format
    done
    if [[ -s "${TMP}" ]]; then
        echo -e "\n${FLD} No Automation Configs found\n";
        exitScriBt 1;
    else
        NO=1;
        # Adapted from lunch selection menu
        while read -r CT; do
            CMB[$NO]="$CT";
            (( NO++ ));
        done <<< "$(cat "${TMP}")";
        unset CT NO;
        for CT in $(eval echo "{1..${#CMB[*]}}"); do
            echo -e " $CT. ${CMB[$CT]} ";
        done | column
        unset CT;
        echo -e "\n${QN} Which would you like\n";
        prompt ANO;
        echo -e "\n${EXE} Running ScriBt on Automation Config ${CMB[$ANO]}\n";
        sleep 2;
        source "${CMB[${ANO}]}.rc";
    fi
} # automator

# Some Essentials

# 'read -r' command with custom prompt '[>]' in Cyan
function prompt()
{
    read -r -p $'\033[1;36m[>]\033[0m ' "$1";
    if [[ -z "$(eval "echo \$$1")" ]] && [[ -z "$2" ]]; then
        echo -e "\n${FLD} No response provided\n";
        prompt "$1";
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
export CALL_ME_ROOT=$(echo "$(pwd)/" | sed -e 's#//$#/#g');

if [[ "$0" == "ROM.sh" ]] && [[ $(type -p ROM.sh) ]]; then
    export PATHDIR="$(type -p ROM.sh | sed 's/ROM.sh//g')";
else
    export PATHDIR="${CALL_ME_ROOT}";
fi

# Show Interrupt Acknowledgement message on receiving SIGINT
trap interrupt SIGINT;

# Version
if [ -d "${PATHDIR}.git" ]; then
    # Check Branch
    export BRANCH=$(git rev-parse --abbrev-ref HEAD);
    cd "${PATHDIR}";
    if [[ "${BRANCH}" == "master" ]]; then
        VERSION=$(git describe --tags $(git rev-list --max-count=1 HEAD));
    else
        VERSION="${BRANCH}";
    fi
    cd "${CALL_ME_ROOT}";
else
    VERSION="";
fi
if [[ "$1" == "automate" ]]; then
    export automate="yus_do_eet";
    the_start; # Pre-Initial Stage
    echo -e "${INF} ${ATBT} Lem'me do your work";
    automator;
elif [ -z "$1" ]; then
    the_start;
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
