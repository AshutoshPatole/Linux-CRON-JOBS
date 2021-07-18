#! /bin/bash

# Script used to get just the ip address in the terminal

IP_ADDR=$(ifconfig | grep broadcast | awk '{print $2}')

echo $IP_ADDR