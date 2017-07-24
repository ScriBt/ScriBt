#!/bin/bash
#================< upScriBt - Part of Projekt ScriBt >=================#
#========< Copyright 2016-2017, Arvindraj Thangaraj - "a7r3" >=========#
#=============< Credits to Łukasz "JustArchi" Domeradzki >=============#

[[ ! -z "${PATHDIR}" ]] && cd "${PATHDIR}";
# Update local
git fetch -q --tags origin;
# Remote VERSION Tag
RVER=$(git describe --tags "$(git rev-list --max-count=1 origin/${BRANCH})");
# Local VERSION Tag
LVER=$(git describe --tags "$(git rev-list --max-count=1 ${BRANCH})");
echo -e "\n${EXE} ${CL_WYT}Checking for Updates${NONE}\n";
# Get all new tags
NEW=$(comm -13 <(git tag --merged master | sort) <(git tag --merged origin/master | sort));
if [[ -n "$NEW" ]]; then
    while read -r TAG; do
        if git rev-parse "$TAG"^'{tag}' -- &> /dev/null; then
            MSG=$(git cat-file tag "$TAG" | tail -n+6);
            [[ ! -z "$MSG" ]] && echo -e "${CL_WYT}${MSG}${NONE}\n";
        fi
    done <<< "$NEW";
    LHEAD=$(git rev-parse HEAD);
    git fetch -q origin "${BRANCH}";
    RHEAD=$(git rev-parse origin/"${BRANCH}");
    if [[ "$LHEAD" != "$RHEAD" ]]; then
        echo -e "${SCS} Update Detected. Version ${RVER}\n";
        echo -e "${QN} Do you want to Update\n";
        read -r -p $'\033[1;36m[>]\033[0m ' UDPR;
        case "$UDPR" in
            [Yy])
                echo -e "\n${EXE} Updating ScriBt to Version $RVER\n";
                git reset --hard FETCH_HEAD;
                echo -e "\n${SCS} ScriBt updated Successfully\n\n${EXE} Restarting ScriBt";
                cd "${CALL_ME_ROOT}";
                exec bash "$@";
                ;;
            [Nn])
                echo -e "\n${INF} Staying on ${LVER}\n${INF} But it is recommended to update ScriBt\n";
                ;;
        esac
    else
        echo -e "\n${EXE} ScriBt is up-to-date, Continuing";
    fi
fi
cd "${CALL_ME_ROOT}";
exit 0; # No Failing possibilites, so Peace
