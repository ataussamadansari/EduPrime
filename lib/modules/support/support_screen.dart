import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../data/models/support_ticket_model.dart';
import 'support_controller.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(SupportController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('Help & Support',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'New Ticket',
            onPressed: () => _showCreateSheet(context, ctrl, isDark),
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const ListShimmer();
        }
        if (ctrl.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ctrl.error.value,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.error),
                    textAlign: TextAlign.center),
                const SizedBox(height: AppConstants.spaceMD),
                TextButton(
                    onPressed: ctrl.fetchTickets,
                    child: const Text('Retry')),
              ],
            ),
          );
        }

        return Column(
          children: [
            // FAQ / quick help banner
            _HelpBanner(isDark: isDark)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.1, end: 0),

            // Tickets header
            Padding(
              padding: const EdgeInsets.fromLTRB(AppConstants.spaceMD,
                  AppConstants.spaceMD, AppConstants.spaceMD, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Tickets (${ctrl.tickets.length})',
                      style: AppTextStyles.h2.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      )),
                  TextButton.icon(
                    onPressed: () => _showCreateSheet(context, ctrl, isDark),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('New'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ctrl.tickets.isEmpty
                  ? _EmptyState(isDark: isDark,
                      onTap: () => _showCreateSheet(context, ctrl, isDark))
                  : RefreshIndicator(
                      onRefresh: ctrl.fetchTickets,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppConstants.spaceMD),
                        itemCount: ctrl.tickets.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppConstants.spaceMD),
                        itemBuilder: (context, i) => _TicketCard(
                          ticket: ctrl.tickets[i],
                          isDark: isDark,
                        )
                            .animate(
                                delay: Duration(milliseconds: i * 60))
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, end: 0),
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

// ── Help Banner ───────────────────────────────────────────────────────────────
class _HelpBanner extends StatelessWidget {
  final bool isDark;
  const _HelpBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spaceMD),
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
      ),
      child: Row(
        children: [
          const Icon(Icons.support_agent_rounded,
              color: Colors.white, size: 40),
          const SizedBox(width: AppConstants.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How can we help?',
                    style:
                        AppTextStyles.h3.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                    'Submit a ticket and our team will respond within 24 hours.',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ticket Card ───────────────────────────────────────────────────────────────
class _TicketCard extends StatelessWidget {
  final SupportTicketModel ticket;
  final bool isDark;
  const _TicketCard({required this.ticket, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(ticket.subject,
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: AppConstants.spaceSM),
              _StatusBadge(status: ticket.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(ticket.message,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppConstants.spaceSM),
          Row(
            children: [
              _MetaChip(
                  label: ticket.category, color: AppColors.primary),
              const SizedBox(width: AppConstants.spaceSM),
              _MetaChip(
                  label: ticket.priority,
                  color: _priorityColor(ticket.priority)),
              const Spacer(),
              Text(
                ticket.createdAt.length >= 10
                    ? ticket.createdAt.substring(0, 10)
                    : ticket.createdAt,
                style: AppTextStyles.caption.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          // Admin reply
          if (ticket.adminReply != null &&
              ticket.adminReply!.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spaceSM),
            Container(
              padding: const EdgeInsets.all(AppConstants.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSM),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.reply_rounded,
                      color: AppColors.success, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(ticket.adminReply!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'high':
        return AppColors.error;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.warning;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'open'
        ? AppColors.info
        : status == 'resolved'
            ? AppColors.success
            : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: AppTextStyles.caption
            .copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MetaChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(label,
          style: AppTextStyles.caption
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _EmptyState({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent_outlined,
                  size: 72,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight)
              .animate()
              .scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 500.ms,
                  curve: Curves.elasticOut),
          const SizedBox(height: AppConstants.spaceMD),
          Text('No tickets yet',
              style: AppTextStyles.h2.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              )),
          const SizedBox(height: AppConstants.spaceSM),
          Text('Need help? Create a support ticket.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              )),
          const SizedBox(height: AppConstants.spaceLG),
          AppButton(
              label: 'Create Ticket',
              onTap: onTap,
              width: 200,
              icon: Icons.add_rounded),
        ],
      ),
    );
  }
}

// ── Create Ticket Bottom Sheet ────────────────────────────────────────────────
void _showCreateSheet(
    BuildContext context, SupportController ctrl, bool isDark) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.only(
        left: AppConstants.spaceMD,
        right: AppConstants.spaceMD,
        top: AppConstants.spaceMD,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppConstants.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXL)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.borderDark
                      : AppColors.borderLight,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),
            Text('New Support Ticket',
                style: AppTextStyles.h2.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                )),
            const SizedBox(height: AppConstants.spaceMD),

            // Subject
            TextField(
              controller: ctrl.subjectCtrl,
              decoration: const InputDecoration(
                hintText: 'Subject *',
                prefixIcon: Icon(Icons.subject_rounded),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),

            // Message
            TextField(
              controller: ctrl.messageCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe your issue *',
                prefixIcon: Icon(Icons.message_outlined),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),

            // Category + Priority row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          )),
                      const SizedBox(height: 4),
                      Obx(() => _DropdownField(
                            value: ctrl.selectedCategory.value,
                            items: SupportController.categories,
                            isDark: isDark,
                            onChanged: (v) =>
                                ctrl.selectedCategory.value = v!,
                          )),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Priority',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          )),
                      const SizedBox(height: 4),
                      Obx(() => _DropdownField(
                            value: ctrl.selectedPriority.value,
                            items: SupportController.priorities,
                            isDark: isDark,
                            onChanged: (v) =>
                                ctrl.selectedPriority.value = v!,
                          )),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spaceLG),

            Obx(() => AppButton(
                  label: 'Submit Ticket',
                  onTap: ctrl.submitTicket,
                  isLoading: ctrl.isSubmitting.value,
                  icon: Icons.send_rounded,
                )),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final bool isDark;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor:
              isDark ? AppColors.cardDark : AppColors.surfaceLight,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

