#!/bin/bash
rsync -av --progress --delete --delete-excluded --exclude-from exclusions.txt /Users/michael rsync://brick/Archive/Sellout/
