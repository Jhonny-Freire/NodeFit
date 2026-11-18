import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

// Regras puras da conta local: validação dos campos e hash da senha.
// Ficam fora das telas para serem testadas sozinhas (test/domain/).

/// Normaliza o e-mail antes de gravar ou buscar: sem espaços e minúsculo,
/// para "Joao@Email.com " e "joao@email.com" serem a mesma conta.
String normalizeEmail(String email) => email.trim().toLowerCase();

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Tamanho mínimo da senha.
const minPasswordLength = 6;

/// Validadores no formato do `TextFormField.validator`: `null` = válido,
/// texto = mensagem de erro mostrada embaixo do campo.
abstract final class CredentialValidators {
  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Informe seu nome.';
    if (v.length > 80) return 'Use no máximo 80 letras.';
    return null;
  }

  static String? email(String? value) {
    final v = normalizeEmail(value ?? '');
    if (v.isEmpty) return 'Informe o e-mail.';
    if (!_emailPattern.hasMatch(v)) return 'E-mail inválido.';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Informe a senha.';
    if (v.length < minPasswordLength) {
      return 'A senha precisa de pelo menos $minPasswordLength caracteres.';
    }
    return null;
  }

  /// No login só conferimos se veio algo (a regra de tamanho é do cadastro).
  static String? requiredPassword(String? value) =>
      (value ?? '').isEmpty ? 'Informe a senha.' : null;

  static String? Function(String?) confirmPassword(
    String Function() original,
  ) =>
      (value) => value != original() ? 'As senhas não conferem.' : null;
}

/// Hash de senha com PBKDF2-HMAC-SHA256.
///
/// Por que não só `sha256(senha)`: com um sal aleatório por usuário, duas
/// senhas iguais geram hashes diferentes; e as milhares de iterações deixam
/// um ataque de força bruta muito mais lento.
abstract final class PasswordHasher {
  static const iterations = 10000;
  static const _keyLength = 32; // bytes (256 bits)

  /// Sal novo, aleatório e criptograficamente seguro, em Base64.
  static String newSalt() {
    final rnd = Random.secure();
    final bytes = Uint8List.fromList(
      List.generate(16, (_) => rnd.nextInt(256)),
    );
    return base64Encode(bytes);
  }

  /// Hash (Base64) da [password] com o [salt] informado.
  static String hash(String password, String salt) {
    final hmac = Hmac(sha256, utf8.encode(password));
    final saltBytes = base64Decode(salt);
    // PBKDF2 (RFC 8018) com um único bloco: 32 bytes = tamanho do SHA-256.
    var u = hmac.convert([...saltBytes, 0, 0, 0, 1]).bytes;
    final result = Uint8List.fromList(u);
    for (var i = 1; i < iterations; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < _keyLength; j++) {
        result[j] ^= u[j];
      }
    }
    return base64Encode(result);
  }

  /// Confere a senha comparando em tempo constante (não "vaza", pelo tempo
  /// da resposta, quantos caracteres do hash bateram).
  static bool verify(String password, String salt, String expectedHash) {
    final a = utf8.encode(hash(password, salt));
    final b = utf8.encode(expectedHash);
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
