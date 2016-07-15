#! /usr/bin/env bash

# License

# author:
# email:
# version: 0.0
# created:
# modified:

# TODO 

# bash unofficial strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

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
ok="${green}${spacing}${black}"
crit="${red}${spacing}${black}"
warn="${yellow}${spacing}${black}"
text="${spacing}"
server="${dark_grey}${spacing}${black}"

help () {
	echo "help message"
}

# optional check num args
set +u
if [[ $# -lt 0 ]]
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

