#!/bin/bash
# Bonus：start 时创建分离的 tmux 会话和采集器；stop 时正常停止采集器并结束会话。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu

input="$1"
output="$2"
action="${3:-start}"

source "$input/bonus.env"

if [ "$action" = "start" ]; then

    if tmux -L "$TMUX_SOCKET" has-session -t "$SESSION" 2>/dev/null; then
        echo "Session $SESSION already exists. Skipping start."
    else
        tmux -L "$TMUX_SOCKET" new-session -d -s "$SESSION" "python3 \"$WORKER_TOOL\" --token \"$TOKEN\" --log \"$output/bonus.log\""
    fi

elif [ "$action" = "stop" ]; then
    if tmux -L "$TMUX_SOCKET" has-session -t "$SESSION" 2>/dev/null; then
        tmux -L "$TMUX_SOCKET" send-keys -t "$SESSION" C-c
        sleep 1
        tmux -L "$TMUX_SOCKET" kill-session -t "$SESSION"
    fi
fi

exit 0
