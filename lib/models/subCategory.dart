class SubCategory {
  final String id; // Unique identifier for the subcategory
  final String name; // Name of the subcategory

  SubCategory({
    required this.id,
    required this.name,
  });

  factory SubCategory.fromMap(Map<String, dynamic> data) {
    return SubCategory(
      id: data['id'],
      name: data['name'],
    );
  }
}
