import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/widgets/common.dart';

void main() {
  // Regressão: no S26, digitar a carga e tocar OK derrubava o app
  // ("_dependents.isEmpty"): o controlador do campo era descartado enquanto
  // o diálogo ainda animava a saída.
  testWidgets('digitar número e confirmar não quebra', (tester) async {
    String? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async => result = await showNumberInputDialog(
                  context,
                  title: 'Carga',
                ),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '42,5');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(result, '42,5');
    expect(tester.takeException(), isNull);
  });

  testWidgets('diálogo de texto: confirmar e cancelar não quebram', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async =>
                    result = await showTextInputDialog(context, title: 'Nome'),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Banco');
    await tester.pump(); // o botão só habilita depois do redesenho
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(result, 'Banco');

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(result, isNull);
    expect(tester.takeException(), isNull);
  });
}
