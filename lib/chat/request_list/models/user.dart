class User {
  final String id;
  final String name;
  final String? profileImage;
  
  User({
    required this.id,
    required this.name,
    this.profileImage,
  });
}
