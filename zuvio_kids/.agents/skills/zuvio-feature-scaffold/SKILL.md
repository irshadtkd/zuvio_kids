---
name: zuvio-feature-scaffold
description: >-
  Use this skill whenever creating a new feature, adding a new screen, or
  scaffolding any new Dart/Flutter file in the ZuvioKids project. Provides
  exact file templates, naming conventions, and step-by-step instructions
  that comply with the ZuvioKids Clean Architecture + Riverpod standards.
---

# ZuvioKids Feature Scaffold Skill

Use this skill to scaffold any new feature end-to-end. Follow every step in
order. Do not skip steps.

---

## Step 1 — Determine the Feature Name

- Use `snake_case` for the folder name (e.g., `letter_tracing`, `number_quiz`).
- Create the following folder tree under `lib/features/<feature_name>/`:

```
lib/features/<feature_name>/
├── data/
│   ├── datasources/
│   │   ├── <feature>_remote_datasource.dart   # abstract interface
│   │   └── <feature>_remote_datasource_impl.dart
│   ├── models/
│   │   └── <feature>_model.dart
│   └── repositories/
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <feature>_entity.dart
│   ├── repositories/
│   │   └── <feature>_repository.dart          # abstract interface
│   └── usecases/
│       └── get_<feature>.dart                 # one use case per file
└── presentation/
    ├── providers/
    │   ├── <feature>_notifier.dart
    │   └── <feature>_provider.dart
    ├── screens/
    │   └── <feature>_screen.dart
    └── widgets/
        └── <feature>_card.dart               # example feature widget
```

---

## Step 2 — Domain Layer Templates

### Entity (`domain/entities/<feature>_entity.dart`)
```dart
// <FeatureName>Entity — pure Dart, no Flutter, no json dependencies
class <FeatureName>Entity {
  const <FeatureName>Entity({
    required this.id,
    // add fields
  });

  final String id;
  // add fields

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is <FeatureName>Entity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
```

### Repository Interface (`domain/repositories/<feature>_repository.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/<feature>_entity.dart';

abstract interface class <FeatureName>Repository {
  Future<Either<Failure, List<<FeatureName>Entity>>> getAll();
  // Add other methods as needed
}
```

### Use Case (`domain/usecases/get_<feature>.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/<feature>_entity.dart';
import '../repositories/<feature>_repository.dart';

/// Retrieves all [<FeatureName>Entity] items.
class Get<FeatureName> {
  const Get<FeatureName>(this._repository);

  final <FeatureName>Repository _repository;

  Future<Either<Failure, List<<FeatureName>Entity>>> call() =>
      _repository.getAll();
}
```

---

## Step 3 — Data Layer Templates

### Model (`data/models/<feature>_model.dart`)
```dart
import 'package:zuvio_kids/features/<feature>/domain/entities/<feature>_entity.dart';

class <FeatureName>Model extends <FeatureName>Entity {
  const <FeatureName>Model({
    required super.id,
    // add fields
  });

  factory <FeatureName>Model.fromJson(Map<String, dynamic> json) =>
      <FeatureName>Model(
        id: json['id'] as String,
        // parse fields
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        // serialize fields
      };

  factory <FeatureName>Model.fromEntity(<FeatureName>Entity entity) =>
      <FeatureName>Model(
        id: entity.id,
        // map fields
      );
}
```

### Abstract DataSource (`data/datasources/<feature>_remote_datasource.dart`)
```dart
import '../models/<feature>_model.dart';

abstract interface class <FeatureName>RemoteDataSource {
  Future<List<<FeatureName>Model>> getAll();
}
```

### DataSource Impl (`data/datasources/<feature>_remote_datasource_impl.dart`)
```dart
import 'package:zuvio_kids/core/errors/app_exception.dart';
import '<feature>_remote_datasource.dart';
import '../models/<feature>_model.dart';

class <FeatureName>RemoteDataSourceImpl implements <FeatureName>RemoteDataSource {
  const <FeatureName>RemoteDataSourceImpl(/* inject http client / dio */);

  @override
  Future<List<<FeatureName>Model>> getAll() async {
    try {
      // implement API call
      return [];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
```

### Repository Impl (`data/repositories/<feature>_repository_impl.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/features/<feature>/domain/entities/<feature>_entity.dart';
import 'package:zuvio_kids/features/<feature>/domain/repositories/<feature>_repository.dart';
import '../datasources/<feature>_remote_datasource.dart';

class <FeatureName>RepositoryImpl implements <FeatureName>Repository {
  const <FeatureName>RepositoryImpl(this._remoteDataSource);

  final <FeatureName>RemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<<FeatureName>Entity>>> getAll() async {
    try {
      final models = await _remoteDataSource.getAll();
      return right(models);
    } on ServerException catch (e) {
      return left(NetworkFailure(message: e.message));
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}
```

---

## Step 4 — Presentation Layer Templates

### Notifier State (`presentation/providers/<feature>_notifier.dart`)
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/features/<feature>/domain/entities/<feature>_entity.dart';
import 'package:zuvio_kids/features/<feature>/domain/usecases/get_<feature>.dart';

class <FeatureName>Notifier
    extends AsyncNotifier<List<<FeatureName>Entity>> {
  @override
  Future<List<<FeatureName>Entity>> build() async {
    return _fetch();
  }

  Future<List<<FeatureName>Entity>> _fetch() async {
    final useCase = ref.read(get<FeatureName>UseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) => throw failure,
      (entities) => entities,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}
```

### Provider (`presentation/providers/<feature>_provider.dart`)
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/features/<feature>/domain/entities/<feature>_entity.dart';
import 'package:zuvio_kids/features/<feature>/domain/usecases/get_<feature>.dart';
import 'package:zuvio_kids/features/<feature>/data/datasources/<feature>_remote_datasource_impl.dart';
import 'package:zuvio_kids/features/<feature>/data/repositories/<feature>_repository_impl.dart';
import '<feature>_notifier.dart';

// Data source provider
final <feature>RemoteDataSourceProvider =
    Provider</* DataSourceInterface */>(
  (ref) => <FeatureName>RemoteDataSourceImpl(),
);

// Repository provider
final <feature>RepositoryProvider =
    Provider<<FeatureName>Repository>(
  (ref) => <FeatureName>RepositoryImpl(
    ref.watch(<feature>RemoteDataSourceProvider),
  ),
);

// Use case provider
final get<FeatureName>UseCaseProvider = Provider<Get<FeatureName>>(
  (ref) => Get<FeatureName>(ref.watch(<feature>RepositoryProvider)),
);

// Notifier provider
final <feature>NotifierProvider =
    AsyncNotifierProvider<<FeatureName>Notifier, List<<FeatureName>Entity>>(
  <FeatureName>Notifier.new,
);
```

### Screen (`presentation/screens/<feature>_screen.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/errors/error_handler.dart';
import '../providers/<feature>_provider.dart';

class <FeatureName>Screen extends ConsumerWidget {
  const <FeatureName>Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(<feature>NotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.<featureTitle>)),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(ErrorHandler.getLocalizedMessage(error, context)),
        ),
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Text(item.id); // replace with proper widget
          },
        ),
      ),
    );
  }
}
```

---

## Step 5 — Register Route

In `core/constants/app_routes.dart`, add:
```dart
static const String <feature> = '/<feature>';
```

In `core/router/app_router.dart`, add the route case.

---

## Step 6 — Add Strings

Follow the **`zuvio-localisation`** skill to add all new strings.

---

## Step 7 — Verify

Run `flutter analyze` — zero warnings or errors expected.
