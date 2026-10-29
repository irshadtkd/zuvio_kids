import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/features/numbers/data/datasources/number_local_datasource.dart';
import 'package:zuvio_kids/features/numbers/data/datasources/number_local_datasource_impl.dart';
import 'package:zuvio_kids/features/numbers/data/repositories/number_repository_impl.dart';
import 'package:zuvio_kids/features/numbers/domain/repositories/number_repository.dart';
import 'package:zuvio_kids/features/numbers/domain/usecases/clear_number_progress.dart';
import 'package:zuvio_kids/features/numbers/domain/usecases/complete_number_session.dart';
import 'package:zuvio_kids/features/numbers/domain/usecases/get_number_progress.dart';
import 'package:zuvio_kids/features/numbers/domain/usecases/get_number_sessions.dart';
import 'numbers_notifier.dart';
import 'numbers_state.dart';

/// Local data source provider
final numberLocalDataSourceProvider = Provider<NumberLocalDataSource>(
  (ref) => const NumberLocalDataSourceImpl(),
);

/// Repository provider
final numberRepositoryProvider = Provider<NumberRepository>(
  (ref) => NumberRepositoryImpl(
    ref.watch(numberLocalDataSourceProvider),
  ),
);

/// Use case providers
final getNumberSessionsUseCaseProvider = Provider<GetNumberSessions>(
  (ref) => GetNumberSessions(ref.watch(numberRepositoryProvider)),
);

final getNumberProgressUseCaseProvider = Provider<GetNumberProgress>(
  (ref) => GetNumberProgress(ref.watch(numberRepositoryProvider)),
);

final completeNumberSessionUseCaseProvider = Provider<CompleteNumberSession>(
  (ref) => CompleteNumberSession(ref.watch(numberRepositoryProvider)),
);

final clearNumberProgressUseCaseProvider = Provider<ClearNumberProgress>(
  (ref) => ClearNumberProgress(ref.watch(numberRepositoryProvider)),
);

/// Main state notifier provider for Numbers module
final numbersNotifierProvider =
    AsyncNotifierProvider<NumbersNotifier, NumbersState>(
  NumbersNotifier.new,
);

/// Derived provider exposing current student's total numbers stars
final numbersStarsProvider = Provider<int>((ref) {
  final state = ref.watch(numbersNotifierProvider).valueOrNull;
  return state?.totalStars ?? 0;
});
