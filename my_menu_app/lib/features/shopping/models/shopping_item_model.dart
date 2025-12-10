class ShoppingItem {
  final String id;
  final String userId;
  final String name;
  final bool isChecked;

  ShoppingItem({
    required this.id,
    required this.userId,
    required this.name,
    this.isChecked = false,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      isChecked: json['is_checked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'name': name, 'is_checked': isChecked};
  }

  ShoppingItem copyWith({
    String? id,
    String? userId,
    String? name,
    bool? isChecked,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
