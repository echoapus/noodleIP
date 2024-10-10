#!/bin/bash

# 初始化儲存 IPv4 和 IPv6 地址的變數
ipv4_list=()
ipv6_list=()

# 檢查是否存在 blacklist.txt 檔案
if [ ! -f blacklist.txt ]; then
    echo "Error: 'blacklist.txt' 檔案不存在。"
    exit 1
fi

# 逐行讀取 blacklist.txt，依據 IP 類型加入對應的列表中
while IFS= read -r ip; do
    if [[ $ip =~ : ]]; then
        # IPv6 地址
        ipv6_list+=("IP-CIDR6,$ip/128")
    else
        # IPv4 地址
        ipv4_list+=("IP-CIDR,$ip/32")
    fi
done < blacklist.txt

# 將 IPv4 和 IPv6 地址合併並組合成規則字串
combined_list=("${ipv6_list[@]}" "${ipv4_list[@]}")
rule="OR,(${combined_list[*]// /), (})"

# 組成最終的 [Rule] 格式
final_rule="[Rule]\n$rule,REJECT"

# 將結果寫入 list.txt
echo -e "$final_rule" > badlist.txt

echo "轉換完成，結果已儲存至 'list.txt'。"
