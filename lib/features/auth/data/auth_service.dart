import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/domain/credentials.dart';
import '../../../core/prefs/prefs_repository.dart';

part 'auth_service.g.dart';

/// Erro de autenticação com mensagem pronta para mostrar na tela.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Autenticação local: as contas ficam na tabela `users` do próprio banco
/// SQLite (Drift) e a sessão é o id do usuário logado em `app_prefs`.
///
/// Nada sai do celular: não há servidor, por isso o login funciona offline.
class AuthService {
  AuthService(this._db) : _prefs = PrefsRepository(_db);

  final AppDatabase _db;
  final PrefsRepository _prefs;

  /// Cria a conta e já deixa o usuário logado.
  ///
  /// Lança [AuthException] se o e-mail já estiver cadastrado ou algum campo
  /// for inválido (as telas validam antes, aqui é a segunda barreira).
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final error =
        CredentialValidators.name(name) ??
        CredentialValidators.email(email) ??
        CredentialValidators.password(password);
    if (error != null) throw AuthException(error);

    final normalized = normalizeEmail(email);
    if (await _findByEmail(normalized) != null) {
      throw const AuthException('Este e-mail já está cadastrado.');
    }

    final salt = PasswordHasher.newSalt();
    final AppUser user;
    try {
      user = await _db
          .into(_db.users)
          .insertReturning(
            UsersCompanion.insert(
              name: name.trim(),
              email: normalized,
              passwordHash: PasswordHasher.hash(password, salt),
              passwordSalt: salt,
            ),
          );
    } on Exception {
      // Corrida rara: outro cadastro com o mesmo e-mail entre a busca e o
      // insert. A coluna é UNIQUE, então o banco recusa a linha.
      if (await _findByEmail(normalized) != null) {
        throw const AuthException('Este e-mail já está cadastrado.');
      }
      rethrow;
    }
    await _startSession(user);
    return user;
  }

  /// Entra com e-mail e senha.
  ///
  /// E-mail inexistente e senha errada dão a MESMA mensagem, para não
  /// revelar quais e-mails têm conta.
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw const AuthException('Preencha e-mail e senha.');
    }
    final user = await _findByEmail(normalizeEmail(email));
    if (user == null ||
        !PasswordHasher.verify(
          password,
          user.passwordSalt,
          user.passwordHash,
        )) {
      throw const AuthException('E-mail ou senha incorretos.');
    }
    await _startSession(user);
    return user;
  }

  /// Sai da conta. Os treinos continuam no banco; só a sessão é apagada.
  Future<void> logout() => _prefs.set(PrefKeys.sessionUserId, null);

  /// Usuário logado agora (`null` = ninguém). Atualiza sozinho quando a
  /// sessão muda (login/logout) ou o banco é trocado (restaurar backup).
  Stream<AppUser?> watchCurrentUser() {
    final query = _db.select(_db.appPrefs).join([
      innerJoin(_db.users, _db.users.id.equalsExp(_db.appPrefs.value)),
    ])..where(_db.appPrefs.key.equals(PrefKeys.sessionUserId));
    return query.watchSingleOrNull().map((row) => row?.readTable(_db.users));
  }

  Future<AppUser?> _findByEmail(String normalizedEmail) => (_db.select(
    _db.users,
  )..where((u) => u.email.equals(normalizedEmail))).getSingleOrNull();

  Future<void> _startSession(AppUser user) =>
      _prefs.set(PrefKeys.sessionUserId, user.id);
}

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) => AuthService(ref.watch(appDatabaseProvider));

/// Quem está logado. O roteador observa este provider para proteger as telas.
@Riverpod(keepAlive: true)
Stream<AppUser?> currentUser(Ref ref) =>
    ref.watch(authServiceProvider).watchCurrentUser();
