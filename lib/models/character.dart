class Character {
  final String name;
  final int age;
  final String background;
  final List<String> inventory;

  Character({
    required this.name,
    required this.age,
    required this.background,
    this.inventory = const [],
  });

  Character copyWith({
    String? name,
    int? age,
    String? background,
    List<String>? inventory,
  }) {
    return Character(
      name: name ?? this.name,
      age: age ?? this.age,
      background: background ?? this.background,
      inventory: inventory ?? this.inventory,
    );
  }

  void addToInventory(String item) {
    inventory.add(item);
  }

  List<String> getInventory() {
    return List.from(inventory);
  }
}
