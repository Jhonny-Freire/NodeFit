> Pesquisa bruta (em inglês) feita em 14/10/2026 para embasar o PLANO.md. Cada item tem nível de confiança e fontes. As decisões finais estão no PLANO.md; este arquivo é só referência.

# Competitor UX research: workout loggers (Hevy, Strong, Fitbod, Smart Fit, Gaviões/EVO and niche machine-settings apps), nutrition apps (MyFitnessPal, MacroFactor, FatSecret, Tecnonutri, Dietbox, Smart Fit Nutri), Brazilian food data sources, common complaints, the gap for a notebook built around machine settings, and UX patterns for logging in the gym (research date 2026-10-14)

## 1. Hevy: how does it show previous performance while logging, and how do notes work? Does it store machine settings?
[verified]
Previous column: Hevy shows your earlier result for the same set number in a PREVIOUS column on the left. Tapping a previous value copies it into the current set. When you add an exercise you have done before, Hevy pre-fills the number of sets, the weight and the reps. A setting chooses the source: any past workout, or only the last time you did it in the same routine. One recent Reddit report says the 'Any Workout' option fails to show the last weight across routines.

Notes (changed very recently): Hevy 3.2.0, shipped around 13 Oct 2026, rebuilt notes into three types:
- Pinned to Exercise: written once, shown every time you do that exercise in any routine. The launch post names machine settings and form cues, with the example 'seat notch 7, pad on 3'. The goal it states is to stop retyping such notes.
- Pinned to Routine: specific to one program.
- Workout note: for that session only. It reappears as a greyed-out placeholder the next time you do the exercise.

All three are free text, tied to the exercise and not to a gym or a specific machine. No structured fields, photos or per-gym versions were found.

Roadmap: Hevy's July 2026 community update lists 'Gyms inside Hevy' (tagging the gym on a workout) as a first step toward gym features.

Unmet demand on r/Hevy:
- A user's gym swapped its cable machines, so the same stack numbers now mean about half the load. They want history separated by gym.
- A user wants a plate builder that uses only the plates they own.
- A user wants to swap a busy machine mid-workout.
Sources: https://www.hevyapp.com/features/track-workouts/ | https://www.hevyapp.com/features/workout-settings/ | https://help.hevyapp.com/hc/en-us/articles/36011779117591-How-to-Use-Exercise-Notes-in-Hevy-for-Better-Workout-Tracking | https://apps.apple.com/us/app/hevy-workout-tracker-gym-log/id1458862350 | https://redlib.groet-infra.nl/r/Hevy/top | https://redlib.groet-infra.nl/r/Hevy/new | https://www.hevyapp.com/community-updates/july-26/

## 2. Hevy: rest timer, supersets, routines, plate calculator, warm-ups, PRs, measurements and photos, offline, export, pricing
[verified]
Workout settings documented by Hevy:
- Default rest timer, set per exercise. It starts when you tick a set.
- Previous-values source (any workout or same routine).
- Warm-up calculator (Pro only): percentage-based, with plate and dumbbell rounding.
- Option to include or exclude warm-up sets from stats and PRs.
- Keep Awake During Workout.
- Plate calculator for barbell, EZ bar and short bar. It does not cover dumbbells.
- RPE column.
- Smart Superset Scrolling: jumps to the next exercise in the superset when you complete a set.
- Inline per-set timer for timed exercises.
- Live PR notification with adjustable volume.

Lock screen: a 'Live Activity' widget on iOS and Android shows the current exercise, the next set and the rest timer, with ±15 s and skip buttons. On Android it is a lock-screen notification you must enable. A 1.30.27 changelog added instructions for fixing background rest-timer problems on Android 14. Version 3.0.11 (May 2026) added more haptic feedback.

Supersets: from the exercise menu, choose 'Add To Superset'.

Measurements and photos: free accounts get body weight and waist. Pro adds body fat % and neck, shoulders, chest, biceps, forearms, abdomen, hips, thighs and calves. Progress photos are limited to one per day and have an overlay of the previous photo to line up the pose.

Export and import: CSV export of workouts or measurements. CSV import accepts only the Strong format.

Offline: no official statement found. Third-party sources contradict each other.

Free vs Pro (official help centre): the free tier allows 4 routines, 7 custom exercises and 3 months of history. Pro prices:
- US: $2.99 per month, $23.99 per year, $74.99 lifetime.
- Brazil App Store: R$12,90 per month, R$99,90 per year, R$429,90 lifetime. The app is available in Portuguese and rated 5.0 from about 25k ratings in Brazil.
Sources: https://www.hevyapp.com/features/workout-settings/ | https://help.hevyapp.com/hc/en-us/articles/35649846517399-How-to-Use-Hevy-s-Live-Activity-on-iOS-and-Android | https://www.apkmirror.com/apk/hevy-gym-workout-tracker/hevy-gym-log-workout-tracker/hevy-gym-log-workout-tracker-1-30-27-release/ | https://scout.appaloosa.io/en/apps/ios/com.hevyapp.hevy/history | https://help.hevyapp.com/hc/en-us/articles/35385479603479-Body-Composition-Tracking-Measurements-and-Progress-Photos | https://help.hevyapp.com/hc/en-us/articles/38001424401943-How-to-Import-Strong-App-CSV-Files-and-Export-Your-Data-in-Hevy | https://help.hevyapp.com/hc/en-us/articles/35119778922263-Hevy-Pro-Subscription-How-to-get-Pro-and-What-Does-It-Include | https://apps.apple.com/br/app/hevy-workout-tracker-gym-log/id1458862350

## 3. Strong: feature set, notes, previous values, rest timer, pricing
[likely]
From the App Store listing:
- Automatic rest countdown.
- Plate calculator and warm-up calculator.
- Supersets.
- Set tags: Warm Up, Failure, Drop Set.
- 1RM estimate, PRs, and volume and 1RM charts.
- Body measurements tracker (weight and other vitals, with Apple Health).
- Notes and progress pictures attached to workouts.
- CSV export to Notes or Email. Version 6.2.0 added options to include timers and notes.
- Cloud Sync backup.
- A standalone Apple Watch app.

Version 6.5.1 (early October 2026) added Live Activity and Dynamic Island for rest timers, on iOS only. I could not confirm how the rest timer behaves on the Android lock screen.

Not verified:
- An exercise-level pinned note. Only workout-level notes are documented. A 'sticky note' for rack pin settings belongs to a different app, Stronglifts, and per a search snippet is iOS-only.
- Exact behaviour of the previous column. A third-party review says it shows last session's weight and reps.

Free tier: unlimited logging, 3 custom routines. Charts are Pro-only according to a competitor's comparison, checked 8 Sep 2026.

Prices:
- US: $4.99 per month, $29.99 per year, $99.99 lifetime (older $79.99 SKUs also listed).
- Brazil App Store: from R$12,90 to R$18,90 per month and R$77,90 to R$117,90 per year, with 'Forever' at R$499,90 or R$599,90. Several SKUs are listed. Available in Portuguese; rated 4.8 from 916 ratings in Brazil.

Complaints in review aggregators: Apple Watch sync failures, and occasional workouts lost or deleted after updates. These are anecdotal.
Sources: https://apps.apple.com/us/app/strong-workout-tracker-gym-log/id464254577 | https://apps.apple.com/br/app/strong-workout-tracker-gym-log/id464254577 | https://www.sensai.fit/blog/fitness-app-pricing-free-tier-comparison | https://support.stronglifts.com/article/176-notes | https://justuseapp.com/en/app/464254577/strong-workout-tracker-gym-log/reviews | https://unitq.com/unitq-scorecards/strongworkouttracker

## 4. Fitbod: how it handles logging, notes, gym profiles, warm-ups, supersets, rest timer, offline, pricing
[verified]
Fitbod generates workouts with AI and adjusts weight, reps and sets from what you actually log.

Gym profiles: one per location. Each stores the available equipment, body stats and experience level. They do not store machine settings.

Notes: per-exercise notes (form cues, modifications) under the exercise's More > Notes. Past notes appear in the exercise's history Results tab.

Warm-ups: added automatically, but only to weighted exercises and only to the first exercise for each muscle group. You turn this on in My Plan > Training Format.

Supersets: Fitbod tags and logs supersets automatically.

Rest timer: starts after you log a set, with a tone or vibration. The help centre says the app must be open for the timer to sound, even with notifications on. This is a clear weakness.

Offline: you can generate, log and save workouts offline, and they sync later. Records and full history may be missing offline. Deleting the app before it syncs loses local data.

Price: there is no permanent free tier, only a 7-day trial. The US App Store lists $12.99 or $15.99 per month and $79.99 or $95.99 per year (the lower SKUs are legacy). Version 8.36.0 shipped in October 2026; rating 4.8 from 287k.
Sources: https://apps.apple.com/us/app/fitbod-gym-fitness-planner/id1041517543 | https://fitbod.me/blog/your-gym-profile/ | https://help.fitbod.me/hc/en-us/articles/30721437384215-How-to-Navigate-the-Exercise-Details-Screen | https://help.fitbod.me/hc/en-us/articles/360006337634-Warm-Up-Sets | https://help.fitbod.me/hc/en-us/articles/360006572594-Can-I-use-Fitbod-without-an-internet-connection | https://www.sensai.fit/blog/fitness-app-pricing-free-tier-comparison

## 5. Smart Fit app (Brazil): what it does and what users complain about
[likely]
Features (official Brazil App Store listing, version 4.9.22, October 2026):
- A workout plan built from an intake questionnaire ('anamnese').
- Exercise videos.
- You can 'anotar suas cargas, fazer comentários' (record loads and add comments), with progress charts.
- An occupancy chart for each gym unit.
- A Social tab with groups, challenges and a ranking.
- Trainer-made workouts from Smart Fit Coach and bioimpedance results from Smart Fit Body.
- Plan purchase and day pass.
- Nutrition partners under 'Smart Fit Mais'. The nutritionist service is a separate app, Smart Fit Nutri.
- Rating 4.8 from about 77k ratings. Android has more than 10M installs (third-party data).

The listing mentions no structured machine-setting field and no offline mode.

2026 review themes (aggregated by mwm.ai; overall 3.7 from 7,888 reviews):
- The workout in progress resets when you close the app or it goes to standby (versions 4.7.12, 4.8.5 and 4.8.6, April to May 2026).
- Slow loading and too many taps. One reviewer has to open each machine just to see its weight.
- The app needs internet and shows a black screen while content downloads.
- Features were removed (training calendar, weekly streak).
- Exercise order is fixed.
- Users request Apple Health and Apple Watch support.
Sources: https://apps.apple.com/BR/app/id1308265270 | https://mwm.ai/pt/apps/smart-fit-app/1308265270 | https://apps.apple.com/app/id1442126612

## 6. Does a 'Gaviões' gym-chain app exist, and what about Skyfit?
[verified]
Yes. 'Academia Gaviões' is on the Brazil App Store (iPhone only). The seller is Academia os Gavioes do Karate LTDA, the copyright line is '© 2019 by W12 Inovações Tecnológicas', and the privacy policy is hosted at evo.w12.com.br. It is a white-label student app for gyms that run the EVO management system.

It lets students view:
- Their workout: exercises, loads, reps, form tips and the date the plan expires ('vencimento do treino').
- Class schedule with check-in, booking and waitlist.
- Plans and payments.
- Physical assessment results.
- A timeline of posts.
- CrossFit WODs, PRs and rankings.

Rating 4.8 from about 3k. Version 2.0.647 is dated 24 Feb (year not shown). Visible complaints: it asks for login every time despite Face ID, and the design looks amateurish.

I found no Google Play listing, and no sign that students can log their own loads (the trainer's plan is read-only). In April 2026 Gaviões launched a separate brand, Fast Treino (machine-guided 36-minute circuits), whose app handles payment, check-in, instructions and progress history.

Skyfit's app is the same kind of EVO/W12 white-label: workouts, class schedule and check-in. Rating 4.7 from about 4.2k. One review asks for photos of the machines.
Sources: https://apps.apple.com/BR/app/id1491967041 | https://apps.apple.com/BR/app/id1635144202 | https://mercadoeconsumo.com.br/27/04/2026/servicos/academia-gavioes-24h-lanca-rede-focada-em-treinos-intensos-com-precos-a-partir-de-r-39/

## 7. Do apps with structured machine settings already exist? Is there evidence of demand?
[likely]
Niche apps exist, all on iOS:
- Rackord (rackord.app): a 'setup card' for each machine with settings such as seat height, pin position and back-pad notch, plus notes and photos. Sets pre-fill from the last session; it has a rest timer with strong vibration, form-check video, PR badges, and keeps data on the phone with no account. Per-gym support is not mentioned and pricing is not stated.
- MyGym Sessions: per-gym machine setups ('seat height, settings'), RPE and tempo, optional weekly front/side/back photos with alignment guides, export and backup. Free. Version 1.0 was 21 Jul 2026 and 1.2.2 was 23 Sep; not enough ratings yet.
- My GymMachine Binder: one card per machine (seat height, handle position and so on), listed as 'coming soon' for 3 Jun 2026. The listing now returns 404, so its status is unverified.

I found no Android app that clearly offers structured machine settings.

Gym-side systems: EGYM smart machines save seat position and weight per member and adjust automatically when you tap in with a band or card. A search snippet says PerfectGym's member platform stores a 0–99 value for each device setting (seat height, seat incline); I could not open that page.

Demand signals:
- ABC Trainerize idea 'Cell for seat height or cable settings': posted Jan 2017, 16 votes.
- ABC Trainerize idea 'Equipment settings': Feb 2023, 6 votes. Comments ask for formats like 'Seat 3, Arm 1' and note the same weight feels different on different machines.
- Whoop community request for per-exercise notes on rack pin positions.
- Hevy's 3.2.0 pinned notes, presented as one of its most requested features.
Sources: https://rackord.app/ | https://apps.apple.com/us/app/mygym-sessions/id6790164588 | https://ideas.abcfitness.com/forums/940789-client-gym-members-abc-trainerize/suggestions/17801866-cell-for-seat-height-or-cable-settings | https://ideas.abcfitness.com/forums/940789-client-gym-members-abc-trainerize/suggestions/46265611-equipment-settings | https://www.community.whoop.com/t/request-add-workout-notes-for-each-specific-exercise-in-strength-trainer/14697 | https://gymbox.com/facilities/egym/ | https://recsports.ufl.edu/egym/ | https://support.perfectgym.com/hc/en-001/articles/27571296673041-How-to-add-device-settings-to-exercises-of-a-training-plan | https://help.macrofactorapp.com/en/articles/300-set-up-your-gym-profiles

## 8. MyFitnessPal: nutritionist plans vs free logging, Brazilian food quality, barcode, quick add, complaints
[verified]
Free logging uses a crowdsourced database of more than 20.5M foods, with macro goals, recipes and meals. On the Brazil App Store, Premium includes the barcode scanner, intermittent fasting, custom macro goals, insights and no ads. Brazil Premium prices range from R$31,90 to R$329,90 across monthly and annual SKUs. Rating 4.9 from about 99k in Brazil; version 26.41.0 shipped in October 2026.

Barcode paywall: the scanner moved to Premium on 1 Oct 2022 and is still Premium. US prices are about $19.99 per month and $79.99 per year. I could not confirm a Premium+ meal-planner tier from an official source.

Nutritionist plans: there is no workflow for a plan prescribed by a nutritionist.

Data quality:
- A JMIR 2020 study, comparing against a Belgian food table, found energy and macros accurate (energy r=0.96) but cholesterol and sodium poor, and rejected 2.8% of entries as absurd.
- Duplicate entries are a known problem.
- I found no source that evaluates Brazilian foods or TACO alignment specifically.

Complaints (unstar.app, 27 Jul 2026, 202 negative US Google Play reviews):
- Paywall or formerly free features: 29%.
- Barcode paywall named specifically: 13%.
- 2026 redesign added taps: 11%.
- Sync and integrations failing: 10%.
- Ads, some of which block controls: 9%.
- Logouts and lost history: 8%.
- Food search failing: 7%.
Sources: https://apps.apple.com/BR/app/id341232718 | https://www.droid-life.com/2022/08/24/myfitnesspal-puts-barcode-scanner-behind-premium-paywall/ | https://unstar.app/blog/is-myfitnesspal-premium-worth-it-paywall-app-reviews-2026 | https://doaj.org/article/5f4740e901364065a8ce0d18bbe6f514

## 9. MacroFactor: logging methods, quick add, barcode coverage, pricing; MacroFactor Workouts
[likely]
Logging methods (help centre): barcode and label scanning, food search, Quick Add, 'Describe' (natural language or voice), and a Library of favourites, custom foods and recipes. AI photo logging is also available. You can start logging from widgets, a long-press on the app icon, or a '+' on any hour of the food timeline.

Quick Add takes kcal, protein, fat, carbs and alcohol, but quick adds are not saved for reuse.

MacroFactor claims MyFitnessPal needs about 1.5x more actions for common logging tasks. That figure is the company's own benchmark.

Barcode coverage: a search snippet attributed to MacroFactor's food-logger page lists strong support in the US, CA, UK, AU, IE, NZ, JP, FR and ES, with the label scanner as the fallback elsewhere. Brazil is not listed. The help article does not name countries.

Nutritionist plans: no workflow for one.

Pricing (official): $11.99 per month, $47.99 for 6 months, $71.99 per year for either app. A bundle with MacroFactor Workouts is $89.99 per year. There is no free tier, only a 7-day trial.

MacroFactor Workouts has gym profiles that store equipment, weight increments, bands and allowed or disallowed exercises. I found no documented seat or machine-setting field.
Sources: https://help.macrofactorapp.com/en/articles/215-how-to-log-food-in-macrofactor | https://macrofactor.com/new-food-logger/ | https://macrofactor.com/workouts/price/ | https://help.macrofactorapp.com/en/articles/393-how-macrofactor-subscriptions-and-bundles-work | https://help.macrofactorapp.com/en/articles/300-set-up-your-gym-profiles

## 10. Brazilian nutrition apps: nutritionist plan vs free logging (FatSecret, Tecnonutri, Dietbox, Smart Fit Nutri)
[likely]
FatSecret (Brazil App Store): core logging, the barcode scanner and weight tracking are free. It also has photo recognition. Premium adds meal plans made by nutritionists (keto, Mediterranean and others). Brazil prices range from R$37,90 to R$53,90 per month and R$82,90 to R$234,90 per year (several SKUs). Rating 4.9 from about 22k. The listing does not describe Brazilian food coverage.

Tecnonutri (Vitat): more than 50 programs with menus 'elaborados por nutricionistas', a calorie and macro diary, and weekday chat with nutritionists. Brazil prices run up to R$239,90 per year. Rating 4.6 from about 26k. The Brazil iOS listing's latest version is 5.1.3 from 7 Feb 2024, so it may be stagnant. No barcode scanner is mentioned.

Dietbox patient app: free for patients. The nutritionist registers the plan in Dietbox's professional software; the patient sees what to eat at each meal time, gets meal-time alerts and keeps a food diary. Rating 4.9 from about 71k; version 8.7.69 dated 1 Oct. Complaints: crashes on iOS 26.1, logged meals not saving, and a disliked 2024 redesign.

Smart Fit Nutri: a personalised plan from a nutritionist plus chat (terms by N2B; benefits last 12 months) and Smart Fit Body bioimpedance. No food diary or barcode is mentioned.

Nutritionist plans in Brazil usually come as meal slots with exchange or substitution lists and household measures. That is general practice; the sources here describe exchange lists and household-measure tables.
Sources: https://apps.apple.com/BR/app/id347184248 | https://www.fatsecret.com/br/aplicativo | https://apps.apple.com/BR/app/id574794938 | https://apps.apple.com/BR/app/id648610153 | https://www.reclameaqui.com.br/empresa/dietbox/faq/ | https://apps.apple.com/app/id1442126612 | https://anais-siiepe.ufpel.edu.br/2016/CS_03148.pdf | https://arquivos.sistemas.ufg.br/arquivos/202323520705d426578949a3badfbf988/Medidas_caseiras_atualizada.pdf

## 11. Which Brazilian food databases can a personal app use, and under what terms?
[likely]
TACO, 4th edition (NEPA/UNICAMP, 2011): about 500 foods, per Revista Pesquisa FAPESP; I could not confirm the exact count. The book allows full or partial reproduction 'desde que citada a fonte' (with the source cited). Commercial or in-app use is not addressed explicitly; the contact is taco@unicamp.br.

TBCA (USP/FoRC): version 7.3 has 6,182 foods and ingredients (Agência FAPESP, 30 Sep 2026). Free to look up, but a 2019 Jornal da USP note said using its database inside another tool requires a paid licence. Current terms are unverified.

Open Food Facts: about 36,957 products on br.openfoodfacts.org. The database is under ODbL, its contents under DbCL, and images under CC BY-SA. You must credit and link Open Food Facts, and derived databases must be share-alike. Official API limits are 15 product reads and 10 searches per minute per IP. A custom User-Agent in the form 'AppName/Version (email)' is required; reading needs no login.
Sources: https://www.nescon.medicina.ufmg.br/biblioteca/imagem/1549.pdf | https://revistapesquisa.fapesp.br/mesa-a-brasileira/ | https://agencia.fapesp.br/tabela-brasileira-de-composicao-de-alimentos-se-transforma-em-ecossistema-digital-de-pesquisa/59305 | https://jornal.usp.br/?p=268561 | https://world.openfoodfacts.org/terms-of-use | https://openfoodfacts.github.io/documentation/docs/Product-Opener/api/ | https://br.openfoodfacts.org/

## 12. Common user complaints across these categories
[likely]
1. Basics put behind a paywall: MyFitnessPal's barcode scanner (the most-cited single item); Hevy's routine and history caps; Strong's 3-routine limit and Pro-only charts; Fitbod's lack of any free tier; Hevy's circumference measurements being Pro-only.
2. Lost progress or data and reliance on the network: Smart Fit resets the workout in progress on close or standby and needs internet; MyFitnessPal logouts and lost history; Strong and Hevy watch and Apple Health sync failures; Dietbox diary entries not saving.
3. Too many taps or slow flows: MyFitnessPal's 2026 redesign; Smart Fit's slow loading and having to open each machine to see its weight; OpenTrainer's write-up on keyboard round-trips for every set.
4. Timers that die in the background: Fitbod's timer needs the app open; Hevy's Android 14 background-timer fix; Samsung's 'put apps to sleep' and adaptive battery killing alarms (dontkillmyapp.com). That site says that since One UI 6.0, foreground services that follow Android 14 policy are guaranteed to run.
5. Ads blocking controls in MyFitnessPal.
6. Gym chain apps: forced login every time (Gaviões/EVO), dated design, fixed exercise order, removed features.
7. Load history that breaks when equipment changes: the Hevy user whose gym replaced its cable stacks.
Sources: https://unstar.app/blog/is-myfitnesspal-premium-worth-it-paywall-app-reviews-2026 | https://mwm.ai/pt/apps/smart-fit-app/1308265270 | https://apps.apple.com/BR/app/id1491967041 | https://help.fitbod.me/hc/en-us/articles/360006572594-Can-I-use-Fitbod-without-an-internet-connection | https://dontkillmyapp.com/samsung | https://dev.to/magnificode/building-opentrainer-real-time-workout-tracking-with-convex-and-nextjs-59h4 | https://redlib.groet-infra.nl/r/Hevy/new | https://apps.apple.com/BR/app/id648610153

## 13. What gap does a digital training notebook with structured settings per gym and machine fill, beyond Hevy/Strong notes?
[likely]
What now exists (Oct 2026): Hevy's free-text note pinned to an exercise, explicitly meant for machine settings; Fitbod's per-exercise notes; Strong's workout notes; and iOS-only niche apps (Rackord, MyGym Sessions).

Gaps still open:
(a) The machine is not its own record. Hevy and Fitbod attach notes to an abstract exercise ('Leg Press'), not to a specific machine at a specific gym. Someone who trains at two gyms, or whose gym swaps equipment, gets one note and one load history for different machines.
(b) Settings are not structured. Free text cannot pre-fill, check what changed, or show a 'Seat 7 → 8' history. Users ask for formats like 'Seat 3, Arm 1' (Trainerize) and 'seat notch 7, pad on 3' (Hevy).
(c) Load is not tied to the machine's own scale. Stack numbers, lb vs kg, cable pulley ratios and per-side loading make history comparable only for the same machine, as the Hevy cable-swap complaint shows.
(d) There are no photos of the machine or of where a setting sits.
(e) Nothing offline-first, in Portuguese, on Android. The niche apps are iOS-only, and Brazilian chain apps (Smart Fit, EVO-based Gaviões and Skyfit) show a trainer's plan, need internet, and lose sessions.
(f) The trainer's plan from the gym (Ficha A/B/C with an expiry date) cannot be entered and then annotated with your own settings and how each session went.

The window is narrowing: Hevy's roadmap adds gym tagging. Being better has to mean depth (machine as its own record, structured settings, per-machine history, photos, offline), not just having notes.
Sources: https://redlib.groet-infra.nl/r/Hevy/top | https://www.hevyapp.com/community-updates/july-26/ | https://ideas.abcfitness.com/forums/940789-client-gym-members-abc-trainerize/suggestions/17801866-cell-for-seat-height-or-cable-settings | https://rackord.app/ | https://apps.apple.com/us/app/mygym-sessions/id6790164588 | https://apps.apple.com/BR/app/id1491967041 | https://mwm.ai/pt/apps/smart-fit-app/1308265270

## 14. UX patterns for logging in the gym: one hand, tap targets, steppers vs keyboard, auto-fill, haptics, screen awake
[likely]
- Tap targets: Google recommends at least 48×48dp (about 9 mm) with 8dp or more between targets. Apple's HIG uses 44pt; WCAG 2.2 AA requires 24×24 CSS px.
- One-handed use: Hoober (UXmatters, 2013) observed 1,333 people. A secondary summary reports 49% one-handed, 36% cradled and 15% two-handed; I could not check these figures against the original.
- Steppers and custom keypad: Gript uses a lifting keyboard with weight steppers and ± rep buttons. Focusing the RPE/RIR field turns it into a one-tap grid, and you can 'log a whole set without lifting your thumb'. The OpenTrainer write-up describes the friction of tap field, wait for keyboard, type, dismiss for every value. An open-source logger PR added −/+ steppers that still open the numeric keypad, and review flagged that steppers must stay keyboard-focusable for accessibility.
- Auto-fill: Hevy copies previous values on tap and pre-fills sets; Rackord pre-fills from the last session; Gript shows placeholders that a quick 'complete' accepts.
- Haptics: Hevy 3.0.11 added more haptic feedback; Rackord uses strong vibration for the rest timer; Gript can vibrate when the timer ends with sound off; OpenTrainer cites haptics as confirmation with sweaty hands.
- Screen awake: Hevy has a 'Keep Awake During Workout' option. Android's guidance is FLAG_KEEP_SCREEN_ON on the activity, kept as short as possible. In Flutter, wakelock_plus 1.8.1 (BSD-3-Clause, fluttercommunity.dev) recommends enabling it only on the screens that need it.
- Lock-screen timer on Android: Live Updates are explicitly allowed for 'workouts… that the user starts'. Requirements: ongoing, a content title, setRequestPromotedOngoing, the POST_PROMOTED_NOTIFICATIONS permission, no custom RemoteViews, not colorized; ProgressStyle and MetricStyle are among the allowed styles. A status-bar chip can count down via setUsesChronometer and setChronometerCountdown (max 96dp). Press reports (not Samsung documentation) say One UI 8 adopted Live Updates for the Now Bar and One UI 9 surfaces them automatically.
- Exact alarms: SCHEDULE_EXACT_ALARM is denied by default for new installs targeting Android 13+ on Android 14.
- Hevy's lock-screen widget offers ±15 s and skip without unlocking the phone.
Sources: https://support.google.com/accessibility/android/answer/7101858 | https://www.uxmatters.com/mt/archives/2013/02/how-do-users-really-hold-mobile-devices.php | https://www.woshipm.com/ucd/57973.html | https://apps.apple.com/us/app/gym-log-workout-tracker-gript/id6760785452 | https://dev.to/magnificode/building-opentrainer-real-time-workout-tracking-with-convex-and-nextjs-59h4 | https://github.com/mondragon-developer/gym-tracker/pull/13 | https://developer.android.com/develop/background-work/background-tasks/awake/screen-on | https://pub.dev/packages/wakelock_plus | https://developer.android.com/develop/ui/views/notifications/live-update | https://www.androidauthority.com/one-ui-8-live-updates-support-3573794 | https://www.sammyfans.com/2026/05/21/samsung-now-bar-to-support-more-third-party-apps-in-one-ui-9/ | https://developer.android.com/about/versions/14/changes/schedule-exact-alarms | https://help.hevyapp.com/hc/en-us/articles/35649846517399-How-to-Use-Hevy-s-Live-Activity-on-iOS-and-Android

## 15. Body evolution: is the Gemini plan's Navy body-fat input set right, and what can Health Connect hold?
[likely]
The Gemini plan's inputs are wrong. The US Navy circumference formula (Hodgdon and Beckett) uses height, neck and waist for men, plus hip for women. Body weight is not an input.
- Men (inches): %BF = 86.010·log10(abdomen − neck) − 70.041·log10(height) + 36.76.
- Women: 163.205·log10(waist + hip − neck) − 97.684·log10(height) − 78.387.
The formula is undefined unless waist is larger than neck.

The Army's 2023 one-site test is a different method. It uses abdominal circumference and body weight; the AR 600-9 worksheet gives -26.97 − 0.12·weight(lb) + 1.99·abdomen(in) for men.

Health Connect has record types for:
- Weight, BodyFat, LeanBodyMass, BodyWaterMass, BoneMass, Height and BMR.
- ExerciseSession (strength or weightlifting types).
- Nutrition (macros and micronutrients, with meal type) and Hydration.
- PlannedExerciseSession, behind a feature flag.
It has no type for body circumferences such as waist or arm, so those must stay in the app.
Sources: https://med.libretexts.org/Courses/Irvine_Valley_College/Physiology_Labs_at_Home/03%3A_Anthropometrics/3.02%3A_Part_B-_Circumference_Measures/3.2.04%3A_Part_B4-_The_U.S._Navy_body_fat_estimation_formula | https://topendsports.com/testing/bodyfat-girths.htm | https://www.army.mil/article/267486 | https://www.nationalacademies.org/read/25128/chapter/3 | https://developer.android.com/health-and-fitness/guides/health-connect/plan/data-types

## IMPLICATIONS
- Data model: make Gym → Machine (equipment instance) its own record, separate from Exercise. A logged set belongs to an exercise done on a specific machine at a specific gym. Keep load history and PRs per exercise+machine by default, with an optional merged view, so a cable stack swap or a second gym does not corrupt progress. This is the one thing Hevy's new pinned notes (3.2.0, Oct 2026) cannot do.
- Structured settings per machine: user-defined fields, each with a type (number/notch, letter, pin hole, left/right side, free text) and an optional photo of where it sits. Keep a history of changes. On the active-set card, show the last-used settings at the top with a one-tap 'same as last time' confirmation, and let the user edit only the field that changed. Free-text notes remain alongside.
- Load unit per machine (kg, lb, stack plate number, per side vs total) and the machine's own increments. Steppers and the plate calculator use these: plate math uses the plates the user owns and also covers dumbbells, two gaps users raise with Hevy.
- Notes now need to match Hevy at minimum: pinned to exercise or machine, pinned to routine, and a per-session note ('how it went') that comes back as a read-only placeholder next time. Add quick tags (easy/ok/hard, pain/discomfort) so notes can be searched.
- The Gemini plan's 'Ghost mode' is just Hevy's PREVIOUS column. Treat it as a baseline: show the previous value next to every set, from the same exercise+machine with a 'same routine' option; tap to copy; pre-fill sets on start.
- Logging UX: a custom in-app number pad with ± steppers (machine increment for load, 1 for reps), big buttons (at least 48dp; aim for 56–64dp on the active-workout screen), primary actions in the bottom thumb zone, a haptic on set completion and when the timer ends, and keep-screen-on only while a workout screen is open (wakelock_plus). No keyboard round-trips for routine sets.
- Durability matters more than polish. Save every tapped set to local storage immediately (Drift/SQLite) so a workout survives the app closing or being killed; Smart Fit users complain that closing the app resets the workout. Make the app offline-first with no mandatory login. Drop the mock admin@nodefit.com login from the Gemini plan.
- Android rest timer for the S26: an ongoing notification eligible as a Live Update (setRequestPromotedOngoing, POST_PROMOTED_NOTIFICATIONS, chronometer countdown, ±15 s and Skip actions) so it can show on the lock screen and in the Now Bar. Do not rely on a Dart Timer alone. Use a foreground service that follows Android 14+ service-type policy, and a one-time prompt to exempt the app from Samsung battery optimisation. Verify Now Bar behaviour on a real device (unverified).
- Gym chain plan: let the user enter or copy the gym's Ficha A/B/C (with expiry date and trainer notes) as a routine, then add personal settings on top. Chain apps (Smart Fit, EVO-based Gaviões/Skyfit) only show the plan read-only.
- Body evolution: a weekly or every-two-weeks reminder; free circumferences (Hevy charges for these); progress photos with an overlay of the previous photo; and a Navy body-fat estimate using height, neck and waist (plus hip for women), not weight as the Gemini plan said. Label it an estimate. Optionally read weight and body fat from Health Connect (Galaxy Watch or scale). Circumferences stay in the app because Health Connect has no type for them.
- Nutrition, two modes: (1) 'Plano do nutricionista': meal slots with times, options and substitution lists in household measures, an adherence checklist and meal-time reminders, the Dietbox-style flow Brazilian patients know. (2) Free logging: search, quick add (saveable, unlike MacroFactor), favourites/repeat meal, and a free barcode scanner (the MyFitnessPal paywall is the top complaint).
- Food data: bundle TACO 4th edition offline with a visible citation, and confirm commercial use with NEPA/UNICAMP before any public release. Use Open Food Facts for barcodes with ODbL attribution, a custom User-Agent, local caching and the 15/min read limit. Do not use the TBCA database without a licence.
- Export and backup from day one: full JSON backup/restore plus CSV export. Consider importing Strong-format CSV, which works as the de facto interchange format (Hevy imports only that). This answers the sync-loss and lock-in complaints.
- Cut or defer from the Gemini plan: the 'Radar Health' GPS map of gyms and clinics, 20+ exercise GIFs (licensing and size), and 'Smart import' of PDFs through the Gemini API. The last sends health data to a third party; if import is wanted later, consider on-device OCR for nutritionist PDFs.
- Pricing context if this ever ships: Hevy Pro is R$12,90/month or R$99,90/year in Brazil, and its free tier is generous. Competing on price is pointless; compete on the Portuguese, offline, Android machine-notebook depth and keep every basic free.
