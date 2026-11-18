import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/ids.dart';

/// Fotos de progresso na pasta privada do app (`photos/body/`): fora da
/// Galeria, dentro do backup ZIP. O banco guarda o caminho RELATIVO.
abstract final class PhotoStore {
  static const _folder = 'photos/body';

  static Future<Directory> _root() => getApplicationSupportDirectory();

  /// Copia a foto tirada para a pasta privada e devolve o caminho relativo.
  static Future<String> keep(String sourcePath) async {
    final root = await _root();
    final dir = Directory(p.join(root.path, _folder));
    await dir.create(recursive: true);
    final rel = '$_folder/${newId()}.jpg';
    await File(sourcePath).copy(p.join(root.path, rel));
    // O arquivo temporário da câmera não precisa ficar.
    try {
      await File(sourcePath).delete();
    } on FileSystemException {
      // Se não der para apagar, o sistema limpa o cache depois.
    }
    return rel;
  }

  static Future<File> resolve(String relativePath) async =>
      File(p.join((await _root()).path, relativePath));

  static Future<void> delete(Iterable<String> relativePaths) async {
    for (final rel in relativePaths) {
      final f = await resolve(rel);
      if (f.existsSync()) await f.delete();
    }
  }
}
