import 'package:json_annotation/json_annotation.dart';

part 'cloud_user.g.dart';



@JsonSerializable()
class CloudUser {
  const CloudUser({required this.id, required this.stage});

  factory CloudUser.fromJson(Map<String, dynamic> json) =>
      _$CloudUserFromJson(json);

  final String id;
  final int stage;
}
