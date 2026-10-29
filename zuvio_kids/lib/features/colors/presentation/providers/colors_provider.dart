import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/features/colors/data/datasources/color_local_datasource.dart';
import 'package:zuvio_kids/features/colors/data/datasources/color_local_datasource_impl.dart';
import 'package:zuvio_kids/features/colors/data/repositories/color_repository_impl.dart';
import 'package:zuvio_kids/features/colors/domain/repositories/color_repository.dart';
import 'package:zuvio_kids/features/colors/domain/usecases/clear_color_progress.dart';
import 'package:zuvio_kids/features/colors/domain/usecases/complete_color_session.dart';
import 'package:zuvio_kids/features/colors/domain/usecases/get_color_progress.dart';
import 'package:zuvio_kids/features/colors/domain/usecases/get_color_session.dart';
import 'colors_notifier.dart';
import 'colors_state.dart';

/// Local data source provider
final colorLocalDataSourceProvider = Provider<ColorLocalDataSource>(
  (ref) => const ColorLocalDataSourceImpl(),
);

/// Repository provider
final colorRepositoryProvider = Provider<ColorRepository>(
  (ref) => ColorRepositoryImpl(
    ref.watch(colorLocalDataSourceProvider),
  ),
);

/// Use case providers
final getColorSessionUseCaseProvider = Provider<GetColorSession>(
  (ref) => GetColorSession(ref.watch(colorRepositoryProvider)),
);

final getColorProgressUseCaseProvider = Provider<GetColorProgress>(
  (ref) => GetColorProgress(ref.watch(colorRepositoryProvider)),
);

final completeColorSessionUseCaseProvider = Provider<CompleteColorSession>(
  (ref) => CompleteColorSession(ref.watch(colorRepositoryProvider)),
);

final clearColorProgressUseCaseProvider = Provider<ClearColorProgress>(
  (ref) => ClearColorProgress(ref.watch(colorRepositoryProvider)),
);

/// Main state notifier provider for Colors module
final colorsNotifierProvider =
    AsyncNotifierProvider<ColorsNotifier, ColorsState>(
  ColorsNotifier.new,
);

/// Derived provider exposing current student's total colors stars
final colorsStarsProvider = Provider<int>((ref) {
  final state = ref.watch(colorsNotifierProvider).valueOrNull;
  return state?.totalStars ?? 0;
});
