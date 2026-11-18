// Abre um arquivo .sqlite avulso (o banco de dentro do backup) para conferir
// antes de restaurar. Só existe no app nativo: na web não há `dart:ffi`, então
// o import condicional troca pela versão que avisa que não é suportado.
export 'probe_executor_stub.dart'
    if (dart.library.ffi) 'probe_executor_native.dart';
