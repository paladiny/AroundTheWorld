# AroundTheWorld
科学上网
## 免密登录服务器
客户端命令： ```ssh-keygen```
按3次回车生成公钥私钥。（第一次要求输入存密钥的文件名，按回车则为默认/root/.ssh/id_rsa，第二次为加密密码，按回车默认密码为空，第三次回车则是密码再次确认）。<br>
在服务器新建文件/root/.ssh/authorized_keys，把客户端公钥/root/.ssh/id_rsa.pub的内容复制到服务器authorized_keys文件中。<br>
客户端ssh链接服务器，则可不用输入密码免密登录。<br>
---
## GCP创建服务器
机器类型选微型，最便宜的那种。地区优先香港，其他所有配置不动，防火墙规则勾选http和https流量。
创建完使用google提供的网页ssh工具登录。修改root密码:sudo passwd root,修改完成后用命令 su  获取root权限。
