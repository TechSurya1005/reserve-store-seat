class TimeSlotEntity {
  final String? id;
  final String slotName;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimeSlotEntity({
    this.id,
    required this.slotName,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
}
