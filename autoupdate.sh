#! /bin/bash

admin_mail = "your_mail_id_here@gmail.com"
# Create a temporary path in /tmp to write a temporary log file.
# We will remove this file after we have updated the system
tmpfile = $(mktemp)

# First we update the repos.
# >> is used for appending the output to the tempfile without overriding the previous output
# 2>&1 is nothing but the redirection of stderr to the tmpfile
echo "updating the repos" >>${tmpfile}
sudo apt-get update >>${tmpfile} 2>&1

# And if there are any upgrades found we upgrade them silently using -y
echo "checking whether updates are there" >>${tmpfile}
sudo apt-get upgrade -y >>${tmpfile} 2>&1

# After upgrades we will clean and remove the files which are not necessary now
echo "cleaning and removing unnecessary files" >>${tmpfile}
sudo apt-get autoclean >>${tmpfile} 2>&1
sudo apt-get autoremove >>${tmpfile} 2>&1
echo "everything is done" >>${tmpfile}

# No we will check whether there are any errors that occurs while updating the system
# Using the grep command we check whether we get Error(E) or Warnings(W) in updating the system
# if there are then we will simply send a notification to the user with an audio and also a mail to the admin.
if grep -q 'E: \|W: ' ${tmpfile}; then
	mail -s "Upgrade of your server failed $(date)" ${admin_mail} <${tmpfile}
	XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send --icon="/home/username/Downloads/menulogo.png" ToxiBot "Error while updating the system. Please check the logs at /home/ashu/script_logs/autoupdate_log. I have also sent a log mail to the admin."
	mpg123 /home/username/path-to-audio/errorupdate.mp3
else
	mail -s "Upgraded your server succesfully $(date)" ${admin_mail} <${tmpfile}
	XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send --icon="/home/username/Downloads/menulogo.png" ToxiBot "System has been updated"
	mpg123 /home/username/path-to-audio/updated.mp3
fi

# we will store the logs permanenlty in a file and we will remove the temp file
# note we are using a single > while copying the content from tempfile to the update_error.log file
# because we are not interested in the previous outputs

cat ${tmpfile} >/home/ashu/script_logs/update_error.log

# Simply removing the tempfile
rm -f ${tmpfile}

# CRONTAB

# using crontab we will set the frequency of update
# I would love to update my system whenever i reboot it
# So to enter into crontab run this command in the terminal

# crontab -e

# When the editor appears paste this command at the end

# @reboot sleep 200 && /home/username/path-to-script/autoupdate.sh

# that's it now you don't have to remember to update the system again

