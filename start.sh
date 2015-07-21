#!/bin/bash -e

echo user:x:$(id -u):0:USER:/root:/bin/bash >> /etc/passwd

apachectl start

# Clean up the extra templates
echo
echo 'Clean up zabbix templates'
echo '---------------'
ansible-playbook /root/ansible/playbooks/clean_zabbix.yml
echo

# Create the heartbeat and os linux templates along with items
echo
echo 'Create zabbix templates'
echo '---------------'
ansible-playbook /root/ansible/playbooks/setup_zabbix.yml
echo

# restart http
echo
echo 'Stop httpd'
echo '---------------'
killall httpd
echo

sleep 5

echo
echo 'start httpd'
echo '---------------'
LANG=C /usr/sbin/httpd -DFOREGROUND
