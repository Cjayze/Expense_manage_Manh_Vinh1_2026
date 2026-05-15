  import 'Expense.dart'; 

  class ListExpense {
    // Biến chứa danh sách các khoản chi tiêu (Tenclass)
    List<Expense> expenses = [];

    // --- 1. CREATE (Tạo mới bản ghi) ---
    void addExpense(Expense newExp) {
      expenses.add(newExp);
      print("Đã thêm thành công: ${newExp.title}");
    }

    // --- 2. READ (Đọc/Lấy danh sách bản ghi) ---
    void getAllExpenses() {
      if (expenses.isEmpty) {
        print("Danh sách chi tiêu đang trống!");
        return;
      }
      print("--- DANH SÁCH CHI TIÊU HIỆN TẠI ---");
      for (var item in expenses) {
        item.printDetails(); // Gọi hàm in từ file Expense.dart
      }
    }

    // --- 3. EDIT (Sửa bản ghi theo ID cụ thể) ---
    void editExpense(String id, String newTitle, double newAmount) {
      bool found = false;
      for (var item in expenses) {
        if (item.id == id) {
          item.title = newTitle;
          item.amount = newAmount;
          found = true;
          print("Đã cập nhật thông tin cho ID: $id");
          break;
        }
      }
      if (!found) {
        print("Không tìm thấy mã $id để sửa!");
      }
    }

    // --- 4. DELETE (Xóa bản ghi - Bổ sung để hoàn thiện CRUD) ---
    void deleteExpense(String id) {
      int initialLength = expenses.length;
      expenses.removeWhere((item) => item.id == id);
      
      if (expenses.length < initialLength) {
        print("Đã xóa ID: $id thành công.");
      } else {
        print("Xóa thất bại! Không tìm thấy ID: $id");
      }
    }
  }