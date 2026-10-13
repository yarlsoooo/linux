#!/bin/bash
# Q2：创建 sentry_ws 四个子目录、两个空文件以及指定脚本和配置。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu
input="$1"
output="$2"

# TODO：删除下方提示和 exit 77，再填写你的命令。

if [ -z "$input" ] || [ -z "$output" ]; then
    exit 1
fi
mkdir -p "$output/sentry_ws/scripts"
mkdir -p "$output/sentry_ws/config"
mkdir -p "$output/sentry_ws/logs"
mkdir -p "$output/sentry_ws/tmp"

touch "$output/sentry_ws/logs/.keep"
touch "$output/sentry_ws/tmp/scratch.txt"

cat > "$output/sentry_ws/scripts/hello.sh" << 'EOF'
#!/bin/bash
echo "Hello, AIM Linux!"
EOF

cat > "$output/sentry_ws/config/robot.conf" << 'EOF'
robot=sentry
mode=training
log_level=INFO
EOF
exit 0
