#!/bin/bash
# Q4：合并日志，按级别提取，保存首尾片段并统计错误行数。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu
input="$1"
output="$2"

# TODO：删除下方提示和 exit 77，再填写你的命令。

if [ -z "$input" ] || [ -z "$output" ]; then
    exit 1
fi

cat "$input/boot.log" "$input/run.log" > "$output/all.log"
grep "^ERROR" "$output/all.log" > "$output/errors.log" || true
grep -E "^(WARN|ERROR)" "$output/all.log" > "$output/attention.log" || true
tail -n 5 "$output/all.log" > "$output/recent.log" || true
head -n 3 "$output/errors.log" > "$output/first-errors.log" || true
wc -l < "$output/errors.log" > "$output/error-count.txt"
exit 0
