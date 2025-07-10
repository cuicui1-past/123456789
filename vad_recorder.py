import sys
import wave
import time
import webrtcvad
from collections import deque
import audioop  # 使用标准库进行音频转换

# 配置参数
SAMPLE_RATE = 16000
CHANNELS = 2
FRAME_DURATION = 30
FRAME_SIZE = int(SAMPLE_RATE * FRAME_DURATION / 1000) * 2 * CHANNELS  # 每帧字节数

# 业务参数
MIN_RECORD_DURATION = 3
SILENCE_FRAMES_THRESHOLD = 67

# 固定录音文件名（用于覆盖）
RECORDING_FILENAME = "recording.wav"

# 初始化
vad = webrtcvad.Vad(3)
record_buffer = deque()
is_recording = False
start_time = 0
silence_counter = 0

def stereo_to_mono(frame):
    """正确的双声道转单声道（16位PCM）"""
    # 使用audioop进行专业转换
    return audioop.tomono(frame, 2, 0.5, 0.5)  # 左右声道各取50%

def save_recording(buffer, timestamp=None):
    """保存为正确的WAV格式（固定文件名实现覆盖）"""
    with wave.open(RECORDING_FILENAME, 'wb') as wf:
        wf.setnchannels(1)  # 单声道输出
        wf.setsampwidth(2)   # 16位采样
        wf.setframerate(SAMPLE_RATE)
        wf.writeframes(b''.join(buffer))
    print(f"录音保存：{RECORDING_FILENAME}")

try:
    print("开始录音（按Ctrl+C退出）...")
    while True:
        frame = sys.stdin.buffer.read(FRAME_SIZE)
        if not frame:
            break

        # 转换为单声道用于VAD检测
        mono_frame = stereo_to_mono(frame)
        is_speech = vad.is_speech(mono_frame, SAMPLE_RATE)

        # 录音状态管理
        if is_speech:
            if not is_recording:
                # 开始新录音（覆盖模式）
                is_recording = True
                start_time = time.time()
                record_buffer.clear()
                silence_counter = 0
                print("检测到语音，开始录音...")
            
            # 添加当前帧（存储转换后的单声道数据）
            record_buffer.append(mono_frame)
            silence_counter = 0
        else:
            if is_recording:
                # 添加静默帧（仅在录音中）
                record_buffer.append(mono_frame)
                
                # 检查终止条件
                current_duration = (len(record_buffer) * FRAME_DURATION) / 1000
                if current_duration >= MIN_RECORD_DURATION:
                    silence_counter += 1
                    if silence_counter >= SILENCE_FRAMES_THRESHOLD:
                        save_recording(record_buffer)
                        print(f"录音结束（时长：{current_duration:.1f}秒）")
                        sys.exit(0)  # 完成一次录音后退出程序

except KeyboardInterrupt:
    if is_recording and record_buffer:
        save_recording(record_buffer)
        print(f"\n手动终止，录音保存：{RECORDING_FILENAME}")
    sys.exit(0)
