import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/table_entity.dart';

class TableModel extends TableEntity {
  TableModel({
    super.id,
    required super.area,
    required super.name,
    required super.size,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TableModel.fromJson(Map<String, dynamic> json, String id) {
    return TableModel(
      id: id,
      area: json['area'] ?? '',
      name: json['name'] ?? '',
      size: json['size'] is int
          ? json['size']
          : int.tryParse(json['size']?.toString() ?? '0') ?? 0,
      isActive: json['isActive'] ?? true,
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
      'area': area,
      'name': name,
      'size': size,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
