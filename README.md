vpnd
====

smart vpn routing table for tomato shibby mod.

用法
----
将所有文件放在 ```/jffs``` 目录下。编辑 ```pptp.options``` 文件，用```服务器地址/用户名/密码```替换占位符。

运行前请先执行
```
/jffs/update.sh
```
获得最新路由表数据。

登录路由器管理页，点击 ```Administration -> Scripts -> WAN Up```，在输入框中写入一行
```
/jffs/start-pptp.sh
```

若要停止运行，请执行
```
/jffs/stop-pptp.sh
```


DNS 污染
----
在 Dnsmasq 配置中加入 ```conf-file=/jffs/dnsmasq.conf```。
