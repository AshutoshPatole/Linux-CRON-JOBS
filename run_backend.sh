#!/usr/bin/env bash

# Checking if the command is run with root or not .
if [ "$(whoami)" != "root" ]
then
  echo "You have to run this script as Superuser!"
  exit 1
fi

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

printf 'Setting up the environment....\n'
spinner &

sleep 2

kill "$!"
printf '\n'

echo "Opening Mongodb Compass"
sudo -u ashu mongodb-compass &

echo "Opening Postman"
sudo -u ashu postman & >>/dev/null

echo "Starting mongo in localhost:27017...."
sudo mongod --dbpath /var/lib/mongodb --journal & >>/dev/null


echo "All set...."
