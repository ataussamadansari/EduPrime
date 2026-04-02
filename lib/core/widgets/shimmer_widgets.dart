import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_constants.dart';

// Base shimmer box
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = AppConstants.radiusSM,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A3A4A) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF3A4A5A) : const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

// ── Dashboard shimmer ─────────────────────────────────────────────────────────
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar shimmer
        const SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spaceMD,
              vertical: AppConstants.spaceSM,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 100, height: 12),
                      SizedBox(height: 6),
                      ShimmerBox(width: 160, height: 20),
                    ],
                  ),
                ),
                ShimmerBox(
                    width: 36, height: 36, radius: AppConstants.radiusFull),
                SizedBox(width: AppConstants.spaceSM),
                ShimmerBox(
                    width: 36, height: 36, radius: AppConstants.radiusFull),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        // Body shimmer
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(
                    width: double.infinity,
                    height: 155,
                    radius: AppConstants.radiusXL),
                const SizedBox(height: AppConstants.spaceLG),
                Row(
                  children: List.generate(
                      3,
                      (i) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: i < 2 ? AppConstants.spaceSM : 0),
                              child: const ShimmerBox(
                                  width: double.infinity,
                                  height: 80,
                                  radius: AppConstants.radiusLG),
                            ),
                          )),
                ),
                const SizedBox(height: AppConstants.spaceLG),
                const ShimmerBox(width: 160, height: 20),
                const SizedBox(height: AppConstants.spaceMD),
                ...List.generate(
                    2,
                    (_) => const Padding(
                          padding:
                              EdgeInsets.only(bottom: AppConstants.spaceMD),
                          child: ShimmerBox(
                              width: double.infinity,
                              height: 90,
                              radius: AppConstants.radiusLG),
                        )),
                const SizedBox(height: AppConstants.spaceSM),
                const ShimmerBox(width: 160, height: 20),
                const SizedBox(height: AppConstants.spaceMD),
                SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppConstants.spaceMD),
                    itemBuilder: (_, __) => const ShimmerBox(
                        width: 175, height: 230, radius: AppConstants.radiusLG),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Course list shimmer ───────────────────────────────────────────────────────
class CourseListShimmer extends StatelessWidget {
  final bool isGrid;
  const CourseListShimmer({super.key, this.isGrid = true});

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return GridView.builder(
        padding: const EdgeInsets.all(AppConstants.spaceMD),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: AppConstants.spaceMD,
          mainAxisSpacing: AppConstants.spaceMD,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const ShimmerBox(
            width: double.infinity,
            height: double.infinity,
            radius: AppConstants.radiusLG),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spaceMD),
      itemBuilder: (_, __) => const ShimmerBox(
          width: double.infinity, height: 90, radius: AppConstants.radiusLG),
    );
  }
}

// ── Profile shimmer ───────────────────────────────────────────────────────────
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spaceXXL),
          // Avatar
          const Center(
            child: ShimmerBox(
                width: 88, height: 88, radius: AppConstants.radiusFull),
          ),
          const SizedBox(height: AppConstants.spaceMD),
          const Center(child: ShimmerBox(width: 140, height: 20)),
          const SizedBox(height: 8),
          const Center(child: ShimmerBox(width: 200, height: 14)),
          const SizedBox(height: AppConstants.spaceLG),
          // Stats
          Row(
            children: List.generate(
                3,
                (i) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: i < 2 ? AppConstants.spaceSM : 0),
                        child: const ShimmerBox(
                            width: double.infinity,
                            height: 70,
                            radius: AppConstants.radiusLG),
                      ),
                    )),
          ),
          const SizedBox(height: AppConstants.spaceLG),
          // Menu items
          const ShimmerBox(
              width: double.infinity,
              height: 200,
              radius: AppConstants.radiusLG),
          const SizedBox(height: AppConstants.spaceMD),
          const ShimmerBox(
              width: double.infinity,
              height: 240,
              radius: AppConstants.radiusLG),
        ],
      ),
    );
  }
}

// ── List shimmer (generic) ────────────────────────────────────────────────────
class ListShimmer extends StatelessWidget {
  final int count;
  final double itemHeight;

  const ListShimmer({super.key, this.count = 5, this.itemHeight = 90});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spaceMD),
      itemBuilder: (_, __) => ShimmerBox(
          width: double.infinity,
          height: itemHeight,
          radius: AppConstants.radiusLG),
    );
  }
}

// ── Course detail shimmer ─────────────────────────────────────────────────────
class CourseDetailShimmer extends StatelessWidget {
  const CourseDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(
              width: double.infinity,
              height: 240,
              radius: AppConstants.radiusLG),
          const SizedBox(height: AppConstants.spaceMD),
          const ShimmerBox(width: 200, height: 14),
          const SizedBox(height: AppConstants.spaceSM),
          const ShimmerBox(width: double.infinity, height: 28),
          const SizedBox(height: AppConstants.spaceSM),
          const ShimmerBox(width: double.infinity, height: 16),
          const SizedBox(height: AppConstants.spaceLG),
          const ShimmerBox(
              width: double.infinity,
              height: 80,
              radius: AppConstants.radiusLG),
          const SizedBox(height: AppConstants.spaceLG),
          const ShimmerBox(width: 120, height: 20),
          const SizedBox(height: AppConstants.spaceMD),
          ...List.generate(
              3,
              (_) => const Padding(
                    padding: EdgeInsets.only(bottom: AppConstants.spaceSM),
                    child: ShimmerBox(
                        width: double.infinity,
                        height: 56,
                        radius: AppConstants.radiusLG),
                  )),
        ],
      ),
    );
  }
}
