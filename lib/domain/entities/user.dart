class User {
  const User({required this.id, required this.firstName, required this.lastName, required this.email, required this.image, this.phone = ''});
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String phone;
  String get fullName => '$firstName $lastName';
}
