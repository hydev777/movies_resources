import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.id,
    this.name,
    this.nodeId,
  });

  final String? id;
  final String? name;
  final String? nodeId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        nodeId: json["nodeId"],
      );

  @override
  List<Object?> get props => [
        id,
        name,
        nodeId,
      ];
}
