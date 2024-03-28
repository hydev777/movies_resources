import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
      );

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
