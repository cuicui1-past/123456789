#!/bin/bash

# 定义目标目录和脚本
TARGET_DIR="/run/media/mmcblk1p1/user/MeloTTS/c"
DEMO_SCRIPT1="./2.demo"
#DEMO_SCRIPT2="./audio3.demo"

# 检查目标目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo "错误: 目录 '$TARGET_DIR' 不存在"
    exit 1
fi

# 导航到目标目录
echo "进入目录: $TARGET_DIR"
cd "$TARGET_DIR" || exit

# 检查第一个脚本是否存在且可执行
if [ ! -x "$DEMO_SCRIPT1" ]; then
    echo "错误: 脚本 '$DEMO_SCRIPT1' 不存在或不可执行"
    exit 1
fi

# 执行第一个脚本
echo "执行脚本: $DEMO_SCRIPT1"
"$DEMO_SCRIPT1"

# 检查执行状态
if [ $? -ne 0 ]; then
    echo "错误: 脚本 '$DEMO_SCRIPT1' 执行失败"
    exit 1
fi

# 检查第二个脚本是否存在且可执行
if [ ! -x "$DEMO_SCRIPT2" ]; then
    echo "错误: 脚本 '$DEMO_SCRIPT2' 不存在或不可执行"
    exit 1
fi

# 执行第二个脚本
echo "执行脚本: $DEMO_SCRIPT2"
"$DEMO_SCRIPT2"

# 检查最终执行状态
if [ $? -ne 0 ]; then
    echo "错误: 脚本 '$DEMO_SCRIPT2' 执行失败"
    exit 1
fi

echo "所有脚本执行完毕"
exit 0
rm /run/media/mmcblk1p1/user/qwen2/out/output.txt
