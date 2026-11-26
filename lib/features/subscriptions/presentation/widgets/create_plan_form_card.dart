import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_labeled_field.dart';
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
    required this.onCancel,
    required this.onSave,
  });

  final CreatePlanState state;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<PlanStatus> onStatusChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onPriceChanged;
  final ValueChanged<PlanBillingPeriod> onBillingPeriodChanged;
  final ValueChanged<String> onBenefitsChanged;
  final ValueChanged<String> onLimitChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

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
          const SizedBox(height: _gap),
          AppTextField(
            label: SubscriptionsStrings.planDescriptionLabel,
            hintText: SubscriptionsStrings.planDescriptionHint,
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
          AppTextField(
            label: SubscriptionsStrings.planBenefitsLabel,
            hintText: SubscriptionsStrings.planBenefitsHint,
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
            onChanged: onLimitChanged,
          ),
          const Divider(height: 40, color: AppColors.divider),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 10,
            children: [
              AppSecondaryButton(label: AppStrings.cancel, onPressed: onCancel),
              AppPrimaryButton(
                label: SubscriptionsStrings.savePlan,
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
