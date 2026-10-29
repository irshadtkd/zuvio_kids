import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../../domain/entities/animal_session_entity.dart';
import '../../domain/repositories/animals_repository.dart';
import '../datasources/animals_local_datasource.dart';

/// Repository implementation fulfilling [AnimalsRepository].
/// Layer: Data Repository Impl
class AnimalsRepositoryImpl implements AnimalsRepository {
  const AnimalsRepositoryImpl(this._dataSource);

  final AnimalsLocalDataSource _dataSource;

  @override
  Future<Either<Failure, List<AnimalSessionEntity>>> getSessions() async {
    try {
      final sessions = await _dataSource.getSessions();
      return right(sessions);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSessionCompleted(
    String sessionId,
    int stars,
  ) async {
    try {
      await _dataSource.saveSessionCompleted(sessionId, stars);
      return right(null);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetProgress() async {
    try {
      await _dataSource.resetProgress();
      return right(null);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(UnexpectedFailure(message: e.toString()));
    }
  }
}
