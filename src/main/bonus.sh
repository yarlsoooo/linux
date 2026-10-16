#!/bin/bash
# Bonus：start 时创建分离的 tmux 会话和采集器；stop 时正常停止采集器并结束会话。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu


if [ -f "./bonus.env" ]; then
    source ./bonus.env
elif [ -f "$(dirname "$0")/../../bonus.env" ]; then
    source "$(dirname "$0")/../../bonus.env"
elif [ -f "$(dirname "$0")/../bonus.env" ]; then
    source "$(dirname "$0")/../bonus.env"
fi

ACTION=${1:-start}

for var in TMUX_SOCKET SESSION TOKEN WORKER_TOOL; do
    if [ -z "${!var}" ]; then
        echo "错误：环境变量 $var 未设置 (请确保评测环境已提供 bonus.env)"
        exit 1
    fi
done

OUTPUT_DIR=${output:-"./output"}
LOG_FILE="$OUTPUT_DIR/bonus.log"
mkdir -p "$OUTPUT_DIR"

do_start() {
    tmux -L "$TMUX_SOCKET" has-session -t "$SESSION" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "会话 '$SESSION' 已存在，无需重复启动。"
        exit 0
    fi

    echo "正在创建分离会话 '$SESSION' 并启动采集器..."
    tmux -L "$TMUX_SOCKET" new-session -d -s "$SESSION" "python3 \"$WORKER_TOOL\" --token \"$TOKEN\" --log \"$LOG_FILE\""

    if [ $? -eq 0 ]; then
        echo "启动成功。日志正在写入: $LOG_FILE"
        echo "你可以安全地关闭当前终端（SSH断开不影响会话）。"
    else
        echo "启动失败，请检查参数。"
        exit 1
    fi
}

do_stop() {
    tmux -L "$TMUX_SOCKET" has-session -t "$SESSION" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "会话 '$SESSION' 不存在，无需停止。"
        exit 0
    fi

    echo "正在停止会话 '$SESSION' 中的采集器..."
    tmux -L "$TMUX_SOCKET" kill-session -t "$SESSION"

    if [ $? -eq 0 ]; then
        echo "会话已终止，清理完成。"
    else
        echo "停止会话失败，请检查。"
        exit 1
    fi
}

case "$ACTION" in
    start)
        do_start
        ;;
    stop)
        do_stop
        ;;
    *)
        echo "用法: $0 {start|stop}"
        exit 1
        ;;
esac

exit 0


