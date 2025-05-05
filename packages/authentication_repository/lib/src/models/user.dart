import 'package:equatable/equatable.dart';



/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({required this.id, this.mobile, this.stage, this.idToken});

  /// The current user's email address.
  final String? mobile;

  /// The current user's id.
  final String id;

  /// The current user's stage.
  final String? stage;

  final Future<String?>? idToken;
  




  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [mobile, id, stage];
}
