#! /usr/bin/env bash

# Script to monitor server status

# author: ECAllen
# email: ethancallen@gmail.com 
# version: 1.0
# created: 1/30/2015
# modified: 7/14/2016

# TODO 
# specify alternate ports for ssh
# check for: nc
# check if ping works
# use gnu parallel if available

# bash unofficial strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Use getopts http://wiki.bash-hackers.org/howto/getopts_tutorial?s[]=get&s[]=opt
OPTIND=1

# color definitions http://misc.flogisoft.com/bash/tip_colors_and_formatting
black='\e[0m'
red='\e[41m'
green='\e[32m'
yellow='\e[33m'
dark_grey='\e[100m'
blue='\E[34;47m'
magenta='\E[35;47m'
cyan='\E[36;47m'
white='\E[37;47m'

# formatting strings used with printf
spacing="%15s"
ok_format="${green}${spacing}${black}"
crit_format="${red}${spacing}${black}"
warn_format="${yellow}${spacing}${black}"
text_format="${spacing}"
server_format="${dark_grey}${spacing}${black}"
count_format="%4s"

help () {
	echo "usage $0 [-n count] <server list> [check interval]"
	echo "- where server list is a file with one server per line"
	echo "- optional check interval is the amount of time you"
	echo "  would pass to the sleep command. ex. 15s"
	echo "requirements: netcat, ping/ICMP supported"
	# echo "optional: GNU parallel"
}

# optional check num args
set +u
if [[ $# -lt 1 ]]
then
	help
	exit 1
fi
set -u

# initialize variables
VERBOSE=false
DEBUG=false

# process command line args
while getopts "h?vd" opt
do
	case "${opt}" in
	h|\?)
		help
		exit 0
	;;
	v)
		VERBOSE=true
	;;
	d)
		DEBUG=true
	;;
	esac
done

shift $((OPTIND-1))

set +u
[ "${1}" = "--" ] && shift
set -u

if $DEBUG 
then
	# debugging 
	set -xeuo pipefail
fi

# optional process positional command line args
# ex. file=${1}

SERVER_LIST=${1}
SLEEP_INTERVAL=${2:-60s}

while true
do
	clear
	printf "${magenta}${count_format} ${spacing} ${spacing} ${spacing}${black}\n" "#" "Server" "Ping" "SSH"
	count=0

	for server in $(cat $SERVER_LIST)
	do
		count=$((count + 1))

		set +e
		ping_out=$(ping -c 1 -q $server 2>&1)
		ping_exit=$?
		set -e

		if [[ ${ping_exit} > 0 ]]
		then
			ping="OFFLINE"
			ping_format=${crit_format}

			ssh="FAIL"
			ssh_format=${crit_format}
		else
			ping="ONLINE"
			ping_format=${ok_format}

			set +e 
			ssh_out=$(nc -w1 ${server} -z 22 2>&1)
			ssh_exit=$?
			set -e

			if [[ ${ssh_exit} > 0 ]]
			then
				ssh="FAIL"
				ssh_format=${crit_format}
			else
				ssh="OK"
				ssh_format=${ok_format}
			fi
		fi

		printf "${count_format} ${server_format} ${ping_format} ${ssh_format}\n" ${count} ${server} ${ping} ${ssh}
	done

	echo "sleeping ${SLEEP_INTERVAL}"
	sleep ${SLEEP_INTERVAL}
done
