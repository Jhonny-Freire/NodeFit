import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_ble/universal_ble.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/load.dart';
import '../../../core/domain/okok_scale.dart';

/// Procura a balança de bioimpedância pelo Bluetooth e devolve a leitura
/// quando o peso trava. Funciona junto com o app da balança (só escuta os
/// anúncios; não conecta nem pareia).
Future<ScaleReading?> readFromScale(BuildContext context) =>
    Navigator.of(context, rootNavigator: true).push<ScaleReading>(
      MaterialPageRoute(builder: (_) => const _ScaleScanScreen()),
    );

/// Um aparelho visto no scan, com o último anúncio.
class _Seen {
  _Seen(this.device, this.reading, this.at);
  final BleDevice device;
  final ScaleReading? reading;
  final DateTime at;
}

class _ScaleScanScreen extends StatefulWidget {
  const _ScaleScanScreen();

  @override
  State<_ScaleScanScreen> createState() => _ScaleScanScreenState();
}

class _ScaleScanScreenState extends State<_ScaleScanScreen> {
  final _seen = <String, _Seen>{};
  StreamSubscription<BleDevice>? _sub;
  String? _problem;
  bool _scanning = false;

  /// Para formatos sem "peso travado": o mesmo valor por 2 s conta como.
  double? _lastWeight;
  DateTime? _sameSince;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _sub?.cancel();
    if (_scanning) UniversalBle.stopScan().catchError((Object _) {});
    super.dispose();
  }

  Future<void> _start() async {
    try {
      await UniversalBle.requestPermissions();
    } catch (_) {
      setState(
        () => _problem =
            'Sem permissão de "Dispositivos próximos". Libere em '
            'Configurações → Apps → NodeFit → Permissões.',
      );
      return;
    }
    final state = await UniversalBle.getBluetoothAvailabilityState();
    if (state == AvailabilityState.poweredOff) {
      setState(() => _problem = 'Ligue o Bluetooth do celular.');
      return;
    }
    if (state == AvailabilityState.unsupported) {
      setState(() => _problem = 'Este celular não tem Bluetooth LE.');
      return;
    }
    _sub = UniversalBle.scanStream.listen(_onDevice);
    try {
      await UniversalBle.startScan(
        platformConfig: PlatformConfig(
          android: AndroidOptions(scanMode: AndroidScanMode.lowLatency),
        ),
      );
      if (mounted) setState(() => _scanning = true);
    } catch (e) {
      if (mounted) setState(() => _problem = 'Não deu para procurar: $e');
    }
  }

  void _onDevice(BleDevice d) {
    final reading = parseOkokAdvertisement(
      name: d.name,
      manufacturerData: [
        for (final m in d.manufacturerDataList)
          (companyId: m.companyId, payload: m.payload),
      ],
    );
    if (reading != null && reading.weightKg > 0) {
      final w = reading.weightKg;
      if (_lastWeight != w) {
        _lastWeight = w;
        _sameSince = DateTime.now();
      }
    }
    if (!mounted) return;
    setState(() => _seen[d.deviceId] = _Seen(d, reading, DateTime.now()));
  }

  bool _locked(ScaleReading r) =>
      r.stable ??
      (_sameSince != null &&
          DateTime.now().difference(_sameSince!) >= const Duration(seconds: 2));

  Future<void> _copyDiagnostics() async {
    final lines = [
      for (final s in _seen.values)
        [
          s.device.name ?? '(sem nome)',
          s.device.deviceId,
          'rssi ${s.device.rssi}',
          for (final m in s.device.manufacturerDataList)
            '0x${m.companyId.toRadixString(16).padLeft(4, '0')}: '
                '${hexBytes(m.payload)}',
          if (s.device.services.isNotEmpty)
            'serviços: ${s.device.services.join(', ')}',
        ].join(' | '),
    ];
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Diagnóstico copiado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scales = _seen.values.where((s) => s.reading != null).toList()
      ..sort((a, b) => b.at.compareTo(a.at));
    final gatt = _seen.values
        .where(
          (s) => s.reading == null && looksLikeChipseaGatt(s.device.services),
        )
        .toList();
    final others =
        _seen.values
            .where((s) => s.reading == null && !gatt.contains(s))
            .toList()
          ..sort(
            (a, b) => (b.device.rssi ?? -999).compareTo(a.device.rssi ?? -999),
          );
    final reading = scales.firstOrNull?.reading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ler da balança'),
        actions: [
          IconButton(
            tooltip: 'Copiar diagnóstico',
            icon: const Icon(Icons.copy_all_outlined),
            onPressed: _seen.isEmpty ? null : _copyDiagnostics,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_problem != null)
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.error_outline,
                  color: context.semantic.attention,
                ),
                title: Text(_problem!),
              ),
            )
          else if (reading == null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Suba na balança, sem meia nem sapato',
                      style: context.texts.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ela acende e manda o peso pelo Bluetooth. Não precisa '
                      'parear nem fechar o app OKOK.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            _ReadingCard(
              reading: reading,
              locked: _locked(reading),
              onUse: () => Navigator.of(context).pop(reading),
            ),
          if (gatt.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.bluetooth_connected),
                title: Text(
                  'Achei ${gatt.first.device.name ?? 'uma balança'} que '
                  'precisa de conexão',
                ),
                subtitle: const Text(
                  'Esse modelo ainda não é lido pelo app. Toque em copiar '
                  'diagnóstico (no topo) e mande para o desenvolvimento.',
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          ExpansionTile(
            title: Text('Outros aparelhos Bluetooth (${others.length})'),
            subtitle: const Text('Para diagnóstico'),
            children: [
              for (final s in others.take(30))
                ListTile(
                  dense: true,
                  title: Text(s.device.name ?? '(sem nome)'),
                  subtitle: Text(
                    [
                      'rssi ${s.device.rssi}',
                      for (final m in s.device.manufacturerDataList)
                        '0x${m.companyId.toRadixString(16).padLeft(4, '0')}: '
                            '${hexBytes(m.payload)}',
                    ].join('\n'),
                    style: const TextStyle(fontFeatures: tabularFigures),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({
    required this.reading,
    required this.locked,
    required this.onUse,
  });
  final ScaleReading reading;
  final bool locked;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    final imp = reading.impedanceOhm;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${formatNumber(double.parse(reading.weightKg.toStringAsFixed(2)))} kg',
              textAlign: TextAlign.center,
              style: context.texts.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontFeatures: tabularFigures,
              ),
            ),
            Text(
              locked ? 'Peso travado ✓' : 'Medindo… fique sem se mexer',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: locked
                    ? context.colors.primary
                    : context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (imp != null && imp > 0)
              Text(
                'Impedância ${formatNumber(imp.round())} Ω (guardada para '
                'calcular a composição depois)',
                textAlign: TextAlign.center,
                style: context.texts.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: locked ? onUse : null,
              style: FilledButton.styleFrom(minimumSize: const Size(64, 56)),
              child: const Text('USAR NO CHECK-IN'),
            ),
            const SizedBox(height: 4),
            Text(
              'Formato ${reading.variant}',
              textAlign: TextAlign.center,
              style: context.texts.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
