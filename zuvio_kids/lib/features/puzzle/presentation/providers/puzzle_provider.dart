import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/puzzle_local_datasource.dart';
import '../../data/datasources/puzzle_local_datasource_impl.dart';
import '../../data/repositories/puzzle_repository_impl.dart';
import '../../domain/repositories/puzzle_repository.dart';
import 'puzzle_notifier.dart';
import 'puzzle_state.dart';

/// Provider for local data source.
final puzzleLocalDataSourceProvider = Provider<PuzzleLocalDataSource>((ref) {
  return const PuzzleLocalDataSourceImpl();
});

/// Provider for puzzle repository.
final puzzleRepositoryProvider = Provider<PuzzleRepository>((ref) {
  final localDataSource = ref.watch(puzzleLocalDataSourceProvider);
  return PuzzleRepositoryImpl(localDataSource: localDataSource);
});

/// Main provider exposing puzzle state and operations.
final puzzleNotifierProvider =
    AsyncNotifierProvider<PuzzleNotifier, PuzzleState>(() {
  return PuzzleNotifier();
});
