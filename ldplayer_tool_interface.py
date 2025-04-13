import tkinter as tk
from tkinter import messagebox
import subprocess

# Hàm xử lý khi nhấn nút Run Test (1 LDPlayer)
def run_test():
    ldplayer_path = ldplayer_entry.get().strip()
    email_path = email_entry.get().strip()
    
    if not ldplayer_path or not email_path:
        messagebox.showwarning("Cảnh báo", "Vui lòng nhập đầy đủ đường dẫn!")
        return

    try:
        # Gọi script automation_tool.sh với chế độ Run Test (1 LDPlayer)
        result = subprocess.run(
            ["bash", "automation_tool.sh", "run_test", ldplayer_path, email_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        if result.returncode == 0:
            messagebox.showinfo("Thành công", f"Đã thực hiện thành công:\n{result.stdout}")
        else:
            messagebox.showerror("Lỗi", f"Đã xảy ra lỗi:\n{result.stderr}")
    except Exception as e:
        messagebox.showerror("Lỗi", f"Không thể thực hiện script:\n{str(e)}")

# Hàm xử lý khi nhấn nút Run Tool (5 LDPlayer)
def run_tool():
    ldplayer_path = ldplayer_entry.get().strip()
    email_path = email_entry.get().strip()
    
    if not ldplayer_path or not email_path:
        messagebox.showwarning("Cảnh báo", "Vui lòng nhập đầy đủ đường dẫn!")
        return

    try:
        # Gọi script automation_tool.sh với chế độ Run Tool (5 LDPlayer)
        result = subprocess.run(
            ["bash", "automation_tool.sh", "run_tool", ldplayer_path, email_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        if result.returncode == 0:
            messagebox.showinfo("Thành công", f"Đã thực hiện thành công:\n{result.stdout}")
        else:
            messagebox.showerror("Lỗi", f"Đã xảy ra lỗi:\n{result.stderr}")
    except Exception as e:
        messagebox.showerror("Lỗi", f"Không thể thực hiện script:\n{str(e)}")

# Tạo giao diện Tkinter
root = tk.Tk()
root.title("LDPlayer Automation Tool")

# Nhãn và ô nhập liệu cho đường dẫn LDPlayer9
ldplayer_label = tk.Label(root, text="Đường dẫn thư viện LDPlayer9:")
ldplayer_label.pack(pady=5)
ldplayer_entry = tk.Entry(root, width=60)
ldplayer_entry.pack(pady=5)

# Nhãn và ô nhập liệu cho đường dẫn Emails
email_label = tk.Label(root, text="Đường dẫn thư viện Emails:")
email_label.pack(pady=5)
email_entry = tk.Entry(root, width=60)
email_entry.pack(pady=5)

# Nút Run Test
run_test_button = tk.Button(root, text="Run Test (1 LDPlayer)", command=run_test, bg="lightblue")
run_test_button.pack(pady=10)

# Nút Run Tool
run_tool_button = tk.Button(root, text="Run Tool (5 LDPlayer)", command=run_tool, bg="lightgreen")
run_tool_button.pack(pady=10)

# Chạy giao diện
root.mainloop()