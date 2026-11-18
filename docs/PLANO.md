# Caderno de Treino: plano do projeto

> **Versão 1, de 14/10/2026.** O nome é provisório; pode ser "NodeFit" ou outro, a decisão é sua. A única coisa que **não** dá para mudar depois é o `applicationId` (veja a seção 9).
>
> Este documento junta quatro pesquisas, que estão em `pesquisa/` com as fontes, e três rascunhos de design que passaram por dois revisores. Quando os rascunhos discordavam, a decisão final é a que está aqui.

---

## 0. Resumo em uma tela

| Pergunta | Resposta |
|---|---|
| A ideia vale a pena? | **Sim.** O diferencial é justamente o que o plano do Gemini não modelou: **o aparelho como registro próprio, com ajustes estruturados por academia**, e não só "carga e reps". |
| Android Studio ou multiplataforma? | É uma falsa escolha. O Android Studio é uma **IDE**, e a decisão de verdade é entre o **framework** Kotlin nativo e Flutter. Fique com o **Flutter**, que já está instalado (3.47.1). O app sai primeiro no S26, e o mesmo código vai depois para iOS e PC. O Android Studio continua sendo usado para o SDK, o emulador e o Logcat. |
| Banco de dados | **Drift** (SQLite), offline, sem login. O `sqflite` sai porque não roda no PC sem adaptação. |
| Quando dá para usar na academia? | Em umas **3 a 4 semanas** de meio período, com treino livre, ajustes do aparelho, séries com a coluna "Anterior", a nota de "como foi" e backup. |
| Em que ordem? | Caderno de treino → evolução física → dieta → integrações Samsung → nuvem, iOS e PC. |
| Antes de programar | Eram 3 problemas no PC. A pasta do projeto e os caminhos com "ã" já foram resolvidos em 14/10. Falta completar o SDK (cmdline-tools e licenças). Veja a seção 9. |

---

## 1. A ideia vale a pena?

**Sim, e existe espaço real para ela.** O que a pesquisa encontrou em outubro de 2026:

- **O Hevy confirmou a demanda.** A versão 3.2.0, lançada por volta de 13/10/2026, trouxe notas "fixadas no exercício", e o exemplo oficial é justamente um ajuste de máquina ("seat notch 7, pad on 3"). Mas a nota é **texto livre**, presa a um exercício genérico ("Leg Press") e não ao **aparelho da sua academia**. Quem treina em duas unidades, ou cuja academia trocou a máquina, fica com uma nota só e um histórico de carga que mistura máquinas diferentes. Um usuário reclamou no Reddit que, depois da troca dos cabos na academia, o mesmo número da pilha passou a valer quase metade da carga.
- **Os apps das redes não deixam você anotar de verdade.** O da Smart Fit tem avaliações de 2026 reclamando que o treino reseta ao fechar o app ou quando a tela apaga, e que ele depende de internet. Os apps da Gaviões e da Skyfit são white-label do sistema EVO (W12): mostram a ficha do professor, a agenda e o check-in. Não encontrei versão Android do app da Gaviões.
- **Quem estrutura os ajustes só existe no iOS.** Rackord e MyGym Sessions têm um "cartão de ajustes" por máquina. **Não achei nenhum app Android que faça isso.**

**O espaço livre é este:** um app Android, em português, offline, em que **o aparelho é um registro próprio**, com ajustes estruturados (Banco 7 · Encosto 3 · Pino 12), foto, histórico ("Banco 7 → 8 em 14/10") e carga comparável **dentro do mesmo aparelho**. Esse é o seu caderno de papel, só que melhor.

**Um cuidado:** "app completo tipo Smart Fit" é a forma mais rápida de nunca terminar. O plano abaixo entrega o caderno primeiro e acrescenta o resto em versões fechadas.

---

## 2. Android Studio × multiplataforma → **Flutter**

São duas coisas diferentes. **Android Studio** é o editor, o SDK Manager, o emulador e o Logcat, e ele funciona com Flutter pelo plugin oficial. A escolha de verdade é o **framework**:

| Opção | Vence quando… | No seu caso |
|---|---|---|
| **Flutter (Dart)** ✅ | Um código para Android, iOS, Windows, macOS e Linux. Desktop estável desde 2022. | **Já está instalado.** Tem plugins maduros para tudo que o MVP precisa: notificações, fotos, gráficos, tela ligada e o próprio Drift. |
| Kotlin + Jetpack Compose | O app vai ser **só Android para sempre**, ou você quer aprender Kotlin pensando no mercado Android. | PC e iOS virariam outro projeto. |
| Kotlin Multiplatform + Compose Multiplatform | Você prefere Kotlin e quer cara de app nativo. Está estável em Android, iOS e desktop desde 2025. | Ecossistema menor, mais código por plataforma, e o desktop roda na JVM. |
| React Native / Expo | Você já sabe React/TypeScript. | Desktop mais fraco, e você começaria do zero. |

**Vale para qualquer framework:**
- **Gerar o app de iPhone exige macOS com Xcode**, numa máquina sua ou num Mac na nuvem (o Codemagic dá 500 min/mês grátis).
- **Instalar no seu S26 pelo cabo é grátis e não exige conta.** O `flutter run`, o Run do Android Studio e o `adb install` estão **isentos** da nova verificação de desenvolvedor do Google, inclusive no Brasil, onde ela vale desde 30/09/2026. Isso está escrito na FAQ oficial do Google.

**Editor:** o VS Code já tem as extensões de Dart e Flutter instaladas. Se preferir o Android Studio, instale nele o plugin "Flutter" (Settings → Plugins).

---

## 3. O que muda em relação ao plano do Gemini

| Item do Gemini | Decisão | Por quê |
|---|---|---|
| Flutter + Riverpod + go_router + Material 3 | **Mantém** | São boas escolhas. Use o Riverpod 3 (3.4.3) e o go_router 18. |
| **sqflite** | **Troca por Drift** | O sqflite só roda em Android, iOS e macOS. O Drift tem um único schema para todas as plataformas, migrações, consultas reativas e código tipado. |
| **Ajustes de máquina** | **Não existiam**, agora são o centro | Era o valor central do seu caderno. Veja a seção 5. |
| Login falso `admin@nodefit.com/123456` | **Corta** | Não protege nada, ensina a deixar senha no código e cria atrito. Login só entra se um dia houver sincronização na nuvem. |
| 20+ exercícios com GIFs | **Troca** | Os termos do ExerciseDB (AscendAPI) **proíbem guardar** os GIFs, e as imagens do free-exercise-db foram raspadas da internet. No lugar: cerca de 70 nomes em PT-BR, só texto, mais **a foto que você mesmo tira do aparelho**. |
| Ambiente "academia × casa" | **Troca** | "Casa" vira só mais uma academia, com os aparelhos e ajustes dela. |
| Carga, reps, RIR, cadência e notas **por série** | **Ajusta** | Carga e reps sempre. RIR é opcional. Cadência fica como prescrição da ficha, não como campo para digitar a cada série. As notas ficam por exercício ("como foi"). |
| "Modo Arena" com cronômetro | **Refaz** | Um timer em Dart morre quando a tela apaga. O descanso passa a ser um **horário de término salvo no banco**, com notificação na tela bloqueada, e o treino é retomado se o app fechar. |
| "Modo Fantasma" | **Melhora** | É a coluna "Anterior" que todo app tem. A melhoria é olhar o **mesmo exercício no mesmo aparelho** e somar uma sugestão por dupla progressão. |
| Gordura pela fórmula da Marinha com "altura, peso, cintura, pescoço" | **Corrige** | **O peso não entra na fórmula.** Para homens ela usa altura, pescoço e abdômen (no umbigo); para mulheres, altura, pescoço, cintura (no ponto mais estreito) e quadril. O peso só serve depois, para calcular massa gorda e massa magra. |
| Exportar CSV | **Amplia** | CSV não restaura nada. O plano é um **backup completo (ZIP) com restauração desde a primeira versão**, mais CSV na v0.2. |
| Painel de macros e foto do prato | **Adia** | Vem na fase da dieta, com uma base de alimentos de verdade (TACO). A foto do prato não calcula macro. |
| Importar PDF pela API do Gemini | **Adia** | A chave embutida no app vaza e o recurso manda dado de saúde para terceiros. A alternativa futura é o Gemini Nano rodando no próprio S26. |
| "Radar Health" (mapa com GPS) | **Corta** | Não tem relação com o caderno e traz custo de API, permissão de localização e obrigações da LGPD. |
| Timer de alongamento pós-treino | **Adia** | Quando entrar, vira só uma ficha de exercícios por tempo. |

---

## 4. Princípios do produto (valem para todas as versões)

1. **O caderno vem primeiro.** Enquanto registrar o treino não estiver ótimo, nenhuma ideia nova entra.
2. **Na academia, cada ação custa no máximo 1 ou 2 toques.** A regra é *configurar em casa e executar na academia*.
3. **Funciona 100% offline.** Nenhuma tela depende de internet.
4. **Não exige conta.** Você abre e usa.
5. **Nada se perde.** Cada toque grava no banco na hora, e o treino sobrevive ao app fechar, à bateria acabar e ao celular reiniciar.
6. **Os dados são seus.** Backup completo desde a v0.1, e as fotos ficam fora da Galeria.
7. **Feito para mão suada:** alvos de toque de pelo menos 48 dp (56 a 64 dp na tela de treino), ações na metade de baixo da tela e vibração ao concluir uma série.
8. **Estimativa aparece como estimativa:** 1RM estimado, % de gordura e gasto calórico. O app sugere, mas não prescreve.

**Filtro para qualquer ideia nova:** ela ajuda a anotar ou consultar o caderno? Funciona sem internet? Cabe em 2 toques ou acontece fora do treino? Se não passar, vai para o `IDEIAS.md` (o "estacionamento").

---

## 5. Modelo do domínio: a peça central

```
Academia                (ex.: "Academia do bairro", "Unidade Centro", "Casa")
 └─ Aparelho            (ex.: "Leg press 45° preto", "Polia dupla 1", "Halteres")
     ├─ foto · unidade (kg | lb | nº da placa) · incremento (ex.: 5 kg)
     ├─ carga por lado ou total · carga inicial (carrinho, barra)
     └─ ESTAÇÃO = Exercício × Aparelho (nesta academia)
          ├─ Ajustes:     Banco = 7 · Encosto = 3 · Pino = 12 · Pegada = "corda"
          ├─ Histórico:   "Banco 7 → 8 em 14/10"
          ├─ Nota fixada: "escápula travada, não travar o cotovelo"
          └─ Séries, recordes e 1RM estimado, separados por estação

Exercício (catálogo)  nome em PT-BR, apelidos, músculos primários e secundários
Ficha                 exercícios em ordem + aparelho preferido + alvo (3 × 8–12) + descanso
Sessão                séries registradas + "como foi" (texto, tag fácil/ok/difícil, dor)
```

**Por que existe a "estação":** o ajuste não pertence ao exercício, pertence ao par **exercício × aparelho**. A "Polia dupla 1" tem a polia no furo 2 no tríceps corda e no furo 12 no crucifixo. E "20" numa polia não é o mesmo que "20" na outra. Com estações, cada combinação tem os próprios ajustes e o próprio histórico de carga.

**Quando a academia troca a máquina:** use "Substituir aparelho". O antigo é arquivado com todo o histórico e o novo começa limpo.

### 5.1 Tabelas da v0.1 (Drift)

Nomes em inglês no código e interface em português. Todas as tabelas têm `id` (UUID v7, texto), `created_at` e `updated_at` (UTC).

| Tabela | Colunas principais |
|---|---|
| `gyms` | name, notes, archived_at |
| `gym_weights` (v0.1.1) | gym_id, kind (plate/dumbbell), load_milli, unit (kg/lb), quantity. É o inventário de anilhas e halteres da academia, usado pela calculadora de anilhas. |
| `equipment` | gym_id, name, gym_label ("nº 14"), photo_path, **load_unit** (kg/lb/plate), **load_basis** (total/perSide/perHand), increment_milli, base_load_milli, replaces_equipment_id, archived_at |
| `exercises` | id = *slug* nos exercícios embarcados (`supino-reto-barra`) ou UUID nos que você cria; name_pt, **search_name** (minúsculas e sem acento), aliases, equipment_type, primary_muscles, secondary_muscles, is_custom, archived_at |
| `stations` | exercise_id, gym_id, equipment_id (nulo para exercício sem aparelho, como a flexão), **pinned_note**, photo_path, archived_at. É única por (exercício, academia, aparelho), regra garantida no repositório porque o SQLite trata NULL como valor distinto. |
| `station_settings` | station_id, label ("Banco"), kind (number/text), value_num, value_text, step, photo_path, sort_order, archived_at |
| `station_setting_changes` | setting_id, old_value, new_value, session_id, changed_at. **Só cresce**, nunca é editada, e é daí que sai o "7 → 8". |
| `routines` (fichas) | name ("Ficha A · Peito/Tríceps"), label (A/B/C), gym_id, trainer, **expires_on** (AAAA-MM-DD), notes, sort_order, archived_at |
| `routine_exercises` | routine_id, exercise_id, preferred_equipment_id, position, target_sets, rep_min, rep_max, target_rir, rest_sec, warmup_sets, tempo (prescrição em texto), notes, superset_group (v0.1.1) |
| `workout_sessions` | routine_id, gym_id, title (cópia), started_at, **ended_at** (nulo enquanto o treino está em andamento), **local_date**, **rest_ends_at**, notes |
| `session_exercises` | session_id, station_id, routine_exercise_id, position, **cópias** de load_unit/load_basis/increment/metas/rest_sec, how_it_went, effort_tag (easy/ok/hard), pain, superset_group (v0.1.1; copiado da ficha ou definido no treino livre) |
| `workout_sets` | session_exercise_id, position, set_type (warmup/working/drop/failure), **load_milli**, reps, rir (REAL, aceita 0,5), **completed_at** (nulo = série só planejada), note |
| `app_prefs` | key → value |

**Decisões que evitam dor de cabeça depois:**
- **Carga como inteiro, no número que você lê na máquina:** `load_milli` = valor × 1000, na unidade da estação. 62,5 kg vira `62500`, 45 lb vira `45000` e "placa 7" vira `7000`. Isso evita erro de ponto flutuante, e "Anterior", recordes e progressão funcionam igual para qualquer máquina. A carga total em kg (×2 por lado + carrinho) só é calculada para exibir, para o volume do resumo do treino (Fatia 2) e para o volume semanal da v0.2. Aparelhos com unidade "nº da placa" ficam fora da soma em kg, porque o banco não sabe quanto pesa cada placa; o resumo mostra esse volume à parte.
- **As sessões guardam cópias** (unidade, metas, nome da ficha). Editar a ficha depois não reescreve o passado.
- **Exclusão:** linhas "folha", como séries, são apagadas de verdade, com o "Desfazer" recolocando a linha guardada na memória. Um ajuste que já tem histórico em `station_setting_changes` não é apagado: ganha `archived_at`, para não perder o "7 → 8". Academias, aparelhos, exercícios e estações com histórico são só **arquivados**. Os UUIDs e o `updated_at` já deixam a sincronização futura possível. Exclusão lógica em todas as tabelas fica para quando existir sync, numa tabela `tombstones`.
- **Gravação:** ao iniciar o treino, o app já cria as séries planejadas (`completed_at` nulo), pré-preenchidas com o "Anterior" ou a sugestão. Cada **Concluir** é um UPDATE numa transação que também grava `rest_ends_at`. Ao finalizar, as séries não feitas são apagadas.
- **Datas:** instantes ficam em UTC, e o "dia" do treino fica em `local_date` (AAAA-MM-DD), calculado na hora do registro.
- **Fotos:** só o **caminho relativo** vai no banco (`photos/equipment/<id>.jpg`). Os arquivos ficam em `getApplicationSupportDirectory()`, uma pasta privada que não aparece na Galeria.
- **Uma só forma de consultar na v0.1:** a API em Dart do Drift. SQL escrito à mão (`.drift`, `customSelect`) só entra para o volume semanal da v0.2.

### 5.2 Consultas que fazem o app

- **Anterior:** as séries concluídas da última sessão **da mesma estação**, em ordem. Se não houver, o app **mostra apenas como referência**, sem pré-preencher as séries, o mesmo exercício na mesma academia em outro aparelho, com o rótulo "outro aparelho". Um aparelho que substituiu outro (`replaces_equipment_id`) **não** herda o "Anterior" do antigo, porque "20" na máquina nova pode não ser "20" na velha.
- **Ajustes atuais:** `station_settings` da estação, com a data da última mudança ("desde 07/10").
- **Sugestão:** é calculada na hora, a partir do "Anterior" (regra em 7.1), e não fica salva no banco.
- **Recordes por estação:** só séries que não são de aquecimento. Maior carga, mais repetições numa mesma carga e maior 1RM estimado (só séries de 1 a 10 reps).

---

## 6. Arquitetura

### 6.1 Stack e pacotes da v0.1 (conferidos no pub.dev em 14/10/2026)

| Para quê | Pacote |
|---|---|
| Estado | `flutter_riverpod` ^3.4.3 · `riverpod_annotation` ^4.0.7. Em dev: `riverpod_generator` ^4.0.9 e `riverpod_lint` ^3.1.9 (em `plugins:` do `analysis_options.yaml`, não via custom_lint) |
| Navegação | `go_router` ^18.0.2 |
| Banco | `drift` ^2.35.2 · `drift_flutter` ^0.3.1. Em dev: `drift_dev` ^2.35.1 e `build_runner` ^2.16.2 |
| Utilitários | `path_provider` ^2.1.6 · `uuid` ^4.6.0 · `intl` ^0.20.3 |
| Treino | `wakelock_plus` ^1.8.1 · `flutter_local_notifications` ^22.3.2 (exige *core library desugaring*) + `timezone` (versão a conferir) |
| Fotos e backup | `image_picker` ^1.2.4 · `share_plus` ^13.3.1 · `file_picker` ^13.1.0 · `archive` (ZIP; versão a conferir) |
| v0.2 em diante | `fl_chart` ^1.2.0 · `health` ^13.3.2 (Health Connect) · `openfoodfacts` ^3.31.0 |

**Não use:** `sqflite`; `sqlite3_flutter_libs` (virou um pacote vazio, "+eol"); `isar` (abandonado); `custom_lint`; `StateNotifier`/`StateProvider` (legado no Riverpod 3); `gal` para fotos do corpo. **Cuidado com tutoriais antigos**, que usam Riverpod 2, sqflite e custom_lint.

**Estilo único de Riverpod:** geração de código com `@riverpod`. O `build_runner` já roda por causa do Drift, então o custo é quase zero. O **banco é a fonte da verdade**: os providers expõem *streams* dos repositórios, o widget chama o repositório para gravar, e a tela se atualiza sozinha. `Notifier` fica só para estado efêmero, como o rascunho da série sendo digitada.

**Material:** no Flutter 3.47 o Material também existe como pacote separado (`material_ui`), e o go_router 18 já usa esse pacote. No dia 1, siga o que o `flutter create` gerar e teste rotas, transições e o voltar preditivo com o go_router 18. Se aparecer conflito, migre com `dart fix --apply --code=migrate_design_widgets`.

### 6.2 Pastas (por funcionalidade, com camadas leves)

```
lib/
  main.dart
  app/            app.dart · router.dart · theme/ (tokens de cor, tipografia, dimensões)
  core/
    db/           app_database.dart · tables/ · seed/   (Drift: schemaVersion + migrações)
    platform/     notifications.dart · samsung_battery.dart
    files/        photo_store.dart                      (pasta privada de fotos)
    utils/        ids.dart · clock.dart (relógio testável) · text_normalize.dart · formatters.dart
    widgets/      value_stepper.dart · big_action_button.dart · …
  features/
    catalog/      exercícios
    gyms/         academias, aparelhos, estações e AJUSTES (o núcleo)
    routines/     fichas
    workout/      treino em andamento, timer, resumo   (domain/: progressão, 1RM)
    history/      histórico e recordes
    backup/       exportar e importar ZIP
    settings/     configurações, diagnóstico do timer, licenças
test/             domain/ (fórmulas) · data/ (repositórios com banco em memória) · widgets/
assets/seed/      exercicios_pt_br.json
```

Quatro regras simples substituem uma "Clean Architecture" pesada:
1. **Widget nunca acessa o Drift diretamente.** Sempre passa por um repositório exposto por um provider.
2. **Regra de negócio em Dart puro vai para `domain/`**, sem importar Flutter nem Drift. Isso vale para fórmulas, progressão e diferença de ajustes.
3. **`application/` só existe quando a ação envolve mais de um repositório ou um serviço da plataforma.** Exemplos: iniciar ou finalizar treino, backup.
4. **Interface só quando houver duas implementações reais.** Em Dart toda classe já é uma interface implícita, então os testes não precisam de interface criada só por precaução.

Os módulos futuros (`body/`, `nutrition/`, `integrations/health_connect/`, `sync/`, `ai_import/`) entram como novas pastas em `features/`. Cada um traz suas tabelas e um passo de migração.

### 6.3 Navegação

- **Abas:** **Treinar · Caderno · Progresso · Mais**. Na v0.3 entra **Dieta** (5 abas, o máximo recomendado pelo Material). As abas usam `StatefulShellRoute`.
- **O treino em andamento é uma rota de tela cheia fora das abas**: `/sessao/:id`, no navegador raiz. Esse caminho é estável e também serve para a notificação abrir o treino. Se você sair do treino, uma minibarra ("Treino 32:14 · Descanso 01:12") aparece sobre as abas.

### 6.4 Visual (v0.1: só tema escuro)

| Token | Cor | Uso |
|---|---|---|
| `surface` | `#0E0F0C` | Fundo das telas. É quase preto, para manter a hierarquia entre superfícies. |
| `surfaceContainerLowest` | `#000000` | **Só na tela de treino**, que fica ligada a hora inteira e é onde o OLED economiza de verdade |
| `surfaceContainer*` | `#161814` → `#2D3029` | Cards, linhas de série, painéis |
| `onSurface` / `onSurfaceVariant` | `#E4E6DC` / `#B9BDB0` | Texto principal num branco "quente" (não puro) e texto secundário |
| `primary` | **`#CCFF00`** (o neon do Gemini) | Ação principal e série ativa. É **acento**, não fundo. |
| `onPrimary` | `#0E0F0C` | O texto sobre o neon **precisa ser escuro**: branco sobre neon dá contraste de 1,2:1 e reprova. |
| `rest` (extensão) | `#5BD6E6` ciano | Tudo que é descanso |
| `attention` (extensão) | `#FFC857` âmbar | Avisos, ficha vencida, recorde |
| `error` | `#FFB4AB` | Erro e tag "dor" |

- Use **números tabulares** no timer, na carga e nas reps. Tamanhos: timer entre 57 e 64 sp, carga e reps entre 28 e 32 sp.
- **Teste com a fonte do sistema em 130%**, porque usuários Samsung costumam aumentar muito.
- No tema, o botão principal tem altura mínima de 56 dp: `minimumSize: Size(64, 56)`. Não use `Size.fromHeight`, que quebra botões dentro de linhas.
- O tema claro, com primário oliva `#4A6300`, fica para depois.

### 6.5 Timer de descanso que funciona com a tela bloqueada (o maior risco técnico)

1. **A fonte da verdade é `rest_ends_at` no banco.** A tela calcula `restante = rest_ends_at − agora`. Os botões −15 s, +15 s e Pular só reescrevem esse horário. Por isso o timer sobrevive ao app morrer.
2. **Notificação de contagem regressiva** ao concluir a série: `ongoing`, `usesChronometer`, `chronometerCountDown`, `when = fim`, `timeoutAfter = restante` (para não mostrar tempo negativo) e visibilidade pública na tela bloqueada. O próprio Android faz a contagem.
3. **Alerta de fim** agendado para `rest_ends_at` com `AndroidScheduleMode.alarmClock` e o **mesmo ID** da notificação de contagem, para substituí-la. O som e a vibração vêm do **canal** de notificação; não toque áudio pelo app em segundo plano. No Android 17, apps com targetSdk 37 têm esse áudio cortado sem aviso; com o targetSdk 36 de hoje ainda funciona, mas não conte com isso.
4. **Permissões:** `POST_NOTIFICATIONS` é pedida em contexto, num checklist "Preparar timer" feito em casa. Para alarme exato, a build pessoal declara `USE_EXACT_ALARM` (sem pergunta ao usuário). **Antes de publicar na Play**, troque por `SCHEDULE_EXACT_ALARM` com a tela de permissão.
5. **Na v0.1, os botões ±15 s e Pular ficam só dentro do app.** Tocar na notificação abre `/sessao/:id`. Botões na própria notificação rodam num *isolate* separado e exigem cuidado extra com o banco (`shareAcrossIsolates`), então ficam para depois.
6. **Serviço em primeiro plano** (tipo `health`) **só se o teste 10/10 no S26 falhar.** Se for preciso, declare no manifesto `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_HEALTH` e `HIGH_SAMPLING_RATE_SENSORS`, com o serviço marcado como `foregroundServiceType="health"`. Assim o app não precisa pedir a permissão de "atividade física" ao usuário.
7. **Tela ligada** (`wakelock_plus`) apenas na tela de treino.
8. **Samsung:** a One UI coloca para "dormir" os apps parados. Mostre uma única vez um atalho para "Apps que nunca hibernam" (Configurações → Bateria → Limites de uso em segundo plano).

**Critério de aceite:** em 10 de 10 testes de 3 minutos com o S26 bloqueado, o alerta vibra e toca no máximo 2 s depois do horário.

### 6.6 Backup (crítico desde o MVP)

Sem servidor, o celular é o **único** lugar onde os dados existem. As fotos da pasta privada **somem ao desinstalar**, e o backup automático do Android tem limite de 25 MB.

- **Exportar** gera um ZIP com `db.sqlite` (uma cópia consistente feita com `VACUUM INTO`), a pasta `photos/` e um `manifest.json` (versão do app, versão do schema, contagens e data). O arquivo vai para o Drive, para um e-mail seu ou para o PC, pelo compartilhamento ou pelo seletor de pastas.
- **Restaurar:** o app valida o manifest, fecha o banco, troca o arquivo e as fotos e reabre. O próprio Drift migra backups de versões antigas. Não há modo "mesclar", que só faz sentido quando existir sync.
- **Cópia automática antes de cada atualização do app:** ao abrir numa build nova, o app copia o banco para `backups/pre_<build>.sqlite` e mantém as 3 últimas.
- **Lembrete:** "último backup há X dias", a cada 7 dias durante o alfa.
- **Backup automático do Android:** inclui o banco e exclui `photos/` (`dataExtractionRules` + `fullBackupContent`).
- **Teste de ida e volta:** exportar, desinstalar, reinstalar e importar precisa dar as mesmas contagens.

### 6.7 App de desenvolvimento × app do dia a dia (não perca seus treinos)

- No `android/app/build.gradle.kts`, a build **debug** recebe `applicationIdSuffix = ".dev"` e o nome "Caderno DEV". O `flutter run` instala um **app separado, com dados separados**.
- O app que vai para a academia é **release**, assinado com a sua **keystore de release**. Para gerar e instalar:
  1. `flutter build apk --release`
  2. `adb install -r build\app\outputs\flutter-apk\app-release.apk` (o `adb` fica em `<SDK>\platform-tools`)
- ⚠️ **Não use `flutter install` para atualizar esse app.** Ele **desinstala a versão anterior antes de instalar** (`flutter_tools/lib/src/commands/install.dart`), e isso apaga o banco e as fotos.
- Evite também `flutter run --release`: se a instalação falhar, ele desinstala e instala de novo.
- Se o `adb install -r` recusar por assinatura diferente, **pare e confira a keystore**. Nunca desinstale.
- Exporte um backup antes de cada atualização.

---

## 7. Regras de negócio (cada uma vira teste unitário)

### 7.1 Dupla progressão
A ficha define uma faixa, por exemplo 3 × 8–12.
- Se **todas** as séries válidas da última vez na estação chegaram ao topo da faixa, a sugestão é **carga + 1 incremento do aparelho**, voltando ao fundo da faixa.
- Se não chegaram, a sugestão é **a mesma carga**, buscando +1 rep nas séries que ficaram abaixo do topo.
- O app só sugere; nunca muda nada sozinho.

### 7.2 1RM estimado
- **Epley:** `carga × (1 + reps/30)`. **Brzycki** (opcional): `carga × 36 / (37 − reps)`. As duas dão o mesmo valor com 10 reps: 100 kg × 10 ≈ 133,3.
- Só para séries de **1 a 10 reps**. Com 1 rep, o resultado é a própria carga.
- Sempre aparece rotulado como "estimado", porque o erro pode passar de 10%.

### 7.3 Esforço
Guarde o **RIR**. Se o usuário preferir RPE, converta com `RPE = 10 − RIR`.

### 7.4 Gordura pela fórmula da Marinha (v0.2; medidas em cm, log na base 10)
- **Homens:** `495 / (1,0324 − 0,19077·log(abdômen − pescoço) + 0,15456·log(altura)) − 450`, com o abdômen medido no umbigo. Valide que abdômen > pescoço.
- **Mulheres:** `495 / (1,29579 − 0,35004·log(cintura + quadril − pescoço) + 0,22100·log(altura)) − 450`, com a cintura medida no ponto mais estreito e o quadril no ponto mais largo. Valide que cintura + quadril > pescoço.
- **O peso não é entrada.** Ele só entra depois: massa gorda = peso × %, e massa magra = peso − massa gorda.
- Mostre o resultado com a margem de **±3,5 a 4 pontos** e guarde as medidas brutas.
- **Teste:** um homem com 178 cm de altura, pescoço de 38 cm e abdômen de 85 cm tem ≈ **16,44%**.

### 7.5 Gasto calórico (v0.3)
Mifflin-St Jeor (kg, cm, anos):
- **Homens:** `10·P + 6,25·A − 5·I + 5`
- **Mulheres:** `10·P + 6,25·A − 5·I − 161`

Multiplique por um fator de atividade entre 1,2 e 1,9 e ajuste pela tendência do peso em 2 a 4 semanas. Mostre o aviso "não é orientação médica".

### 7.6 Volume semanal (v0.2)
Cada série conta 1 para o músculo primário e 0,5 para cada secundário. O painel é informativo, não é prescrição.

### 7.7 Recordes
Por estação, sem contar séries de aquecimento. São recalculados quando você edita uma sessão antiga.

---

## 8. Roadmap

Premissa de tempo: **meio período (8 a 10 h/semana), aprendendo Flutter junto.** As estimativas podem errar de 30% a 50%. Se faltar tempo, **corte escopo, não qualidade**.

### Semana 0: preparar o terreno (veja a seção 9)
O critério de pronto é o `flutter run` abrindo o app "olá" no S26. Inclui um **teste rápido do timer** (2 a 3 horas): um app mínimo que mostra a contagem regressiva com o celular bloqueado e toca o alerta de fim. Assim o maior risco técnico é resolvido primeiro.

### Fatia 1, "Alfa na academia" (cerca de 3 a 4 semanas) — ✅ implementada (código pronto em 19/10/2026; falta usar na academia)
- Catálogo com cerca de 70 exercícios em PT-BR. A busca ignora acentos ("extensora" encontra "Cadeira extensora"). Dá para criar um exercício a partir da própria busca.
- Academias e aparelhos: unidade, incremento, carga por lado ou total.
- **Estação com ajustes** (número com passo, ou texto) e **histórico de mudanças**. O cartão de ajustes aparece **sem nenhum toque**, antes da primeira série, e a zona do polegar repete os ajustes da máquina da vez.
  - *Decisão na implementação:* não há botão "Igual à última vez". Os valores mostrados **já são** os da última vez: se nada mudou, você não toca em nada (0 toques em vez de 1). Se mudou, toca no ajuste (2 toques), e a mudança entra no histórico.
- **Treino livre:** + exercício, depois escolher o aparelho.
- Séries com a coluna **Anterior**. Concluir custa 1 toque. Os steppers usam o incremento do aparelho. Os tipos de série são aquecimento, normal, drop e falha.
- Desfazer por 5 s, editar uma série, adicionar ou trocar exercício e trocar o aparelho quando o seu estiver ocupado.
- Nota "como foi" e tag fácil/ok/difícil/dor. A nota da última vez reaparece em cinza.
- Timer **dentro do app**, com a tela ligada. O fim do descanso vibra forte e toca o som de notificação do celular (canal nativo em `MainActivity.kt`), em qualquer tela do app. A notificação na tela bloqueada vem na Fatia 2.
- **Retomar o treino** depois que o app fechar.
- **Exportar backup.**

**Pronto quando:** você levar o app para a academia e treinar com ele. Anote o que irritou.

### Fatia 2, "Fichas e timer de verdade" (cerca de 3 a 4 semanas) — ✅ implementada (26/10/2026)
- Fichas A/B/C (com professor, vencimento e observações) e a próxima ficha sugerida, que inicia com **1 toque**.
- Séries pré-preenchidas com a **sugestão por dupla progressão**.
- **Timer com notificação na tela bloqueada** (seção 6.5), com o teste 10/10.
- Resumo do treino: duração, volume e **recordes novos**.
- Histórico por data, por ficha e por exercício. Tela da estação com as séries, os recordes e o histórico de ajustes.
- Foto do aparelho e do ajuste, guardada na pasta privada.
- **Restaurar backup**, cópia automática antes de cada atualização e lembrete.

**v0.1 pronto = você treinou 8 vezes seguidas sem voltar ao caderno de papel.**

### Fatia 3, "O que os concorrentes têm" — ✅ implementada (26/10/2026)
Comparação feita em 26/10/2026 (base: `docs/pesquisa/04-concorrentes-e-ux.md`) entre o que o app já faz e o que Hevy, Strong, Fitbod e Smart Fit oferecem. Entraram as lacunas de uso **na academia**, que custam pouco e não mexem no banco:
- **Recorde na hora** (Hevy): vibração forte e aviso ao concluir a série que bate a carga máxima ou o 1RM estimado da estação. Conta as séries de hoje, para não comemorar duas vezes.
- **Aquecimento calculado** (Strong; no Hevy é pago): rampa até a carga planejada (1 série: 60% × 6; 2: 50/75%; 3: 40/60/80%), arredondada para baixo no passo do aparelho. Sem carga planejada, repete o aquecimento da última vez.
- **Calculadora de anilhas** (Hevy, Strong): sem toque nenhum, a zona do polegar mostra "Cada lado: 20 + 1,25" em barra, Smith e máquina de anilhas. A carga anotada não inclui a barra (que fica em "Carrinho/barra").
- **Gráfico de evolução** por estação (fl_chart): carga máxima ou 1RM estimado. Era da v0.2; adiantado.
- **Constância** (Hevy; o Smart Fit tirou e recebeu reclamação): dias na semana, semanas seguidas e calendário de 5 semanas.
- **Salvar treino como ficha** (Hevy "Save as routine").

**Lacunas que ficam para depois** (e onde entram):
| Lacuna | Quem tem | Onde |
|---|---|---|
| Bi-set / tri-set com rolagem para o par | Hevy, Strong | ✅ Fatia 4 |
| Cardio e exercícios por tempo/distância (esteira, bike, prancha) — schema v2 | Hevy, Strong | ✅ Fatia 4 |
| Botões +15 s / Pular na notificação do descanso | Hevy | v0.4 (junto do Live Update) |
| Anilhas que a SUA academia tem (inventário) | pedido no r/Hevy | quando a calculadora padrão incomodar |
| Medidas, fotos com sobreposição, % de gordura | Hevy (pago), Strong | v0.2 |
| Volume semanal por músculo | Hevy | v0.2 |
| Exportar CSV / importar do Strong | Hevy, Strong | v0.2 |
| Widget, Health Connect, relógio | Hevy, Strong | v0.4 |
| Vídeos/GIFs de execução | Smart Fit, Hevy | fora (licença e tamanho) |
| Social, ranking | Smart Fit | nunca |

### Fatia 4, "Bi-set e cardio" — ✅ implementada (26/10/2026)
- **Bi-set/tri-set** na ficha e no treino: exercícios vizinhos com o mesmo `supersetGroup`. Regra pura em `core/domain/superset.dart` (juntar, separar, normalizar depois de mover/remover, próxima série). Depois de cada série vai para o par sem descanso; descansa ao fechar a rodada.
- **Schema v2:** `exercises.tracking` (carga × reps, tempo, tempo e distância), `workout_sets.duration_sec` e `distance_m`. Migração `stepByStep` gerada pelo `drift_dev make-migrations` (snapshots em `drift_schemas/`, teste em `test/drift/`), conferida também numa cópia do banco real do S26.
- **Catálogo v2:** esteira, bicicleta ergométrica e horizontal, elíptico, escada, remo ergômetro (cardio), pular corda e prancha (por tempo); filtro "Cardio" no seletor.
- Cardio entra com 1 série e sem descanso; não conta para recordes nem para o gráfico de carga.

### v0.1.1 (pequenos extras)
Inventário de anilhas da academia (a calculadora padrão entrou na Fatia 3); reordenar a ficha arrastando já existe.

### v0.2, Evolução física — ✅ implementada (26/10/2026)
*Como ficou:* schema v3 (`body_checkins`, `body_values` com uma linha por medida × 1000, `body_photos` com caminho relativo). Medidas da fita, da balança de bioimpedância (digitadas a partir do app da balança, ex.: OKOK) e a impedância bruta (para quando a leitura por Bluetooth chegar). Tendência do peso = média exponencial que respeita o intervalo entre pesagens (α = 0,1/dia). Perfil (sexo, altura, ano) em `app_prefs`. Fotos pelo pacote `camera`, com a anterior em transparência. Lembrete semanal inexato. CSV com BOM, `;` e vírgula decimal.

### v0.2.1, Ler a balança de bioimpedância (OKOK/Chipsea) — 🟡 beta (26/10/2026: formatos de anúncio prontos; falta testar com a balança real e o modelo com conexão)
Pesquisa de 26/10/2026: o app OKOK International (`com.chipsea.btcontrol.en`) **não** sincroniza composição corporal com o Health Connect no Android, não exporta CSV e exige conta. O caminho bom é ler a **balança** direto:
- Balanças "broadcast" (nomes ADV / Chipsea-BLE / Yoda): o peso (e às vezes a impedância) vem no *manufacturer data* do anúncio BLE, **sem parear** — dá para ler junto com o app OKOK. Formatos conhecidos pelo openScale: IDs 0x20CA (peso + impedância), 0x11CA, 0xF0FF e `xxC0`.
- Balanças GATT "Chipsea-BLE" (serviço 0xFFF0): conectam, recebem sexo/idade/altura e devolvem a composição já calculada pela balança.
- **Não copiar código do openScale (GPL-3)**: reimplementar a partir da descrição do protocolo. Composição a partir da impedância só com equações publicadas, rotuladas como estimativa.
- Primeiro passo: identificar a variante (tela "Procurar balança" com os anúncios crus).
- Alternativa sem código: openScale + openScale-sync → Health Connect → NodeFit lê o Health Connect (v0.4); perde gordura visceral e % de músculo.

### v0.2 — plano original
- Check-in semanal ou quinzenal com lembrete inexato. Esse lembrete pode atrasar: no Android 12+ a janela de um alarme inexato é de pelo menos 10 minutos, e a One UI adia mais se o app ficar uns 3 dias sem uso (daí a dica "Apps que nunca hibernam"). Para um check-in semanal isso basta, então dispensa a permissão de alarme exato.
- Peso e medidas configuráveis: pescoço, abdômen no umbigo, cintura natural, quadril, braço, coxa, panturrilha e peito.
- % de gordura pela Marinha (seção 7.4), com massa gorda e magra.
- Fotos de frente, lado e costas **fora da Galeria**, com a foto anterior em transparência para alinhar a pose.
- Gráficos com fl_chart: peso com tendência, medidas, 1RM estimado por estação e volume semanal por músculo.
- CSV para planilha (separador `;`, vírgula decimal, UTF-8 com BOM para o Excel em pt-BR).

### v0.3, Dieta (em três partes, que podem vir **antes** da v0.2 se a dieta for prioridade)
- **v0.3a, Seguir o plano** (cerca de 2 semanas): o plano do nutricionista como refeições com horário, opções e substituições em texto, mais a foto do plano em papel. Tem lembrete no horário e marcação **feito / parcial / pulado** com 1 toque. Não precisa de base de alimentos.
- **v0.3b, Diário de macros** (3 a 4 semanas): **TACO 4ª ed.** offline, convertida do xlsx oficial do NEPA/UNICAMP (597 alimentos, valores por 100 g, com a fonte citada). Inclui adição rápida que fica salva, favoritos e metas por Mifflin-St Jeor. **A TBCA não pode ser usada**, porque os termos proíbem reproduzir e alterar.
- **v0.3c, Código de barras** (1 a 2 semanas): Open Food Facts, com créditos e licença ODbL, User-Agent próprio e no máximo 15 leituras por minuto. A base tem cerca de 37 mil produtos brasileiros, então o cadastro manual continua como alternativa.

### v0.4, Integrações Android e Samsung
- **Health Connect** (pacote `health`): **lê** peso, % de gordura e passos que o Samsung Health sincroniza da balança ou do Galaxy Watch, e **grava** um resumo do treino. Exige minSdk 26, `FlutterFragmentActivity` e uma tela de política de privacidade. O Health Connect não guarda séries, reps nem circunferências, então essas informações continuam no app.
- **Live Update** (Android 16+): o timer aparece na barra de status. Segundo relatos da imprensa, ele também aparece no Now Bar da Samsung, mas não há documentação oficial, então confirme no S26. Exige um trecho pequeno em Kotlin.
- **Widget** na tela inicial: "Próxima: Ficha B · Iniciar".
- **Distribuir para até 20 aparelhos** pela conta gratuita "Limited Distribution", com o pacote já registrado na Semana 0 (seção 9.3). Isso prepara o app para a expansão global da verificação, prevista para 2027 e ainda sem data. A partir dela, instalar um app não registrado sem adb vai exigir o registro ou o "fluxo avançado" (configuração única, espera de 24 h e um aviso a cada instalação).

### v1.0, Nuvem e outras plataformas (opcional)
- **Sincronização opcional** com login, de verdade e só nessa hora. Supabase e PowerSync ainda precisam ser avaliados. É aqui que entram a **LGPD** (consentimento destacado para dados de saúde, política de privacidade, exportação e exclusão de conta) e a tabela de *tombstones*.
- **iPhone:** Mac com Xcode ou Codemagic, e o Apple Developer Program por US$ 99/ano para instalar de forma prática.
- **PC com Windows:** Visual Studio com "Desktop development with C++", o Modo de Desenvolvedor do Windows e o pacote `msix`. A tela grande é ótima para **montar fichas e ver gráficos**.
- **Google Play** (se quiser): US$ 25, verificação de identidade e **teste fechado com 12 testadores por 14 dias seguidos**.

### Depois (reavaliar quando chegar lá)
- Importar PDF de ficha ou dieta com IA **no próprio S26**: Gemini Nano pela Prompt API (beta), via o plugin comunitário `google_mlkit_genai_prompt`. Você sempre revisa o resultado antes de salvar.
- Wear OS, alongamento guiado e fotos de refeição.
- Importar o CSV do Strong.
- **Nunca:** anúncios, ranking social, venda de dados.

---

## 9. Semana 0: checklist

### 9.1 No PC: três problemas encontrados no seu ambiente

1. ✅ **Pasta do projeto** (resolvido em 14/10). O projeto saiu do OneDrive da empresa e de "Área de Trabalho" e foi para **`C:\Dev\App Academia`**: ASCII, fora do OneDrive. A documentação já está em `docs/`.
   - O espaço em "App Academia" costuma funcionar. Como o nome da pasta não é um nome de pacote Dart válido, o projeto será criado com `--project-name`.
   - Se alguma ferramenta reclamar do espaço no primeiro build, renomeie a pasta para `C:\Dev\app_academia`.
2. ✅ **Caminhos com "ã"** (resolvido em 14/10). O seu usuário do Windows tem "ã", e as ferramentas nativas (NDK, CMake) costumam quebrar com isso.
   - O SDK foi **copiado** para `C:\Android\Sdk`. O Flutter (`flutter config --android-sdk`) e o Android Studio (`options\android.sdk.path.xml` e `jdk.table.xml`) já apontam para lá. O backup da configuração antiga do Android Studio está em `%APPDATA%\Google\AndroidStudio2025.3.3\_backup_sdk_path_2026-10-14`.
   - Variáveis de ambiente de usuário criadas: `ANDROID_HOME=C:\Android\Sdk`, `PUB_CACHE=C:\pub-cache` e `GRADLE_USER_HOME=C:\gradle`. Os caches do pub e as distribuições do Gradle foram copiados para os caminhos novos.
   - **Reabra o terminal, o VS Code e o Android Studio** para eles enxergarem as variáveis.
   - O SDK antigo continua em `%LOCALAPPDATA%\Android\Sdk`. Depois que o primeiro build funcionar, você pode apagá-lo e liberar cerca de 2 GB.
3. ✅ **Gradle: "Unable to establish loopback connection"** (resolvido em 14/10). O Java cria sockets locais na pasta temporária, que também tem "ã". Corrigido com a variável de usuário `JAVA_TOOL_OPTIONS=-Djdk.net.unixdomain.tmpdir=C:\gradle\tmp` e com `C:\gradle\gradle.properties`. Terminais abertos antes da mudança precisam ser reabertos.
4. ⏳ **SDK incompleto** (falta você fazer). O `flutter doctor` acusa a falta do **cmdline-tools** e as licenças ainda não foram aceitas.
   - Abra o Android Studio → More Actions → **SDK Manager** e confira que o "Android SDK Location" mostra `C:\Android\Sdk`.
   - Na aba *SDK Tools*, marque **Android SDK Command-line Tools (latest)**. Na aba *SDK Platforms*, marque **Android 16 (API 36)**. Depois clique em Apply. O NDK o Gradle baixa sozinho, já no caminho novo, e o CMake não é necessário.
   - Num terminal novo, rode `flutter doctor --android-licenses` e aceite as licenças. Depois confira com `flutter doctor -v`.

**Também:**
- [ ] `flutter upgrade`, para ir de 3.47.1 a **3.47.7**, no mesmo canal estável. Não use a beta.
- [ ] Instalar o **driver USB da Samsung** no Windows.
- [ ] Escolher o editor: o VS Code já está pronto (atualize a extensão Dart). No Android Studio, instale o plugin Flutter.
- [ ] O JDK já está resolvido: o JBR 21 do Android Studio atende o mínimo de Java 17. Não instale outro.
- [ ] **Só quando for fazer a versão de PC:** Visual Studio Community com "Desktop development with C++" e o Modo de Desenvolvedor do Windows.

### 9.2 No Galaxy S26
- [ ] Configurações → Sobre o telefone → Informações do software → tocar **7 vezes** em "Número de compilação".
- [ ] Opções do desenvolvedor → **Depuração USB**. Se quiser, ative também a **Depuração sem fio** e pareie pelo QR code do Android Studio ("Pair devices over Wi-Fi").
- [ ] Segurança e privacidade → **Bloqueador automático (Auto Blocker): desligado**, inclusive a opção de religar sozinho, se ela existir. Nunca ative "Restrições máximas". Com o bloqueador ligado, a depuração USB fica cinza.
- [ ] Conferir em Atualização de software: o S26 provavelmente já está, ou vai estar em breve, na One UI 9 (Android 17).

### 9.3 Decisões do projeto (permanentes)
- [ ] **Nome e `applicationId` definitivos**, por exemplo `io.github.<seu-usuario>.<app>`. Nunca use `com.example`. Comando, dentro de `C:\Dev\App Academia`: `flutter create --org io.github.<seu-usuario> --project-name <app> --platforms android .`. iOS e Windows entram depois com `flutter create --platforms=ios,windows .`.
- [ ] Na `build.gradle.kts`: `minSdk = 26`, compileSdk e targetSdk 36 (o padrão), desugaring ligado e o sufixo `.dev` na build debug.
- [ ] **Keystore de release** criada e com **cópia fora do PC**. Sem ela você não registra o pacote no Google e não consegue atualizar o app sem desinstalar.
- [ ] **Registrar o nome do pacote já agora** na conta gratuita "Limited Distribution" do Android Developer Console. Ela pede uma conta Google com verificação em 2 etapas e um perfil de pagamentos, mas não cobra taxa nem pede documento. O Google só aceita nomes de pacote que o Android **ainda não viu**, então deixar para depois tem o risco de o nome não ser mais aceito.
- [ ] `git init` e um repositório **privado**. Nunca versione `key.properties`, `*.jks` nem backups exportados.
- [ ] **Fotografe 3 páginas do seu caderno de papel antigo.** São o melhor documento de requisitos que você tem e viram dados de teste: fichas reais e ajustes de uns 10 aparelhos.

---

## 10. Distribuição: o que é grátis e o que custa

| Caminho | Custo | Observações |
|---|---|---|
| Seu S26 via cabo ou Wi-Fi (`flutter run`, `adb install`) | Grátis | **Isento** da verificação de desenvolvedor, também no Brasil. |
| APK enviado por arquivo | Grátis | Provavelmente ainda instala em 2026, mas o Bloqueador automático barra. A expansão global está prevista para 2027. |
| Conta "Limited Distribution" (Android Developer Console) | Grátis | Até 20 aparelhos autorizados, sem documento. É o melhor caminho para amigos ou para um avaliador. |
| Google Play | US$ 25 (uma vez) | Exige documento e teste fechado com 12 testadores por 14 dias. O target API 36 já atende. |
| iPhone | US$ 99/ano + Mac ou CI | Não dá para gerar o app de iPhone no Windows. Com Apple ID grátis, o app expira em 7 dias e funciona em no máximo 3 aparelhos. |
| Windows | Grátis | Pacote `msix`. O cadastro de desenvolvedor individual na Microsoft Store é grátis. |

---

## 11. Riscos e como evitar

| Risco | Como evitar |
|---|---|
| **Escopo infinito** ("app completo") | Versões fechadas, o `IDEIAS.md` e o critério dos 8 treinos reais antes da próxima versão. |
| **Perder dados** | Gravar a cada toque, estado do treino no banco, backup ZIP, cópia antes de cada atualização, app *dev* separado, keystore guardada. |
| **Curva de aprendizado** | Fatias verticais (uma função de ponta a ponta por vez), uma biblioteca nova por vez, documentação oficial em vez de tutorial velho. |
| **Timer falhando no Samsung** | Teste rápido na Semana 0, horário de término no banco, alarme `alarmClock`, dica "nunca hibernar" e teste 10/10. |
| **Modelo de dados errado** (ajuste preso ao exercício) | As estações da seção 5, validadas com os dados reais do seu caderno. |
| **Licenças de conteúdo** | Sem GIFs ou imagens raspadas. TACO com a fonte citada; TBCA não. Open Food Facts com créditos. |
| **Interpretar estimativa como valor exato** | Rótulo "estimado", faixa de erro e o aviso "não é orientação médica". |
| **LGPD** | Uso só seu, no aparelho, fica fora da lei (art. 4º, I). Antes de outras pessoas usarem, siga o checklist da v1.0. |

---

## 12. Se este também for o projeto da Fatec (a confirmar)

O plano do Gemini menciona a disciplina Programação para Dispositivos Móveis II. Se for o caso:

1. **Confirme a ementa e os critérios com o professor antes de cortar algo.** Se ele exigir login, API externa, câmera ou GPS, implemente o que agrega valor ao app:
   - câmera: fotos do aparelho e do shape;
   - API externa: Open Food Facts;
   - notificações: o timer.

   Login e mapa só entram como módulos isolados, **nunca com senha no código**.
2. **Documente a arquitetura:**
   - diagrama de camadas: telas → providers → repositórios → Drift;
   - diagrama de entidades da seção 5;
   - mapa de navegação;
   - ADRs curtos (registros de decisão) explicando por que Flutter, por que Drift, por que sem login e por que sem GIFs.
3. **Testes** (o ponto forte deste projeto):
   - unitários para todas as regras da seção 7;
   - de widget para a tela de treino;
   - de migração do Drift;
   - um teste do fluxo completo em modo avião.
4. **Qualidade visível:**
   - `flutter analyze` limpo;
   - CI no GitHub Actions;
   - commits pequenos;
   - um README com a Semana 0.
5. **Entrega instalável:** use adb na apresentação, ou a conta gratuita *Limited Distribution* para o avaliador instalar.

O **prazo** muda o fatiamento, porque talvez valha antecipar telas que contam ponto. Por isso essa é a primeira pergunta da seção 13.

---

## 13. Decisões pendentes (preciso das suas respostas)

1. **É para a Fatec?** Se for, qual o prazo e o que o professor exige?
2. **Nome do app e `applicationId`?** Por exemplo "NodeFit" + `io.github.<seu-usuario>.nodefit`.
3. ~~**Pasta do projeto**~~: resolvido, é `C:\Dev\App Academia`.
4. **Prioridade da dieta:** a v0.3a ("seguir o plano") vem antes ou depois da evolução física?
5. **Alguém de iPhone** precisa usar o app? Isso define quando pensar em Mac ou Codemagic.

---

## Fontes principais

As pesquisas completas, com nível de confiança e links, estão em `pesquisa/`.

- Verificação de desenvolvedor do Android e isenção do ADB: developer.android.com/developer-verification/guides/faq
- Versões dos pacotes: pub.dev (consultado em 14/10/2026)
- Drift e plataformas: drift.simonbinder.eu/platforms
- Hevy 3.2.0, notas fixadas: help.hevyapp.com
- Fórmula da Marinha: Hodgdon & Beckett (1984), via National Academies (IOM, 1998)
- TACO 4ª ed.: nepa.unicamp.br/publicacoes
- Open Food Facts (ODbL e limites da API): openfoodfacts.github.io/openfoodfacts-server/api
- LGPD: Lei 13.709/2018, arts. 4º, 5º, 11 e 18
