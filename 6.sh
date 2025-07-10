#!/bin/bash

# 主控制脚本 - 按顺序执行bash1到bash5并无限循环

# 定义子脚本路径
SCRIPT_DIR="."  # 脚本所在目录，可根据实际情况修改
SCRIPTS=(
    "$SCRIPT_DIR/7.sh"
    "$SCRIPT_DIR/sencevoics.sh"
    "$SCRIPT_DIR/qwen.sh"
    "$SCRIPT_DIR/melotts.sh"
 
)

# 日志文件
LOG_FILE="script_loop.log"

# 检查脚本是否存在并可执行
check_scripts() {
    local all_exist=0
    for script in "${SCRIPTS[@]}"; do
        if [[ ! -x "$script" ]]; then
            echo "错误: 脚本 $script 不存在或不可执行" >&2
            all_exist=1
        fi
    done
    return $all_exist
}

# 执行单个脚本并记录日志
run_script() {
    local script="$1"
    local start_time=$(date +%s)
    
    echo "[$(date)] 开始执行: $script" | tee -a "$LOG_FILE"
    
    # 执行脚本并捕获输出
    if output=$("$script" 2>&1); then
        local exit_code=0
        echo "[$(date)] 执行成功: $script (耗时: $(( $(date +%s) - start_time ))秒)" | tee -a "$LOG_FILE"
    else
        local exit_code=$?
        echo "[$(date)] 执行失败: $script (退出码: $exit_code)" | tee -a "$LOG_FILE"
        echo "错误详情: $output" | tee -a "$LOG_FILE"
    fi
    
    return $exit_code
}

# 主循环
main() {
    echo "[$(date)] 开始主控制脚本" | tee -a "$LOG_FILE"
    
    # 检查脚本
    if ! check_scripts; then
        echo "脚本检查失败，退出" >&2
        exit 1
    fi
    
    local iteration=1
    while true; do
        echo "[$(date)] 开始第 $iteration 次循环" | tee -a "$LOG_FILE"
        
        for script in "${SCRIPTS[@]}"; do
            run_script "$script"
            
            # 如果脚本执行失败，可以选择继续或退出循环
            # 这里选择继续执行下一个脚本
        done
        
        echo "[$(date)] 第 $iteration 次循环完成" | tee -a "$LOG_FILE"
        echo "----------------------------------------" | tee -a "$LOG_FILE"
        
        ((iteration++))
        
        # 循环间隔，可以根据需要调整或删除
        sleep 3
    done
}

# 执行主函数
main
