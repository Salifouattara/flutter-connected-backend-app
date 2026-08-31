import '../../domain/entities/user.dart';
class UserModel extends User {
  const UserModel({required super.id, required super.firstName, required super.lastName, required super.email, required super.image, super.phone});
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int, firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '', email: json['email'] as String? ?? '',
    image: json['image'] as String? ?? '', phone: json['phone'] as String? ?? '',
  );
  Map<String, dynamic> toJson() => {'id': id, 'firstName': firstName, 'lastName': lastName, 'email': email, 'image': image, 'phone': phone};
}
