#!/bin/bash

# IP 集合名稱
IPSET_NAME_V4="blocklist_v4"
IPSET_NAME_V6="blocklist_v6"
SUDO="sudo"

# 如果當前使用者為 root，則不需要使用 sudo
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
fi

# 檢查是否存在 blacklist.txt 檔案
if [ ! -f blacklist.txt ]; then
    echo "Error: 'blacklist.txt' 檔案不存在。"
    exit 1
fi

# 創建或清空 IPv4 集合
if $SUDO ipset list $IPSET_NAME_V4 &>/dev/null; then
    $SUDO ipset flush $IPSET_NAME_V4
else
    $SUDO ipset create $IPSET_NAME_V4 hash:ip family inet
fi

# 創建或清空 IPv6 集合
if $SUDO ipset list $IPSET_NAME_V6 &>/dev/null; then
    $SUDO ipset flush $IPSET_NAME_V6
else
    $SUDO ipset create $IPSET_NAME_V6 hash:ip family inet6
fi

# 逐行讀取 blacklist.txt，依據 IP 類型加入對應的集合中
while IFS= read -r ip; do
    if [[ $ip =~ : ]]; then
        # IPv6 地址
        $SUDO ipset add $IPSET_NAME_V6 $ip
    else
        # IPv4 地址
        $SUDO ipset add $IPSET_NAME_V4 $ip
    fi
done < blacklist.txt

# 將更新後的 IPSET 集合應用到 iptables 和 ip6tables 規則中（如果規則還不存在）
if ! $SUDO iptables -C INPUT -m set --match-set $IPSET_NAME_V4 src -j DROP &>/dev/null; then
    $SUDO iptables -I INPUT -m set --match-set $IPSET_NAME_V4 src -j DROP
fi

if ! $SUDO ip6tables -C INPUT -m set --match-set $IPSET_NAME_V6 src -j DROP &>/dev/null; then
    $SUDO ip6tables -I INPUT -m set --match-set $IPSET_NAME_V6 src -j DROP
fi

echo "IPSET 已更新並套用最新的阻擋清單（IPv4 與 IPv6）。"
