import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/domain/credentials.dart';

void main() {
  group('validação dos campos', () {
    test('nome obrigatório', () {
      expect(CredentialValidators.name('  '), 'Informe seu nome.');
      expect(CredentialValidators.name('João'), isNull);
    });

    test('e-mail vazio ou fora do formato', () {
      expect(CredentialValidators.email(''), 'Informe o e-mail.');
      expect(CredentialValidators.email('joao'), 'E-mail inválido.');
      expect(CredentialValidators.email('joao@email'), 'E-mail inválido.');
      expect(CredentialValidators.email(' Joao@Email.com '), isNull);
    });

    test('senha com tamanho mínimo e confirmação', () {
      expect(CredentialValidators.password(''), 'Informe a senha.');
      expect(CredentialValidators.password('12345'), contains('pelo menos 6'));
      expect(CredentialValidators.password('123456'), isNull);
      final confirm = CredentialValidators.confirmPassword(() => 'abc123');
      expect(confirm('abc12'), 'As senhas não conferem.');
      expect(confirm('abc123'), isNull);
    });

    test('e-mail normalizado', () {
      expect(normalizeEmail('  Joao@Email.COM '), 'joao@email.com');
    });
  });

  group('hash da senha', () {
    test('mesma senha + mesmo sal = mesmo hash; confere só a senha certa', () {
      final salt = PasswordHasher.newSalt();
      final hash = PasswordHasher.hash('senha123', salt);
      expect(PasswordHasher.hash('senha123', salt), hash);
      expect(hash, isNot(contains('senha123')));
      expect(PasswordHasher.verify('senha123', salt, hash), isTrue);
      expect(PasswordHasher.verify('senha124', salt, hash), isFalse);
    });

    test('sal diferente gera hash diferente para a mesma senha', () {
      final a = PasswordHasher.hash('senha123', PasswordHasher.newSalt());
      final b = PasswordHasher.hash('senha123', PasswordHasher.newSalt());
      expect(a, isNot(b));
    });
  });
}
