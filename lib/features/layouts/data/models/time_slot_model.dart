import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/time_slot_entity.dart';

class TimeSlotModel extends TimeSlotEntity {
  TimeSlotModel({
    super.id,
    required super.slotName,
    required super.active,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json, String id) {
    return TimeSlotModel(
      id: id,
      slotName: json['slotName'] ?? '',
      active: json['active'] ?? true,
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
      'slotName': slotName,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
