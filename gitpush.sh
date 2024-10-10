#!/bin/bash

# 檢查是否在 Git 儲存庫內
if [ ! -d .git ]; then
  echo "此目錄不是 Git 儲存庫！"
  exit 1
fi

# 取得當前時間作為提交訊息
commit_message="Update on $(date '+%Y-%m-%d %H:%M:%S')"

# 將所有未追蹤的檔案加入至 Git 追蹤
git add .

# 提交變更並附加當前時間作為訊息
git commit -m "$commit_message"

# 推送至遠端
git push

# 顯示推送結果
echo "所有變更已成功推送至遠端儲存庫。提交訊息：$commit_message"
