import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Banco SQLite de um arquivo (Android/desktop).
QueryExecutor probeExecutor(File file) => NativeDatabase(file);
