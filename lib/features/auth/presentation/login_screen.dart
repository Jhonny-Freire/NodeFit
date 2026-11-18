import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/credentials.dart';
import '../data/auth_service.dart';
import 'auth_widgets.dart';

/// Tela de login (rota `/login`).
///
/// Não navega sozinha depois de entrar: o roteador percebe a sessão nova
/// (`currentUserProvider`) e redireciona para o app — ou para a tela que o
/// usuário tentou abrir antes ([from]).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.from});

  /// Caminho que o usuário tentou abrir sem estar logado.
  final String? from;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 1ª barreira: validação dos campos (vazio, formato do e-mail).
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // 2ª barreira: o serviço confere e-mail e senha no banco.
      await ref
          .read(authServiceProvider)
          .login(email: _email.text, password: _password.text);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) setState(() => _error = 'Não consegui entrar: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Entrar no NodeFit',
      subtitle: 'Seu caderno digital de treino.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                label: 'Senha',
                validator: CredentialValidators.requiredPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: _submit,
              ),
              const SizedBox(height: 24),
              if (_error != null) AuthErrorBanner(_error!),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: Text(_loading ? 'ENTRANDO…' : 'ENTRAR'),
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
                    path: '/cadastro',
                    queryParameters: widget.from == null
                        ? null
                        : {'from': widget.from},
                  ).toString(),
                ),
          child: const Text('Não tem conta? Criar conta'),
        ),
      ],
    );
  }
}
