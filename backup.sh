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
# Maximum backup frequency.
# Note the backup will only occur if it can actually contact
# the backup destination. However, if, for example, you are at home
# for 10 days straight, what is the minimum time between backups.
#
# Must be one of the following strings: 
#       "ALWAYS", "HOURLY", "DAILY", "WEEKLY", "MONTHLY" (month = 30 days)
#
# ALWAYS means just do the backup whenever the script is run (by the user or cron)
#
BACKUP_FREQUENCY="ALWAYS"


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
RSYNC_OPTIONS="-anv --progress --delete --delete-excluded"

##############################################################################
###            DON'T EDIT BEYOND THIS POINT UNLESS YOU KNOW WHAT           ###
###                            YOU ARE DOING                               ###
##############################################################################

HOUR=3600
DAY=86400
WEEK=604800
MONTH=2592000

# Test whether we are on the desired wifi network
CURRENT_WIFI=`networksetup -getairportnetwork $WIFI_ADAPTER`
echo "$CURRENT_WIFI" | grep $BACKUP_NETWORK

CURRENT_TIME=`date +%s`
echo "Current time: $CURRENT_TIME"

LAST_BACKUP_TIME=0

if [ -e "$HOME/.last_backup" ]; then
	LAST_BACKUP_TIME=`cat "$HOME/.last_backup"`
	echo "Last backup time: $LAST_BACKUP_TIME";
else
	echo "Last backup timestamp not found!";
fi

TIME_DIFF=$(( $CURRENT_TIME - $LAST_BACKUP_TIME ))

echo "Time Diff: $TIME_DIFF" 

# do we need to do a backup?
case $BACKUP_FREQUENCY in

	"ALWAYS")	
		echo "Always doing the backup"
		;;
	"HOURLY")
		echo "Backup scheduled for hourly"
		if [ $TIME_DIFF -ge $HOUR ]; then
			echo "Time Diff is bigger than an hour, we should backup"
		else
			echo "Don't need to backup yet"
			exit 1
		fi
		;;

	"DAILY")
		echo "Backup scheduled for daily"
		if [ $TIME_DIFF -ge $DAY ]; then
			echo "Time Diff is bigger than a day, we should backup"
		else
			echo "Don't need to backup yet"
			exit 1
		fi
		;;
	"WEEKLY")
		echo "Backup scheduled for weekly"
		if [ $TIME_DIFF -ge $WEEK ]; then
			echo "Time Diff is bigger than a week, we should backup"
		else
			echo "Don't need to backup yet"
			exit 1
		fi
		;;
	"MONTHLY")
		echo "Backup scheduled for monthly"
		if [ $TIME_DIFF -ge $MONTH ]; then
			echo "Time Diff is bigger than a month, we should backup"
		else
			echo "Don't need to backup yet"
			exit 1
		fi
esac


if [ $? -eq 0 ]; then 
	echo "On desired network, continuing"
	rsync $RSYNC_OPTIONS --exclude-from $EXCLUDE_FILE $SOURCE_DIRECTORY $DESTINATION
	# Only update the backup timestamp if rsync worked
	if [ $? -eq 0 ]; then
		date +%s > $HOME/.last_backup
		echo "Backup successful!"
	else
		echo "Backup failed!"
	fi
	exit 0
else
	echo "Not on desired network, bailing"
	exit 1
fi

