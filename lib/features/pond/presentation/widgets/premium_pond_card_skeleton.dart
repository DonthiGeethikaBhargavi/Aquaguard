import 'package:flutter/material.dart';

import '../../../../core/widgets/premium_shimmer.dart';

class PremiumPondCardSkeleton extends StatelessWidget {
  const PremiumPondCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        color: Colors.white.withOpacity(0.02),

        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          //////////////////////////////////////////////////////
          /// HEADER
          //////////////////////////////////////////////////////
          Row(
            children: [
              const PremiumShimmer(width: 140, height: 20),

              const Spacer(),

              PremiumShimmer(
                width: 52,
                height: 26,

                borderRadius: BorderRadius.circular(100),
              ),
            ],
          ),

          const SizedBox(height: 26),

          //////////////////////////////////////////////////////
          /// METRICS
          //////////////////////////////////////////////////////
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: const [
                    PremiumShimmer(width: 72, height: 34),

                    SizedBox(height: 12),

                    PremiumShimmer(width: 90, height: 14),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: const [
                    PremiumShimmer(width: 62, height: 34),

                    SizedBox(height: 12),

                    PremiumShimmer(width: 84, height: 14),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          //////////////////////////////////////////////////////
          /// FOOTER
          //////////////////////////////////////////////////////
          const PremiumShimmer(width: double.infinity, height: 52),
        ],
      ),
    );
  }
}
