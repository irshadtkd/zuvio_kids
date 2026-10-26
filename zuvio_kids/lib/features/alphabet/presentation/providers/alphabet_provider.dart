import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/features/alphabet/data/datasources/alphabet_local_datasource.dart';
import 'package:zuvio_kids/features/alphabet/data/datasources/alphabet_local_datasource_impl.dart';
import 'package:zuvio_kids/features/alphabet/data/repositories/alphabet_repository_impl.dart';
import 'package:zuvio_kids/features/alphabet/domain/repositories/alphabet_repository.dart';
import 'package:zuvio_kids/features/alphabet/domain/usecases/clear_alphabet_progress.dart';
import 'package:zuvio_kids/features/alphabet/domain/usecases/complete_alphabet_session.dart';
import 'package:zuvio_kids/features/alphabet/domain/usecases/get_alphabet_progress.dart';
import 'package:zuvio_kids/features/alphabet/domain/usecases/get_alphabet_sessions.dart';
import 'alphabet_notifier.dart';
import 'alphabet_state.dart';

/// Local data source provider
final alphabetLocalDataSourceProvider = Provider<AlphabetLocalDataSource>(
  (ref) => const AlphabetLocalDataSourceImpl(),
);

/// Repository provider
final alphabetRepositoryProvider = Provider<AlphabetRepository>(
  (ref) => AlphabetRepositoryImpl(
    ref.watch(alphabetLocalDataSourceProvider),
  ),
);

/// Use case providers
final getAlphabetSessionsUseCaseProvider = Provider<GetAlphabetSessions>(
  (ref) => GetAlphabetSessions(ref.watch(alphabetRepositoryProvider)),
);

final getAlphabetProgressUseCaseProvider = Provider<GetAlphabetProgress>(
  (ref) => GetAlphabetProgress(ref.watch(alphabetRepositoryProvider)),
);

final completeAlphabetSessionUseCaseProvider =
    Provider<CompleteAlphabetSession>(
  (ref) => CompleteAlphabetSession(ref.watch(alphabetRepositoryProvider)),
);

final clearAlphabetProgressUseCaseProvider = Provider<ClearAlphabetProgress>(
  (ref) => ClearAlphabetProgress(ref.watch(alphabetRepositoryProvider)),
);

/// Main state notifier provider for Alphabet module
final alphabetNotifierProvider =
    AsyncNotifierProvider<AlphabetNotifier, AlphabetState>(
  AlphabetNotifier.new,
);

/// Derived provider exposing current student's total stars
final alphabetStarsProvider = Provider<int>((ref) {
  final state = ref.watch(alphabetNotifierProvider).valueOrNull;
  return state?.totalStars ?? 0;
});
