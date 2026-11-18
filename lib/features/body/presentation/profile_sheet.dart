import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/body.dart';
import '../../../core/domain/load.dart';
import '../../../core/widgets/common.dart';
import '../data/body_repository.dart';

/// Sexo, altura e ano de nascimento (para IMC e % de gordura).
Future<void> showProfileSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _ProfileSheet(),
    );

class _ProfileSheet extends ConsumerStatefulWidget {
  const _ProfileSheet();

  @override
  ConsumerState<_ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends ConsumerState<_ProfileSheet> {
  Sex? _sex;
  final _height = TextEditingController();
  final _year = TextEditingController();
  bool _loaded = false;

  @override
  void dispose() {
    _height.dispose();
    _year.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(bodyProfileProvider).value;
    if (!_loaded && profile != null) {
      _loaded = true;
      _sex = profile.sex;
      _height.text = profile.heightCm == null
          ? ''
          : formatNumber(profile.heightCm!);
      _year.text = profile.birthYear?.toString() ?? '';
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, sheetBottomPadding(context)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Seu perfil', style: context.texts.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Usado no IMC e na estimativa de gordura. Fica só no celular.',
            style: context.texts.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<Sex>(
            segments: [
              for (final s in Sex.values)
                ButtonSegment(value: s, label: Text(s.label)),
            ],
            emptySelectionAllowed: true,
            selected: {?_sex},
            onSelectionChanged: (s) =>
                setState(() => _sex = s.isEmpty ? null : s.first),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _height,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Altura',
              suffixText: 'cm',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _year,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              labelText: 'Ano de nascimento (opcional)',
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              final h = parseLoadMilli(_height.text);
              final y = int.tryParse(_year.text.trim());
              await ref
                  .read(bodyRepositoryProvider)
                  .saveProfile(
                    sex: _sex,
                    heightCm: h == null || h < 50000 || h > 260000
                        ? null
                        : h / 1000,
                    birthYear: y == null || y < 1900 || y > DateTime.now().year
                        ? null
                        : y,
                  );
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
