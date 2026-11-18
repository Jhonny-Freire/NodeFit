import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/domain/enums.dart';

/// Grupo muscular como a academia fala (filtros do seletor de exercício).
class MuscleGroup {
  const MuscleGroup(this.key, this.label, this.muscles);
  final String key;
  final String label;

  /// Chaves de músculo do catálogo que pertencem ao grupo.
  final Set<String> muscles;
}

const muscleGroups = <MuscleGroup>[
  MuscleGroup('chest', 'Peito', {'chest'}),
  MuscleGroup('back', 'Costas', {'lats', 'upperBack', 'lowerBack'}),
  MuscleGroup('shoulders', 'Ombros', {
    'frontDelts',
    'sideDelts',
    'rearDelts',
    'traps',
  }),
  MuscleGroup('biceps', 'Bíceps', {'biceps'}),
  MuscleGroup('triceps', 'Tríceps', {'triceps'}),
  MuscleGroup('legs', 'Pernas', {
    'quads',
    'hamstrings',
    'adductors',
    'abductors',
  }),
  MuscleGroup('glutes', 'Glúteos', {'glutes'}),
  MuscleGroup('calves', 'Panturrilha', {'calves'}),
  MuscleGroup('abs', 'Abdômen', {'abs', 'obliques'}),
  MuscleGroup('forearms', 'Antebraço', {'forearms'}),
  MuscleGroup('cardio', 'Cardio', {'cardio'}),
];

List<String> _keys(String csv) => [
  for (final k in csv.split(','))
    if (k.trim().isNotEmpty) k.trim(),
];

/// Grupo principal do exercício (pelo primeiro músculo primário).
MuscleGroup? groupOf(Exercise e) {
  for (final key in _keys(e.primaryMuscles)) {
    for (final g in muscleGroups) {
      if (g.muscles.contains(key)) return g;
    }
  }
  return null;
}

/// O exercício trabalha o grupo como músculo primário?
bool belongsTo(Exercise e, MuscleGroup g) =>
    _keys(e.primaryMuscles).any(g.muscles.contains);

IconData equipmentIcon(EquipmentType t) => switch (t) {
  EquipmentType.barbell ||
  EquipmentType.dumbbell ||
  EquipmentType.kettlebell => Icons.fitness_center,
  EquipmentType.machine ||
  EquipmentType.plateLoaded ||
  EquipmentType.smith => Icons.precision_manufacturing_outlined,
  EquipmentType.cable => Icons.cable,
  EquipmentType.bodyweight => Icons.accessibility_new,
  EquipmentType.band => Icons.linear_scale,
  EquipmentType.other => Icons.more_horiz,
};

/// "hoje", "ontem", "há 3 dias", "há 2 semanas".
String relativeDay(DateTime instant) {
  final now = DateTime.now();
  final a = DateTime(now.year, now.month, now.day);
  final l = instant.toLocal();
  final days = a.difference(DateTime(l.year, l.month, l.day)).inDays;
  if (days <= 0) return 'hoje';
  if (days == 1) return 'ontem';
  if (days < 14) return 'há $days dias';
  if (days < 60) return 'há ${days ~/ 7} semanas';
  return 'há ${days ~/ 30} meses';
}
