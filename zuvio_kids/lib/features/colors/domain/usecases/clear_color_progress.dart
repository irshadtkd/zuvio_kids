import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/color_repository.dart';

/// Clears color learning progress.
/// If [studentName] is provided, clears only that student's progress.
/// If omitted, clears all color progress across all profiles (used during logout).
/// Layer: Domain UseCase
class ClearColorProgress {
  const ClearColorProgress(this._repository);

  final ColorRepository _repository;

  Future<Either<Failure, void>> call([String? studentName]) {
    if (studentName != null && studentName.isNotEmpty) {
      return _repository.clearProgress(studentName);
    }
    return _repository.clearAll();
  }
}
