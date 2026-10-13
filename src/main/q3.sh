#!/bin/bash
# Q3：复制素材、备份配置、移动草稿、删除 tmp、设定权限并直接运行 hello.sh。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu
input="$1"
output="$2"

# TODO：删除下方提示和 exit 77，再填写你的命令。

if [ -z "$input" ] || [ -z "$output" ]; then
    exit 1
fi
rm -rf "$output/sentry_ws/tmp"
mkdir -p "$output/sentry_ws/scripts"
mkdir -p "$output/sentry_ws/config"
mkdir -p "$output/sentry_ws/backup"
mkdir -p "$output/sentry_ws/archive"
cp "$input/hello.sh" "$output/sentry_ws/scripts/hello.sh"
cp "$input/robot.conf" "$output/sentry_ws/config/robot.conf"
cp "$input/draft.conf" "$output/sentry_ws/config/draft.conf"
cp "$output/sentry_ws/config/robot.conf" "$output/sentry_ws/backup/robot.conf"
mv "$output/sentry_ws/config/draft.conf" "$output/sentry_ws/archive/draft.conf.old"
rm -rf "$output/sentry_ws/tmp"
chmod 750 "$output/sentry_ws/scripts/hello.sh"
chmod 640 "$output/sentry_ws/config/robot.conf"

bash "$output/sentry_ws/scripts/hello.sh" > "$output/hello-output.txt"
exit 0
