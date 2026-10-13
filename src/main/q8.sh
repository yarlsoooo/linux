#!/bin/bash
# Q8：repair 时识别并停止采集器、修复 HTTP 服务；cleanup 时停止修复后的服务。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu
input="$1"
output="$2"

# TODO：删除下方提示和 exit 77，再填写你的命令。

if [ -z "$input" ] || [ -z "$output" ]; then
    exit 1
fi

action="${3:-repair}" 

source "$input/process.env"


if [ "$action" = "cleanup" ]; then
    if [ -f "$output/service/pid" ]; then
        SERVICE_PID=$(cat "$output/service/pid")
        kill "$SERVICE_PID" || true
        for i in {1..10}; do
            if ! ss -tlnp 2>/dev/null | grep -q ":$TARGET_PORT "; then
                break
            fi
            sleep 0.5
        done
    fi
    exit 0
fi

PID_VAL=$(ps -p "$TARGET_PID" -o pid= | tr -d ' ')
USER_VAL=$(ps -p "$TARGET_PID" -o user= | tr -d ' ')
STATE_VAL=$(ps -p "$TARGET_PID" -o state= | tr -d ' ')
COMMAND_VAL=$(ps -p "$TARGET_PID" -o args=)

cat > "$output/process.txt" << EOF
pid=$PID_VAL
user=$USER_VAL
state=$STATE_VAL
command=$COMMAND_VAL
EOF


grep -E "TICK|START" "$WORKER_LOG" | tail -n 2 > "$output/collector-sample.log" || true

kill "$TARGET_PID" || true


for i in {1..10}; do
    if ! ps -p "$TARGET_PID" > /dev/null 2>&1; then
        break
    fi
    sleep 0.5
done


kill "$SERVICE_PID" || true
sleep 1


cat > "$output/server.conf" << EOF
bind=127.0.0.1
port=$TARGET_PORT
route=/status
EOF
bash "$START_TOOL" "$output/server.conf" "$output/service"
HTTP_CODE="000"

for i in {1..20}; do
    HTTP_CODE=$(curl -s -o "$output/http-body.txt" -w "%{http_code}" "http://127.0.0.1:$TARGET_PORT/status" || echo "000")
    if [ "$HTTP_CODE" = "200" ]; then
        break
    fi
    sleep 0.5
done
echo "$HTTP_CODE" > "$output/http-status.txt"

exit 0

