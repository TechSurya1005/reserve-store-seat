class BookingEntity {
  final String? id;
  final String tableId;
  final String timeSlotId;
  final String date;
  final String status;
  final int partySize;
  final String customerName;
  final String customerPhone;
  final String specialRequests;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingEntity({
    this.id,
    required this.tableId,
    required this.timeSlotId,
    required this.date,
    required this.status,
    required this.partySize,
    required this.customerName,
    required this.customerPhone,
    required this.specialRequests,
    required this.createdAt,
    required this.updatedAt,
  });
}
