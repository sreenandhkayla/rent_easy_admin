import 'models/shop_report.dart';

class ReportsMockData {
  ReportsMockData._();

  static const List<String> admins = [
    'Arjun Raghavan',
    'Meera Suresh',
    'Kiran Joseph',
  ];

  static List<ShopReport> reports() => List.of(_reports);

  static ShopReport? report(String reportId) {
    for (final ShopReport item in _reports) {
      if (item.reportId == reportId) return item;
    }
    return null;
  }

  static void assign(
    String reportId, {
    required String? admin,
    required String actor,
    required DateTime now,
  }) {
    _update(reportId, (report) {
      if (report.status.isClosed || report.assignedAdmin == admin) {
        return report;
      }
      final bool starts =
          admin != null && report.status == ReportStatus.pending;
      return report.copyWith(
        status: starts ? ReportStatus.underReview : null,
        assignedAdmin: () => admin,
        events: [
          ...report.events,
          ReportEvent(
            type: starts
                ? ReportEventType.reviewStarted
                : admin == null
                ? ReportEventType.unassigned
                : ReportEventType.assigned,
            actor: starts ? admin : actor,
            at: now,
            note: starts ? null : admin,
          ),
        ],
      );
    });
  }

  static void requestClarification(
    String reportId, {
    required String actor,
    required DateTime now,
  }) {
    _update(
      reportId,
      (report) => report.status.isClosed
          ? report
          : report.copyWith(
              events: [
                ...report.events,
                ReportEvent(
                  type: ReportEventType.clarificationRequested,
                  actor: actor,
                  at: now,
                ),
              ],
            ),
    );
  }

  static void close(
    String reportId, {
    required ReportStatus status,
    required String note,
    required String actor,
    required DateTime now,
  }) {
    _update(
      reportId,
      (report) => report.status.isClosed
          ? report
          : report.copyWith(
              status: status,
              assignedAdmin: () => report.assignedAdmin ?? actor,
              events: [
                ...report.events,
                ReportEvent(
                  type: status == ReportStatus.dismissed
                      ? ReportEventType.dismissed
                      : ReportEventType.resolved,
                  actor: actor,
                  at: now,
                  note: note,
                ),
              ],
            ),
    );
  }

  static void assignCorrection(String reportId, {required String? admin}) {
    _update(reportId, (report) {
      final ReportCorrection? correction = report.correction;
      if (correction == null) return report;
      return report.copyWith(
        correction: correction.copyWith(assignedAdmin: () => admin),
      );
    });
  }

  static void reviewCorrection(
    String reportId, {
    required String note,
    required String actor,
    required DateTime now,
  }) {
    _update(reportId, (report) {
      final ReportCorrection? correction = report.correction;
      if (correction == null ||
          correction.status == CorrectionStatus.reviewed) {
        return report;
      }
      return report.copyWith(
        correction: correction.copyWith(
          status: CorrectionStatus.reviewed,
          assignedAdmin: () => correction.assignedAdmin ?? actor,
        ),
        events: [
          ...report.events,
          ReportEvent(
            type: ReportEventType.correctionReviewed,
            actor: actor,
            at: now,
            note: note,
          ),
        ],
      );
    });
  }

  static void _update(
    String reportId,
    ShopReport Function(ShopReport report) change,
  ) {
    final int index = _reports.indexWhere((item) => item.reportId == reportId);
    if (index < 0) return;
    _reports[index] = change(_reports[index]);
  }

  static ReportEvent _submitted(DateTime at) =>
      ReportEvent(type: ReportEventType.submitted, actor: '', at: at);

  static final List<ShopReport> _reports = [
    ShopReport(
      reportId: 'RPT-3108',
      shopId: 'SHP-2001',
      shopName: 'Kumar Construction Rentals',
      category: ReportCategory.itemNotReturned,
      submittedAt: DateTime(2026, 11, 23, 16, 40),
      status: ReportStatus.pending,
      reportedParty: 'Customer •••••4471',
      reason: 'Concrete mixer not returned after the rental period',
      description:
          'A concrete mixer rented on 16 Nov was due back on 21 Nov. The '
          'customer has not returned it or answered calls.',
      supportingInformation: 'Rental agreement and call log',
      events: [_submitted(DateTime(2026, 11, 23, 16, 40))],
    ),
    ShopReport(
      reportId: 'RPT-3104',
      shopId: 'SHP-2006',
      shopName: 'Nair Sound & Lights',
      category: ReportCategory.damagedItem,
      submittedAt: DateTime(2026, 11, 21, 11, 5),
      status: ReportStatus.pending,
      reportedParty: 'Customer •••••2190',
      reason: 'Speaker returned with a torn cone',
      description:
          'Two PA speakers were returned on 20 Nov. One had a torn speaker '
          'cone that was not there at handover.',
      supportingInformation: 'Handover and return photos',
      events: [_submitted(DateTime(2026, 11, 21, 11, 5))],
    ),
    ShopReport(
      reportId: 'RPT-3101',
      shopId: 'SHP-2008',
      shopName: 'Menon Car Rentals',
      category: ReportCategory.paymentDefault,
      submittedAt: DateTime(2026, 11, 20, 13, 2),
      status: ReportStatus.underReview,
      assignedAdmin: 'Arjun Raghavan',
      reportedParty: 'Customer •••••3368',
      reason: 'Outstanding balance after vehicle return',
      description:
          'The vehicle was returned on 14 Nov with ₹6,400 outstanding. The '
          'customer has not settled the balance.',
      supportingInformation: 'Final invoice reference and payment reminder log',
      events: [
        _submitted(DateTime(2026, 11, 20, 13, 2)),
        ReportEvent(
          type: ReportEventType.reviewStarted,
          actor: 'Arjun Raghavan',
          at: DateTime(2026, 11, 20, 15, 30),
        ),
      ],
    ),
    ShopReport(
      reportId: 'RPT-3097',
      shopId: 'SHP-2004',
      shopName: 'Rasheed Wedding Decor',
      category: ReportCategory.identityMismatch,
      submittedAt: DateTime(2026, 11, 18, 14, 15),
      status: ReportStatus.pending,
      reportedParty: 'Customer •••••8815',
      reason: 'ID document did not match the renter',
      description:
          'The person collecting the decor set showed an ID with a different '
          'name from the booking.',
      supportingInformation: 'Booking record and ID check note',
      events: [_submitted(DateTime(2026, 11, 18, 14, 15))],
    ),
    ShopReport(
      reportId: 'RPT-3092',
      shopId: 'SHP-2011',
      shopName: 'Pillai Tools Hub',
      category: ReportCategory.abusiveBehaviour,
      submittedAt: DateTime(2026, 11, 15, 18, 50),
      status: ReportStatus.underReview,
      assignedAdmin: 'Meera Suresh',
      reportedParty: 'Customer •••••5023',
      reason: 'Customer was abusive towards staff',
      description:
          'The customer shouted at counter staff when asked for the security '
          'deposit.',
      supportingInformation: 'Staff statement',
      events: [
        _submitted(DateTime(2026, 11, 15, 18, 50)),
        ReportEvent(
          type: ReportEventType.reviewStarted,
          actor: 'Meera Suresh',
          at: DateTime(2026, 11, 16, 10, 5),
        ),
      ],
    ),
    ShopReport(
      reportId: 'RPT-3085',
      shopId: 'SHP-2012',
      shopName: 'Thomas Event Equipment',
      category: ReportCategory.itemNotReturned,
      submittedAt: DateTime(2026, 11, 10, 10, 20),
      status: ReportStatus.resolved,
      assignedAdmin: 'Arjun Raghavan',
      reportedParty: 'Customer •••••7342',
      reason: 'Chairs not returned after an event',
      description:
          'Forty folding chairs were due back on 8 Nov and were returned only '
          'after reminders.',
      supportingInformation: 'Rental agreement and reminder log',
      events: [
        _submitted(DateTime(2026, 11, 10, 10, 20)),
        ReportEvent(
          type: ReportEventType.reviewStarted,
          actor: 'Arjun Raghavan',
          at: DateTime(2026, 11, 10, 14, 0),
        ),
        ReportEvent(
          type: ReportEventType.resolved,
          actor: 'Arjun Raghavan',
          at: DateTime(2026, 11, 12, 11, 30),
          note: 'Items returned in full. No further action needed.',
        ),
      ],
    ),
    ShopReport(
      reportId: 'RPT-3079',
      shopId: 'SHP-2010',
      shopName: 'Varghese Furniture Rentals',
      category: ReportCategory.paymentDefault,
      submittedAt: DateTime(2026, 11, 6, 12, 45),
      status: ReportStatus.dismissed,
      assignedAdmin: 'Meera Suresh',
      reportedParty: 'Customer •••••6604',
      reason: 'Rental fee unpaid',
      description:
          'The customer did not pay the final rental fee for a sofa set '
          'returned on 4 Nov.',
      supportingInformation: 'Invoice reference',
      events: [
        _submitted(DateTime(2026, 11, 6, 12, 45)),
        ReportEvent(
          type: ReportEventType.reviewStarted,
          actor: 'Meera Suresh',
          at: DateTime(2026, 11, 7, 9, 40),
        ),
        ReportEvent(
          type: ReportEventType.dismissed,
          actor: 'Meera Suresh',
          at: DateTime(2026, 11, 8, 16, 10),
          note: 'Payment was received before the report was submitted.',
        ),
      ],
    ),
    ShopReport(
      reportId: 'RPT-3071',
      shopId: 'SHP-2005',
      shopName: 'Mathew Machinery Hire',
      category: ReportCategory.damagedItem,
      submittedAt: DateTime(2026, 11, 1, 18, 22),
      status: ReportStatus.resolved,
      assignedAdmin: 'Kiran Joseph',
      reportedParty: 'Customer •••••9145',
      reason: 'Excavator bucket damaged',
      description: 'Shop reports damage to an excavator bucket on return.',
      supportingInformation: 'Inspection record and photos',
      correction: ReportCorrection(
        summary:
            'The customer submitted a correction request stating the damage '
            'existed before the rental began.',
        receivedAt: DateTime(2026, 11, 19, 14, 5),
      ),
      events: [
        ReportEvent(
          type: ReportEventType.submitted,
          actor: '',
          at: DateTime(2026, 11, 1, 18, 22),
          note: 'By Mathew Machinery Hire',
        ),
        ReportEvent(
          type: ReportEventType.resolved,
          actor: 'Kiran Joseph',
          at: DateTime(2026, 11, 5, 11, 40),
          note:
              'Damage confirmed by the shop inspection record and noted on '
              'the report.',
        ),
        ReportEvent(
          type: ReportEventType.correctionReceived,
          actor: 'ToolRent support',
          at: DateTime(2026, 11, 19, 14, 5),
        ),
      ],
    ),
  ];
}
