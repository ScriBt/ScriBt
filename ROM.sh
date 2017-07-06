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
# Default Maximum Width to be occupied by the Interface                #
export NOCHARS_DEF="54";                                               #
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
    center_it "${CL_YEL}[!]${NONE} Command Execution ${CL_YEL}[!]${NONE}" "1eq1";
    for (( CT=0; CT<${#ARG[*]}; CT++ )); do
        echo -en "\033[1;3${CT}m$(eval "echo \${ARG[${CT}]}") " | sed -e 's/NULL//g' -e 's/execroot/sudo/g' -e 's/#/ /g';
    done
    echo -e "\n";
    for (( CT=0; CT<${#ARGD[*]}; CT++ )); do
        [[ $(eval "echo \${ARG[${CT}]}") != "NULL" ]] && \
         echo -en "\033[1;3${CT}m$(eval "echo \${ARGD[${CT}]}")\033[0m\n" | sed 's/#/ /g';
    done
    # Give some time for the user to read it
    pause "4";
    echo;
    [[ "$1" =~ --out=* ]] && TEE="2>&1 | tee -a ${1/*=/}";
    CMD=$(echo "${ARG[*]} ${TEE}" | sed -e 's/NULL//g' -e 's/#/ /g');
    # Execute the command
    if eval "${CMD}"; then
        echo -e "\n${SCS} Command Execution Successful";
        unset STS;
    else
        echo -e "\n${FLD} Command Execution Failed";
        STS="1";
    fi
    unset -v CMD CT ARG{,S,D} i;
    dash_it;
} # cmdprex

function cherrypick() # Automated Use only
{
    echo -ne '\033]0;ScriBt : Picking Cherries\007';
    center_it "${CL_LRD}Pick those Cherries${NONE}" "1eq";
    echo -e "\n${EXE} ${ATBT} Attempting to Cherry-Pick Provided Commits\n";
    cd "${CALL_ME_ROOT}$1" || exitScriBt 1;
    git fetch ${2/\/tree\// };
    git cherry-pick "$3";
    cd "${CALL_ME_ROOT}";
    echo -e "\n${INF} It's possible that the pick may have conflicts. Solve those and then continue.";
    dash_it;
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
        if ! sign_exists "\u2764"; then SIGN="<3"; fi;
        echo -e "${CL_LGN}[${NONE}${CL_LRD}${SIGN}${NONE}${CL_LGN}]${NONE} Peace! :)\n";
    else
        echo -e "${CL_LRD}[${NONE}${CL_RED}<${NONE}${CL_LGR}/${NONE}${CL_RED}3${NONE}${CL_LRD}]${NONE} Failed somewhere :(\n";
    fi
    rm -f "${TV1}" "${TV2}" "${TEMP}";
    [ -f "${PATHDIR}update_message.txt" ] && rm "${PATHDIR}update_message.txt";
    [ -s "${STMP}" ] || rm "${STMP}"; # If temp_sync.txt is empty, delete it
    [ -s "${RMTMP}" ] || rm "${RMTMP}"; # If temp_compile.txt is empty, delete it
    exit "$1";
} # exitScriBt

function get_rom_info()
{
    # Get ROM's info, if user directly starts sync
    cd "${CALL_ME_ROOT}.repo/manifests";
    _RNM=$(git config --get remote.origin.url | awk -F "/" '{print $4}');
    cd  ${CALL_ME_ROOT};
    for FILE in ${CAFR[*]} ${AOSPR[*]}; do
        if grep -q "${_RNM}" "${FILE}"; then
            source "${FILE}";
            ROM_FN="$(echo ${FILE//.rc/} | awk -F "/" '{print $NF}' | sed -e 's/_/ /g')";
            break;
        fi
    done;
    unset _RNM FILE FILES;
} # get_rom_info

function main_menu()
{
    echo -ne '\033]0;ScriBt : Main Menu\007';
    center_it "${SCS} ${CL_LBL}Main Menu${NONE} ${SCS}" "eq1";
    echo -e "1$(center_it "Choose ROM & Init" "sp" "$(( NOCHARS_DEF - 2 ))")1";
    echo -e "2$(center_it "Sync" "sp" "$(( NOCHARS_DEF - 2 ))")2";
    echo -e "3$(center_it "Pre-Build" "sp" "$(( NOCHARS_DEF - 2 ))")3";
    echo -e "4$(center_it "Build" "sp" "$(( NOCHARS_DEF - 2 ))")4";
    echo -e "5$(center_it "Various Tools" "sp" "$(( NOCHARS_DEF - 2 ))")5\n";
    echo -e "6$(center_it "About ScriBt" "sp" "$(( NOCHARS_DEF - 2 ))")6";
    echo -e "7$(center_it "EXIT" "sp" "$(( NOCHARS_DEF - 2 ))")7";
    dash_it;
    echo -e "\n${QN} Select the Option you want to start with\n";
    prompt ACTION;
    teh_action "${ACTION}" "mm";
} # main_menu

function manifest_gen() # D 1,5
{
    function add_repo()
    {
        export lineStart="<project" lineEnd="/>";
        echo -e "\n${INF} Please enter the following one by one\n";
        echo -e "${INF} Hit Enter if no answer is to be provided (repository name & path CANNOT be blank).";
        echo -en "\n${QN} Repository Name : "; prompt repo_name;
        echo -en "\n${QN} Repository Path : "; prompt repo_path;
        echo -en "\n${QN} Branch : "; prompt repo_revision --no-repeat;
        listremotes;
        echo -e "\n${QN} Enter the desired remote ${CL_WYT}name${NONE}\n";
        prompt repo_remote --no-repeat;
        line=( "name=\"${repo_name}\"" "path=\"${repo_path}\"" );
        [ ! -z "${repo_revision}" ] && line=( "${line[*]}" "revision=\"${repo_revision}\"" );
        [ ! -z "${repo_remote}" ] && line=( "${line[*]}" "remote=\"${repo_remote}\"" );
        if grep -q "${repo_path}" "${MANIFEST}"; then
            echo -e "\n${FLD} Another repo has the same checkout path ${CL_WYT}${repo_path}${NONE}";
            echo -e "\n${INF} Please try again";
        else
            line=( "${lineStart}" "${line[*]}" "${lineEnd}" );
            echo -e "${line[*]}" >> "${FILE}";
            echo -e "\n${SCS} Repository added";
        fi
        unset repo_{name,path,revision,remote};
        unset line{,Start,End};
    } # add_repo

    function remove_repo()
    {
        export lineStart="<remove-project" lineEnd="/>";
        echo -e "\n${QN} Please enter the Repository Name\n";
        prompt repo_name;
        if grep -q "${repo_name}" "${MANIFEST}"; then
            line=( "${lineStart}" "name=\"${repo_name}\"" "${lineEnd}" );
            echo -e "${line[*]}" >> "${FILE}";
            echo -e "\n${SCS} Project ${repo_name} removed from manifest";
        else
            echo -e "\n${FLD} Project ${repo_name} not found. Bailing out.\n";
        fi
        unset repo_name;
        unset line{,Start,End};
    } # remove_repo

    function add_remote()
    {
        export lineStart="<remote"; export lineEnd="/>";
        echo -e "\n${INF} Please enter the following one by one\n";
        echo -e "${INF} If some of them are not needed, hit ENTER key [remote name and remote URL CANNOT be blank]";
        echo -en "\n${QN} Remote Name : "; prompt remote_name;
        echo -en "\n${QN} Remote Fetch URL : "; prompt remote_url;
        echo -en "\n${QN} Revision : "; prompt remote_revision;
        for CT in ${REMN[*]}; do
            if [[ "${CT}" == "${remote_name}" ]]; then
                echo -e "${FLD} Remote ${remote_name} already exists\n";
                echo -e "${INF} Try again\n";
                break && manifest_gen_menu;
            fi
        done
        line=( "name=\"${remote_name}\"" "fetch=\"${remote_url}\"" );
        [ ! -z "${remote_revision}" ] && line=( "${line[*]}" "revision=\"${remote_revision}\"" );
        line=( "${lineStart}" "${line[*]}" "${lineEnd}" );
        echo -e "${line[*]}" >> "${FILE}";
        echo -e "\n${SCS} Remote ${remote_name} added";
        unset remote_{name,revision,url};
        unset line{,Start,End};
        unset CT;
    } # add_remote

    function listremotes()
    {
        echo -en "\n${INF} Following are the list of Remotes\n";
        echo -en "\n${INF} ${CL_WYT}Name${NONE}\t${CL_DGR}(Fetch URL)${NONE}\n\n";
        for (( CT=0; CT<"${#REMN[*]}"; CT++ )); do
            eval "echo -e \${CL_WYT}\${REMN[$CT]} \${CL_DGR}\(\${REMF[$CT]}\)";
            echo -e "${NONE}";
        done
    } # listremotes

    function listops()
    {
        echo -e "\n${INF} Operations Performed\n";
        while read -r line; do
            eval $(echo $line | sed -e 's/^<.* n/n/g' -e 's/\/>//g');
            case "$(echo $line | awk '{print $1}')" in
                "<project")
                    echo -e "${INF} ${CL_LGN}Add${NONE} Project ${CL_WYT}${name}${NONE}\n"
                    echo -e "${INDENT}Checkout Path : $path";
                    echo -e "${INDENT}Revision (Branch) : $revision";
                    echo -e "${INDENT}Remote : $remote\n";
                    ;;
                "<remove-project")
                    echo -e "${INF} ${CL_LRD}Remove${NONE} Project ${CL_WYT}${name}${NONE}\n";
                    ;;
                "<remote")
                    echo -e "${INF} ${CL_WYT}Add${NONE} remote ${CL_WYT}${name}${NONE}";
                    echo -e "${INDENT}Fetch URL : $fetch";
                    echo -e "${INDENT}Default Revision (branch) : $revision\n";
                    ;;
            esac
            unset name path remote revision fetch;
        done <<< "$(awk 'f;/<manifest>/{f=1}' ${FILE})";
    } # listops

    function save_me()
    {
        echo -e "\n${QN} Provide a name for this manifest [Just the name]\n";
        prompt NAME;
        echo -e "</manifest>" >> "${FILE}";
        if mv -f "${FILE}" ".repo/local_manifests/${NAME}.xml"; then
            echo -e "\n${SCS} Custom Manifest successfully saved\n";
        else
            echo -e "\n${FLD} Couldn't save the manifest";
            echo -e "\n${INF} Manually copy ${CL_WYT}file.xml${NONE} to .repo/local_manifests/${NAME}.xml\n";
        fi
        unset CT OP NAME;
        # Delete intermediate manifest
        rm -f "${MANIFEST}";
        quick_menu;
    } # save_me

    function manifest_gen_menu()
    {
        unset OP;
        center_it "${CL_LGN}[!]${NONE} ${CL_WYT}Manifest Generator${NONE} ${CL_LGN}[!]${NONE}" "1eq1";
        echo -e "1) Add a repository/project";
        echo -e "2) Remove a repository/project";
        echo -e "3) Add a remote";
        echo -e "4) List remotes";
        echo -e "5) List performed operations";
        echo -e "6) Save Custom Manifest && Return to Quick-Menu";
        echo -e "\nTo ${CL_WYT}Replace${NONE} a Repo -> Remove the repo, then add it's replacement";
        dash_it;
        prompt OP;
        unset CT repo_path;
        unset {repo,remote}_{name,revision,remote};
        unset line{,Start,End};
        case "${OP}" in
            1) add_repo ;;
            2) remove_repo ;;
            3) add_remote ;;
            4) listremotes ;;
            5) listops ;;
            6) save_me ;;
        esac
        [[ "$OP" != "6" ]] && manifest_gen_menu;
    } # manifest_gen_menu

    if [[ ! -d .repo ]]; then
        echo -e "\n${FLD} ROM Source not initialized\n";
        quick_menu;
    else
        # Grab the manifest
        MANIFEST="${CALL_ME_ROOT}manifest.xml";
        rm -f "${MANIFEST}";
        repo manifest > "${MANIFEST}";
        # Our file
        FILE="${CALL_ME_ROOT}file.xml";
        rm -f "${FILE}";
        # `while' equivalent of this loop brings all test cases in ONE line
        # And additionally distinguishes each test case by a newline between them
        # Not what I wanted (seperate lines), So...
        # shellcheck disable=SC2013
        for line in $(grep '<remote' "${MANIFEST}" | sed -e 's/<remote//g' -e 's/ /X/g' -e 's/\/>//g'); do
            line="${line//X/ }";
            eval "$line";
            if [[ "${fetch}" == ".." ]]; then
                cd "${CALL_ME_ROOT}.repo/manifests";
                # Poor awk logic :/, won't burn down the world tho :)
                fetch=$(git config --get remote.origin.url | awk -F "/" '{print $1"//"$3}');
                cd "${CALL_ME_ROOT}";
            fi
            REMN+=( "$name" );
            REMF+=( "$fetch" );
        done
        unset line fetch name review revision;
        mkdir -p "${CALL_ME_ROOT}.repo/local_manifests/";
        touch "${FILE}";
        echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<manifest>" > "${FILE}";
        manifest_gen_menu;
    fi
} # manifest_gen

function it_is_apt() # D pkgmgr_check
{
    while read -r path; do
        if apt moo &> /dev/null; then
            APTPATH="${path}";
        fi
    done <<< "$(which apt-get)
    $(which apt)";
    if [ -z "${APTPATH}" ]; then
        return 1;
    else
        return 0;
    fi
} # it_is_apt

function pkgmgr_check() # ID
{
    if which pacman &> /dev/null; then
        PKGMGR="pacman";
    elif it_is_apt; then
        PKGMGR="${APTPATH}";
    else
        echo -e "${FLD} No supported package manager has been found.";
        echo -e "\n${INF} Arch Linux or a Debian/Ubuntu based Distribution is required to run ScriBt.";
        exitScriBt 1;
    fi
    echo -e "\n${SCS} Package manager ${CL_WYT}${PKGMGR//*apt/apt}${NONE} detected.\033[0m";
} # pkgmgr_check

function quick_menu()
{
    echo -ne '\033]0;ScriBt : Quick Menu\007';
    center_it "${CL_PNK}Quick-Menu${NONE}" "1eq";
    center_it "1. Init | 2. Sync | 3. Pre-Build | 4. Build | 5. Tools" "sp";
    center_it "6. About ScriBt | 7. Exit" "sp";
    dash_it "0";
    prompt ACTION;
    teh_action $ACTION "qm";
} # quick_menu

function rom_check() # D 1,2,3
{
    if ! echo $1 | grep -q 'A'; then
        FILE=$(eval "echo \${CAFR[$1]}" | sed 's/ /_/g');
    else
        FILE=$(eval "echo \${AOSPR[${1//A/}]}" | sed 's/ /_/g');
    fi
    if [ -f "${FILE}" ]; then
        source "${FILE}";
    else
        echo -e "\n${FLD} Invalid Selection\n";
        rom_select;
    fi
} # rom_check

function rom_select() # D 1,2
{
    dash_it;
    echo -e "${CL_YEL}[?]${NONE} ${CL_WYT}Which ROM are you trying to build\nChoose among these (Number Selection)\n";
    for (( CT=1; CT<"${#CAFR[*]}"; CT++ )); do
        echo -n "${CT}. ";
        eval "echo -en \${CAFR[$CT]//.rc/}" | awk -F "/" '{print $NF}' | sed -e 's/_/ /g';
    done | pr -t -2;
    echo -e "\n${INF} ${CL_WYT}Non-CAF / Google-Family ROMs${NONE}";
    echo -e "${INF} ${CL_WYT}Choose among these ONLY if you're building for a Nexus/Pixel Device\n";
    for (( CT=1; CT<"${#AOSPR[*]}"; CT++ )); do
        echo -n "A${CT}. ";
        eval "echo -en \${AOSPR[$CT]//.rc/}" | awk -F "/" '{print $NF}' | sed -e 's/_/ /g';
    done | pr -t -2;
    dash_it;
    [ -z "$automate" ] && unset SBRN && prompt SBRN;
    rom_check "$SBRN";
    ROM_FN="$(echo ${FILE//.rc/} | awk -F "/" '{print $NF}' | sed -e 's/_/ /g')";
    echo -e "\n${INF} You have chosen -> ${CL_WYT}${ROM_FN}${NONE}\n";
    unset CT;
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
            eval "SB$1=${SB2}";
        fi
        export "SB${1//\[*\]}";
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
    pause "4";
    echo -e "${EXE} Detecting Available Branches in ${ROM_FN} Repository";
    RCT=$(( ${#ROM_NAME[*]} - 1 ));
    for CT in $(eval "echo {0..$RCT}"); do
        echo -e "\nOn ${ROM_NAME[$CT]} (ID->$CT)\n";
        BRANCHES=$(git ls-remote -h "https://github.com/${ROM_NAME[$CT]}/${MAN[$CT]}" |\
            awk -F "/" '{if (length($4) != 0) {print $3"/"$4} else {print $3}}');
        if [[ ! -z "$CNS" && "$SBRN" != A* ]]; then
            echo "$BRANCHES" | grep --color=never 'caf' | column;
        else
            echo "$BRANCHES" | column;
        fi
    done
    unset CT;
    echo -e "\n${INF} These Branches are available at the moment";
    echo -e "\n${QN} Specify the ID and Branch you're going to sync";
    echo -e "\n${INDENT}Format : [ID] [BRANCH]\n";
    ST="Branch"; shut_my_mouth NBR "$ST";
    CT="${SBNBR/ */}"; # Count
    SBBR="${SBNBR/* /}"; # Branch
    MNF="${MAN[$CT]}"; # Orgn manifest name at count
    RNM="${ROM_NAME[$CT]}"; # Orgn name at count
    echo -e "${QN} Any Source you have already synced ${CL_WYT}[y/n]${NONE}\n"; get "info" "refer";
    ST="Use Reference Source"; shut_my_mouth RF "$ST";
    if [[ "$SBRF" == [Yy] ]]; then
        echo -e "\n${QN} Provide me the Synced Source's Location from /\n";
        ST="Reference Location"; shut_my_mouth RFL "$ST";
        REF="--reference=\"${SBRFL}\"";
    fi
    echo -e "${QN} Set clone-depth ${CL_WYT}[y/n]${NONE}\n"; get "info" "cldp";
    ST="Use clone-depth"; shut_my_mouth CD "$ST";
    if [[ "$SBCD" == [Yy] ]]; then
        echo -e "${QN} Depth Value ${CL_WYT}[Default - 1]${NONE}\n";
        ST="clone-depth Value"; shut_my_mouth DEP "$ST";
        CDP="--depth\=${SBDEP:-1}";
    fi
    # Check for Presence of Repo Binary
    if ! which repo; then
        echo -e "${FLD} ${CL_WYT}repo${NONE} binary isn't installed";
        echo -e "\n${EXE} Installing ${CL_WYT}repo${CL_WYT}";
        [ ! -d "${HOME}/bin" ] && mkdir -pv ${HOME}/bin;
        cmdprex \
            "Tool/Lib to transfer data with URL syntax<->curl" \
            "repo dwnld URL<->https://storage.googleapis.com/git-repo-downloads/repo" \
            "Output Redirection Operator<->>" \
            "Redirection file<->${HOME}/bin/repo";
        cmdprex \
            "Change Permissions on an Entity<->chmod" \
            "Add executable permission<->a+x" \
            "File to be chmod-ed<->${HOME}/bin/repo";
        echo -e "${SCS} Repo Binary Installed";
        echo -e "\n${EXE} Adding ${HOME}/bin to PATH\n";
        if [[ $(grep 'PATH=["]*' ${HOME}/.profile | grep -c '$HOME/bin') != "0" ]]; then
            echo -e "${SCS} $HOME/bin is in PATH";
        else
            {
                echo -e "\n# set PATH so it includes user's private bin if it exists";
                echo -e "if [ -d \"\$HOME/bin\" ]; then\n${INDENT}PATH=\"\$HOME/bin:\$PATH\"\nfi";
            } >> "${HOME}/.profile";
            source ${HOME}/.profile;
            echo -e "\n${SCS} $HOME/bin added to PATH";
        fi
        echo -e "${SCS} Done. Ready to Initialize Repo";
    fi
    MURL="https://github.com/${RNM}/${MNF}";
    cmdprex --out="${STMP}" \
        "repository management tool<->repo" \
        "initialze in current directory<->init" \
        "reference source directory<->${REF}" \
        "clone depth<->${CDP}" \
        "manifest URL specifier<->-u" \
        "URL<->${MURL}" \
        "manifest branch specifier<->-b" \
        "branch<->${SBBR}";
    unset BRANCHES MURL CDP REF MNF CT;
    if [ -z "$STS" ]; then
        if [ ! -f "${CALL_ME_ROOT}.repo/local_manifests" ]; then
            mkdir -pv "${CALL_ME_ROOT}.repo/local_manifests";
        fi
        if [ -z "$automate" ]; then
            echo -e "\n${QN} Generate a Custom manifest ${CL_WYT}[y/n]${NONE}\n";
            prompt SBGCM;
            [[ "$SBGCM" == [Yy] ]] && manifest_gen;
        fi
    else
        unset STS;
    fi
    [ -z "$automate" ] && quick_menu;
} # init

function sync() # 2
{
    # Change terminal title
    [ ! -z "$automate" ] && teh_action 2;
    if [ ! -f .repo/manifest.xml ]; then init; fi;
    get_rom_info;
    echo -e "\n${EXE} Preparing for Sync\n";
    echo -e "${QN} Number of Threads for Sync \n"; get "info" "jobs";
    ST="Number of Threads"; shut_my_mouth JOBS "$ST";
    echo -e "${QN} Force Sync needed ${CL_WYT}[y/n]${NONE}\n"; get "info" "fsync";
    ST="Force Sync"; shut_my_mouth F "$ST";
    echo -e "${QN} Need some Silence in the Terminal ${CL_WYT}[y/n]${NONE}\n"; get "info" "silsync";
    ST="Silent Sync"; shut_my_mouth S "$ST";
    echo -e "${QN} Sync only Current Branch ${CL_WYT}[y/n]${NONE}\n"; get "info" "syncrt";
    ST="Sync Current Branch"; shut_my_mouth C "$ST";
    echo -e "${QN} Sync with clone-bundle ${CL_WYT}[y/n]${NONE}\n"; get "info" "clnbun";
    ST="Use clone-bundle"; shut_my_mouth B "$ST";
    dash_it;
    #Sync-Options
    [[ "$SBS" == "y" ]] && SILENT="-q";
    [[ "$SBF" == "y" ]] && FORCE="--force-sync";
    [[ "$SBC" == "y" ]] && SYNC_CRNT="-c";
    [[ "$SBB" == "y" ]] || CLN_BUN="--no-clone-bundle";
    echo -e "${EXE} Starting Sync for ${ROM_FN}";
    cmdprex --out="${STMP}" \
        "repository management tool<->repo" \
        "update working tree<->sync" \
        "no. of jobs<->-j${SBJOBS:-1}" \
        "silent sync<->${SILENT}" \
        "force sync<->${FORCE}" \
        "sync current branch only<->${SYNC_CRNT}" \
        "use clone.bundle<->${CLN_BUN}";
    unset SILENT FORCE SYNC_CRNT CLN_BUN;
    [ -z "$automate" ] && quick_menu;
} # sync

function device_info() # D 3,4
{
    echo -ne "\033]0;ScriBt : Device Info\007";
    # Change ROMNIS to ROMV if ROMV is non-zero
    [ ! -z "${ROMV}" ] && export ROMNIS="${ROMV}";
    if [ -d "${CALL_ME_ROOT}vendor/${ROMNIS}/config" ]; then
        CNF="vendor/${ROMNIS}/config";
    elif [ -d "${CALL_ME_ROOT}vendor/${ROMNIS}/configs" ]; then
        CNF="vendor/${ROMNIS}/configs";
    elif [ -d "${CALL_ME_ROOT}vendor/${ROMNIS}/products" ]; then
        CNF="vendor/${ROMNIS}/products";
    else
        CNF="vendor/${ROMNIS}";
    fi
    get_rom_info; # Restore ROMNIS
    center_it "${CL_PRP}Device Info${NONE}" "1eq1";
    echo -e "${QN} What's your Device's CodeName";
    echo -e "\n${INF} Refer Device Tree - All Lowercases\n";
    ST="Device CodeName"; shut_my_mouth DEV "$ST";
    SBCM=$(find device/*/"${SBDEV}" -maxdepth 0 -type d | awk -F "/" '{print $2}');
    if [ -z "${SBCM}" ]; then
        echo -e "\n${FLD} Device Tree not found";
        echo -e "${INDENT}Invalid Details OR Missing Source";
        echo -e "\n${QN} Correct the provided details ${CL_WYT}[y/n]${NONE}";
        prompt PD;
        case "$PD" in
            [Yy])
                unset PD;
                device_info;
                ;;
            *)
                quick_menu;
                ;;
        esac
    fi
    echo -e "${QN} Build type \n${INF} Valid types : userdebug, user, eng\n";
    ST="Build type"; shut_my_mouth BT "$ST";
    if [[ "$SBBT" =~ userdebug\|user\|eng ]]; then
        echo -e "\n${FLD} Invalid build type specified";
        echo -e "\n${EXE} Falling back to ${CL_WYT}userdebug${NONE}";
        SBBT="userdebug";
    fi
    echo -e "\n${QN} Choose your Device type among these";
    get "info" "devtype";
    get "misc" "device_types";
    for TYP in ${TYPES[*]}; do
        if [ -f "${CNF}/${TYP}.mk" ]; then echo -e "$TYP"; fi;
    done | pr -t -2;
    unset CT;
    echo;
    ST="Device Type"; shut_my_mouth DTP "$ST";
    dash_it;
} # device_info

function start_venv()
{
    # Create a Virtual Python2 Environment
    if [[ "${PKGMGR}" == "pacman" ]] && [[ -z "${ACTIVE_VENV}" ]]; then
        if python -V | grep -i -q "Python 3."; then
            echo -e "${INF} Python 3 Detected";
            echo -e "\n${INF} Android BuildSystem requires a Python 2.x Environment to function properly";
            if ! which virtualenv2 &> /dev/null; then
                echo -e "\n${FLD} Python2 not found";
                echo -e "\n${EXE} Attempting to install Python2\n";
                cmdprex \
                    "Execute command as 'root'<->execroot" \
                    "Arch Linux Package Mgr.<->${PKGMGR}" \
                    "Sync Pkgs.<->-S" \
                    "Answer 'yes' to prompts<->--noconfirm" \
                    "virtual env. (python2) package<->python2-virtualenv";
            fi
            echo -e "\n${EXE} Creating Python2 virtual environment";
            cmdprex \
                "Python2 Virtual EnvSetup<->virtualenv2" \
                "Location of Virtual Env<->${HOME}/venv";
            if [[ -z "$STS" ]]; then
                cmdprex \
                    "Execute in current shell<->source" \
                    "Shell script to activate Virtual Env<->${HOME}/venv/bin/activate";
                 echo -e "${SCS} Python2 environment created\n";
                 ACTIVE_VENV="true";
            else
                echo -e "${FLD} An error occured while trying to start the Environment";
                echo -e "\n${EXE} Aborting\n";
                exitScriBt 1;
            fi
        fi
    fi
} # start_venv

function stop_venv()
{
    if [[ "${ACTIVE_VENV}" == "true" ]]; then
        echo -e "\n${EXE} Exiting virtual environment\n";
        deactivate && rm -rf ${HOME}/venv && echo -e "${SCS} Python2 virtual environment deleted";
    fi
} # stop_venv

function init_bld() # D 3,4
{
    dash_it;
    echo -e "${EXE} Initializing Build Environment";
    cmdprex \
        "Execute in current shell<->source" \
        "Environment Setup Script<->build/envsetup.sh";
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
    get_rom_info;
    init_bld;
    [ -z "${SBDEV}" ] && device_info;
    # Change terminal title
    [ ! -z "$automate" ] && teh_action 3;
    DEVDIR="device/${SBCM}/${SBDEV}/";

    function vendor_strat_all()
    {
        if [[ ! -z "$ROMV" ]]; then cd "vendor/${ROMV}"; else cd "vendor/${ROMNIS}"; fi;
        dash_it;

        function dtree_add()
        {   # AOSP-CAF|RRO|F-AOSP|Flayr|OmniROM|Zephyr
            echo -e "\n${EXE} Adding Lunch Combo in Device Tree";
            [ ! -f "${DEVDIR}vendorsetup.sh" ] && touch "${DEVDIR}vendorsetup.sh";
            if ! grep -q "${ROMNIS}_${SBDEV}" "${DEVDIR}vendorsetup.sh"; then
                echo -e "add_lunch_combo ${TARGET}" >> ${DEVDIR}vendorsetup.sh;
            else
                echo -e "\n${SCS} Lunch combo already added to vendorsetup.sh";
            fi
        } # dtree_add

        if [[ "$ROMNIS" == "du" ]] && [[ "$CNS" == "y" ]]; then
            VSTP="caf-vendorsetup.sh";
        else
            VSTP="vendorsetup.sh";
        fi
        echo -e "\n${EXE} Adding Device to ROM Vendor";
        for STRAT_FILE in "${ROMNIS}.devices" "${ROMNIS}-device-targets" "${VSTP}"; do
            #          Found file     &&    Strat Not Performed
            if [ -f "${STRAT_FILE}" ] && [ -z "${STRAT_DONE}" ]; then
                if ! grep -q "${SBDEV}" "${STRAT_FILE}"; then
                    case "${STRAT_FILE}" in
                        "${ROMNIS}.devices")
                            echo -e "${SBDEV}" >> "${STRAT_FILE}" ;;
                        "${ROMNIS}-device-targets")
                            echo -e "${TARGET}" >> "${STRAT_FILE}" ;;
                        "${VSTP}")
                            echo -e "add_lunch_combo ${TARGET}" >> "${STRAT_FILE}" ;;
                    esac
                else
                    echo -e "\n${INF} Device already added to ${STRAT_FILE}";
                fi
                export STRAT_DONE="y"; # File Found, Strat Performed
            fi
        done
        [ -z "${STRAT_DONE}" ] && dtree_add; # If none of the Strats Worked
        echo -e "\n${SCS} Done";
        cd "${CALL_ME_ROOT}";
        dash_it;
    } # vendor_strat_all

    function vendor_strat_kpa() # AOKP-4.4|AICP|PAC-5.1|Krexus-CAF|AOSPA|Non-CAFs
    {
        cd "${CALL_ME_ROOT}vendor/${ROMNIS}/products";

        function bootanim()
        {
            echo -e "\n${INF} Device Resolution\n";
            if [ ! -z "$automate" ]; then
                get "info" "bootres";
                echo -e "\n${QN} Enter the Desired Highlighted Number\n";
                prompt SBBTR;
            else
                echo -e "${INF} ${ATBT} Resolution Chosen : ${SBBTR}";
            fi
        } # bootanim

        #Vendor-Calls
        get "strat" "${ROMNIS}";
        get "strat" "common";
    } # vendor_strat_kpa

    function find_ddc() # For Finding Default Device Configuration file
    {
        # used by :- interactive_mk, src/strat/common.rc
        # Collect a list of makefiles containing the string PRODUCT_NAME
        DDCS=( $(grep -rl "PRODUCT_NAME" | sed -e 's/.mk//g') );
        # If required file is present && function was called by 'interactive_mk'; then
        if (echo "${DDCS[*]}" | grep -q "${INTF}") && [[ $1 == "intm" ]]; then
            DDC="NULL";
        else
            # Add grep expression entries
            for file in ${DDCS[*]}; do
                GREP+=( "-e $file " );
            done
            # Get a count of other DDCs inherited by the makefile
            for file in ${DDCS[*]}; do
                read -r "C_${file}" <<< $(grep -c "${GREP[*]}" "${file}.mk");
            done
            max=0;
            # DDC should be the file inheriting maximum product makefiles
            for file in ${DDCS[*]}; do
                if [[ $(eval "echo \${C_${file}}") -ge "$max" ]]; then
                     DDC="${file}.mk";
                     max=$(eval "echo \${C_${file}}");
                fi
            done
        fi
        unset file max GREP DDCS;
    } # find_ddc

    function print_makefile_addition()
    {
        echo -e "\n${INF} Adding the following makefile call under ${2}";
        echo -e "\n\$(${CL_LRD}call${NONE} ${CL_YEL}inherit-product${NONE}, ${CL_LGN}${1}${NONE})";
        echo -e "\n${CL_LRD}call a function${NONE}";
        echo -e "${CL_YEL}function which inherits a product's makefile${NONE}";
        echo -e "${CL_LGN}makefile to be called${NONE}\n";
        pause "1";
    } # print_makefile_addition

    function interactive_mk()
    {
        init_bld;
        dash_it;
        echo -e "${EXE} Creating Interactive Makefile";
        echo -e "${INDENT}So that device tree gets identified by the ROM's BuildSystem\n";
        pause "4";

        function create_imk()
        {
            cd "${DEVDIR}";
            [ -z "$INTF" ] && INTF="${ROMNIS}.mk";
            get "misc" "intmake";
            print_makefile_addition "${CNF}/${SBDTP}.mk" "${INTF}";
            print_makefile_addition "${DEVDIR}${DDC}" "${INTF}";
            {
                echo -e "\n# Inherit ${ROMNIS} common stuff";
                echo -e "\$(call inherit-product, ${CNF}/${SBDTP}.mk)";
                echo -e "\n# Calling Default Device Configuration File";
                echo -e "# File which contains ROM Identifiers, Vital Device info";
                echo -e "# And inherits from other product makefiles";
                echo -e "\$(call inherit-product, ${DEVDIR}${DDC})";
            } >> "${INTF}";
            # To prevent Missing Vendor Calls in DDC-File
            echo -e "\n${INF} In file ${CL_WYT}${DDC}${NONE}";
            echo -e "${INDENT}${CL_WYT}inherit-product${NONE} is replaced by ${CL_WYT}inherit-product-if-exists${NONE}"
            echo -e "${INDENT}Since ${CL_WYT}${DDC}${NONE} may inherit makefiles ${CL_WYT}from a different ROM${NONE} that might not exist";
            echo -e "\n${INF} This is being done so that the build won't fail even when other ROM's makefile(s) go missing\n";
            pause "4";
            # Search for makefile calls |\
            #     Invert match 'vendor/${name-of-vendor}' |\
            #         Perform the replacement on remaining matches;
            grep 'call inherit-product' "${DEVDIR}${DDC}" |\
                grep -v "vendor/${SBCM}" |\
                    sed -i 's/inherit-product, vendor/inherit-product-if-exists, vendor/g' "${DDC}";
            # Add User-desired Makefile Calls
            echo -e "\n${INF} Enter number of desired Makefile calls";
            echo -e "\n${INF} Enter 0 if you don't want to add any\n";
            ST="No of Makefile Calls"; shut_my_mouth NMK "$ST";
            for (( CT=0; CT<"${SBNMK}"; CT++ )); do
                echo -e "\n${QN} Enter Makefile location from Root of BuildSystem\n";
                ST="Makefile"; shut_my_mouth LOC[$CT] "$ST" array;
                if [ -f "${CALL_ME_ROOT}${SBLOC[$CT]}" ]; then
                    echo -e "\n${EXE} Adding Makefile $(( CT + 1 ))";
                    print_makefile_addition "${SBLOC[$CT]}" "${INTF}";
                    echo -e "\n\$(call inherit-product, ${SBLOC[$CT]})" >> "${INTF}";
                else
                    echo -e "\n${FLD} Makefile ${SBLOC[$CT]} not Found. Aborting";
                fi
            done
            unset CT;
            echo -e "\n${INF} Adding ROM specific identification variable";
            {
                echo -e "\n# ROM Specific Identifier";
                echo -e "PRODUCT_NAME := ${ROMNIS}_${SBDEV}";
            } >> "${INTF}";
            echo -e "\n${SCS} Interactive Makefile ${CL_WYT}${INTF}${NONE} created successfully";
            echo -e "${INF} Please take a look at ${CL_WYT}${DEVDIR}${INTF}${NONE} later on how it was made";
            cd "${CALL_ME_ROOT}";
            dash_it;
        } # create_imk

        find_ddc "intm";
        if [[ "$DDC" != "NULL" ]]; then create_imk; else echo "$NOINT"; fi;
    } # interactive_mk

    function need_for_int()
    {
        if [ -f "${CALL_ME_ROOT}${DEVDIR}${INTF}" ]; then
            echo "$NOINT";
        else
            interactive_mk;
        fi
    } # need_for_int

    echo -e "\n${EXE} ${ROMNIS}-fying Device Tree\n";

    NOINT=$(echo -e "${SCS} Interactive Makefile Unneeded, continuing");
    APMK="${CALL_ME_ROOT}${DEVDIR}AndroidProducts.mk";
    if [ -f "$APMK" ]; then S="+="; else S=":="; fi;

    function add_prdt_makefile_to_apmk()
    {
        echo -e "${INF} Adding line under ${CL_WYT}${APMK}${NONE} to include makefile ${CL_WYT}${INTF}${NONE}";
        {
            echo -e "\nPRODUCT_MAKEFILES $S \\";
            echo -e "\t\$(LOCAL_DIR)/${INTF}";
        } >> "${APMK}";
    } # add_prdt_makefile_to_apmk

    case "$ROMNIS" in
        aosp|carbon|nitrogen|omni|zos)
            # AEX|AOSP-CAF/RRO|Carbon|F-AOSP|Flayr|Nitrogen|OmniROM|Parallax|Zephyr
            INTF="${ROMNIS}_${SBDEV}.mk";
            need_for_int;
            add_prdt_makefile_to_apmk;
            ;;
        eos)
            INTF="${ROMNIS}.mk";
            need_for_int;
            add_prdt_makefile_to_apmk;
            ;;
        aosip)
            # AOSiP-CAF
            if [ ! -f "vendor/${ROMNIS}/products" ]; then
                INTF="${ROMNIS}.mk";
                need_for_int;
            else
                echo "$NOINT";
            fi
            ;;
        aokp|pac)
            # AOKP-4.4|PAC-5.1
            if [ ! -f "vendor/${ROMNIS}/products" ]; then
                INTF="${ROMNIS}.mk";
                need_for_int;
            else
                echo "$NOINT";
            fi
            ;;
        aicp|krexus|pa|pure|krexus|pure)
            # AICP|Krexus-CAF|AOSPA|Non-CAFs except DU
            echo "$NOINT";
            ;;
        *)
            # Rest of the ROMs
            INTF="${ROMNIS}.mk";
            need_for_int;
            ;;
    esac
    unset S;

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
    pause "4";
    [ -z "$automate" ] && quick_menu;
} # pre_build

function build() # 4
{
    # Change terminal title
    [ ! -z "$automate" ] && teh_action 4;

    function hotel_menu()
    {
        center_it "${CL_LBL}Hotel Menu${NONE}" "1eq1";
        echo -e "[*] ${CL_WYT}lunch${NONE} > Setup Build Environment for the Device";
        echo -e "[*] ${CL_WYT}breakfast${NONE} > Download Device Dependencies and ${CL_WYT}lunch${NONE}";
        echo -e "[*] ${CL_WYT}brunch${NONE} > ${CL_WYT}breakfast${NONE} + ${CL_WYT}lunch${NONE} then Start Build\n";
        echo -e "${QN} Type in the desired option\n";
        echo -e "${INF} Building for a new Device ? select ${CL_WYT}lunch${NONE}";
        dash_it;
        ST="Selected Option"; shut_my_mouth SLT "$ST";
        case "$SBSLT" in
            "lunch")
                cmdprex \
                    "Setup Device-Specific Build Environment<->${SBSLT}" \
                    "Target Name<->${TARGET}";
                ;;
            "breakfast")
                cmdprex \
                    "Fetch dependencies and Setup Device-Specific Build Environment<->${SBSLT}" \
                    "Device Codename<->${SBDEV}" \
                    "ROM BuildType<->${SBBT}";
                ;;
            "brunch")
                echo -e "\n${EXE} Starting Compilation - ${ROM_FN} for ${SBDEV}\n";
                cmdprex \
                    "Sync n Build<->${SBSLT}" \
                    "Device Codename<->${SBDEV}";
                ;;
            *) echo -e "${FLD} Invalid Selection.\n"; hotel_menu ;;
        esac
        echo;
    } # hotel_menu

    function build_make()
    {
        if [[ "$1" != "brunch" ]]; then
            # Showtime!
            [[ "$SBMK" != "mka" ]] && BCORES="-j${BCORES:-1}";
            # Sequence ->  GZRs & CarbonROM | AOKP | AOSiP | A lot of ROMs | All ROMs
            for MAKECOMMAND in ${ROMNIS} rainbowfarts kronic bacon otapackage; do
                if [[ $(grep -c "^${MAKECOMMAND}:" "${CALL_ME_ROOT}build/core/Makefile") == "1" ]]; then
                    START=$(date +"%s"); # Build start time
                    cmdprex --out="${RMTMP}" \
                        "GNU make<->${SBMK}" \
                        "Target name to build ROM<->${MAKECOMMAND}" \
                        "No. of cores<->${BCORES}";
                    END=$(date +"%s"); # Build end time
                    break;  # Building one target is enough
                fi
            done
            SEC=$(( END - START )); # Difference gives Build Time
            if [ -z "$STS" ]; then
                echo -e "\n${FLD} Build Status : Failed";
            else
                echo -e "\n${SCS} Build Status : Success";
            fi
            echo -e "\n${INF} ${CL_WYT}Build took $(( SEC / 3600 )) hour(s), $(( SEC / 60 % 60 )) minute(s) and $(( SEC % 60 )) second(s).${NONE}" | tee -a "${RMTMP}";
            echo -e "\n${INF} Build log stored in ${CL_WYT}${RMTMP}${NONE}";
            dash_it;
            quick_menu;
        fi
    } # build_make

    function make_module()
    {
        if [ -z "$1" ]; then
            echo -e "\n${QN} Know the Location of the Module\n";
            prompt KNWLOC;
        fi
        if [[ "$KNWLOC" == "y" || "$1" == "y" ]]; then
            echo -e "\n${QN} Specify the directory which builds the module\n";
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
                *) echo -e "\n${FLD} Invalid Selection\n"; make_module ;;
            esac
        else
            echo -e "\n${INF} Do either of these two actions:\n1. Google it (Easier)\n2. Run this command in terminal : grep \"LOCAL_MODULE := <Insert_MODULE_NAME_Here> \".\n\n Press ENTER after it's Done..\n";
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
        echo -e "${INF} You're building on ${CL_WYT}${KBUILD_BUILD_USER}@${KBUILD_BUILD_HOST}${NONE}";
        echo -e "\n${SCS} Done";
    } # custuserhost

    function kbuild()
    {
        function kinit()
        {
            echo -e "\n${QN} Enter the location of the Kernel source\n";
            ST="Kernel Location"; shut_my_mouth KL "$ST";
            if [ -f ${SBKL}/Makefile ]; then
                echo -e "\n${SCS} Kernel Makefile found";
                cd "${SBKL}";
            else
                echo -e "\n${FLD} Kernel Makefile not found. Aborting\n";
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
                SBKD=$(eval "echo \${KDEFS[$(( CT - 1 ))]}" | awk -F "/" '{print $4}');
                SBKA=$(eval "echo \${KDEFS[$(( CT - 1 ))]}" | awk -F "/" '{print $2}');
            fi
            echo -e "\n${INF} Arch : ${SBKA}";
            echo -e "\n${QN} Number of Jobs / Threads\n";
            BCORES=$(grep -c ^processor /proc/cpuinfo); # CPU Threads/Cores
            echo -e "${INF} Maximum No. of Jobs -> ${CL_WYT}${BCORES}${NONE}\n";
            ST="Number of Jobs"; shut_my_mouth NT "$ST";
            if [[ "$SBNT" > "$BCORES" ]]; then # Y u do dis
                echo -e "\n${FLD} Invalid Response";
                SBNT="$BCORES";
                echo -e "\n${INF} Using Maximum no of threads : $BCORES";
            fi
            export action_kinit="done";
        } # kinit

        function settc()
        {
            echo -e "\n${INF} Make sure you have downloaded (synced) a Toolchain for compiling the kernel";
            echo -e "\n${QN} Point me to the location of the toolchain [ from \"/\" ]";
            echo -e "\n${INF} Example - ${CL_WYT}/home/foo/tc${NONE}\n"
            ST="Toolchain Location"; shut_my_mouth KTL "$ST";
            if [[ -d "${SBKTL}" ]]; then
                KCCP=$(find ${SBKTL}/bin/${SBKA}*gcc | grep -v 'androidkernel' | sed -e 's/gcc//g' -e 's/.*bin\///g');
                if [[ ! -z "${KCCP}" ]]; then
                    echo -e "\n${SCS} Toolchain Detected";
                    echo -e "\n${INF} Toolchain Prefix : ${KCCP}\n";
                else
                    echo -e "\n${FLD} Toolchain Binaries not found";
                fi
            else
                echo -e "\n${FLD} Directory not found";
                unset SBKTL;
            fi
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
                        "GNU make<->make" \
                        "Target name to clean objects, modules, and Kernel Configuration<->clean" \
                        "No. of Jobs<->-j${SBNT}" \
                    ;;
                2)
                    cmdprex \
                        "GNU make<->make" \
                        "Target name to clean objects and modules only<->mrproper" \
                        "No. of Jobs<->-j${SBNT}" \
                    ;;
            esac
            echo -e "\n${SCS} Kernel Cleaning done";
            echo -e "\n${INF} Check output for details";
            export action_kcl="done";
        } # kclean

        function mkkernel()
        {
            # Execute these before building kernel
            [ -z "${action_kinit}" ] && kinit;
            [ -z "${KCCP}" ] && settc;
            [ -z "${action_kcl}" ] && kclean;
            [ ! -z "${SBCUH}" ] && custuserhost;

            echo -e "\n${EXE} Compiling the Kernel";
            cmdprex \
                "Mark variable to be Inherited by child processes<->export" \
                "Set CPU Architecture<->ARCH=\"${SBKA}\"" \
                "Set Toolchain Location<->CROSS_COMPILE=\"${SBKTL}/bin/${KCCP}\"";
            [ ! -z "$SBNT" ] && SBNT="-j${SBNT}";
            cmdprex \
                "GNU make<->make" \
                "Defconfig to be Initialized<->${SBKD}";
            cmdprex \
                "GNU make<->make" \
                "No. of Jobs<->${SBNT}";
            if [[ ! -z "${STS}" ]]; then
                echo -e "\n${SCS} Compiled Successfully";
            else
                echo -e "\n${FLD} Compilation failed";
            fi
        } # mkkernel

        echo -ne "\033]0;ScriBt : KernelBuilding\007";
        center_it "${CL_LCN}[!]${NONE} ${CL_WYT}Kernel Building${NONE} ${CL_LCN}[!]${NONE}" "1eq1";
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
        dash_it;
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
            *) echo -e "\n${FLD} Invalid Selection\n" ;;
        esac
        [ -z "$automate" ] && kbuild;
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
            center_it "${CL_LRD}Patch Manager${NONE}" "1eq1";
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
            dash_it;
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
        dash_it;
        echo -e "${QN} Select a Build Option:\n";
        echo -e "1. Start Building ROM (ZIP output) (Clean Options Available)";
        echo -e "2. Make a Particular Module";
        echo -e "3. Setup CCACHE for Faster Builds";
        echo -e "4. Kernel Building";
        echo -e "5. Patch Manager";
        echo -e "0. Quick Menu\n";
        dash_it;
        ST="Option Selected"; shut_my_mouth BO "$ST";
    } # build_menu

    build_menu;
    case "$SBBO" in
        0) quick_menu ;;
        1)
            if [ -d "${CALL_ME_ROOT}.repo" ]; then
                # Get Missing Information
                get_rom_info;
                [ -z "$SBDEV" ] && device_info;
                # Change terminal title
                [ ! -z "$automate" ] && teh_action 4;
            else
                echo -e "\n${FLD} ROM Source Not Found (Synced)";
                echo -e "\n${FLD} Please perform an init and sync before doing this";
                exitScriBt 1;
            fi
            init_bld;
            choose_target;
            echo -e "\n${QN} Should I use 'make' or 'mka'"; get "info" "make";
            ST="Selected Method"; shut_my_mouth MK "$ST";
            case "$SBMK" in
                "make")
                    echo -e "\n${QN} Number of Jobs / Threads";
                    BCORES=$(grep -c ^processor /proc/cpuinfo); # CPU Threads/Cores
                    echo -e "${INF} Maximum No. of Jobs -> ${CL_WYT}${BCORES}${NONE}\n";
                    ST="Number of Jobs"; shut_my_mouth NT "$ST";
                    if [[ "$SBNT" > "$BCORES" ]]; then # Y u do dis
                        echo -e "\n${FLD} Invalid Response";
                        echo -e "\n${EXE} Setting no. of threads to maximum - ${CL_WYT}${BCORES}${NONE}";
                        BCORES="${SBNT}";
                    fi
                    ;;
                "mka") BCORES="" ;; # mka utilizes max resources
                *)
                    echo -e "\n${FLD} No response received";
                    echo -e "\n${EXE} Using ${CL_WYT}mka${NONE}";
                    SBMK="mka"; BCORES="";
                    ;;
            esac
            echo -e "${QN} Keep build output in another directory ${CL_WYT}[y/n]${NONE}\n"; get "info" "outdir";
            ST="Another /out dir"; shut_my_mouth OD "$ST";
            case "$SBOD" in
                [Yy])
                    echo -e "${INF} Enter the Directory location from / (root)\n";
                    ST="/out location"; shut_my_mouth OL "$ST";
                    if [ -d "$SBOL" ]; then
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Set Custom Output Directory<->OUT_DIR=\"${SBOL}\"";
                    else
                        echo -e "\n${INF} /out location is unchanged";
                    fi
                    ;;
                [Nn])
                    echo -e "${INF} /out location is unchanged";
                    ;;
            esac
            # Set SBOL to default OUT_DIR value
            [ -z "${SBOL}" ] && SBOL="${CALL_ME_ROOT}out";
            echo -e "\n${QN} Clean output directory before Building";
            echo -e "\n${INF} Output directory - ${CL_WYT}${SBOL}${NONE}"; get "info" "outcln";
            ST="Option Selected"; shut_my_mouth CL "$ST";
            if [[ $(grep -c 'BUILD_ID=M' "${CALL_ME_ROOT}build/core/build_id.mk") == "1" ]]; then
                echo -e "\n${QN} Use Jack Toolchain ${CL_WYT}[y/n]${NONE}\n"; get "info" "jack";
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
                echo -e "\n${QN} Use Ninja to build Android ${CL_WYT}[y/n]${NONE}\n"; get "info" "ninja";
                ST="Use Ninja"; shut_my_mouth NJ "$ST";
                case "$SBNJ" in
                    [yY])
                        echo -e "\n${INF} Building Android with Ninja BuildSystem";
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Use Ninja<->USE_NINJA=true";
                        ;;
                    [nN])
                        echo -e "\n${INF} Building Android with the Non-Ninja BuildSystem";
                        cmdprex \
                            "Mark variable to be Inherited by child processes<->export" \
                            "Variable to Disable Ninja<->USE_NINJA=false";
                        cmdprex \
                            "Command to unset an entity<->unset" \
                            "Unsetting this Var removes Ninja temp files<->BUILDING_WITH_NINJA";
                        ;;
                    *) echo -e "${FLD} Invalid Selection.\n" ;;
                esac
                # Jack cannot be disabled in N
                # Jack workaround prompt is asked if this is set to y/Y
                SBJK="y";
            fi
            if [[ "${SBJK}" == [Yy] ]] && [[ "$(free -m | awk '/^Mem:/{print $2}')" -lt "4096" ]]; then
                echo -e "\n${INF} Your system has less than 4GB RAM";
                echo -e "\n${INF} Jack's Java VM requires >8GB of RAM to function properly";
                echo -e "\n${QN} Use Jack workarounds for proper functioning";
                echo -e "\n${INF} Unless you know what you're doing - ${CL_LBL}Answer y${NONE}\n";
                ST="Use Jack Workaround"; shut_my_mouth JWA "$ST";
                case "${SBJWA}" in
                    [Yy])
                        export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx3G";
                        if [[ -f "${HOME}/.jack-server/config.properties" ]]; then
                            if [[ "$(grep -c 'jack.server.max-service=1' ${HOME}/.jack-server/config.properties)" == "0" ]]; then
                                sed -i "/jack.server.max-service=*/c\jack.server.max-service=1" ${HOME}/.jack-server/config.properties;
                            fi
                        fi
                        if [[ -f "${HOME}/.jack" ]]; then
                            if [[ "$(grep -c 'SERVER_NB_COMPILE=1' ${HOME}/.jack)" == "0" ]]; then
                                sed -i "/SERVER_NB_COMPILE=*/c\SERVER_NB_COMPILE=1" ${HOME}/.jack;
                            fi
                        fi
                        echo -e "\n{EXE} Cleaning old JACK Session";
                        rm -rf /tmp/jack-*;
                        jack-admin kill-server;
                        ;;
                    *)
                        echo -e "\n${INF} Not using Jack Workarounds\n";
                        ;;
                esac
            fi
            case "$SBCL" in
                1)
                    echo -e "\n${INF} Cleaning staging directories requires device-specific build environment";
                    echo -e "\n${INF} ${CL_WYT}lunch${NONE}ing device ${SDDEV}";
                    cmdprex \
                        "Setup Device-Specific Build Environment<->lunch" \
                        "Build Target Name<->${TARGET}";
                    cmdprex \
                        "GNU make<->$SBMK" \
                        "Target Name to remove staging files<->installclean";
                    ;;
                2)
                    cmdprex \
                        "GNU make<->$SBMK" \
                        "Target Name to remove entire build output<->clean";
                    ;;
                *) echo -e "${INF} No Clean Option Selected.\n" ;;
            esac
            echo -e "\n${QN} Set a custom user/host ${CL_WYT}[y/n]${NONE}\n";
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
            echo -e "\n${FLD} Invalid Selection\n";
            build;
            ;;
    esac
} # build

function tools() # 5
{
    # change terminal title
    [ ! -z "$automate" ] && teh_action 5;

    function installdeps()
    {
        echo -e "\n${EXE} Attempting to detect Distro";
        dist_db;
        if [[ ! -z "$DYR" ]]; then
            echo -e "\n${SCS} Distro Detected Successfully";
        else
            echo -e "\n${FLD} Distro not present in supported Distros\n\n${INF} Contact the Developer for Support\n";
            quick_menu;
        fi
        echo -e "\n${EXE} Installing Build Dependencies\n";
        get "pkgs" "common";
        get "pkgs" "$DYR";
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
        get "pkgs" "archcommon";
        echo -e "\n${EXE} Installing required packages";
        if ! grep -q ".*\[multilib\]" /etc/pacman.conf; then
            echo -e "\n${EXE} Enabling usage of multilib repository";
            echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf;
            echo -e "\n${EXE} Updating repository list";
            cmdprex \
                "Execute command as 'root'<->execroot" \
                "Arch Package Mgr.<->${PKGMGR}" \
                "Sync Pkgs<->-S" \
                "fetch fresh pkg databases from server<->-y" \
                "upgrade installed packages<->-u";
        fi
        # Install packages from multilib-devel
        if ${PKGMGR} -Qq gcc gcc-libs &> /dev/null; then
            echo -e "\n${INF} i686 packages - gcc, gcc-libs might conflict with their 'multilib' counterpart";
            echo -e "\n${INF} Answer ${CL_WYT}y${NONE} to the prompt for removal of the conflicting i686 packages";
        fi
        for item in ${GCC}; do
            if ! pacman -Qq ${item}  &> /dev/null; then
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Arch Package Mgr.<->${PKGMGR}" \
                    "Sync Pkgs<->-S" \
                    "multilib package<->${item}";
            fi
        done
        # sort out already installed pkgs
        for item in ${PKGS[*]}; do
            if ! pacman -Qq "${item}" &> /dev/null; then
                PKGSREQ+=( "${item}" );
            fi
        done
        if [[ ! -z "${PKGSREQ[*]}" ]]; then
            # Install required packages
            cmdprex \
                "Command Execution as 'root'<->execroot" \
                "Arch Package Mgr.<->${PKGMGR}" \
                "Sync Pkgs<->-S" \
                "Answer 'yes' to prompts<->--noconfirm" \
                "Packages List<->${PKGSREQ[*]}";
            if [ -z "$STS" ]; then
                echo -e "${SCS} Packages were installed successfully";
            else
                echo -e "${SCS} An Error occured while installing some of the packages";
            fi
        else
            echo -e "\n${SCS} You already have all required packages";
        fi
        unset item PKGSREQ;
    } # installdeps_arch

    function java_select()
    {
        echo -e "${INF} If you have Installed Multiple Versions of Java or Installed Java from Different Providers (OpenJDK / Oracle)";
        echo -e "${INF} You may now select the Version of Java which is to be used BY-DEFAULT\n";
        dash_it;
        case "${PKGMGR}" in
            *apt*)
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Maintains symlinks for default commands<->update-alternatives" \
                    "Configure command symlink<->--config" \
                    "Command to Configure<->java";
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Maintains symlinks for default commands<->update-alternatives" \
                    "Configure command symlink<->--config" \
                    "Command to Configure<->javac";
                ;;
            "pacman")
                cmdprex \
                    "Arch Linux Java Mgr.<->archlinux-java" \
                    "Shows list of Java Pkgs.<->status";
                echo -e "\n${QN} Please enter desired version [eg. \"java-7-openjdk\"]\n";
                prompt ARCHJA;
                cmdprex \
                    "Execute command as 'root'<->execroot" \
                    "Arch Linux Java Mgr.<->archlinux-java" \
                    "Set Default Environment<->set" \
                    "Java Environment Name<->${ARCHJA}";
                ;;
        esac
    } # java_select

    function java_check()
    {
      if [[ $( java -version &> "$TMP"; grep -c "version \"1.$1" "$TMP" ) == "1" ]]; then
          dash_it;
          echo -e "${SCS} OpenJDK-$1 or Java 1.$1.0 has been successfully installed";
          dash_it;
      fi
    } # java_check

    function java_install()
    {
        echo -ne "\033]0;ScriBt : Java $1\007";
        echo -e "\n${EXE} Installing OpenJDK-$1 (Java 1.$1.0)";
        echo -e "\n${QN} Remove other Versions of Java ${CL_WYT}[y/n]${NONE}\n";
        prompt REMOJA;
        echo;
        case "$REMOJA" in
            [yY])
                case "${PKGMGR}" in
                    *apt*)
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
                            "remove configuration files<->-n" \
                            "remove unnecessary dependencies<->-s" \
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
        case "${PKGMGR}" in
            *apt*)
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
                    "download fresh package databases<->-y";
                ;;
        esac
        case "${PKGMGR}" in
            *apt*)
                cmdprex \
                    "Command Execution as 'root'<->execroot" \
                    "Commandline Package Manager<->${PKGMGR}" \
                    "Keyword for Installing Package<->install" \
                    "Answer 'yes' to prompts<->-y" \
                    "OpenJDK $1 Package Name<->openjdk-$1-jdk";
                ;;
            "pacman")
                cmdprex \
                    "Execute command as 'root'<->execroot" \
                    "Arch Package Mgr.<->pacman" \
                    "Sync Pkgs<->-S" \
                    "download fresh package databases<->-y"
                    "OpenJDK $1 Package Name<->jdk$1-openjdk" ;;
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
        center_it "${CL_YEL}JAVA${NONE} Installation" "1eq1";
        echo -e "1. Install Java";
        echo -e "2. Switch Between Java Versions / Providers\n";
        echo -e "0. Quick Menu\n";
        echo -e "${INF} ScriBt installs Java by OpenJDK";
        dash_it;
        prompt JAVAS;
        case "$JAVAS" in
            0)  quick_menu ;;
            1)
                echo -ne '\033]0;ScriBt : Java\007';
                echo -e "\n${QN} Android Version of the ROM you're building";
                echo -e "1. Java 1.6.0 (4.4.x Kitkat)";
                echo -e "2. Java 1.7.0 (5.x.x Lollipop && 6.x.x Marshmallow)";
                echo -e "3. Java 1.8.0 (7.x.x Nougat)\n";
                if [[ "${PKGMGR}" == *apt* ]]; then
                    echo -e "4. Ubuntu 16.04 & Want to install Java 7";
                    echo -e "5. Ubuntu 14.04 & Want to install Java 8\n";
                fi
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
        dash_it;
        echo -e "${EXE} Updating / Creating Android USB udev rules (51-android)";
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
        if [[ "$PKGMGR" == *apt* ]]; then
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
        echo -e "${SCS} Done";
        dash_it;
    } # udev_rules


    function git_creds()
    {
        echo -e "\n${INF} Enter the Details with reference to your ${CL_WYT}GitHub account${NONE}";
        echo -e "${INDENT}If you have one";
        pause "4";
        echo -e "\n${QN} Enter the Username";
        echo -e "${INF} Enter a desired name (or GitHub username)\n";
        prompt GIT_U;
        echo -e "\n${QN} Enter the E-mail ID\n";
        prompt GIT_E;
        cmdprex \
            "git commandline<->git" \
            "Configure git<->config" \
            "Apply changes to all local repositories<->--global" \
            "Configuration<->user.name" \
            "Value of specified configuration<->${GIT_U}";
        cmdprex \
            "git commandline<->git" \
            "Configure git<->config" \
            "Apply changes to all local repositories<->--global" \
            "Configuration<->user.email" \
            "Value of specified configuration<->${GIT_E}";
        echo -e "${SCS} Done";
        quick_menu;
    } # git_creds

    function check_utils_version()
    {
        # If util is repo then concatenate the file else execute it as a binary
        CAT="cat ";
        [[ "$1" == "repo" ]] || unset CAT;
        case "$2" in
            "utils") BIN="${CAT}src/utils/$1" ;; # Util Version that ScriBt has under utils folder
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
        echo -e "\n${EXE}Checking presence of ${HOME}/bin folder\n";
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
        echo -e "\n${SCS} Done";
        unset VER IDIR UIC;
    } # installer

    function scribtofy()
    {
        echo -e "\n${INF} This Function allows ScriBt to be executed under any directory";
        echo -e "${INDENT}Temporary Files would be present at working directory itself";
        echo -e "${INDENT}Older ScriBtofications, if present, would be overwritten";
        echo -e "\n${QN} Shall I ScriBtofy ${CL_WYT}[y/n]${NONE}\n";
        prompt SBFY;
        case "$SBFY" in
            [Yy])
                    echo -e "\n${EXE} Adding ScriBt to PATH";
                    echo -e "# ScriBtofy\nexport PATH=\"${CALL_ME_ROOT}:\$PATH\";" > "${HOME}/.scribt";
                    grep -q 'source ${HOME}/.scribt' "${HOME}/.bashrc" || echo -e "\n#ScriBtofy\nsource \${HOME}/.scribt;" >> "${HOME}/.bashrc";
                    echo -e "\n${SCS} Done";
                    echo -e "\n${INF} Either enter ${CL_WYT}source ${HOME}/.bashrc${NONE} OR ${CL_WYT}Open a new Terminal for changes to take effect";
                    echo -e "\n${INF} ${CL_WYT}bash ROM.sh${NONE} under any directory";
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
                    echo -e "\n${SCS} Tag was created successfully";
                    echo -e "\n${QN} Do you want to upload it to the server (origin)?\n";
                    prompt QN_UPLOAD;
                    if [[ "${QN_UPLOAD}" =~ (y|yes) ]]; then
                        if git push origin master && git push origin v"${UPDATE_VERSION}"; then
                            echo -e "\n${INF} Upload successful";
                        else
                            echo -e "\n${FLD} Upload failed";
                        fi
                    fi
                else
                    echo -e "\n${FLD} Failed to create the tag";
                fi
            fi
        fi
        unset CORRECT UPDATE_VERSION RESULT_SIGN QN_SIGN QN_UPLOAD;
        [ -f "${PATHDIR}update_message.txt" ] && rm "${PATHDIR}update_message.txt";
        cd "${CALL_ME_ROOT}";
    } # update_creator

    function tool_menu()
    {
        center_it "${CL_LBL}Tools${NONE}" "1eq1";
        center_it "1. Install Build Dependencies" "sp1";
        center_it "2. Install Java (OpenJDK 6/7/8)" "sp";
        center_it "3. Setup ccache (After installing it)" "sp";
        center_it "4. Install/Update ADB udev rules" "sp";
        center_it "5. Add/Update Git Credentials" "sp";
        center_it "6. Install make ${CL_WYT}~${NONE}" "sp";
        center_it "7. Install ninja ${CL_WYT}~${NONE}" "sp";
        center_it "8. Install ccache ${CL_WYT}~${NONE}" "sp";
        center_it "9. Install repo ${CL_WYT}~${NONE}" "sp";
        center_it "10. Add ScriBt to PATH" "sp";
        center_it "11. Create a ScriBt Update [DEV]" "sp";
        center_it "12. Generate a Custom Manifest" "sp";
# TODO: center_it "X. Find an Android Module's Directory" "sp";
        center_it "0. Quick Menu" "sp";
        echo -e "\n${CL_WYT}~${NONE} These versions are recommended to use";
        echo -e "  If you have any issue in higher versions";
        dash_it;
        prompt TOOL;
        case "$TOOL" in
            0) quick_menu ;;
            1) case "${PKGMGR}" in
                   *apt*) installdeps ;;
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
            *) echo -e "\n${FLD} Invalid Selection\n"; tool_menu ;;
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
    6)  # NOT TO BE AUTOMATED
        echo -ne '\033]0;About ScriBt\007';
        get "misc" "logo";
        quick_menu;
        ;;
    7)
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
        echo -e "\n${INF} ${CL_WYT}Re-clone${NONE} ScriBt for upScriBt to work properly";
        echo -e "\n${FLD} Update-Check Cancelled";
        echo -e "\n${INF} No modifications have been done\n";
    else
        [ ! -z "${PATHDIR}" ] && cd "${PATHDIR}";
        cd "${CALL_ME_ROOT}";
        if [[ "${BRANCH}" == "master" ]]; then
            # Download the Remote Version of Updater, determine the Internet Connectivity by working of this command
            if curl -fs -o "${PATHDIR}upScriBt.sh" "https://raw.githubusercontent.com/ScriBt/ScriBt/${BRANCH}/src/upScriBt.sh"; then
                echo -e "\n${SCS} Internet Connectivity : ONLINE";
                bash "${PATHDIR}src/upScriBt.sh" "$0" "$1";
            else
                echo -e "\n${FLD} Internet Connectivity : OFFLINE";
                echo -e "\n${INF} Please connect to the Internet for complete functioning of ScriBt";
            fi
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

    # Start a python2 virtualenv for some Arch Linux systems
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
    pause "4";
    clear;
    get "misc" "banner";
    pause "4";
    center_it "${CL_WYT}${VERSION:-NULL}${NONE}" "1sp1";
} # the_start

function automator()
{
    echo -e "\n${EXE} Searching for Automatable Configs\n";
    for AF in *.rc; do
        grep 'AUTOMATOR="true_dat"' --color=never "$AF" -l >> "${TMP}";
        sed -i -e 's/.rc//g' "${TMP}"; # Remove the file format
    done
    if [[ ! -s "${TMP}" ]]; then
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
        for CT in $(eval "echo {1..${#CMB[*]}}"); do
            echo -e " $CT. ${CMB[$CT]} ";
        done | column
        unset CT;
        echo -e "\n${QN} Which would you like\n";
        prompt ANO;
        echo -e "\n${EXE} Running ScriBt on Automation Config ${CMB[$ANO]}\n";
        pause "4";
        source "${CMB[${ANO}]}.rc";
    fi
} # automator

###################
# Some Essentials #
###################

function sign_exists()
{
    if [[ $(echo -e "$1") == "$1" ]]; then
        return 1; # Invalid ASCII
        # Dev has to set alternate SIGN
    else
        SIGN=$(echo -e "$1");
        return 0; # Valid ASCII
    fi
} # sign_exists

function center_it()
{
    # Function to center a statement
    # Usage :
    # center_it <statement> "NBSignNA" <width>
    # Sign being either 'eq' (equals) or 'sp' (spaces)
    # NewlineBefore (NB)- New lines to be created before echoing statement
    # NewlineAfter (NA)- New lines to be created after echoing statement
    # <width> can be set if necessary
    # Example: center_it "foo" "1eq1" "15"
    # Output :
    #
    # ===== foo =====
    #
    # [OutputEndsAbove]

    if [ -z "$3" ]; then
        NOCHARS="${NOCHARS_DEF}";
    else
        NOCHARS="$3";
    fi
    case "$2" in
        *eq*)
            if ! sign_exists "\u2550"; then
                CHAR="="; # To avoid name conflict with "SIGN"
            else
                CHAR="$SIGN";
            fi
            SP=" ";
            NOCHARS="$(( NOCHARS - 2 ))";
            ;;
        *sp*)
            CHAR=$(echo -en " ");
            ;;
    esac
    # Newlines before statement
    NB="${2//[es][qp]*/}";
    # Newlines after statement
    NA="${2//*[es][qp]/}";
    # No. of Remaining characters
    # Remove all ASCII Escape Sequences
    NOC_NOASCII=$(echo "$1" |\
                sed 's/\\u..../X/g' |\
                sed 's/\\033\[0m//g' |\
                sed 's/\\033\[[01];[34][1-9]m//g' |\
                wc -L);
    NSP=$(( NOCHARS - NOC_NOASCII ));
    # Left-Spacing
    SL=$(( NSP / 2 ));
    # Right Spacing
    SR=$(( NSP - SL ));
    SPACEL="$(for (( i=0; i<${SL:-0}; i++ )); do echo -en "${CHAR}"; done;)";
    SPACER="$(for (( i=0; i<${SR:-0}; i++ )); do echo -en "${CHAR}"; done;)";
    for (( i=0; i<${NB:-0}; i++ )); do echo; done;
    echo -e "${CL_WYT}${SPACEL}${NONE}${SP}$1${SP}${CL_WYT}${SPACER}${NONE}";
    for (( i=0; i<${NA:-0}; i++ )); do echo; done;
    unset S{L,P,R} SPACE{L,R} N{A,B,SP} NO{CHARS,_NOASCII} CHAR i;
} # center_it

function dash_it()
{
    # Function to create <hr> like borders
    # Usage:
    # dash_it <NB> <width>
    # NewlineBefore (NB)- New lines to be created before echoing statement
    # <width> isn't a compulsory paremeter
    # Can be specified if one wants a border of
    # custom length
    # Example : dash_it "2" "10"
    # Output :
    #
    #
    # ==========
    #
    # [OutputEndsAbove]

    NOCHARS="${2:-${NOCHARS_DEF}}";
    NB="$1";
    if ! sign_exists "\u2550"; then
        SIGN="=";
    fi
    for (( i=0; i<${NB:-1}; i++ )); do echo; done;
    echo -en "${CL_WYT}";
    for i in $(eval "echo {1..$NOCHARS}"); do
        echo -en "${SIGN}";
    done
    echo -en "${NONE}";
    echo -e "\n";
    unset N{A,B} NOCHARS;
} # dash_it

# 'sudo' command with custom prompt '[#]' in Pink
function execroot(){ sudo -p $'\033[1;35m[#]\033[0m ' "$@"; };

# Function to execute files under "src"
function get(){ source "${PATHDIR}src/${1}/${2}.rc"; };

function pause()
{
    # Function to create a pause timer
    # with ProgressBar indicating the pause time
    # Usage:
    # pause <no-of-0.5-sec-pauses>

    TIME="${1:-4}";
    i=1;
    if ! sign_exists "\u25C9"; then
        SIGN=".";
    fi
    while [[ "$i" -le "$TIME" ]]; do
        echo -en "\033[1;3${i}m${SIGN} $(sleep 0.5)${NONE}";
        CLEAR+=( "  " );
        (( i++ ));
        # Limit to 7 colors
        if [[ "$i" == "8" ]]; then
            i=1;
            TIME=$(( TIME - 8 ));
        fi
    done
    echo -en "$(sleep 0.5)\r${CLEAR[*]}\r";
    unset i TIME CLEAR SIGN;
} # pause


# 'read -r' command with custom prompt '[>]' in Cyan
function prompt()
{
    read -r -p $'\033[1;36m[>]\033[0m ' "$1";
    if [[ -z "$(eval "echo \$$1")" ]] && [[ -z "$2" ]]; then
        echo -e "\n${FLD} No response provided\n";
        prompt "$1";
    fi
} # prompt

# Point of Execution

# I ez Root
export CALL_ME_ROOT=$(echo "$(pwd)/" | sed -e 's#//$#/#g');

if [[ "$0" == "ROM.sh" ]] && [[ $(type -p ROM.sh) ]]; then
    export PATHDIR="$(type -p ROM.sh | sed 's/ROM\.sh//g')";
else
    export PATHDIR="${CALL_ME_ROOT}";
fi

export INDENT="    ";

# Load Companion Scripts
source "${PATHDIR}src/color_my_life.rc";
source "${PATHDIR}src/dist_db.rc";
source "${PATHDIR}src/usage.rc";

# Show Interrupt Acknowledgement message on receiving SIGINT
trap interrupt SIGINT;

# The ROMs
export CAFR=( $(ls ${PATHDIR}src/roms/caf/*.rc) );
export AOSPR=( $(ls ${PATHDIR}src/roms/aosp/*.rc) );

# Version
if [ -d "${PATHDIR}.git" ]; then
    # Check Branch
    cd "${PATHDIR}";
    export BRANCH=$(git rev-parse --abbrev-ref HEAD);
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
        get "misc" "logo";
    else
        echo -e "Not available. Please resync ScriBt through git";
        exit 1;
    fi
elif [[ "$1" == "usage" ]]; then
    usage;
else
    usage "$1";
fi
