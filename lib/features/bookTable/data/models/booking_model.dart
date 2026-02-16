import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    super.id,
    required super.tableId,
    required super.timeSlotId,
    required super.date,
    required super.status,
    required super.partySize,
    required super.customerName,
    required super.customerPhone,
    required super.specialRequests,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json, String id) {
    return BookingModel(
      id: id,
      tableId: json['tableId'] ?? '',
      timeSlotId: json['timeSlotId'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'booked',
      partySize: json['partySize'] ?? 1,
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      specialRequests: json['specialRequests'] ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : (json['createdAt'] != null
                ? DateTime.tryParse(json['createdAt'].toString()) ??
                      DateTime.now()
                : DateTime.now()),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : (json['updatedAt'] != null
                ? DateTime.tryParse(json['updatedAt'].toString()) ??
                      DateTime.now()
                : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tableId': tableId,
      'timeSlotId': timeSlotId,
      'date': date,
      'status': status,
      'partySize': partySize,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'specialRequests': specialRequests,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
