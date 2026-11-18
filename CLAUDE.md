# NodeFit — contexto do projeto (para qualquer chat novo)

Leia este arquivo inteiro antes de mexer em qualquer coisa. Ele resume o que
foi decidido e construído entre 14/10 e 26/10/2026 numa conversa longa. O plano
completo, com o porquê de cada decisão, está em `docs/PLANO.md`; a pesquisa
bruta em `docs/pesquisa/`; o que cada versão entregou, no `README.md`.

## O que é

App pessoal de academia para Android (Flutter), feito para substituir o
caderno de papel do dono. Testado num **Galaxy S26** (Android 17, 1080×2340).

O diferencial (o que nenhum concorrente faz bem): **o ajuste de cada máquina**.
A "estação" = exercício × aparelho × academia guarda os ajustes estruturados
(Banco 7, Encosto 3...) com histórico ("Banco 7 → 8 em 14/10"), a nota fixada,
a carga na unidade da própria máquina (kg, lb ou "placa 7") e os recordes.
Depois vieram fichas, evolução física, cardio e leitura de balança.

- **Princípios:** offline, conta só local (v0.6, exigência da P2), sem anúncio; poucos toques na academia
  (alvos de 56 dp, zona do polegar embaixo); tudo gravado no banco na hora
  (fechar o app nunca perde o treino); backup em ZIP desde o início.
- **Público:** uso pessoal. O dono comentou que pode usar o app num **trabalho
  da faculdade (Fatec)** — ainda não confirmado. `docs/PLANO.md` seção 12 tem
  ideias de como apresentar. Se for público/comercial, rever licenças (ver
  "Cuidados").

## Sobre o dono (como trabalhar com ele)

- Fala **português do Brasil**; responda em pt-BR, simples e direto.
- Prefere **autonomia**: "manda bala", "continua" = siga sem perguntar. Ele
  quase não testa; teste você (testes automáticos + aparelho) e diga o que ele
  precisa conferir pessoalmente.
- Antes de começar uma fase grande, explique em poucas linhas o que vai fazer;
  no fim, diga o que foi feito, o que foi testado e o que falta.
- Pronomes não informados: escreva de forma neutra.

## Estado atual (v0.6.0+7, 18/11/2026)

| Versão | O que entrou |
|---|---|
| Fatia 1 | Catálogo PT-BR (busca sem acento), academias/aparelhos, estações com ajustes e histórico, treino livre com coluna "Anterior", concluir em 1 toque, trocar aparelho/exercício, "como foi", timer, backup ZIP |
| Fatia 2 | Fichas A/B/C (professor, vencimento), próxima ficha sugerida, **dupla progressão**, timer na **tela bloqueada** (notificação + alarme exato), resumo com recordes, histórico, restaurar backup |
| Seletor | Escolher exercício mais fácil: recentes, filtros por músculo, aparelho automático na 2ª vez |
| Fatia 3 | Recorde na hora, aquecimento em rampa, anilhas por lado sem conta, gráfico por estação, calendário/constância, salvar treino como ficha |
| Fatia 4 | **Bi-set/tri-set** (sem descanso entre o par) e **cardio/tempo** (esteira: tempo + km; prancha: tempo) — schema v2 |
| v0.2 | **Evolução física**: check-in (peso, fita, valores da balança de bioimpedância, fotos com a anterior em transparência), gordura pela fórmula da Marinha, tendência do peso, gráficos, séries por músculo/semana, lembrete semanal, exportar CSV — schema v3 |
| v0.6 (P2 Fatec) | **Conta local**: cadastro/login/logout, hash PBKDF2-SHA256 + sal, sessão em `app_prefs` (`auth.session_user_id`), `redirect` do go_router protege as telas — schema v4 (`users`). **Personas** em `docs/PERSONAS.md` → relatórios em texto para professor e médico (`core/domain/reports.dart`, `features/reports/`, rota `/mais/relatorio/:tipo`) |
| v0.2.1 (beta) | **Ler a balança OKOK pelo Bluetooth** (anúncios BLE, sem parear) no check-in |

Testes: **120 passando** (`flutter test`), `flutter analyze` sem avisos.

### O que falta / próximos passos

1. **Testar com o dono:** balança real (permissão "Dispositivos próximos"),
   câmera das fotos (permissão), lembrete de check-in. Se a balança for do tipo
   que precisa de conexão (serviço 0xFFF0), implementar esse formato com o
   "copiar diagnóstico" da tela da balança.
2. **Git:** o repositório existe mas **não tem nenhum commit**. O dono ainda
   não passou nome/e-mail para o git; configure só neste repositório
   (`git config user.name/user.email`, sem `--global`; é máquina corporativa)
   quando ele passar. Não faça commit sem isso.
3. **Sugestões aceitas como próximas (versão 0.6):** foto do aparelho/ajuste
   (estava no plano da Fatia 2 e não foi feita; a coluna `photo_path` já
   existe), aviso de estagnação (3 treinos sem progresso → sugestão), metas
   (peso-alvo, treinos/semana). Depois: timer na barra de status/Now Bar com
   +15 s/Pular (Live Update), Health Connect, widget, dieta (v0.3).
4. Pendências antigas: confirmar nome "NodeFit" e o applicationId; Fatec sim
   ou não; inventário de anilhas da academia; composição corporal calculada
   pela impedância (só com equação publicada, rotulada como estimativa).

## Stack e arquitetura

- **Flutter 3.47.7 / Dart 3.13.5**, Android minSdk 26, desugaring ligado.
- **Riverpod 3** com codegen (`@riverpod`), **go_router 18**
  (`StatefulShellRoute` com 4 abas: Treinar · Caderno · Progresso · Mais;
  treino em andamento `/sessao/:id` e check-in `/checkin[/:id]` no navegador
  raiz), **Drift 2.35** (SQLite; datas como texto ISO).
- Outros: flutter_local_notifications 22 (+ timezone), wakelock_plus,
  share_plus, archive, file_picker, fl_chart, camera, universal_ble (BSD).
- Pastas: `lib/core/` (db, **domain** = regras puras testadas, platform,
  prefs, utils, widgets) e `lib/features/<área>/{data,presentation}` (backup,
  body, catalog, gyms, history, routines, settings, workout).
- Regras de negócio puras em `lib/core/domain/` (cada uma tem teste em
  `test/domain/`): progression (dupla progressão), one_rep_max (Epley),
  records, warmup, plates, superset, cardio, frequency, body (Marinha, IMC,
  tendência, volume por músculo), okok_scale (formatos BLE).
- **Cargas são inteiros × 1000** na unidade do aparelho (62,5 kg = 62500);
  medidas do corpo também (85,5 cm = 85500). Sem ponto flutuante no banco.
- Canal nativo `nodefit/alert` em `android/.../MainActivity.kt` (vibração +
  som no fim do descanso). Debug instala como **"NodeFit DEV"**
  (`dev.joaopedro.nodefit.dev`), separado do release.

### Banco (Drift) — schema v4

Tabelas: gyms, equipment, exercises (`tracking`: carga×reps / tempo /
cardio), stations, station_settings, station_setting_changes, routines,
routine_exercises (`superset_group`), workout_sessions, session_exercises,
workout_sets (`duration_sec`, `distance_m`), body_checkins, body_values (uma
linha por medida), body_photos (caminho **relativo** à pasta do app),
app_prefs, users (v4: contas locais).

**Mudou o schema?** Suba `schemaVersion`, escreva o passo em `onUpgrade`
(`stepByStep`) e rode `dart run drift_dev make-migrations` — os snapshots
ficam em `drift_schemas/` e o teste em `test/drift/nodefit/migration_test.dart`
(o comando pode regerar esse teste; confira se o teste de dados preservados
continua lá). Teste também numa **cópia do banco real** do celular (ver
abaixo) antes de instalar.

### build.yaml (atenção)

Dois alvos: o alvo `drift` (app_database, tables, `core/domain/**`,
`core/utils/**`) roda antes do `$default`, senão o riverpod_generator não
enxerga os tipos gerados pelo Drift. Enums usados em tabelas precisam morar em
`core/domain/`.

## Comandos

Versão **web** (v0.6): `flutter build web --release` → servir `build/web` (ex.: `python -m http.server 8087 --directory build/web`). Banco = SQLite wasm + IndexedDB; `web/sqlite3.wasm` e `web/drift_worker.js` têm de bater com a versão do drift no lock. Backup, planilhas, fotos, timer na tela bloqueada e balança ficam escondidos com `kIsWeb`. `restore_service` usa `probe_executor.dart` (import condicional) porque `drift/native.dart` não compila na web.

```bash
dart run build_runner build          # depois de mudar @riverpod ou tabelas
flutter analyze
flutter test                         # suíte normal
flutter test test_screens --update-goldens   # capturas de tela 1080×2340 em test_screens/goldens/
flutter build apk --debug
```

As capturas (`test_screens/`) usam o relógio real: diferenças pequenas de
pixel entre dias são normais; servem para ver as telas e achar texto cortado
(o teste imprime `OVERFLOWS[...]`).

## Ambiente Windows (armadilhas)

- **Trabalhe em `C:\Dev\App Academia`** (a cópia no OneDrive não compila: caminho com acento). `C:\flutter` é uma *junction* para o SDK dentro do OneDrive: `dart run ...` quebra nos build hooks; use `flutter pub run build_runner build` / `flutter pub run drift_dev make-migrations`.
- O usuário do Windows tem "ã" no nome. Por isso: SDK em `C:\Android\Sdk`,
  `PUB_CACHE=C:\pub-cache`, `GRADLE_USER_HOME=C:\gradle` e
  **`JAVA_TOOL_OPTIONS=-Djdk.net.unixdomain.tmpdir=C:\gradle\tmp`** (sem isso
  o Gradle falha com "Unable to establish loopback connection"). Em shells
  novos, defina essas variáveis antes de `flutter build`.
- adb: `C:\Android\Sdk\platform-tools\adb.exe`.
- Não aceite licenças do SDK pelo dono (`flutter doctor --android-licenses`
  é com ele).
- No PowerShell, redirecionamento binário corrompe arquivos: para copiar o
  banco do celular use `cmd /c "adb exec-out run-as ... cat ... > arquivo"`.
- Scripts Python longos dentro de heredoc no bash às vezes quebram; salve o
  script num arquivo temporário e rode.

## Celular do dono: regras de ouro

- **Nunca use `flutter install`** (desinstala e apaga os dados). Atualize com
  `adb install -r build\app\outputs\flutter-apk\app-debug.apk`.
- O dono **usa o app de verdade** (tem fichas e treinos reais). Antes de
  instalar algo que mude o banco ou de testar no aparelho: force-stop, copie
  o banco (`run-as dev.joaopedro.nodefit.dev cat files/nodefit.sqlite`), e
  depois do teste restaure a cópia (push para `/data/local/tmp`, `run-as ...
  cp` para `files/nodefit.sqlite`, apague o temporário). Confira com
  `C:\SQLite\sqlite3.exe` (`pragma user_version`, contagens).
- Não toque em diálogos de permissão do sistema (câmera, Bluetooth,
  notificação) nem desbloqueie o celular — isso é com o dono.
- Automação útil: `uiautomator dump` + `input tap/text/swipe` + `screencap`.

## Cuidados

- **Testes de widget com Drift:** descarte o container/widgets, avance o
  relógio falso e só então `tester.runAsync(db.close)`, senão trava. Depois de
  `enterText`, `pump()` antes de tocar no botão.
- **Riverpod 3:** provider sem ouvinte fica PAUSADO — `ref.read(x.future)` sem `ref.listen` pode esperar para sempre (travou a inicialização em 18/11; teste em `test/widgets/startup_test.dart`). Nunca `ref.read(providerAutoDispose.future)` sem ouvir
  (descarta antes de emitir); use `listenManual` ou leia direto do repositório.
- Diálogos com campo de texto: o controlador pertence a um StatefulWidget e
  só é descartado no `dispose` (descartar ao fechar derrubava o app no S26).
- Folhas de baixo: `useRootNavigator: true` + `sheetBottomPadding(context)`
  (senão ficam atrás das abas ou da barra do Android).
- **Licenças:** openScale é GPL-3 — o leitor da balança foi reimplementado a
  partir da descrição do protocolo; não copie código de lá. A tabela de
  alimentos TBCA não pode ser usada (termos); TACO sim, citando a fonte.
- Estimativas (1RM, gordura pela fita, composição corporal) sempre rotuladas
  como estimativa; o app mostra "não é orientação médica".
