import subprocess

def execute_adb_command(command):
    print(f"Thực thi lệnh ADB: {command}")
    subprocess.run(["adb"] + command.split())

if __name__ == "__main__":
    # Ví dụ lệnh ADB
    execute_adb_command("devices")