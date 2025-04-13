#!/bin/bash

# Kiểm tra tham số đầu vào
if [ "$#" -ne 3 ]; then
    echo "Sử dụng: $0 <mode> <ldplayer_path> <email_path>"
    echo "  mode: run_test (1 LDPlayer) hoặc run_tool (5 LDPlayer)"
    echo "  ldplayer_path: Đường dẫn thư viện LDPlayer9"
    echo "  email_path: Đường dẫn thư viện Emails"
    exit 1
fi

MODE=$1
LDPLAYER_PATH=$2
EMAIL_PATH=$3

# Kiểm tra thư mục LDPlayer và Emails
if [ ! -d "$LDPLAYER_PATH" ]; then
    echo "Thư mục LDPlayer9 không tồn tại: $LDPLAYER_PATH"
    exit 1
fi

if [ ! -d "$EMAIL_PATH" ]; then
    echo "Thư mục Emails không tồn tại: $EMAIL_PATH"
    exit 1
fi

# Hàm sao chép phiên bản LDPlayer gốc thành phiên bản mới
copy_ldplayer_instance() {
    local instance_id=$1
    local new_instance="${LDPLAYER_PATH}/leidian${instance_id}"

    echo "Sao chép phiên bản gốc leidian0 thành leidian${instance_id}..."
    cp -r "${LDPLAYER_PATH}/leidian0" "$new_instance"
    if [ $? -eq 0 ]; then
        echo "Đã tạo leidian${instance_id} thành công."
    else
        echo "Lỗi khi sao chép leidian0 thành leidian${instance_id}."
        exit 1
    fi
}

# Hàm chỉnh sửa thông tin thiết bị trong build.prop
modify_build_prop() {
    local instance_id=$1
    local build_prop_path="${LDPLAYER_PATH}/leidian${instance_id}/system.vmdk"

    echo "Chỉnh sửa thông tin thiết bị trong build.prop cho leidian${instance_id}..."
    adb -s "emulator-${instance_id}" shell "mount -o rw,remount /system && echo '
    ro.build.fingerprint=sony/japanmodel/japan:12/SKQ1.210216.001/$(date +%s):user/release-keys
    ro.product.model=Pixel_${instance_id}_$(shuf -i 1000-9999 -n 1)
    ro.product.manufacturer=Google
    ro.product.brand=Google
    ro.build.version.release=12
    ro.product.locale.language=ja
    ro.product.locale.region=JP
    ' >> /system/build.prop"
    echo "Đã chỉnh sửa build.prop cho leidian${instance_id}."
}

# Hàm tạo file system.prop
create_system_prop() {
    local instance_id=$1
    echo "Tạo file system.prop cho leidian${instance_id}..."
    adb -s "emulator-${instance_id}" shell "echo '
    ro.build.fingerprint=sony/japanmodel/japan:12/SKQ1.210216.001/$(date +%s):user/release-keys
    ro.product.model=Pixel_${instance_id}_$(shuf -i 1000-9999 -n 1)
    ro.product.manufacturer=Google
    ro.product.brand=Google
    ro.build.version.release=12
    ro.product.locale.language=ja
    ro.product.locale.region=JP
    ' > /system/system.prop"
    echo "Đã tạo file system.prop cho leidian${instance_id}."
}

# Hàm xóa dấu vết giả lập
remove_emulator_traces() {
    local instance_id=$1
    echo "Xóa dấu vết giả lập trên leidian${instance_id}..."
    adb -s "emulator-${instance_id}" shell "rm -rf /system/lib/libc_malloc_debug_qemu.so"
    adb -s "emulator-${instance_id}" shell "rm -rf /system/lib/libhoudini.so"
    adb -s "emulator-${instance_id}" shell "rm -rf /system/bin/qemu-props"
    echo "Đã xóa dấu vết giả lập trên leidian${instance_id}."
}

# Hàm kiểm tra trạng thái Root
check_root_status() {
    local instance_id=$1
    echo "Kiểm tra trạng thái Root trên leidian${instance_id}..."
    root_status=$(adb -s "emulator-${instance_id}" shell "ls /system/xbin/su" 2>/dev/null)
    if [ -z "$root_status" ]; then
        echo "Root Access: Không tìm thấy SU Binary (Root đã bị ẩn hoặc chưa bật)."
    else
        echo "Root Access: SU Binary tồn tại (Thiết bị đang Root)."
    fi
}

# Hàm tắt Root Access
disable_root_access() {
    local instance_id=$1
    echo "Tắt Root Access cho leidian${instance_id}..."
    adb -s "emulator-${instance_id}" shell "settings put global root_access 0"
    echo "Đã tắt Root Access cho leidian${instance_id}."
}

# Quy trình cho chế độ Run Test (1 LDPlayer)
run_test() {
    local instance_id=1
    copy_ldplayer_instance "$instance_id"
    modify_build_prop "$instance_id"
    create_system_prop "$instance_id"
    remove_emulator_traces "$instance_id"
    check_root_status "$instance_id"
    disable_root_access "$instance_id"
    echo "Quy trình Run Test hoàn tất cho leidian${instance_id}."
}

# Quy trình cho chế độ Run Tool (5 LDPlayer)
run_tool() {
    for i in {1..5}; do
        copy_ldplayer_instance "$i"
        modify_build_prop "$i"
        create_system_prop "$i"
        remove_emulator_traces "$i"
        check_root_status "$i"
        disable_root_access "$i"
        echo "Hoàn tất quy trình cho leidian${i}."
    done
}

# Chọn chế độ thực thi
case $MODE in
    run_test)
        run_test
        ;;
    run_tool)
        run_tool
        ;;
    *)
        echo "Chế độ không hợp lệ! Vui lòng sử dụng run_test hoặc run_tool."
        exit 1
        ;;
esac

echo "Quy trình tự động hóa đã hoàn tất!"