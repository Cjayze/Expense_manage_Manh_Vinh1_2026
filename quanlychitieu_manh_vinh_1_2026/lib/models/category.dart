class Category{
  int id;
  String name;
  String icon;
  String type;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  void display(){
    print("ID: $id, Name: $name, Icon: $icon, Type: $type");
  }

  void update({
    String? name,
    String? icon,
    String? type,
  }){
    if(name != null) this.name = name;
    if(icon != null) this.icon = icon;
    if(type != null) this.type = type;
  }
}