import '../models/base_entity.dart';

class GenericCrud<T extends BaseEntity> {
  final List<T> _items = [];

  void create(T item) {
    _items.add(item);
  }

  List<T> getAll() {
    return List.unmodifiable(_items);
  }

  T? getById(int id) {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  bool update(T item) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == item.id) {
        _items[i] = item;
        return true;
      }
    }
    return false;
  }

  bool delete(int id) {
    final before = _items.length;
    _items.removeWhere((item) => item.id == id);
    return _items.length != before;
  }
}
