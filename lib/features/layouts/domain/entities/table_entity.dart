class TableEntity {
  final String? id;
  final String area;
  final String name;
  final int size;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TableEntity({
    this.id,
    required this.area,
    required this.name,
    required this.size,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
