#!/bin/sh
set -e

echo "Waiting 10 seconds while the host environment becomes ready ..."
sleep 10

echo "Starting the user interface"

PUID=${PUID:=0}
PGID=${PGID:=0}

if [ ! -f /conf/aria2.conf ]; then
	cp /conf-copy/aria2.conf /conf/aria2.conf
	chown $PUID:$PGID /conf/aria2.conf
	if [ $SECRET ]; then
		echo "rpc-secret=${SECRET}" >> /conf/aria2.conf
	fi
fi

touch /conf/aria2.session
chown $PUID:$PGID /conf/aria2.session

touch /logs.txt
chown $PUID:$PGID /logs.txt

darkhttpd /aria2-webui/docs --port 80 &

echo "Your public IP is $(wget -qO- https://ipecho.net/plain ; echo)"

exec s6-setuidgid $PUID:$PGID aria2c --disable-ipv6=true --conf-path=/conf/aria2.conf --log=/logs.txt
