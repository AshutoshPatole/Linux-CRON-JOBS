#! /bin/bash

# a simple script which opens stackoverflow page after system reboots
# purpose : Get gold medal for opening SO site everyday for 100 days 😏

$(timeout 5 xdg-open https://stackoverflow.com/users/11283638/ashutosh-patole)

# Get the PID of running command
KILL_PROC=$(echo $!)

#Kill the process
$(kill -9 $KILL_PROC)
