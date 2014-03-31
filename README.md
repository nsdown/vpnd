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
/jffs/stop-pptp.sh || true
/jffs/start-pptp.sh
```

DNS 污染
----
首先在 Dnsmasq 配置中加入 ```conf-file=/jffs/dnsmasq.conf``` 后保存。
然后在 ```Administration -> Scripts -> Firewall``` 中加入以下内容
```
iptables -N dnsfilter -t mangle
iptables -t mangle -I dnsfilter -p udp -m udp -m u32 --u32 "0&0x0F000000=0x05000000 && 22&0xFFFF@16=0x042442b2,0x0807c62d,0x253d369e,0x2e52ae44,0x3b1803ad,0x402158a1,0x4021632f,0x4042a3fb,0x4168cafc,0x41a0db71" -j DROP
iptables -t mangle -I dnsfilter -p udp -m udp -m u32 --u32 "0&0x0F000000=0x05000000 && 22&0xFFFF@16=0x422dfced,0x480ecd63,0x480ecd68,0x4e10310f,0x5d2e0859,0x80797e8b,0x9f6a794b,0xa9840d67,0xc043c606,0xca6a0102" -j DROP
iptables -t mangle -I dnsfilter -p udp -m udp -m u32 --u32 "0&0x0F000000=0x05000000 && 22&0xFFFF@16=0xcab50755,0xcb620741,0xcba1e6ab,0xcf0c5862,0xd0381f2b,0xd1244921,0xd1913632,0xd1dc1eae,0xd35e4293,0xd5a9fb23" -j DROP
iptables -t mangle -I dnsfilter -p udp -m udp -m u32 --u32 "0&0x0F000000=0x05000000 && 22&0xFFFF@16=0xd8ddbcb6,0xd8eab30d,0xf3b9bb27,0x4a7d7f66,0x4a7d9b66,0x4a7d2771,0x4a7d2766,0xd155e58a" -j DROP
iptables -t mangle -I PREROUTING -m udp -p udp --sport 53 -i ! ppp1 -j dnsfilter
```

重启路由器或执行 ```service firewall restart```。
