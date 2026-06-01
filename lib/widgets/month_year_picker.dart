import 'package:flutter/material.dart';

class MonthYearPicker extends StatefulWidget {
  final int initialMonth;
  final int initialYear;

  const MonthYearPicker({
    super.key, 
    required this.initialMonth, 
    required this.initialYear,
  });

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    selectedMonth = widget.initialMonth;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () => setState(() => selectedYear--),
                ),
                Text(
                  '$selectedYear',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () => setState(() => selectedYear++),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final monthNumber = index + 1;
                final isSelected = selectedMonth == monthNumber;
                return GestureDetector(
                  onTap: () => setState(() => selectedMonth = monthNumber),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFEB3B) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Thg $monthNumber',
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, {'month': selectedMonth, 'year': selectedYear});
                  },
                  child: const Text('Xác nhận', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}