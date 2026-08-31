import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController(text: 'emilys');
  final _password = TextEditingController(text: 'emilyspass');
  bool _register = false;

  @override
  void dispose() { _username.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final controller = context.read<AuthController>();
    final success = _register
        ? await controller.register(_username.text, '${_username.text}@example.com', _password.text)
        : await controller.login(_username.text, _password.text);
    if (!mounted || !success) return;
    if (_register) {
      setState(() => _register = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compte créé (simulation API). Connectez-vous maintenant.')));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthController>();
    return Scaffold(body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: Form(key: _form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(_register ? 'Créer un compte' : 'Connexion', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 24),
      TextFormField(controller: _username, decoration: InputDecoration(labelText: _register ? 'Prénom' : 'Identifiant'), validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null),
      const SizedBox(height: 12),
      TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe'), validator: (v) => v == null || v.length < 4 ? '4 caractères minimum' : null),
      if (state.error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(state.error!, style: const TextStyle(color: Colors.red))),
      const SizedBox(height: 20),
      FilledButton(onPressed: state.loading ? null : _submit, child: Text(state.loading ? 'Chargement…' : _register ? 'Créer le compte' : 'Se connecter')),
      TextButton(onPressed: state.loading ? null : () => setState(() => _register = !_register), child: Text(_register ? 'J’ai déjà un compte' : 'Créer un compte')),
    ]))))));
  }
}
