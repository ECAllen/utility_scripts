#! /usr/bin/fish

nohup godoc -http=:6060 >/dev/null &

set msg (fortune -a)

set gdoc "godoc started on port 6060"

xmessage $msg $gdoc 
