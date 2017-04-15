#! /usr/bin/fish

# set from and to as args or error

for x in (find . -name "*.mp3")
	set d (dirname $x)	
	set f (basename $x)
	set info (mp3info -p "%l_%a_%n_%t" $x)
	set fname (echo $info | tr [:blank:] [_] | tr -d [\:\'\"\?\&\#\(\)\+\!\,\\-]  | tr -s [\_\.])
	echo "$d $f"
	echo "normalized: $fname"
end

exit 0
