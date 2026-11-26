import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/subscription_payment.dart';
import '../state/payment_details_cubit.dart';
import '../state/payment_details_state.dart';
import '../widgets/payment_receipt_card.dart';
import '../widgets/payment_status_banner.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/verification_timeline_card.dart';

class PaymentDetailsPage extends StatelessWidget {
  const PaymentDetailsPage({super.key, required this.transactionId});

  final String? transactionId;

  static void _backToPayments(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.subscriptionPayments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentDetailsCubit(transactionId)..load(),
      child: BlocBuilder<PaymentDetailsCubit, PaymentDetailsState>(
        builder: (context, state) {
          final SubscriptionPayment? payment = state.payment;
          final DateTime? updatedAt = state.updatedAt;
          final String title =
              payment?.transactionId ?? SubscriptionsStrings.paymentNotFound;
          return AdminShell(
            section: AdminSection.subscriptions,
            isSectionRoot: false,
            title: title,
            subtitle: SubscriptionsStrings.paymentDetailsSubtitle,
            breadcrumb: AppBreadcrumbs(
              items: [
                AppBreadcrumb(
                  SubscriptionsStrings.title,
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.subscriptions,
                    (_) => false,
                  ),
                ),
                AppBreadcrumb(
                  SubscriptionsStrings.tabPayments,
                  onTap: () => _backToPayments(context),
                ),
                AppBreadcrumb(title),
              ],
            ),
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(
                  updatedAt: updatedAt,
                  onPressed: context.read<PaymentDetailsCubit>().load,
                ),
            ],
            child: switch (state.status) {
              PaymentDetailsStatus.loading => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              PaymentDetailsStatus.notFound => _NotFound(
                onBack: () => _backToPayments(context),
              ),
              PaymentDetailsStatus.loaded => _DetailsBody(payment: payment!),
            },
          );
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.payment});

  static const double _twoColumnBreakpoint = 1000;

  final SubscriptionPayment payment;

  @override
  Widget build(BuildContext context) {
    final String? invoice = payment.invoiceNumber;
    final Widget main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentSummaryCard(payment: payment),
        if (payment.isVerified && invoice != null) ...[
          const SizedBox(height: 16),
          PaymentReceiptCard(payment: payment, invoiceNumber: invoice),
        ],
      ],
    );
    final Widget side = VerificationTimelineCard(
      payment: payment,
      onViewShopSubscription: () =>
          Navigator.of(context)
              .pushNamed(AppRoutes.subscriptionDetailsFor(payment.shopId)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentStatusBanner(payment: payment),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < _twoColumnBreakpoint) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [main, const SizedBox(height: 16), side],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: main),
                const SizedBox(width: 16),
                Expanded(child: side),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            SubscriptionsStrings.paymentNotFoundMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          AppTextLink(
            label: SubscriptionsStrings.backToPayments,
            onTap: onBack,
          ),
        ],
      ),
    );
  }
}
