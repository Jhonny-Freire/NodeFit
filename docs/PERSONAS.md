# Personas do NodeFit

Quem usa o NodeFit e o que cada um precisa dele. As três pessoas abaixo são
fictícias, montadas a partir da pesquisa em `docs/pesquisa/` (reclamações dos
apps de academia, rotina de academias low-cost) e do uso real do app.

O ponto central: **só o aluno mexe no app.** O professor e o médico não têm
conta nem instalam nada. Eles recebem do aluno um **relatório em texto**
(WhatsApp, e-mail ou na tela do celular) feito para o que cada um precisa ver.
Isso mantém o app offline e deixa o aluno decidir o que compartilha, porque
dado de saúde é **dado sensível** pela LGPD (art. 5º, II).

---

## 1. Aluno — Lucas, 24 anos

> "Eu sei que fiz 40 kg na cadeira extensora... ou foi 45? E qual era a
> altura do banco mesmo?"

| | |
|---|---|
| **Quem é** | Estudante de tecnologia e estagiário. Treina 4×/semana numa academia low-cost perto do trabalho, às vezes em outra unidade da rede. |
| **Aparelho** | Android intermediário; sinal fraco dentro da academia. |
| **Objetivo** | Ganhar massa muscular e não "andar de lado" nas cargas. |
| **Como treina** | Ficha A/B/C montada pelo professor, trocada a cada 6–8 semanas. Descansa olhando o celular. |
| **Frustrações** | App da rede reseta o treino se a tela apaga; perde a carga da semana anterior; esquece a regulagem de cada máquina; caderno de papel molha e some. |
| **Precisa** | Registrar uma série em 1 toque, ver o "anterior" na hora, saber quando subir carga, guardar o ajuste de cada aparelho, **mostrar a evolução para o professor** e **levar os números ao médico** no check-up. |

**Jornada típica:** abre o app → inicia a próxima ficha sugerida → conclui as
séries (o app já sugere carga) → anota "como foi" e se sentiu dor →
finaliza e vê os recordes. Uma vez por semana, faz o check-in do corpo.

**O que isso muda no app:** tudo precisa funcionar offline e com poucos
toques; a conta é local; o compartilhamento é sempre uma ação dele.

---

## 2. Professor de educação física — Carla, 31 anos

> "Tenho 60 alunos no turno. Se você me mostrar em um minuto o que subiu e
> o que doeu, eu ajusto sua ficha na hora."

| | |
|---|---|
| **Quem é** | Instrutora com CREF, atende o salão da academia em turnos; também dá consultoria on-line pelo WhatsApp. |
| **Relação com o app** | **Não usa o app.** Olha o celular do aluno no salão ou recebe uma mensagem. |
| **Tempo disponível** | 1 a 2 minutos por aluno. |
| **Decisões que toma** | Trocar a ficha, subir ou baixar volume, substituir exercício que causa dor, cobrar frequência. |
| **Precisa ver** | Quantos treinos por semana (aderência); **por exercício: carga do começo × do fim do período** e repetições; **exercícios em que o aluno marcou dor**; comentários de esforço ("pesado", "fácil"); **quais fichas estão em uso e quando vencem**. |
| **Não precisa** | Peso corporal, fotos, medidas (a menos que o aluno queira). |

**O que isso muda no app:** um **Relatório para o professor** curto, em texto
puro (cabe numa mensagem), com período escolhido (4, 8 ou 12 semanas),
destacando dor e ficha vencida.

---

## 3. Médico — Dr. Ricardo, 52 anos

> "Atividade física é remédio. Mas eu preciso saber quanto você realmente
> faz, e não só 'eu vou na academia'."

| | |
|---|---|
| **Quem é** | Clínico / médico do esporte. Vê o paciente em consultas de ~15 min a cada 3–6 meses (check-up, liberação para atividade, acompanhamento de peso ou pressão). |
| **Relação com o app** | **Não usa o app.** Lê o relatório na consulta ou recebe antes por e-mail. |
| **Decisões que toma** | Liberar ou restringir atividade, pedir exames, orientar perda de peso, encaminhar (nutricionista, fisioterapia). |
| **Precisa ver** | Dados do paciente (idade, sexo, altura); **peso no início e no fim do período e a variação**; **IMC**; **circunferência da cintura/abdômen** (risco cardiometabólico); % de gordura **com a origem** (balança ou fita = estimativa); **minutos de atividade por semana** comparados à referência da OMS (150–300 min/semana de atividade moderada); **dores relatadas** durante o treino. |
| **Exige** | Datas claras, origem de cada número, aviso de que os dados são **registrados pelo próprio paciente** e que estimativas não substituem exames. |
| **Não precisa** | Carga de cada exercício, regulagem de máquina. |

**O que isso muda no app:** um **Relatório para o médico** separado, focado
em corpo e volume de atividade, com o aviso "não é orientação médica" e sem
detalhes de treino que só fariam volume.

---

## Resumo: o que cada um recebe

| Informação | Aluno (app) | Professor | Médico |
|---|:---:|:---:|:---:|
| Treinos por semana / constância | ✅ | ✅ | ✅ |
| Duração do treino e minutos por semana | ✅ | — | ✅ |
| Evolução de carga por exercício | ✅ | ✅ | — |
| Exercícios com dor | ✅ | ✅ | ✅ |
| Esforço e "como foi" | ✅ | ✅ | — |
| Fichas em uso e vencimento | ✅ | ✅ | — |
| Peso, IMC, cintura, % gordura | ✅ | — | ✅ |
| Fotos | ✅ | — | — |

## Decisões de produto tiradas das personas

1. **Uma conta, a do aluno.** Professor e médico não precisam de login; dar
   conta para eles exigiria servidor e sincronização, e o problema deles se
   resolve com um relatório.
2. **Relatórios separados por destinatário**, para não mandar dado de saúde
   para quem não precisa (LGPD: necessidade e minimização).
3. **Texto puro**, porque funciona em qualquer canal (WhatsApp, e-mail,
   impresso) sem instalar nada.
4. **Período escolhido pelo aluno** (4, 8 ou 12 semanas): o professor pensa
   no ciclo da ficha; o médico, no intervalo entre consultas.
5. **Prévia antes de enviar:** o aluno vê exatamente o que vai mandar.
