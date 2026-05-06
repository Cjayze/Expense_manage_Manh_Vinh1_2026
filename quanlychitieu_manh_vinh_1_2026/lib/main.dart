import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ExpenseTrackerPage(), debugShowCheckedModeBanner: false));

class ExpenseTrackerPage extends StatelessWidget {
  const ExpenseTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // --- Title & Subtitle ---
            const Text('Quản Lý Chi Tiêu', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: -1)),
            const SizedBox(height: 8),
            const Text('Ghi lại mọi giao dịch, kiểm soát tài chính thông minh', 
              style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 40),


            Center(
              child: Container(
                width: 450,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField('Tên Đăng Nhập', ''),
                    _buildInputField('Mật khẩu', ''),
                    _buildInputField('Xác nhận mật khẩu',''),
                    _buildInputField('Email', '', isLongText: true),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Đăng ký', 
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),

            
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          const Icon(Icons.account_balance_wallet, color: Colors.blueAccent, size: 32),
          const SizedBox(width: 8),
          const Text('SmartWallet', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          const Spacer(),
          _navItem('Báo cáo'), _navItem('Ngân sách'), _navItem('Tiết kiệm'),
          _navItem('Đầu tư'), _navItem('Hướng dẫn'),
          const SizedBox(width: 20),
          TextButton(onPressed: () {}, child: const Text('Đăng nhập', style: TextStyle(color: Colors.black))),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {}, 
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A1A)),
            child: const Text('Đăng ký miễn phí', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildInputField(String label, String placeholder, {bool isLongText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            maxLines: isLongText ? 3 : 1,
            decoration: InputDecoration(
              hintText: placeholder,
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField(
            items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) {},
            decoration: InputDecoration(
              filled: true, fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
            ),
          ),
        ],
      ),
    );
  }

  // --- Footer ---
  Widget _buildFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SmartWallet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              SizedBox(height: 24),
              Row(children: [
                Icon(Icons.facebook, color: Colors.black54), SizedBox(width: 16),
                Icon(Icons.camera_alt, color: Colors.black54), SizedBox(width: 16),
                Icon(Icons.email, color: Colors.black54),
              ]),
            ],
          ),
          const Spacer(),
          _footerColumn('Tính năng', ['Quản lý chi tiêu', 'Thiết lập ngân sách', 'Theo dõi nợ', 'Nhắc nhở hóa đơn']),
          const SizedBox(width: 80),
          _footerColumn('Cộng đồng', ['Blog tài chính', 'Nhóm thảo luận', 'Câu chuyện thành công']),
          const SizedBox(width: 80),
          _footerColumn('Hỗ trợ', ['Trung tâm trợ giúp', 'Liên hệ', 'Điều khoản bảo mật']),
        ],
      ),
    );
  }

  Widget _footerColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 24),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(item, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        )),
      ],
    );
  }
}
