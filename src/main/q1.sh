#!/bin/bash
# Q1：定位 handover，读取隐藏编号和欢迎文本。输出 location.txt、robot-id.txt、welcome.txt。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu
input="$1"
output="$2"

# TODO：删除下方提示和 exit 77，再填写你的命令。

if [ -z "$input" ] || [ -z "$output" ]; then
    exit 1
fi

mkdir -p "$output"
(cd "$input/handover" && pwd) > "$output/location.txt"
cp "$input/handover/.robot-id" "$output/robot-id.txt"
cp "$input/notes/welcome.txt" "$output/welcome.txt"

exit 0
