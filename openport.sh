#!/bin/bash
a='iptables -P INPUT ACCEPT'
b='iptables -P OUTPUT ACCEPT'
c='iptables -P FORWARD ACCEPT'
d='iptables -F'

function openPort(){
	$a
	$b
	$c
	$d
}

function echoInfo(){
	echo -e "\e[1;36m$1\e[0m\n"
}

function echoResult(){
	echo -e "\e[1;32m$1\e[0m\n"
}

function echoError(){
	echo -e "\e[1;35m$1\e[0m\n"
}



openPort
echoResult '已临时放开所有端口' 
echoInfo '添加启动项，每次服务器重启后会自动放开所有端口'

echoInfo '检查文件 /lib/systemd/system/rc.local.service 内容中是否有[Install]段'
grep '[Install]' /lib/systemd/system/rc.local.service > /dev/null
if [ $? -eq 0 ]; then
	echoResult '检查结果：[Install]段已存在'
else
	echoError '检查结果：[Install]段不存在'
	echoInfo '添加[Install]段'
	echo ''>> /lib/systemd/system/rc.local.service
	echo '[Install]'>> /lib/systemd/system/rc.local.service
	echo 'WantedBy=multi-user.target'>> /lib/systemd/system/rc.local.service
	echo 'Alias=rc-local.service' >> /lib/systemd/system/rc.local.service
	echoResult '添加完成'
fi

echoInfo '检查文件 /etc/rc.local 是否存在'
if [ -f "/etc/rc.local" ]; then
	echoResult '检查结果：/etc/rc.local 文件存在'
	echoInfo '检查重启是否自动放开所有端口'
	grep 'iptables -P' /etc/rc.local > /dev/null
	if [ $? -eq 0 ]; then
		echoResult '检查结果：自动放开所有端口'
	else
		echoError '检查结果：无法自动放开所有端口'
		echoInfo '正在添加脚本到rc.local'
		echo -e "$a\n$b\n$c\n$d\n" >>/etc/rc.local
		echoResult '添加完成'
	fi

else
	echoError '文件不存在'
	echoInfo '创建文件 /etc/rc.local'
	echo -e "$a\n$b\n$c\n$d\nexit 0\n" >>/etc/rc.local
	echoResult '创建完成'

	chmod 755 /etc/rc.local
fi

echoInfo '检查软链接是否存在'
if [ -f "/etc/systemd/system/rc.local.service" ];then
	echoResult '软链接存在'
	else
		echoError '软链接不存在'
		echoInfo '创建软链接'
		ln -s /lib/systemd/system/rc.local.service /etc/systemd/system/
		echoResult '创建完成'
fi

echoInfo '脚本执行完毕'