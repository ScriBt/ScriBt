#!/bin/bash
#================< upScriBt - Part of Projekt ScriBt >=================#
#========< Copyright 2016-2017, Arvindraj Thangaraj - "a7r3" >=========#
#=============< Credits to Łukasz "JustArchi" Domeradzki >=============#

[ ! -z "${PATHDIR}" ] && cd ${PATHDIR};
# Remote VERSION
RVER=`curl https://raw.githubusercontent.com/a7r3/ScriBt/${BRANCH}/VERSION -s`;
# Local VERSION
LVER=`cat VERSION`;
# Status 404
PAGE404=`curl https://raw.githubusercontent.com/a7r3/ScriBt/status/generate_404 -s`; # 404 Page
echo -e "\n${EXE} ${CL_WYT}Checking for Updates${NONE}\n";
# Integral Version Names
L=`echo "${LVER}" | sed -e 's/\.//'`;
R=`echo "${RVER}" | sed -e 's/\.//'`;
if [[ "$L" < "$R" ]]; then
    for V in `eval echo {${L}..$((${R}-1))}`; do
        MSG=`curl https://raw.githubusercontent.com/a7r3/ScriBt/status/${V} -s`;
        [ ! -z "$MSG" ] && [ ! "$PAGE404" == "$MSG" ] && echo -e "${CL_WYT}${MSG}${NONE}\n";
    done
fi
LHEAD="$(git rev-parse HEAD)";
git fetch -q origin ${BRANCH};
RHEAD="$(git rev-parse origin/${BRANCH})";
if [[ "$LHEAD" != "$RHEAD" ]]; then
    echo -e "${SCS} Update Detected. Version ${RVER}\n";
    echo -e "${QN} Do you want to Update\n";
    read -p $'\033[1;36m[>]\033[0m ' UDPR;
    case "$UDPR" in
        [Yy])
            echo -e "\n${EXE} Updating ScriBt to Version $RVER\n";
            git reset --hard FETCH_HEAD;
            echo -e "\n${SCS} ScriBt updated Successfully\n\n${EXE} Restarting ScriBt";
            cd ${CALL_ME_ROOT};
            exec bash $@;
            ;;
        [Nn])
            echo -e "\n${INF} Staying on v${LVER}\n${INF} But it is recommended to update ScriBt\n";
            ;;
    esac
else
    echo -e "\n${EXE} ScriBt is up-to-date, Continuing";
fi
cd ${CALL_ME_ROOT};
exit 0; # No Failing possibilites, so Peace
