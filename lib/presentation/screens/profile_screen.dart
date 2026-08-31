import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/network/network_exception.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

/// Third API screen: requests the latest details for the selected user.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});
  final User user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetails());
  }

  Future<void> _loadDetails() async {
    try {
      final user = await context.read<UserRepository>().getUser(widget.user.id);
      if (mounted) setState(() => _user = user);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Impossible de charger le profil.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _user ?? widget.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil utilisateur')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircleAvatar(radius: 48, backgroundImage: user.image.isEmpty ? null : NetworkImage(user.image)),
                  const SizedBox(height: 16),
                  Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(user.email),
                  const SizedBox(height: 4),
                  Text(user.phone),
                ]))),
    );
  }
}
