import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/users_controller.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  @override void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) context.read<UsersController>().load(); }); }
  @override Widget build(BuildContext context) {
    final state = context.watch<UsersController>();
    return Scaffold(appBar: AppBar(title: const Text('Utilisateurs'), actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () async { final auth = context.read<AuthController>(); final navigator = Navigator.of(context); await auth.logout(); if (!mounted) return; navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthScreen()), (_) => false); })]), body: Column(children: [
      if (state.offline) const MaterialBanner(content: Text('Mode hors-ligne : données affichées depuis le cache.'), actions: []),
      Expanded(child: state.loading && state.users.isEmpty ? const Center(child: CircularProgressIndicator()) : state.error != null ? Center(child: Text(state.error!)) : RefreshIndicator(onRefresh: state.load, child: ListView.builder(physics: const AlwaysScrollableScrollPhysics(), itemCount: state.users.length, itemBuilder: (_, i) { final user = state.users[i]; return ListTile(leading: CircleAvatar(backgroundImage: user.image.isEmpty ? null : NetworkImage(user.image), child: user.image.isEmpty ? Text(user.firstName.substring(0, 1)) : null), title: Text(user.fullName), subtitle: Text(user.email), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: user)))); })))
    ]));
  }
}
