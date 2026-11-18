// Bi-set / tri-set: exercícios VIZINHOS com o mesmo número de grupo são
// feitos juntos (uma série de cada, em sequência, e só então o descanso).
// O número em si não importa; o que vale é a sequência.

/// Arruma os grupos: cada sequência de vizinhos com o mesmo número vira um
/// grupo (numerado 1, 2, 3... na ordem); grupo de um exercício só deixa de
/// ser grupo (null).
List<int?> normalizeSupersets(List<int?> groups) {
  final result = List<int?>.filled(groups.length, null);
  var next = 1;
  var i = 0;
  while (i < groups.length) {
    final g = groups[i];
    var end = i + 1;
    if (g != null) {
      while (end < groups.length && groups[end] == g) {
        end++;
      }
      if (end - i > 1) {
        for (var k = i; k < end; k++) {
          result[k] = next;
        }
        next++;
      }
    }
    i = end;
  }
  return result;
}

/// Junta o exercício [index] com o seguinte (e com quem já estiver no grupo
/// de cada um). O último da lista não tem com quem juntar.
List<int?> linkWithNext(List<int?> groups, int index) {
  if (index < 0 || index >= groups.length - 1) {
    return normalizeSupersets(groups);
  }
  final g = [...groups];
  // Número novo, que não colide com nenhum existente; os membros saem da
  // lista ORIGINAL (o grupo de cada lado vem inteiro).
  final fresh = g.whereType<int>().fold(0, (a, b) => a > b ? a : b) + 1;
  for (final k in {
    ...supersetMembers(groups, index),
    ...supersetMembers(groups, index + 1),
  }) {
    g[k] = fresh;
  }
  return normalizeSupersets(g);
}

/// Tira o exercício [index] do grupo dele.
List<int?> unlinkAt(List<int?> groups, int index) {
  if (index < 0 || index >= groups.length) return normalizeSupersets(groups);
  final g = [...groups]..[index] = null;
  return normalizeSupersets(g);
}

/// Posição no grupo (1 = primeiro) e tamanho; null fora de grupo.
({int position, int size})? supersetSlot(List<int?> groups, int index) {
  final g = groups[index];
  if (g == null) return null;
  var start = index;
  while (start > 0 && groups[start - 1] == g) {
    start--;
  }
  var end = index;
  while (end < groups.length - 1 && groups[end + 1] == g) {
    end++;
  }
  if (end == start) return null;
  return (position: index - start + 1, size: end - start + 1);
}

/// Índices do grupo de [index] (só ele, se estiver fora de grupo).
List<int> supersetMembers(List<int?> groups, int index) {
  final slot = supersetSlot(groups, index);
  if (slot == null) return [index];
  final start = index - slot.position + 1;
  return [for (var k = 0; k < slot.size; k++) start + k];
}

/// Depois de concluir uma série do membro [current] do grupo: segue para o
/// próximo membro com série pendente, SEM descanso; quando a rodada fecha
/// (volta para o começo do grupo), descansa. [pending] diz, membro a membro,
/// se ainda há série a fazer (já contando a série recém-concluída).
/// Retorna null se o grupo acabou.
({int next, bool rest})? supersetStep(List<bool> pending, int current) {
  for (var k = current + 1; k < pending.length; k++) {
    if (pending[k]) return (next: k, rest: false);
  }
  for (var k = 0; k <= current; k++) {
    if (pending[k]) return (next: k, rest: true);
  }
  return null;
}
