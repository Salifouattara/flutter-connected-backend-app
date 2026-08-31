import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});
  final User user;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profil')), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [CircleAvatar(radius: 48, backgroundImage: user.image.isEmpty ? null : NetworkImage(user.image)), const SizedBox(height: 16), Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 8), Text(user.email), const SizedBox(height: 4), Text(user.phone)]))));
}
