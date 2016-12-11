#!/bin/bash
#===========================< upScriBt >===============================#
#===========< Copyright 2016, Arvindraj Thangaraj - "a7r3" >===========#
#====================< Part of Projekt ScriBt >========================#

RVER=`curl https://raw.githubusercontent.com/a7r3/ScriBt/master/VERSION -s`;
LVER="cat VERSION";
if [[ "${RVER}" > "${LVER}" ]]; then
    echo -e "${SCS} Update Detected. Version ${RVER}\n";
    echo -e "${QN} Do you want to Update";
    read UDPR;
    case "$UDPR" in
        [Yy])
            mkdir old;
            echo -e "\n${EXE} Updating ScriBt to Version $RVER\n";
            for file in ROM.sh ROM.rc PREF.rc README.md VERSION; do
                mv ${file} old/${file};
                echo -e "${file} `curl -# -s -o ${file} https://raw.githubusercontent.com/a7r3/ScriBt/master/${file}`-> Done.";
            done
            echo -e "${SCS} ScriBt updated Successfully\n";
            echo -e "${INF} Old Version of ScriBt has been moved under ${CL_WYT}old${NONE} folder.\n";
            echo -e "\n${EXE} Restarting ScriBt with the provided parameters";
            if [[ "$1" == "automate" ]] || [[ "$3" == "automate" ]]; then
                echo -e "\n${INF} PREF.rc has been brought back to default";
                echo -e "\n${INF} Please make the changes you made in old PREF.rc which is located under the ${CL_WYT}old${NONE} folder";
                read ENTER;
                echo -e "${SCS} Done.";
            fi
            exec bash ROM.sh $@;
            ;;
        [Nn])
            echo -e "\n${INF} Staying on v${LVER}\n${INF} But it is recommended to update ScriBt\n";
            ;;
    esac
else
    echo -e "\n${SCS} ScriBt is up-to-date";
    echo -e "\n${EXE} Continuing";
fi
