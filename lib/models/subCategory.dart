// ignore_for_file: file_names

class SubCategory {
  final String id;
  final String name; 

  SubCategory({
    required this.id,
    required this.name,
  });

  // Factory method to create a SubCategory from a Map
  factory SubCategory.fromMap(Map<String, dynamic> data) {
    return SubCategory(
      id: data['id'],
      name: data['name'],
    );
  }
}
