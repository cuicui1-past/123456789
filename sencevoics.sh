#!/bin/bash

# 定义目标目录路径
target_dir="/run/media/mmcblk1p1/user/SenseVoice/c"

# 定义要执行的程序
program="./SenseVoice.demo"

# 检查目标目录是否存在
if [ -d "$target_dir" ]; then
    echo "进入目录: $target_dir"
    cd "$target_dir" || exit
    
    # 检查程序是否存在且可执行
    if [ -x "$program" ]; then
        echo "执行程序: $program"
        "$program"
    else
        echo "错误: 程序 '$program' 不存在或不可执行"
        exit 1
    fi
else
    echo "错误: 目录 '$target_dir' 不存在"
    exit 1
fi
cd /run/media/mmcblk1p1/user/SenseVoice
grep '"content":' output.json | sed 's/.*"content": "\(.*\)".*/\1/' > output.txt
