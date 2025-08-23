class Category {
  final String name;
  final String displayName;

  Category({
    required this.name,
    required this.displayName,
  });

  factory Category.fromString(String categoryName) {
    return Category(
      name: categoryName,
      displayName: _formatCategoryName(categoryName),
    );
  }

  static String _formatCategoryName(String category) {
    return category
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}