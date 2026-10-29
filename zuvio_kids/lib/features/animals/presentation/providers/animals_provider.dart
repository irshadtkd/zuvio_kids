import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/animals_local_datasource.dart';
import '../../data/datasources/animals_local_datasource_impl.dart';
import '../../data/repositories/animals_repository_impl.dart';
import '../../domain/repositories/animals_repository.dart';
import '../../domain/usecases/get_animal_sessions.dart';
import '../../domain/usecases/reset_animals_progress.dart';
import '../../domain/usecases/save_animal_session_progress.dart';
import 'animals_notifier.dart';
import 'animals_state.dart';

/// Local data source provider for animals
final animalsLocalDataSourceProvider = Provider<AnimalsLocalDataSource>(
  (ref) => const AnimalsLocalDataSourceImpl(),
);

/// Repository provider for animals
final animalsRepositoryProvider = Provider<AnimalsRepository>(
  (ref) => AnimalsRepositoryImpl(ref.watch(animalsLocalDataSourceProvider)),
);

/// Use case: Get animal sessions
final getAnimalSessionsUseCaseProvider = Provider<GetAnimalSessions>(
  (ref) => GetAnimalSessions(ref.watch(animalsRepositoryProvider)),
);

/// Use case: Save animal session progress
final saveAnimalSessionProgressUseCaseProvider =
    Provider<SaveAnimalSessionProgress>(
  (ref) => SaveAnimalSessionProgress(ref.watch(animalsRepositoryProvider)),
);

/// Use case: Reset animals progress
final resetAnimalsProgressUseCaseProvider = Provider<ResetAnimalsProgress>(
  (ref) => ResetAnimalsProgress(ref.watch(animalsRepositoryProvider)),
);

/// State notifier provider for animals
final animalsNotifierProvider =
    AsyncNotifierProvider<AnimalsNotifier, AnimalsState>(
  AnimalsNotifier.new,
);
