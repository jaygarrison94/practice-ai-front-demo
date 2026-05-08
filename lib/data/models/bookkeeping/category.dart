import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final int type;
  final String? color;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    this.color,
  });

  bool get isIncome => type == 2;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as int,
      color: json['color'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, type, color];
}
