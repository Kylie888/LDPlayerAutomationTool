import os
import subprocess
import json

# Đường dẫn LDPlayer Console
LDPLAYER_CONSOLE = "ldconsole.exe"

def start_ldplayer_instance(instance_name):
    print(f"Khởi động phiên bản LDPlayer: {instance_name}")
    subprocess.run([LDPLAYER_CONSOLE, "launch", "--name", instance_name])

def set_window_position(instance_name, x, y):
    print(f"Đặt vị trí cửa sổ cho {instance_name}: {x}, {y}")
    subprocess.run([LDPLAYER_CONSOLE, "setwindowpos", "--name", instance_name, "--x", str(x), "--y", str(y)])

def run_automation_task(instance_name):
    print(f"Thực hiện tác vụ tự động hóa trên {instance_name}")
    subprocess.run(["python", "adb_helper.py", instance_name])

def main():
    # Đọc cấu hình từ ldplayer_config.json
    with open("ldplayer_config.json", "r") as config_file:
        config = json.load(config_file)
    
    for instance in config["instances"]:
        start_ldplayer_instance(instance["name"])
        set_window_position(instance["name"], instance["x"], instance["y"])
        run_automation_task(instance["name"])

if __name__ == "__main__":
    main()