#! /usr/bin/fish

# For starting godoc at wm startup

nohup godoc -http=:6060 >/dev/null &

set msg (fortune -a)

set gdoc "godoc started on port 6060"

echo -e "$msg\n\n$gdoc" | fold -s | xmessage -file - 
