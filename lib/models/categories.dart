import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.name, 
    required this.icon, 
    required this.color,
  });
}

const List<CategoryItem> expenseCategories = [
  CategoryItem(name: "Mua sắm", icon: Icons.shopping_cart_outlined, color: Colors.amber),
  CategoryItem(name: "Đồ ăn", icon: Icons.restaurant_outlined, color: Colors.tealAccent),
  CategoryItem(name: "Điện thoại", icon: Icons.phone_android_outlined, color: Colors.blueAccent),
  CategoryItem(name: "Giải trí", icon: Icons.sports_esports_outlined, color: Colors.purpleAccent),
  CategoryItem(name: "Giáo dục", icon: Icons.school_outlined, color: Colors.orangeAccent),
  CategoryItem(name: "Sắc đẹp", icon: Icons.content_cut_outlined, color: Colors.pinkAccent),
  CategoryItem(name: "Thể thao", icon: Icons.fitness_center_outlined, color: Colors.greenAccent),
  CategoryItem(name: "Xã hội", icon: Icons.people_outline, color: Colors.indigoAccent),
  CategoryItem(name: "Đi lại", icon: Icons.directions_bus_outlined, color: Colors.redAccent),
  CategoryItem(name: "Quần áo", icon: Icons.checkroom_outlined, color: Colors.cyan),
  CategoryItem(name: "Ô tô", icon: Icons.directions_car_filled_outlined, color: Colors.blue),
  CategoryItem(name: "Rượu", icon: Icons.local_bar_outlined, color: Colors.brown),
];

const List<CategoryItem> incomeCategories = [
  CategoryItem(name: "Lương", icon: Icons.monetization_on_outlined, color: Colors.green),
  CategoryItem(name: "Khoản đầu tư", icon: Icons.trending_up_outlined, color: Colors.teal),
  CategoryItem(name: "Làm thêm", icon: Icons.storefront_outlined, color: Colors.orange),
  CategoryItem(name: "Tiền thưởng", icon: Icons.emoji_events_outlined, color: Colors.amber),
];