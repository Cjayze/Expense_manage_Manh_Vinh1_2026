import '../models/category.dart';

class CategoryManager{
  List<Category> categories = [];
  // Create
  void createCategory(Category category){
    categories.add(category);
  }

  // Read
  List<Category> getAllCategories(){
    return categories;
  }

  // Update
  void updateCategory(int id, {
  String? name,
  String? icon,
  String? type,
}) {
  for (var c in categories) {
    if (c.id == id) {
      c.update(
        name: name,
        icon: icon,
        type: type,
      );
      return;
    }
  }
}

  // Delete
  void deleteCategory(int id){
    categories.removeWhere((category) => category.id == id);
  }
}
