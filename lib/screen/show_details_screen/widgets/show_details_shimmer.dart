import 'package:flutter/material.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShowDetailsShimmer extends StatelessWidget {
  const ShowDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        /// 🔥 Image Header Shimmer
        SliverAppBar(
          backgroundColor: Colors.transparent,
          pinned: true,
          expandedHeight: AppSize.size.height * 0.28,
          flexibleSpace: FlexibleSpaceBar(
            background: AppShimmer(
              width: double.infinity,
              height: AppSize.size.height * 0.28,
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),

        /// 🔽 Body Shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppSize.width(value: 12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Merchant Info Row
                Row(
                  children: [
                    AppShimmer(
                      width: 48,
                      height: 48,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppShimmer(width: 160, height: 18),
                          const SizedBox(height: 8),
                          AppShimmer(width: double.infinity, height: 12),
                          const SizedBox(height: 8),
                          AppShimmer(width: 100, height: 14),
                        ],
                      ),
                    ),
                    AppShimmer(width: 90, height: 40),
                  ],
                ),

                const SizedBox(height: 20),

                /// Tier Info
                Row(
                  children: [
                    AppShimmer(
                      width: 34,
                      height: 34,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmer(width: 140, height: 14),
                        const SizedBox(height: 8),
                        AppShimmer(width: 100, height: 18),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// About Us
                AppShimmer(width: 120, height: 18),
                const SizedBox(height: 8),
                AppShimmer(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                AppShimmer(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                AppShimmer(width: 220, height: 12),

                const SizedBox(height: 24),

                /// Promotions Title
                AppShimmer(width: 220, height: 18),

                const SizedBox(height: 12),

                /// Promotion Cards
                ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, __) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppShimmer(
                        width: double.infinity,
                        height: 110,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(milliseconds: 300),
      color: Colors.grey.shade300,
      colorOpacity: 0.3,
      enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
