import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rent_easy_admin/features/subscriptions/data/models/plan_definition.dart';
import 'package:rent_easy_admin/features/subscriptions/presentation/state/create_plan_state.dart';

void main() {
  group('PlanDefinition', () {
    test('reads a plans document', () {
      final PlanDefinition plan = PlanDefinition.fromDocument('p1', {
        'name': 'Professional',
        'description': 'For busy shops',
        'price': 999,
        'billingPeriod': 'year',
        'benefits': ['Maintenance tracking', '', 'Payment reports'],
        'limit': 'Up to 6 staff accounts',
        'offerTag': 'Launch offer',
        'offerPercentage': 20,
        'status': 'archived',
        'createdAt': Timestamp.fromDate(DateTime(2026, 11, 1)),
        'updatedAt': Timestamp.fromDate(DateTime(2026, 11, 2)),
      });
      expect(plan.id, 'p1');
      expect(plan.billingPeriod, PlanBillingPeriod.year);
      expect(plan.features, ['Maintenance tracking', 'Payment reports']);
      expect(plan.status, PlanStatus.archived);
      expect(plan.offerTag, 'Launch offer');
      expect(plan.offerPrice, 799);
      expect(plan.updatedAt, DateTime(2026, 11, 2));
      expect(plan.subscribedShops, isNull);
    });

    test('missing fields fall back safely', () {
      final PlanDefinition plan = PlanDefinition.fromDocument('p2', const {});
      expect(plan.billingPeriod, PlanBillingPeriod.month);
      expect(plan.status, PlanStatus.active);
      expect(plan.offerPercentage, 0);
      expect(plan.hasDiscount, isFalse);
      expect(plan.offerTag, isNull);
    });

    test('writes the agreed Firestore fields', () {
      const PlanDefinition plan = PlanDefinition(
        id: '',
        name: ' Basic ',
        price: 499,
        billingPeriod: PlanBillingPeriod.month,
        description: '',
        features: ['Return reminders'],
        status: PlanStatus.active,
        offerPercentage: 10,
      );
      expect(plan.toFields(), {
        'name': 'Basic',
        'description': '',
        'price': 499,
        'billingPeriod': 'month',
        'benefits': ['Return reminders'],
        'limit': null,
        'offerTag': null,
        'offerPercentage': 10,
        'status': 'active',
      });
    });

    test('offer price rounds to whole rupees', () {
      expect(PlanDefinition.offerPriceFor(999, 20), 799);
      expect(PlanDefinition.offerPriceFor(499, 15), 424);
      expect(PlanDefinition.offerPriceFor(1000, 0), 1000);
    });
  });

  group('CreatePlanState validation', () {
    CreatePlanState form({String price = '999', String offer = ''}) =>
        CreatePlanState(
          updatedAt: DateTime(2026),
          name: 'Pro',
          price: price,
          offerPercentage: offer,
        );

    test('offer is optional', () {
      expect(form().isValid, isTrue);
      expect(form().toPlan().offerPercentage, 0);
    });

    test('offer from 1 to 99 is accepted', () {
      expect(form(offer: '20').isValid, isTrue);
      expect(form(offer: '20').offerPriceValue, 799);
      expect(form(offer: '99').isValid, isTrue);
    });

    test('offer that makes the price ₹0 is refused', () {
      expect(form(price: '1', offer: '60').isValid, isFalse);
    });

    test('name and price are still required', () {
      expect(form(price: '').isValid, isFalse);
      expect(
        CreatePlanState(updatedAt: DateTime(2026), price: '10').isValid,
        isFalse,
      );
    });
  });

  group('Edit plan', () {
    const PlanDefinition stored = PlanDefinition(
      id: 'p1',
      name: 'Professional',
      price: 999,
      billingPeriod: PlanBillingPeriod.year,
      description: 'For busy shops',
      features: ['Maintenance tracking', 'Payment reports'],
      status: PlanStatus.active,
      limit: 'Up to 6 staff accounts',
      offerTag: 'Launch offer',
      offerPercentage: 20,
    );

    test('form is prefilled from the plan and saves it back unchanged', () {
      final CreatePlanState form = CreatePlanState.fromPlan(stored);
      expect(form.isEditing, isTrue);
      expect(form.benefits, 'Maintenance tracking\nPayment reports');
      expect(form.offerPercentage, '20');
      expect(form.toPlan().toFields(), stored.toFields());
      expect(form.toPlan().id, 'p1');
    });

    test('archive notice shows only when changing to Archived', () {
      final CreatePlanState form = CreatePlanState.fromPlan(stored);
      expect(form.isArchiving, isFalse);
      expect(form.copyWith(status: PlanStatus.archived).isArchiving, isTrue);
      final CreatePlanState archived = CreatePlanState.fromPlan(
        stored.copyWith(status: PlanStatus.archived),
      );
      expect(archived.isArchiving, isFalse);
    });

    test('a new plan is not in edit mode', () {
      expect(CreatePlanState(updatedAt: DateTime(2026)).isEditing, isFalse);
    });
  });
}
