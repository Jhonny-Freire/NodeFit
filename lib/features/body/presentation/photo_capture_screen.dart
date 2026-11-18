import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/body.dart';
import '../data/photo_store.dart';

/// Tira a foto de progresso da [pose] com a foto anterior ([guide]) em
/// transparência por cima, para repetir a pose e a distância. Devolve o
/// caminho relativo da foto guardada, ou null se cancelar.
Future<String?> capturePosePhoto(
  BuildContext context, {
  required PhotoPose pose,
  File? guide,
}) => Navigator.of(context, rootNavigator: true).push<String>(
  MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => _PhotoCaptureScreen(pose: pose, guide: guide),
  ),
);

class _PhotoCaptureScreen extends StatefulWidget {
  const _PhotoCaptureScreen({required this.pose, this.guide});
  final PhotoPose pose;
  final File? guide;

  @override
  State<_PhotoCaptureScreen> createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends State<_PhotoCaptureScreen>
    with WidgetsBindingObserver {
  List<CameraDescription> _cameras = const [];
  CameraController? _controller;
  String? _error;
  bool _front = true; // sozinho no espelho, a frontal é o comum
  double _guideOpacity = 0.35;
  int _timer = 0; // 0, 3 ou 10 s
  int? _countdown;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A câmera é liberada quando o app sai da frente e reaberta na volta.
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller = null;
      c.dispose();
      if (mounted) setState(() {});
    } else if (state == AppLifecycleState.resumed) {
      _open();
    }
  }

  Future<void> _start() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      setState(() => _error = 'Câmera indisponível (${e.code}).');
      return;
    }
    if (_cameras.isEmpty) {
      setState(() => _error = 'Nenhuma câmera encontrada.');
      return;
    }
    await _open();
  }

  Future<void> _open() async {
    final lens = _front ? CameraLensDirection.front : CameraLensDirection.back;
    final camera = _cameras.firstWhere(
      (c) => c.lensDirection == lens,
      orElse: () => _cameras.first,
    );
    final old = _controller;
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller = controller;
    await old?.dispose();
    try {
      await controller.initialize();
      _error = null;
    } on CameraException catch (e) {
      _error = e.code == 'CameraAccessDenied'
          ? 'Sem permissão para a câmera. Libere em Configurações → Apps → '
                'NodeFit → Permissões.'
          : 'Não deu para abrir a câmera (${e.code}).';
    }
    if (mounted) setState(() {});
  }

  Future<void> _shoot() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized || _busy) return;
    setState(() => _busy = true);
    try {
      for (var s = _timer; s > 0; s--) {
        if (!mounted) return;
        setState(() => _countdown = s);
        await HapticFeedback.selectionClick();
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      if (mounted) setState(() => _countdown = null);
      final shot = await c.takePicture();
      await HapticFeedback.mediumImpact();
      final rel = await PhotoStore.keep(shot.path);
      if (mounted) Navigator.of(context).pop(rel);
    } on CameraException catch (e) {
      if (mounted) {
        setState(() => _error = 'Falhou ao tirar a foto (${e.code}).');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final ready = c != null && c.value.isInitialized;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Foto: ${widget.pose.label}'),
        actions: [
          if (_cameras.length > 1)
            IconButton(
              tooltip: 'Trocar câmera',
              icon: const Icon(Icons.cameraswitch_outlined),
              onPressed: _busy
                  ? null
                  : () {
                      setState(() => _front = !_front);
                      _open();
                    },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : !ready
                  ? const CircularProgressIndicator()
                  : AspectRatio(
                      // A prévia vem deitada: em pé, a proporção inverte.
                      aspectRatio: 1 / c.value.aspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(c),
                          if (widget.guide != null)
                            IgnorePointer(
                              child: Opacity(
                                opacity: _guideOpacity,
                                child: Transform.flip(
                                  // A prévia da frontal é espelhada.
                                  flipX: _front,
                                  child: Image.file(
                                    widget.guide!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          if (_countdown != null)
                            Center(
                              child: Text(
                                '$_countdown',
                                style: context.texts.displayLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.guide != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.layers_outlined,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Foto anterior',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Expanded(
                          child: Slider(
                            value: _guideOpacity,
                            max: 0.8,
                            onChanged: (v) => setState(() => _guideOpacity = v),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 0, label: Text('Já')),
                          ButtonSegment(value: 3, label: Text('3 s')),
                          ButtonSegment(value: 10, label: Text('10 s')),
                        ],
                        selected: {_timer},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) =>
                            setState(() => _timer = s.first),
                      ),
                      const Spacer(),
                      FloatingActionButton.large(
                        heroTag: null,
                        tooltip: 'Tirar foto',
                        onPressed: ready && !_busy ? _shoot : null,
                        child: _busy
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.photo_camera),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
