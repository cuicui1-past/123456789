#!/bin/bash

# 音频设备参数（参考开发板音频配置）
# 设备：rockchipnau8822（对应hw:1,0）
# 格式：16位PCM，采样率16000Hz，单声道
AUDIO_DEVICE="hw:1,0"
SAMPLE_RATE=16000
FORMAT="S16_LE"
CHANNELS=2

# 启动arecord采集音频，通过管道传输给Python脚本
arecord -D "$AUDIO_DEVICE" \
        -r "$SAMPLE_RATE" \
        -f "$FORMAT" \
        -c "$CHANNELS" \
        -t raw - | python3 vad_recorder.py

