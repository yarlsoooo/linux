#!/bin/bash
# Q5：运行 launch.env 给定的启动前检查，保存 stdout/stderr、真实退出码和诊断报告。
# 完整接口与验收规格见 Problem.pdf。只修改本文件，不修改测试或工具。
set -eu
input="$1"
output="$2"

# TODO：删除下方提示和 exit 77，再填写你的命令。

if [ -z "$input" ] || [ -z "$output" ]; then
    exit 1
fi


# 1. 读取环境变量（路径可能包含空格，必须加引号）
source "$input/launch.env"

# 2. 运行检查程序并捕获输出与退出码
# 【关键技巧】：临时关闭 set -e，因为检查程序返回10或20是本题的正常预期
set +e
bash "$LAUNCH_TOOL" "$MODEL_PATH" "$CAMERA_PATH" > "$output/stdout.log" 2> "$output/stderr.log"
exit_code=$?
set -e

# 3. 保存真实退出码（> 是覆盖，保证第二次执行不会重复追加）
echo "$exit_code" > "$output/exit-code.txt"

# 4. 根据退出码生成诊断报告
case "$exit_code" in
    0)
        result="SUCCESS"
        reason="NONE"
        ;;
    10)
        result="FAILED"
        reason="MODEL_MISSING"
        ;;
    20)
        result="FAILED"
        reason="CAMERA_DENIED"
        ;;
    *)
        # 防御性兜底（题目只有0/10/20，但防止意外）
        result="FAILED"
        reason="UNKNOWN"
        ;;
esac

# 使用多行重定向写入固定格式的 report.txt
cat > "$output/report.txt" << EOF
result=$result
exit_code=$exit_code
reason=$reason
EOF

# 检查程序失败是我们的正常业务流程，最终脚本必须正常退出 0
exit 0

