#! /bin/bash

# This script is useful for monitoring battert status and notifying you 
# by playing an alarm or a TTS audio clip

# REQUIREMENTS :
# 1. Install acpi for getting battery stats in terminal 

# example
# Linux@BitsAndBytes:~$ acpi -b
# Battery 0: Discharging, 40%, 02:15:50 remaining

# Linux@BitsAndBytes:~$ acpi -b
# Battery 0: Charging, 40%, 22:52:07 until charged

# 2. Install mpg123 to play an audio file from the terminal

# example 
# mpg123 /home/username/path-to-audio-file/audio.mp3

# CMD
# sudo apt-get install acpi mpg123

# STEPS :
# 1. First we check whether the battery is Charging or Discharging using an if command
# 1.1 acpi -b is used to display the battery status
# 1.2 we are piping the output of acpi command to awk (Awk is a scripting language used for manipulating data and generating reports. 
#     The awk command programming language requires no compiling, and allows the user to use variables, numeric functions, string functions, and logical operators.)
#     print ($3) prints the 4th word from the left to right side
#     Battery 0: Discharging, 40%, 02:15:50 remaining
#         1   2     3         4         5       6
# 1.3 If it is equal to discharging then we check if it is less than 15 %
# 1.4  print ($4)-0} => Since we only need 40 not % in comparison hence we are ommiting the % using -0
# 1.5 pactl set-sink-volume 0 75\% && pactl set-sink-mute 0 0 these command is used to increase the system sound if it is mute (0 0) or lies between 0-75%
# mpg123 command is already discussed 

# 2. Similar kind of steps for checking if battery is fully charged or equal to 100%



# SCRIPT

if [ `acpi -b | awk ' { print ($3)}'`  == "Discharging," ] ; then
    # Discharging
    # Monitor for low battery
    if [ `acpi -b | awk ' { print ($4)-0}'`  -le "15" ] ; then
        pactl set-sink-volume 0 75\% && pactl set-sink-mute 0 0 && mpg123 /home/username/path-to-audio/batterydie.mp3 ;
	echo "discharging and less than 15 percent"
    fi
else
    # Charging
    if [ `acpi -b | awk ' { print ($4)-0}'`  -eq "100" ] ; then
        # Fully charged
        pactl set-sink-volume 0 75\% && pactl set-sink-mute 0 0 && mpg123 /home/username/path-to-audio/fullcharged.mp3 ;
    fi
fi


# Running this Script in Linux 

# type crontab -e command in terminal and choose the type of editor you want to use 
# go to the end and paste this command 

# General Syntax

# * / * * * * * command(or)script

# Explanation :
#  * => first staar is a wildcard entry to say that we want to run this job always
#  3 * * * *  next 5 stars
#  ┬ ┬ ┬ ┬ ┬
#  │ │ │ │ │
#  │ │ │ │ │
#  │ │ │ │ └───── day of week (0 - 7) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
#  │ │ │ └────────── month (1 - 12)
#  │ │ └─────────────── day of month (1 - 31)
#  │ └──────────────────── hour (0 - 23)
#  └───────────────────────── min (0 - 59)  we have entered 3 here instead of * to run this job every 3 minute

# The nice drawing above is provided by wikipedia


# Command 
# * /3 * * * * /home/username/path-to-script-file/battery_monitor

# More Explanation
# 0 * * * * -this means the cron will run always when the minutes are 0 (so hourly)
# 0 1 * * * - this means the cron will run always at 1 o'clock.
# * 1 * * * - this means the cron will run each minute when the hour is 1. So 1:00, 1:01, ...1:59.



