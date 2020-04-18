#!/bin/sh

#  firebase-upload-symbols.sh
#  Created by Abdullah Alhaider on 18/4/20.
#
#  TEMPLATE ONLY
#  COMPLETE LINES 14, 17, 20 AND 23 BEFORE USING
#
#  This script uploads dSYMs to Firebase for processing.
# 


# Change path to dSYM folder
SAVED_dSYM_FOLDER="/Users/..../appDsyms" 

# for example: 652ac70afbbde134719v4as01415fa9793da901f
SAVED_FABRIC_API_KEY="HERE_YOU_NEED_TO_ADD_FABRIC_API_KEY_IF_YOU_USE_FABRIC" 

# Change path to Fabric upload script for your project
SAVED_UPLOAD_SCRIPT="/Users/..../Pods/Fabric/upload-symbols"

# Change path to Google services info for your project
SAVED_GOOGLE_CONFIG="/Users/.../GoogleService-Info.plist" 


#######################################################################################
################################         Script        ################################
#######################################################################################

ARCHIVE=$1

function fabric_with_saved_setting() {
    log "============== Start Uploading... ==============" 
    find "$SAVED_dSYM_FOLDER" -name "*.dSYM" | xargs -I \{\} $SAVED_UPLOAD_SCRIPT -a $SAVED_FABRIC_API_KEY -p ios \{\}
    log "================ Upload complete ================"
};

function fabric_without_saved_setting() {
    read -p "Enter your Fabric API key, must be equal to 40 character: " FABRIC_API_KEY
    read -p "Enter full path for dSYM folder: " dSYMFOLDER
    read -p "Enter full path for upload script: " UPLOADSCRIPT
    log "============== Start Uploading... ==============" 
    find "$dSYMFOLDER" -name "*.dSYM" | xargs -I \{\} $UPLOADSCRIPT -a $FABRIC_API_KEY -p ios \{\}
    log "================ Upload complete ================"
};

function upload_to_fabric() {
    if [ "$1" = "y" ];
    then
        fabric_with_saved_setting;
    elif [ "$1" = "n" ];
    then 
        fabric_without_saved_setting
    else
        log "Wrong input!, please re-run again"
        exist 1
    fi
}

function google_service_with_saved_setting() {
    log "============== Start Uploading... ==============" 
    find "$SAVED_dSYM_FOLDER" -name "*.dSYM" | xargs -I \{\} $SAVED_UPLOAD_SCRIPT -gsp $SAVED_GOOGLE_CONFIG -p ios \{\}
    log "================ Upload complete ================"
};

function google_service_without_saved_setting() {
    read -p "Enter your GoogleInfo.plit path: " GOOGLE_CONFIG
    read -p "Enter full path for dSYM folder: " dSYMFOLDER
    read -p "Enter full path for upload script: " UPLOADSCRIPT
    log "============== Start Uploading... ==============" 
    find "$dSYMFOLDER" -name "*.dSYM" | xargs -I \{\} $UPLOADSCRIPT -gsp $GOOGLE_CONFIG -p ios \{\}
    log "================ Upload complete ================"
};

function upload_to_firebase() {
    if [ "$1" = "y" ];
    then
        google_service_with_saved_setting;
    elif [ "$1" = "n" ];
    then 
        google_service_without_saved_setting
    else
        log "Wrong input!, please re-run again"
        exist 1
    fi
}

function log() {
    echo "> $1"
}

welcome() {
    echo "
    ###########################################################
    ###########################################################
    ===========                                      ==========
    ===========     firebase upload symbols tool     ==========
    ===========                                      ==========
    ===========                 by                   ==========
    ===========                                      ==========
    ===========          Abdullah Alhaider           ==========
    ===========                                      ==========
    ===========    https://github.com/cs4alhaider    ==========
    ===========                                      ==========
    ###########################################################
    ###########################################################
    "
}

function run() {
    welcome
    # The "-d" of if checks if a directory exists
    if [ -d $ARCHIVE ]; 
    then

    # log "${ARCHIVE}"
    log "What method you would like to use?"
    log "1️⃣  Fabric"
    log "2️⃣  GoogleService-Info.plist"
    log "================================================"

    read -p "Enter your option [1/2]: " uploadmethod
    read -p "Would you like to use pre-saved setting? [y/n]: " use_pre_saved_setting
    
    if [ "$uploadmethod" = "1" ];
    then
        upload_to_fabric "$use_pre_saved_setting"
    elif [ "$uploadmethod" = "2" ]; 
    then 
        upload_to_firebase "$use_pre_saved_setting"
    else 
        log "No option found for $uploadmethod"
        exist 3
    fi
else
    log "Archive does not exist!"
fi
}

run