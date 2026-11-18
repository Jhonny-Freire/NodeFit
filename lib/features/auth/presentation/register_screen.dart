import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/credentials.dart';
import '../data/auth_service.dart';
import 'auth_widgets.dart';

/// Tela de cadastro (rota `/cadastro`). Ao criar a conta o usuário já fica
/// logado e o roteador leva para o app.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, this.from});

  final String? from;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authServiceProvider)
          .register(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          );
    } on AuthException catch (e) {
      // Ex.: "Este e-mail já está cadastrado."
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) setState(() => _error = 'Não consegui criar a conta: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Criar conta',
      subtitle: 'A conta fica só neste celular: funciona sem internet.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                maxLength: 80,
                validator: CredentialValidators.name,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                validator: CredentialValidators.email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 16),
              PasswordField(
                controller: _password,
                label: 'Senha (mín. $minPasswordLength caracteres)',
                validator: CredentialValidators.password,
              ),
              const SizedBox(height: 16),
              PasswordField(
                controller: _confirm,
                label: 'Confirmar senha',
                validator: CredentialValidators.confirmPassword(
                  () => _password.text,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: _submit,
              ),
              const SizedBox(height: 24),
              if (_error != null) AuthErrorBanner(_error!),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: Text(_loading ? 'CRIANDO…' : 'CRIAR CONTA'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _loading
              ? null
              : () => context.go(
                  Uri(
                    path: '/login',
                    queryParameters: widget.from == null
                        ? null
                        : {'from': widget.from},
                  ).toString(),
                ),
          child: const Text('Já tenho conta: entrar'),
        ),
      ],
    );
  }
}
