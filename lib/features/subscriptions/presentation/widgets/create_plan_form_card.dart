import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_labeled_field.dart';
import '../../../../core/widgets/app_notice_banner.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/plan_definition.dart';
import '../state/create_plan_state.dart';
import 'plan_labels.dart';

class CreatePlanFormCard extends StatelessWidget {
  const CreatePlanFormCard({
    super.key,
    required this.state,
    required this.onNameChanged,
    required this.onStatusChanged,
    required this.onDescriptionChanged,
    required this.onPriceChanged,
    required this.onBillingPeriodChanged,
    required this.onBenefitsChanged,
    required this.onLimitChanged,
    required this.onOfferTagChanged,
    required this.onOfferPercentageChanged,
    required this.onCancel,
    required this.onSave,
    required this.saveLabel,
  });

  final CreatePlanState state;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<PlanStatus> onStatusChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onPriceChanged;
  final ValueChanged<PlanBillingPeriod> onBillingPeriodChanged;
  final ValueChanged<String> onBenefitsChanged;
  final ValueChanged<String> onLimitChanged;
  final ValueChanged<String> onOfferTagChanged;
  final ValueChanged<String> onOfferPercentageChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String saveLabel;

  static const double _gap = 20;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldPair(
            first: AppTextField(
              label: SubscriptionsStrings.planNameLabel,
              hintText: SubscriptionsStrings.planNameHint,
              initialValue: state.name,
              errorText: state.showNameError
                  ? SubscriptionsStrings.planNameRequired
                  : null,
              textInputAction: TextInputAction.next,
              onChanged: onNameChanged,
            ),
            second: AppLabeledField(
              label: SubscriptionsStrings.planStatusLabel,
              child: AppDropdown<PlanStatus>(
                value: state.status,
                items: PlanStatus.values,
                labelOf: PlanLabels.statusOption,
                onChanged: onStatusChanged,
                isExpanded: true,
              ),
            ),
          ),
          if (state.isArchiving) ...[
            const SizedBox(height: 12),
            const AppNoticeBanner(
              tone: AppNoticeTone.warning,
              icon: Icons.archive_outlined,
              message: SubscriptionsStrings.archivePlanNote,
            ),
          ],
          const SizedBox(height: _gap),
          AppTextField(
            label: SubscriptionsStrings.planDescriptionLabel,
            hintText: SubscriptionsStrings.planDescriptionHint,
            initialValue: state.description,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 5,
            onChanged: onDescriptionChanged,
          ),
          const SizedBox(height: _gap),
          _FieldPair(
            first: AppTextField(
              label: SubscriptionsStrings.planPriceLabel,
              hintText: SubscriptionsStrings.planPriceHint,
              initialValue: state.price,
              errorText: state.showPriceError
                  ? SubscriptionsStrings.planPriceRequired
                  : null,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              onChanged: onPriceChanged,
            ),
            second: AppLabeledField(
              label: SubscriptionsStrings.billingDurationLabel,
              child: AppDropdown<PlanBillingPeriod>(
                value: state.billingPeriod,
                items: PlanBillingPeriod.values,
                labelOf: PlanLabels.billingOption,
                onChanged: onBillingPeriodChanged,
                isExpanded: true,
              ),
            ),
          ),
          const SizedBox(height: _gap),
          _FieldPair(
            first: AppTextField(
              label: SubscriptionsStrings.offerTagLabel,
              hintText: SubscriptionsStrings.offerTagHint,
              initialValue: state.offerTag,
              textInputAction: TextInputAction.next,
              onChanged: onOfferTagChanged,
            ),
            second: AppTextField(
              label: SubscriptionsStrings.offerPercentageLabel,
              hintText: SubscriptionsStrings.offerPercentageHint,
              initialValue: state.offerPercentage,
              helperText: SubscriptionsStrings.offerPercentageHelper,
              errorText: state.showOfferError
                  ? SubscriptionsStrings.offerPercentageInvalid
                  : null,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              textInputAction: TextInputAction.next,
              onChanged: onOfferPercentageChanged,
            ),
          ),
          const SizedBox(height: _gap),
          AppTextField(
            label: SubscriptionsStrings.planBenefitsLabel,
            hintText: SubscriptionsStrings.planBenefitsHint,
            initialValue: state.benefits,
            helperText: SubscriptionsStrings.planBenefitsHelper,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 8,
            onChanged: onBenefitsChanged,
          ),
          const SizedBox(height: _gap),
          AppTextField(
            label: SubscriptionsStrings.planLimitsLabel,
            hintText: SubscriptionsStrings.planLimitsHint,
            initialValue: state.limit,
            onChanged: onLimitChanged,
          ),
          if (state.errorMessage case final String message) ...[
            const SizedBox(height: 14),
            Text(message, style: AppTextStyles.fieldError),
          ],
          const Divider(height: 40, color: AppColors.divider),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 10,
            children: [
              AppSecondaryButton(label: AppStrings.cancel, onPressed: onCancel),
              AppPrimaryButton(
                label: saveLabel,
                icon: Icons.check,
                isCompact: true,
                isLoading: state.isSaving,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldPair extends StatelessWidget {
  const _FieldPair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  static const double _stackBreakpoint = 520;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _stackBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              first,
              const SizedBox(height: CreatePlanFormCard._gap),
              second,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 16),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}
