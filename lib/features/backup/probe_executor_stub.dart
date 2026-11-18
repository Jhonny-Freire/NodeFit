import 'dart:io';

import 'package:drift/drift.dart';

/// Na web não dá para abrir um arquivo SQLite avulso.
QueryExecutor probeExecutor(File file) =>
    throw UnsupportedError('Restaurar backup só funciona no app Android.');
