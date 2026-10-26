import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/features/alphabet/presentation/providers/alphabet_provider.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/session_card.dart';
import 'package:zuvio_kids/features/home/presentation/widgets/star_badge.dart';

/// Hub screen showing the 4 Alphabet Learning Sessions:
/// 1. Capital Letters (A–L)
/// 2. Capital Letters (M–Z)
/// 3. Small Letters (a–l)
/// 4. Small Letters (m–z)
/// Layer: Presentation Screen
class AlphabetHubScreen extends ConsumerWidget {
  const AlphabetHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final alphabetState = ref.watch(alphabetNotifierProvider).valueOrNull;
    final sessions = alphabetState?.sessions ?? [];
    final totalStars = alphabetState?.totalStars ?? 0;
    final notifier = ref.read(alphabetNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.appSkyBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar: Back Button + Title + Star Badge ─────────────────
              Row(
                children: [
                  Semantics(
                    button: true,
                    label: l10n.btnBack,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.navy,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      l10n.titleAlphabet,
                      style: AppTextStyles.headerTitle.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  StarBadge(stars: totalStars),
                ],
              ),
              const SizedBox(height: 24),

              // ── Heading ───────────────────────────────────────────────────
              Text(
                l10n.alphabetSessionsHeading,
                style: AppTextStyles.base.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 16),

              // ── 4 Sessions List ───────────────────────────────────────────
              Expanded(
                child: sessions.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return SessionCard(
                            session: session,
                            onTap: () {
                              notifier.selectSession(session.id);
                              Navigator.pushNamed(
                                context,
                                AppRoutes.alphabetLearning,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
