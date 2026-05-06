import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AppHeader extends StatelessWidget{
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          Text(
            'Quản Lý Chi Tiêu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.green,
              fontFamily: "Georgia",
            ),
          ),
          const Spacer(),
          if (MediaQuery.of(context).size.width>500)...[
            const _NavLink('Tổng quan'),
            const _NavLink('Phân loại'),
            const _NavLink('Báo cáo'),
            const _NavLink('Tài khoản'),
          ],
          ElevatedButton.icon(
            onPressed: (){},
            label: const Text('Chi tiêu (3)', style: TextStyle(
              color: Colors.white,
            )),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget{
  final String label;
  const _NavLink(this.label);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        onPressed: (){},
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark, fontSize: 14,
          ),
        ),
      ),
    );
  }
}
