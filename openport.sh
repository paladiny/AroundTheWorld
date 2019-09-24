#!/bin/bash
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
echo '已临时放开所有端口'
echo '添加启动项，每次服务器重启后会自动放开所有端口'

echo '检查 /lib/systemd/system/rc.local.service 是否有[Install]段'
grep '[Install]' /lib/systemd/system/rc.local.service > /dev/null
if [ $? -eq 0 ]; then
	echo '检查结果：[Install]段已存在'
else
	echo '检查结果：[Install]段不存在'
	echo '添加[Install]段'
	echo ''>> /lib/systemd/system/rc.local.service
	echo '[Install]'>> /lib/systemd/system/rc.local.service
	echo 'WantedBy=multi-user.target'>> /lib/systemd/system/rc.local.service
	echo 'Alias=rc-local.service' >> /lib/systemd/system/rc.local.service
	echo '添加完成'
fi

echo '检查 /etc/rc.local 是否存在'
if [ -f "/etc/rc.local" ]; then
	echo '检查结果：/etc/rc.local 文件存在'
	echo '检查重启是否自动放开所有端口'
	grep 'iptables -P' /etc/rc.local > /dev/null
	if [ $? -eq 0 ]; then
		echo '检查结果：自动放开所有端口'
	else
		echo '检查结果：无法自动放开所有端口，正在添加iptables -P'
		echo 'iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F' >>/etc/rc.local
		echo '添加完成'
	fi

else
	echo '创建文件 /etc/rc.local'
	echo '#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
# echo "this is a test" > /usr/local/text.log
# exit 0
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F' >>/etc/rc.local


chmod 755 /etc/rc.local

ln -s /lib/systemd/system/rc.local.service /etc/systemd/system/
fi

