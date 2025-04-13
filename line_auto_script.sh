#!/bin/bash

create_system_prop() {
    echo "Tạo file system.prop..."
}

check_root_status() {
    echo "Kiểm tra trạng thái Root..."
}

modify_device_info() {
    echo "Chỉnh sửa thông tin thiết bị..."
}

remove_emulator_traces() {
    echo "Xóa dấu vết giả lập..."
}

open_line_app() {
    echo "Mở ứng dụng LINE..."
    adb shell monkey -p jp.naver.line.android -c android.intent.category.LAUNCHER 1
}

login_with_credentials() {
    local email=$1
    local password=$2
    echo "Đăng nhập với email: $email"
}

create_system_prop
check_root_status
modify_device_info
remove_emulator_traces
open_line_app
login_with_credentials "example1@gmail.com" "password123"