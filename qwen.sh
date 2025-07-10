#!/bin/bash

# 定义目标目录和脚本
TARGET_DIR="/run/media/mmcblk1p1/user/qwen2/c"
SCRIPT_NAME="./qwen2.sh"

# 检查目标目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo "错误: 目录 '$TARGET_DIR' 不存在"
    exit 1
fi

# 导航到目标目录
echo "进入目录: $TARGET_DIR"
cd "$TARGET_DIR" || exit

# 检查脚本是否存在且可执行
if [ ! -x "$SCRIPT_NAME" ]; then
    echo "错误: 脚本 '$SCRIPT_NAME' 不存在或不可执行"
    
    # 检查脚本是否存在但不可执行
    if [ -f "$SCRIPT_NAME" ]; then
        echo "提示: 脚本存在但不可执行，是否尝试添加执行权限? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            chmod +x "$SCRIPT_NAME"
            echo "已添加执行权限"
        else
            exit 1
        fi
    else
        exit 1
    fi
fi

# 执行脚本
echo "执行脚本: $SCRIPT_NAME"
"$SCRIPT_NAME"
