import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/color_progress_entity.dart';
import '../repositories/color_repository.dart';

/// Fetches the student's color learning progress.
/// Layer: Domain UseCase
class GetColorProgress {
  const GetColorProgress(this._repository);

  final ColorRepository _repository;

  Future<Either<Failure, ColorProgressEntity>> call(String studentName) =>
      _repository.getProgress(studentName);
}
