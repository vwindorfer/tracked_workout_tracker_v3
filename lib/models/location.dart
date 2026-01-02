import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 1)
class Location extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  Location({
    required this.id,
    required this.name,
  });

  Location copyWith({
    String? id,
    String? name,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
