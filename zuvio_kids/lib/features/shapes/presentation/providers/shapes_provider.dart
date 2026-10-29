import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/features/shapes/data/datasources/shape_local_datasource.dart';
import 'package:zuvio_kids/features/shapes/data/datasources/shape_local_datasource_impl.dart';
import 'package:zuvio_kids/features/shapes/data/repositories/shape_repository_impl.dart';
import 'package:zuvio_kids/features/shapes/domain/repositories/shape_repository.dart';
import 'package:zuvio_kids/features/shapes/domain/usecases/clear_shape_progress.dart';
import 'package:zuvio_kids/features/shapes/domain/usecases/complete_shape_session.dart';
import 'package:zuvio_kids/features/shapes/domain/usecases/get_shape_progress.dart';
import 'package:zuvio_kids/features/shapes/domain/usecases/get_shape_sessions.dart';
import 'shapes_notifier.dart';
import 'shapes_state.dart';

/// Local data source provider for Shapes learning.
final shapeLocalDataSourceProvider = Provider<ShapeLocalDataSource>(
  (ref) => const ShapeLocalDataSourceImpl(),
);

/// Repository provider for Shapes learning.
final shapeRepositoryProvider = Provider<ShapeRepository>(
  (ref) => ShapeRepositoryImpl(ref.watch(shapeLocalDataSourceProvider)),
);

/// Use case providers
final getShapeSessionsUseCaseProvider = Provider<GetShapeSessions>(
  (ref) => GetShapeSessions(ref.watch(shapeRepositoryProvider)),
);

final getShapeProgressUseCaseProvider = Provider<GetShapeProgress>(
  (ref) => GetShapeProgress(ref.watch(shapeRepositoryProvider)),
);

final completeShapeSessionUseCaseProvider = Provider<CompleteShapeSession>(
  (ref) => CompleteShapeSession(ref.watch(shapeRepositoryProvider)),
);

final clearShapeProgressUseCaseProvider = Provider<ClearShapeProgress>(
  (ref) => ClearShapeProgress(ref.watch(shapeRepositoryProvider)),
);

/// Main Riverpod notifier provider managing Shapes learning state.
final shapesNotifierProvider =
    AsyncNotifierProvider<ShapesNotifier, ShapesState>(
  ShapesNotifier.new,
);

/// Derived provider exposing the child's total earned shapes stars.
final shapesStarsProvider = Provider<int>((ref) {
  final state = ref.watch(shapesNotifierProvider).valueOrNull;
  return state?.totalStars ?? 0;
});
