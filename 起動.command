#!/bin/bash
# 移動ド音程チェッカー 起動スクリプト
# マイクは file:// では使えないため、ローカルサーバ経由で開く。
cd "$(dirname "$0")" || exit 1
PORT=8765

if lsof -nP -iTCP:$PORT -sTCP:LISTEN >/dev/null 2>&1; then
  echo "サーバは既に起動しています (port $PORT)"
else
  echo "サーバを起動します (port $PORT)..."
  nohup python3 -m http.server $PORT >/dev/null 2>&1 &
  sleep 1
fi

URL="http://localhost:$PORT/"
if [ -d "/Applications/Google Chrome.app" ]; then
  open -a "Google Chrome" "$URL"
else
  open "$URL"
fi

echo "開きました: $URL"
echo "（このウィンドウは閉じて構いません。サーバを止めるには 停止.command）"
sleep 1
