import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:zuvio_kids/features/onboarding/data/datasources/onboarding_local_datasource_impl.dart';
import 'package:zuvio_kids/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:zuvio_kids/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:zuvio_kids/features/onboarding/domain/usecases/clear_user_profile.dart';
import 'package:zuvio_kids/features/onboarding/domain/usecases/get_user_profile.dart';
import 'package:zuvio_kids/features/onboarding/domain/usecases/save_user_profile.dart';
import 'onboarding_notifier.dart';
import 'onboarding_state.dart';

/// Local data source provider
final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>(
  (ref) => const OnboardingLocalDataSourceImpl(),
);

/// Repository provider
final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryImpl(
    ref.watch(onboardingLocalDataSourceProvider),
  ),
);

/// Use case providers
final getUserProfileUseCaseProvider = Provider<GetUserProfile>(
  (ref) => GetUserProfile(ref.watch(onboardingRepositoryProvider)),
);

final saveUserProfileUseCaseProvider = Provider<SaveUserProfile>(
  (ref) => SaveUserProfile(ref.watch(onboardingRepositoryProvider)),
);

final clearUserProfileUseCaseProvider = Provider<ClearUserProfile>(
  (ref) => ClearUserProfile(ref.watch(onboardingRepositoryProvider)),
);

/// Onboarding State Notifier Provider
final onboardingNotifierProvider =
    AsyncNotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
