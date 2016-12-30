#!/bin/bash
#===========================< upScriBt >===============================#
#===========< Copyright 2016, Arvindraj Thangaraj - "a7r3" >===========#
#=============< Credits to Łukasz "JustArchi" Domeradzki >=============#
#====================< Part of Projekt ScriBt >========================#

if [ ! -d ${PATHDIR}.git ]; then # tell the user to re-clone ScriBt
    echo -e "${FLD} Folder ${CL_WYT}.git${NONE} not found";
    echo -e "${INF} Probably the folder's been deleted OR You've ${CL_WYT}Downloaded it${NONE}";
    echo -e "${INF} ${CL_WYT}Re-clone${NONE} ScriBt for upScriBt to work properly\n";
    exit 1;
else
    [ ! -z "${PATHDIR}" ] && cd ${PATHDIR};
    # Check Branch
    BRANCH=`git rev-parse --abbrev-ref HEAD`;
    if [[ "$BRANCH" =~ (master|staging) ]]; then
        RVER=`curl https://raw.githubusercontent.com/a7r3/ScriBt/${BRANCH}/VERSION -s`; # Remote VERSION
        LVER=`cat VERSION`; # Local VERSION
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
                    echo -e "\n${SCS} ScriBt updated Successfully";
                    echo -e "\n${EXE} Restarting ScriBt with the provided parameters";
                    cd ${CALL_ME_ROOT};
                    exec bash $@;
                    ;;
                [Nn])
                    echo -e "\n${INF} Staying on v${LVER}\n${INF} But it is recommended to update ScriBt\n";
                    ;;
            esac
        else
            echo -e "\n${SCS} ScriBt is up-to-date";
            echo -e "\n${EXE} Continuing";
        fi
        cd ${CALL_ME_ROOT};
        exit 0; # No Failing possibilites, so Peace
    else
        echo -e "\n${INF} Current Working Branch is neither 'master' nor 'staging'\n";
        echo -e "${FLD} ScriBt Update Disabled\n\n${INF} No modifications have been done\n";
        cd ${CALL_ME_ROOT};
        exit 1; # Failed here tho :(
    fi
fi
