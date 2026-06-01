// Một abstract class để đảm bảo mọi đối tượng đều phải có thuộc tính 'id'
abstract class Identifiable {
  String get id;
}

// Class Generic CRUD tổng quát
class GenericCRUD<T extends Identifiable> {
  final List<T> _items = [];

  // Create
  void create(T item) {
    _items.add(item);
  }

  // Read All
  List<T> getAll() {
    return List.unmodifiable(_items);
  }

  // Read Single
  T? getById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  // Update
  void update(String id, T newItem) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = newItem;
    }
  }

  // Delete
  void delete(String id) {
    _items.removeWhere((item) => item.id == id);
  }
}