#!/bin/bash
# Q6：将本地 Debian 包安装到 output/sysroot，运行安装后的工具。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu
input="$1"
output="$2"

# TODO：删除下方提示和 exit 77，再填写你的命令。

if [ -z "$input" ] || [ -z "$output" ]; then
    exit 1
fi

# 1. 使用 dpkg 将包安装到输出目录的 sysroot/ 下
# --root: 指定安装根目录（绝不能是 /，必须是 $output/sysroot）
# --force-not-root: 允许普通用户身份执行安装
# --log: 关闭日志记录（该包没有维护脚本）
# -i: 安装指定的 .deb 文件
dpkg --root="$output/sysroot" --force-not-root --log=/dev/null -i "$input/aim-sentry-tools.deb"

# 2. 运行安装后的工具，并将标准输出保存到 tool-output.txt
# 路径是在 sysroot 下的 /usr/bin/ 目录中
"$output/sysroot/usr/bin/aim-sentry-info" > "$output/tool-output.txt"

# 正常退出
exit 0
