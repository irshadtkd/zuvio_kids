# ZuvioKids — Project-Wide Development Rules

These rules are **always active** for every prompt, code generation, modification,
refactoring, and feature implementation in this project. No rule may be bypassed
unless the user explicitly overrides it in the current message.

---

## 1. Clean Architecture — Layer Boundaries

The codebase is organised into **three strict layers**. Every file must live in
exactly one layer and must only depend on layers below it.

```
lib/
├── core/                     # Shared cross-cutting concerns
│   ├── constants/            # AppStrings, AppColors, AppSizes, AppRoutes
│   ├── errors/               # Failure, AppException, ErrorHandler
│   ├── extensions/           # Dart/Flutter extension methods
│   ├── theme/                # AppTheme, AppTextStyles
│   ├── l10n/                 # ARB files + generated localizations
│   ├── utils/                # Pure utility functions
│   └── widgets/              # Globally reusable widgets
│
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── datasources/  # Remote & local data sources (abstract + impl)
│       │   ├── models/       # Data-layer DTOs with fromJson/toJson/fromEntity/toEntity
│       │   └── repositories/ # Repository implementations
│       ├── domain/
│       │   ├── entities/     # Pure Dart entity classes (no Flutter, no json)
│       │   ├── repositories/ # Abstract repository interfaces
│       │   └── usecases/     # One use case per file, single call() method
│       └── presentation/
│           ├── providers/    # Riverpod providers (notifier + state)
│           ├── screens/      # Full-screen widgets (one per route)
│           └── widgets/      # Feature-scoped reusable widgets
│
└── main.dart                 # Entry point only — no logic here
```

### Layer dependency rules
- **Presentation** may only import from `domain` and `core`.
- **Data** may only import from `domain` and `core`.
- **Domain** must have **zero** imports from `data`, `presentation`, or any
  Flutter SDK package (except `dart:` libraries).
- `core/` may only import other `core/` sub-packages and `dart:` / `flutter:`
  packages. It must never import from `features/`.

---

## 2. Riverpod — State Management

- Use **`flutter_riverpod`** (>=2.x with code generation via `riverpod_annotation`
  and `riverpod_generator` where applicable).
- Every provider must be defined in the `presentation/providers/` folder of its
  feature or in `core/providers/` for cross-feature providers.
- Prefer **`AsyncNotifierProvider`** for async state, **`NotifierProvider`** for
  sync state, and **`Provider`** for pure derived values.
- Use **`ref.watch`** inside build methods; **`ref.read`** only in callbacks and
  one-time initialisations.
- Never use `setState` in feature screens — all UI state must flow through
  Riverpod.
- Expose **`AsyncValue<T>`** from notifiers so screens can handle
  `loading / data / error` states uniformly.
- Invalidate or refresh providers explicitly; avoid stale-data bugs.

---

## 3. Error Handling

- All errors must be modelled as a sealed `Failure` class hierarchy in
  `core/errors/failure.dart` (e.g., `NetworkFailure`, `CacheFailure`,
  `ValidationFailure`, `UnexpectedFailure`).
- Repository methods must return **`Either<Failure, T>`** using the `fpdart`
  package (or equivalent). No raw exceptions should escape a repository.
- Use cases propagate `Either<Failure, T>` unchanged.
- Notifiers unwrap `Either` and map failures to user-facing messages via
  `core/errors/error_handler.dart`.
- User-facing error messages must always come from the localised strings.

---

## 4. Localisation (i18n / l10n)

- The app must support **English (`en`)** and **Malayalam (`ml`)** at all times.
- Use **Flutter's official `flutter_localizations` + `intl`** package approach:
  - ARB files live in `lib/core/l10n/` (`app_en.arb`, `app_ml.arb`).
  - Generated classes are referenced as `AppLocalizations.of(context)!`.
- **Never hardcode any user-facing string** directly in a widget or business-logic
  file. Every string — label, heading, button text, instruction, error message,
  tooltip, placeholder, notification — must have an entry in the ARB files and be
  referenced via the generated class.
- When adding a new string:
  1. Add the key+value to `app_en.arb`.
  2. Add the translated key+value to `app_ml.arb`.
  3. Reference it in code via `AppLocalizations.of(context)!.keyName`.

---

## 5. Centralised Constants & Theming

- **`AppStrings`** — Non-localised internal constants (route names, asset paths,
  preference keys). Never used for UI-facing strings.
- **`AppColors`** — All colour definitions. No raw `Color(0x...)` literals in
  widgets.
- **`AppSizes`** — Spacing, border-radius, icon sizes. No magic numbers in
  widgets.
- **`AppTextStyles`** — All `TextStyle` definitions that extend `AppTheme`.
- **`AppRoutes`** — Named route constants and the route generator.
- **`AppTheme`** — `ThemeData` factory. All theme modifications go here.

---

## 6. Code Quality & Lint

- The project uses `flutter_lints` + additional strict rules in
  `analysis_options.yaml`. All generated and edited code **must pass
  `flutter analyze` with zero warnings or errors**.
- Prohibited patterns:
  - `print()` — use the logger at `core/utils/app_logger.dart`.
  - Unused imports, variables, parameters.
  - `dynamic` types unless absolutely unavoidable with a documented reason.
  - `// ignore:` comments unless there is a documented, unavoidable reason.
  - `late` without a compelling reason; prefer nullable + null-safety patterns.
  - `BuildContext` across async gaps — always check `mounted` before using
    `context` after an `await`.

---

## 7. SOLID Principles & Naming

- **S** — Every class has one responsibility. Large classes must be split.
- **O** — Prefer extension and composition over modifying existing classes.
- **L** — Subtypes must be substitutable for their base types.
- **I** — Define narrow interfaces; avoid fat abstract classes.
- **D** — Depend on abstractions (`abstract class` / `interface`), not concretes.
- Naming conventions:
  - Files: `snake_case.dart`
  - Classes: `PascalCase`
  - Variables/methods: `camelCase`
  - Constants: `camelCase` for Dart `const`
  - Private members: `_camelCase`

---

## 8. Reusable Widgets & Components

- Any widget used in more than one feature must be extracted to
  `core/widgets/`.
- Every reusable widget must:
  - Accept only the data it needs via constructor parameters.
  - Never depend on a Riverpod provider directly (pass data in; let the screen
    read the provider).
  - Be documented with a one-line comment describing its purpose.

---

## 9. Performance

- Prefer `const` constructors wherever possible.
- Use `RepaintBoundary` around widgets with expensive repaints.
- Wrap granular state in the smallest possible `Consumer` / `ConsumerWidget`.
- Images must use `cached_network_image` or `flutter_cache_manager`.
- Dispose controllers, streams, and animation controllers in `dispose()`.

---

## 10. Scalability

- New features must be self-contained modules inside `lib/features/<feature>/`.
- No cross-feature direct imports — share only through `core/`.
- Adding a new locale requires only a new ARB file — no widget changes.
- New student levels or modules require only a new feature folder and route.

---

## 11. Skills Reference

When creating new files → skill **`zuvio-feature-scaffold`**.
When adding localised strings → skill **`zuvio-localisation`**.
When implementing error handling → skill **`zuvio-error-handling`**.

---

## 12. Pre-Submission Checklist

- [ ] Files in correct layer/folder per folder structure above.
- [ ] No user-facing strings hardcoded; all in ARB files.
- [ ] No raw colours, sizes, or text styles — use constants.
- [ ] Error handling via `Either<Failure, T>` in repositories.
- [ ] Riverpod providers for all UI state; no `setState` in screens.
- [ ] `flutter analyze` passes with zero issues.
- [ ] No `print()` statements.
- [ ] Reusable widgets in `core/widgets/` if used across features.
- [ ] Every new string in both `app_en.arb` and `app_ml.arb`.
