# Example docker run command
# docker run -ti --net=host --name web --rm=true oso-rhel7-zabbix-web
# /root/start.sh will then start the httpd.
# Default login:password to Zabbix is Admin:zabbix

FROM oso-centos7-ops-base:latest

#EXPOSE 80
#EXPOSE 443
EXPOSE 8000

# Lay down the zabbix repository
RUN yum clean metadata && \
    yum install -y openshift-ops-yum-zabbix && \
    yum clean all

# Install zabbix from zabbix repo
RUN yum install -y zabbix-web-mysql && \
    yum -y update && \
    yum clean all

## WORK AROUND FOR PHP ZABBIX CONF MISSING
ADD zabbix.conf.php /etc/zabbix/web/

## Copy httpd.conf
ADD httpd.conf /etc/httpd/conf/

# Set the timezone in the php.ini file
RUN sed -r -ie 's/^;(date.timezone).*/\1 = America\/New_York/g' /etc/php.ini

# Fix v3 specific environment
RUN chmod 777 /var/run/httpd
RUN chmod 777 /etc/httpd
RUN chmod 777 /var/log/httpd/


# Start apache
ADD start.sh /usr/local/bin/
CMD /usr/local/bin/start.sh

