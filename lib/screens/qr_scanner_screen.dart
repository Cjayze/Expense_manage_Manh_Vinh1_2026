import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../models/categories.dart';
import '../services/database_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  bool _isProcessing = false;
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );

    // Animation cho đường quét scan line
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Phân tích chuỗi QR thành dữ liệu hóa đơn
  Map<String, dynamic>? _parseRawQRCode(String rawValue) {
    // 1. Thử JSON (cho các ứng dụng tùy chỉnh / giả lập)
    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is Map<String, dynamic> && decoded.containsKey('amount')) {
        return decoded;
      }
    } catch (_) {
      // Không phải JSON, tiếp tục xử lý
    }

    // 2. Thử phân tích chuỗi hóa đơn điện tử Tổng cục Thuế (phân cách bằng dấu |)
    // VD: 1|0108365287|1|1C23TTA|0000123|2023-11-20|450000|45000|...
    if (rawValue.contains('|')) {
      final parts = rawValue.split('|');
      double? totalAmount;
      String note = 'Hóa đơn điện tử';
      
      // Tìm số lớn nhất làm tổng tiền (loại trừ các chuỗi quá dài như MST)
      List<double> numbers = [];
      for (var p in parts) {
        if (RegExp(r'^\d+(\.\d+)?$').hasMatch(p.trim())) {
           if (p.trim().length < 12) { 
             numbers.add(double.parse(p.trim()));
           }
        }
      }
      if (numbers.isNotEmpty) {
        totalAmount = numbers.reduce((a, b) => a > b ? a : b);
      }

      // Có thể trích xuất MST hoặc Số HĐ từ parts nếu cần
      if (parts.length > 4) {
        note = 'Hóa đơn Thuế (Mã: ${parts[4]})';
      }

      if (totalAmount != null && totalAmount > 0) {
        return {
          "type": "Chi tiêu",
          "categoryName": "Hóa đơn",
          "amount": totalAmount,
          "note": note,
          "items": []
        };
      }
    }

    // 3. Thử phân tích VietQR hoặc URL tra cứu hóa đơn
    if (rawValue.startsWith('http')) {
       final uri = Uri.tryParse(rawValue);
       if (uri != null && uri.queryParameters.isNotEmpty) {
         final amountStr = uri.queryParameters['amount'] ?? uri.queryParameters['tg'] ?? uri.queryParameters['total'];
         if (amountStr != null) {
            final amount = double.tryParse(amountStr);
            if (amount != null) {
               return {
                  "type": "Chi tiêu",
                  "categoryName": "Hóa đơn",
                  "amount": amount,
                  "note": "Tra cứu HĐ: ${uri.host}",
                  "items": []
               };
            }
         }
       }
    }

    return null;
  }

  void _processQRCode(String rawValue) {
    if (_isProcessing) return;

    final invoiceData = _parseRawQRCode(rawValue);
    
    if (invoiceData != null) {
      setState(() {
        _isProcessing = true;
      });
      _showInvoiceDetails(invoiceData);
    } else {
      // Nếu không parse được, hiển thị thông báo lỗi
      _showErrorSnackBar("Không nhận diện được số tiền từ mã QR này.");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Hiển thị BottomSheet hóa đơn chi tiết
  void _showInvoiceDetails(Map<String, dynamic> invoiceData) {
    final storeName = invoiceData['note'] ?? 'Hóa đơn chưa rõ nguồn';
    final double totalAmount = (invoiceData['amount'] as num).toDouble();
    final items = (invoiceData['items'] as List? ?? []).map((e) => Map<String, dynamic>.from(e)).toList();
    
    // Tìm category phù hợp hoặc mặc định
    String selectedCategory = invoiceData['categoryName'] ?? 'Đồ ăn';
    CategoryItem initialCategory = expenseCategories.firstWhere(
      (cat) => cat.name.toLowerCase() == selectedCategory.toLowerCase(),
      orElse: () => expenseCategories.firstWhere((cat) => cat.name == 'Đồ ăn'),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        CategoryItem activeCategory = initialCategory;
        final formatter = NumberFormat('#,###', 'vi_VN');
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E222B) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.receipt, color: Colors.amber, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Chi tiết hóa đơn quét được",
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                storeName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Thân hóa đơn (Receipt Style)
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF13161C) : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.grey.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Danh sách món lẻ
                          if (items.isNotEmpty) ...[
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              separatorBuilder: (context, index) => Divider(
                                color: isDark ? Colors.grey.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
                              ),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final name = item['name'] ?? '';
                                final double price = (item['price'] as num).toDouble();
                                final int qty = item['qty'] ?? 1;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${formatter.format(price)} đ x $qty",
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${formatter.format(price * qty)} đ",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Dashed line divider using a Row of dash containers
                            Row(
                              children: List.generate(
                                30,
                                (index) => Expanded(
                                  child: Container(
                                    color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade400,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Tổng tiền
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Tổng thanh toán",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${formatter.format(totalAmount)} đ",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Chọn danh mục
                    const Text(
                      "Phân loại chi tiêu",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF13161C) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CategoryItem>(
                          isExpanded: true,
                          value: activeCategory,
                          dropdownColor: isDark ? const Color(0xFF1E222B) : Colors.white,
                          items: expenseCategories.map((CategoryItem cat) {
                            return DropdownMenuItem<CategoryItem>(
                              value: cat,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: cat.color.withValues(alpha: 0.2),
                                    child: Icon(cat.icon, size: 16, color: cat.color),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(cat.name),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (CategoryItem? newValue) {
                            if (newValue != null) {
                              setSheetState(() {
                                activeCategory = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text("Hủy"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // Định dạng hóa đơn chi tiết vào phần ghi chú
                              final sb = StringBuffer(storeName);
                              if (items.isNotEmpty) {
                                sb.write("\n------------------------");
                                for (var item in items) {
                                  sb.write("\n- ${item['name']} x${item['qty']}: ${formatter.format(item['price'])}đ");
                                }
                              }

                              final tx = TransactionModel(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                type: "Chi tiêu",
                                categoryName: activeCategory.name,
                                categoryIconCode: activeCategory.icon.codePoint,
                                categoryColorValue: activeCategory.color.toARGB32(),
                                amount: totalAmount,
                                note: sb.toString(),
                                dateTime: DateTime.now(),
                              );

                              // Lưu vào DB
                              await DatabaseService.addTransaction(tx);

                              if (context.mounted) {
                                Navigator.pop(context); // Đóng BottomSheet
                                Navigator.pop(context); // Quay về HomeScreen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Đã lưu giao dịch từ quét QR thành công!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Lưu giao dịch",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        _isProcessing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Quét QR Hóa đơn",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _scannerController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => _scannerController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _scannerController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front, color: Colors.white);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear, color: Colors.white);
                }
              },
            ),
            onPressed: () => _scannerController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Máy quét Camera thật
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // 2. Lớp phủ đen và vùng quét định vị (Scan Window Frame Overlay)
          _buildScannerOverlay(context),

        ],
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.7;

    return Stack(
      children: [
        // 4 phần che mờ xung quanh vùng quét
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.65),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: scanAreaSize,
                  height: scanAreaSize,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Khung viền vùng quét
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: scanAreaSize,
            height: scanAreaSize,
            child: Stack(
              children: [
                _buildCorner(0, 0),
                _buildCorner(0, 1),
                _buildCorner(1, 0),
                _buildCorner(1, 1),

                // Đường laser chạy lên xuống
                AnimatedBuilder(
                  animation: _scanLineAnimation,
                  builder: (context, child) {
                    final position = _scanLineAnimation.value * scanAreaSize;
                    return Positioned(
                      top: position,
                      left: 10,
                      right: 10,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withValues(alpha: 0.7),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Hướng dẫn
        Positioned(
          top: size.height * 0.18,
          left: 0,
          right: 0,
          child: const Center(
            child: Text(
              "Đặt mã QR của hóa đơn vào khung quét",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(double top, double left) {
    return Positioned(
      top: top == 0 ? 0 : null,
      bottom: top == 1 ? 0 : null,
      left: left == 0 ? 0 : null,
      right: left == 1 ? 0 : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: top == 0 ? const BorderSide(color: Colors.amber, width: 4) : BorderSide.none,
            bottom: top == 1 ? const BorderSide(color: Colors.amber, width: 4) : BorderSide.none,
            left: left == 0 ? const BorderSide(color: Colors.amber, width: 4) : BorderSide.none,
            right: left == 1 ? const BorderSide(color: Colors.amber, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null) {
        _processQRCode(rawValue);
        break;
      }
    }
  }
}
