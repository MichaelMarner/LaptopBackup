#!/bin/bash
#
# Michael's Macbook Pro Backup Script
# Oh Yeah
#


#
# The adapter for the wifi connection.
# Probably en1 on all Macbooks
#
WIFI_ADAPTER="en1"

#
# The wireless network that you want to use to backup
# Backup will not occur unless we are connected to this network
#
BACKUP_NETWORK="PlanetExpress"

#
# A file listing exclusions for the backup
#
EXCLUDE_FILE="exclusions.txt"

#
# The path that we are going to backup
# I'm just backing up my home directory
#
SOURCE_DIRECTORY="$HOME"

#
# Backup Destination
# Can be any format that rsync understands
#
DESTINATION="rsync://brick/Archive/Sellout/"

#
# Rsync options... You probably don't need to modify this
#
RSYNC_OPTIONS="-av --progress --delete --delete-excluded"

##############################################################################
###            DON'T EDIT BEYOND THIS POINT UNLESS YOU KNOW WHAT           ###
###                            YOU ARE DOING                               ###
##############################################################################



rsync $RSYNC_OPTIONS --exclude-from $EXCLUDE_FILE $SOURCE_DIRECTORY $DESTINATION
