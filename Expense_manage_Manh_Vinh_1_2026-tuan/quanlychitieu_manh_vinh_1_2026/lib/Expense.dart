class Expense {
  // --- CÁC BIẾN (THUỘC TÍNH) CẦN CÓ ---
  String id;      // Mã định danh duy nhất cho mỗi khoản chi (để sửa/xóa)
  String title;   // Tên hoặc nội dung chi tiêu (ví dụ: "Ăn sáng", "Đổ xăng")
  double amount;  // Số tiền chi ra (kiểu số thực để tính toán)
  DateTime date;  // Ngày giờ thực hiện chi tiêu

  // Constructor: Hàm khởi tạo để tạo ra một đối tượng Expense mới
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  // --- CÁC PHƯƠNG THỨC (HÀNH ĐỘNG) CỦA ĐỐI TƯỢNG ---
  
  // Phương thức hiển thị nhanh thông tin dưới dạng chữ
  void printDetails() {
    print("Mã: $id | Nội dung: $title | Số tiền: $amount | Ngày: ${date.day}/${date.month}");
  }

  // Phương thức kiểm tra xem khoản chi này có phải là khoản chi lớn không (Ví dụ > 500k)
  bool isExpensive() {
    return amount > 500000;
  }
}