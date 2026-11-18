/// Nomes em PT-BR das chaves de músculo usadas no catálogo.
const muscleLabels = <String, String>{
  'chest': 'Peitoral',
  'lats': 'Dorsais',
  'upperBack': 'Costas (meio)',
  'traps': 'Trapézio',
  'lowerBack': 'Lombar',
  'frontDelts': 'Deltoide anterior',
  'sideDelts': 'Deltoide lateral',
  'rearDelts': 'Deltoide posterior',
  'biceps': 'Bíceps',
  'triceps': 'Tríceps',
  'forearms': 'Antebraço',
  'abs': 'Abdômen',
  'obliques': 'Oblíquos',
  'glutes': 'Glúteos',
  'quads': 'Quadríceps',
  'hamstrings': 'Posteriores',
  'adductors': 'Adutores',
  'abductors': 'Abdutores',
  'calves': 'Panturrilha',
  'cardio': 'Cardio',
};

/// "chest,triceps" → ["Peitoral", "Tríceps"].
List<String> muscleNames(String csv) => [
  for (final key in csv.split(','))
    if (key.trim().isNotEmpty) muscleLabels[key.trim()] ?? key.trim(),
];
