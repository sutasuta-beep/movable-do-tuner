#!/bin/bash
# 移動ド音程チェッカー のローカルサーバを停止する
PORT=8765
PIDS=$(lsof -nP -iTCP:$PORT -sTCP:LISTEN -t 2>/dev/null)
if [ -z "$PIDS" ]; then
  echo "サーバは起動していません (port $PORT)"
else
  echo "$PIDS" | xargs kill
  echo "停止しました (port $PORT)"
fi
sleep 1
