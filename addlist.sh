#!/bin/bash

# IP 集合的名稱
IPSET_NAME="blocklist"

# 如果 IP 集合已存在，先刪除它
if ipset list $IPSET_NAME &>/dev/null; then
    sudo ipset flush $IPSET_NAME
else
    # 如果 IP 集合不存在，則創建一個新的集合
    sudo ipset create $IPSET_NAME hash:ip
fi

# 逐行讀取 IP 清單並將其加入到 IPSET
while IFS= read -r ip
do
    sudo ipset add $IPSET_NAME $ip
done < blacklist.txt

# 將更新後的 IPSET 集合應用到 iptables 規則中（如果規則還不存在）
if ! sudo iptables -C INPUT -m set --match-set $IPSET_NAME src -j DROP &>/dev/null; then
    sudo iptables -I INPUT -m set --match-set $IPSET_NAME src -j DROP
fi

echo "IPSET 已更新並套用最新的阻擋清單。"


