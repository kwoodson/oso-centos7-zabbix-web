#!/bin/bash -e

echo user:x:$(id -u):0:USER:/root:/bin/bash >> /etc/passwd

echo 'start httpd'
LANG=C /usr/sbin/httpd -DFOREGROUND
