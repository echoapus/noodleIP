#!/bin/bash
cd /root/abuseIP
#變更檔案名稱
FILE_NAME="badip.list"

# 確認檔案是否存在
if [[ ! -f "$FILE_NAME" ]]; then
  echo "檔案 $FILE_NAME 不存在，請檢查路徑或檔案名稱是否正確。"
  exit 1
fi

# 顯示當前 Git 狀態
echo "當前 Git 狀態："
git status

# 新增 `badip.list` 到 Git 暫存區
git add *

# 提交變更，並加入提交訊息
COMMIT_MESSAGE="Update badip.list on $(date +"%Y-%m-%d %H:%M:%S")"
git commit -m "$COMMIT_MESSAGE"

# 推送到遠端儲存庫
git push --force origin main

# 結束訊息
echo "成功更新並推送 $FILE_NAME 到遠端儲存庫。"
