#!/bin/bash

cd /root/abuseIP

# 檢查是否存在 blacklist.txt 檔案
if [ ! -f blacklist.txt ]; then
    echo "Error: 'blacklist.txt' 檔案不存在。"
    exit 1
fi

# 初始化儲存格式化後的 IP 規則變數
formatted_list=()

# 逐行讀取 blacklist.txt，依據 IP 類型進行格式化
while IFS= read -r ip; do
    if [[ $ip =~ : ]]; then
        # IPv6 地址
        formatted_list+=("IP-CIDR6,$ip/128")
    else
        # IPv4 地址
        formatted_list+=("IP-CIDR,$ip/32")
    fi
done < blacklist.txt

# 將格式化後的規則列表寫入 list.txt
printf "%s\n" "${formatted_list[@]}" > badip.list

echo "轉換完成，結果已儲存至 'list.txt'。"
