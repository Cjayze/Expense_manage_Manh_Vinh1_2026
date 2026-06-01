import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isAnalysisTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Báo cáo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF1E1E1E),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isAnalysisTab = true),
                      child: _buildSubTab("Phân tích", isAnalysisTab),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isAnalysisTab = false),
                      child: _buildSubTab("Tài khoản", !isAnalysisTab),
                    ),
                  ),
                ],
              ),
            ),
            isAnalysisTab ? _buildAnalysisContent() : _buildAccountContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey[855],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAnalysisContent() {
    return Column(
      children: [
        _buildCardWrapper(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Thống kê hàng tháng', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text('Thg 5', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                  _buildMiniData("Chi tiêu", "0"),
                  _buildMiniData("Thu nhập", "0"),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountContent() {
    return Column(
      children: [
        _buildCardWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tài sản ròng', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 4),
              const Text('0 đ', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Tài sản: 0', style: TextStyle(color: Colors.green)),
                  Text('Nợ phải trả: 0', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]),
                  onPressed: () => _showAddAccountSheet(context),
                  child: const Text('Thêm tài khoản', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]),
                  onPressed: () {},
                  child: const Text('Quản lý tài khoản', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _showAddAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tên tài khoản', style: TextStyle(color: Colors.grey)),
              const TextField(style: TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              const Text('Số tiền', style: TextStyle(color: Colors.grey)),
              const TextField(keyboardType: TextInputType.number, style: TextStyle(color: Colors.white)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Lưu', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }

  Widget _buildMiniData(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 15)),
      ],
    );
  }
}