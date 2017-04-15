#! /usr/bin/fish

for file in * 
	set fname (echo $file | tr [:blank:] [_] | tr -d [\'\"\?\&\#\(\)\+\!\,\\-]  | tr -s [\_\.])
	set rndm (random | cut -c1-4)	
	set new_name "$rndm-$fname"
        cp -v $file mix/$new_name	
end


