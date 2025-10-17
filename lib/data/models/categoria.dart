class Categoria {
  final int categoryId;
  final String categoryName;
  final String categoryState;

  Categoria({
    required this.categoryId,
    required this.categoryName,
    required this.categoryState,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      categoryState: json['category_state'] ?? 'Inactiva',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'category_state': categoryState,
    };
  }
}

List<Categoria> categoriasFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => Categoria.fromJson(json)).toList();
}