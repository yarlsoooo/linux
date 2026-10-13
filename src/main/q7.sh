#!/bin/bash
# Q7：读取 input/remote.env，生成 ssh_config，用 SSH 和 SCP 获取远程数据。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu
input="$1"
output="$2"

# TODO：删除下方提示和 exit 77，再填写你的命令。

if [ -z "$input" ] || [ -z "$output" ]; then
    exit 1
fi

# 1. 读取题目给定的环境变量（包含各种路径、端口和密钥）
source "$input/remote.env"

# 2. 提前创建接收日志的目录
mkdir -p "$output/received"

# 3. 生成 ssh_config 文件
# 【关键】：路径可能包含空格，所以在 ssh_config 内部也要用引号包裹变量
cat > "$output/ssh_config" << EOF
Host aim-sentry
    HostName "$HOST"
    Port "$PORT"
    User "$REMOTE_USER"
    IdentityFile "$KEY_PATH"
    UserKnownHostsFile "$KNOWN_HOSTS"
    IdentitiesOnly yes
    StrictHostKeyChecking yes
    BatchMode yes
EOF

# 4. 严格设置配置文件权限为 600（读写仅限当前用户）
chmod 600 "$output/ssh_config"

# 5. 通过 SSH 执行远程 whoami，保存返回的用户名
# -F 指定使用我们生成的配置文件，避开个人的 SSH 配置
ssh -F "$output/ssh_config" aim-sentry whoami > "$output/remote-user.txt"

# 6. 通过 SCP 下载远端日志到 received/errors.log
# 注意：远程路径中的冒号和空格，用引号包裹整个 "别名:路径"
scp -F "$output/ssh_config" "aim-sentry:$REMOTE_LOG" "$output/received/errors.log"

# 正常退出
exit 0
