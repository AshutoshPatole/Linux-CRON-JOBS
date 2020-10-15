#!/bin/bash

# This script will clear the cached memory from the system
# To clear cache memory we have to run the script as root .

# Checking if the command is run with root or not .
if [ "$(whoami)" != "root" ]
then
  echo "You have to run this script as Superuser!"
  exit 1
fi

# Get Free and Cached Memory Information
freemem_before=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && freemem_before=$(echo "$freemem_before/1024.0" | bc)
cachedmem_before=$(cat /proc/meminfo | grep "^Cached" | tr -s ' ' | cut -d ' ' -f2) && cachedmem_before=$(echo "$cachedmem_before/1024.0" | bc)

# Display the informations here to see how much was available and how much has cached in memory
echo -e "This script will clear cached memory and free up your ram.\n\nAt the moment you have $cachedmem_before MiB cached and $freemem_before MiB free memory."

# Test sync i.e If the return value of the previous command(Memory information) is != 0 then it means that
# our file system is synced and the cached memory can be deleted .
if [ "$?" != "0" ]
then
  echo "Something went wrong, It's impossible to sync the filesystem."
  exit 1
fi

# Clear Filesystem Buffer using "sync" and Clear Caches.
sync && echo 3 > /proc/sys/vm/drop_caches
# We will also clear the thumbanails from the system though it is not related to cached memory.
rm -rfv ~/.cache/thumbnails

freemem_after=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && freemem_after=$(echo "$freemem_after/1024.0" | bc)

# Output
echo -e "This freed $(echo "$freemem_after - $freemem_before" | bc) MiB, so now you have $freemem_after MiB of free RAM."

exit 0 


# To run this script continuously in the background we will use CRON jobs but not regular crontab since
# we need sudo privileges in the script. We will use ...

# sudo crontab -e
# choose your fav editor if you are opening it for the first time and go the the last and paste this command 


# @hourly sh /path-to-the-script/clear.sh >> /path-to-logs/cleared_logs.sh

# you can see the detailed definition of the above command in my battery_monitor script.

# We will check the logs and if there is some cache memory clear information then it means our script is working fine 
