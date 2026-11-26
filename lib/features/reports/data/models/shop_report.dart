import '../../../../core/resources/strings/reports_strings.dart';

enum ReportStatus {
  pending(ReportsStrings.statusPending),
  underReview(ReportsStrings.statusUnderReview),
  resolved(ReportsStrings.statusResolved),
  dismissed(ReportsStrings.statusDismissed);

  const ReportStatus(this.label);

  final String label;

  bool get isClosed =>
      this == ReportStatus.resolved || this == ReportStatus.dismissed;
}

enum ReportCategory {
  itemNotReturned(ReportsStrings.categoryItemNotReturned),
  damagedItem(ReportsStrings.categoryDamagedItem),
  paymentDefault(ReportsStrings.categoryPaymentDefault),
  identityMismatch(ReportsStrings.categoryIdentityMismatch),
  abusiveBehaviour(ReportsStrings.categoryAbusiveBehaviour);

  const ReportCategory(this.label);

  final String label;
}

enum ReportEventType {
  submitted,
  reviewStarted,
  assigned,
  unassigned,
  clarificationRequested,
  resolved,
  dismissed,
  correctionReceived,
  correctionReviewed,
}

enum CorrectionStatus { awaitingReview, reviewed }

class ReportCorrection {
  const ReportCorrection({
    required this.summary,
    required this.receivedAt,
    this.status = CorrectionStatus.awaitingReview,
    this.assignedAdmin,
  });

  final String summary;
  final DateTime receivedAt;
  final CorrectionStatus status;
  final String? assignedAdmin;

  ReportCorrection copyWith({
    CorrectionStatus? status,
    String? Function()? assignedAdmin,
  }) {
    return ReportCorrection(
      summary: summary,
      receivedAt: receivedAt,
      status: status ?? this.status,
      assignedAdmin: assignedAdmin == null
          ? this.assignedAdmin
          : assignedAdmin(),
    );
  }
}

class ReportEvent {
  const ReportEvent({
    required this.type,
    required this.actor,
    required this.at,
    this.note,
  });

  final ReportEventType type;
  final String actor;
  final DateTime at;
  final String? note;
}

class ShopReport {
  const ShopReport({
    required this.reportId,
    required this.shopId,
    required this.shopName,
    required this.category,
    required this.submittedAt,
    required this.status,
    required this.reportedParty,
    required this.reason,
    required this.description,
    required this.supportingInformation,
    required this.events,
    this.isPartyMasked = true,
    this.assignedAdmin,
    this.correction,
  });

  final String reportId;
  final String shopId;
  final String shopName;
  final ReportCategory category;
  final DateTime submittedAt;
  final ReportStatus status;
  final String reportedParty;
  final bool isPartyMasked;
  final String reason;
  final String description;
  final String supportingInformation;
  final List<ReportEvent> events;
  final String? assignedAdmin;
  final ReportCorrection? correction;

  String? get decisionNote {
    for (final ReportEvent event in history) {
      if (event.type == ReportEventType.resolved ||
          event.type == ReportEventType.dismissed) {
        return event.note;
      }
    }
    return null;
  }

  List<ReportEvent> get history =>
      List.of(events)..sort((a, b) => b.at.compareTo(a.at));

  ShopReport copyWith({
    ReportStatus? status,
    String? Function()? assignedAdmin,
    List<ReportEvent>? events,
    ReportCorrection? correction,
  }) {
    return ShopReport(
      reportId: reportId,
      shopId: shopId,
      shopName: shopName,
      category: category,
      submittedAt: submittedAt,
      status: status ?? this.status,
      reportedParty: reportedParty,
      isPartyMasked: isPartyMasked,
      reason: reason,
      description: description,
      supportingInformation: supportingInformation,
      events: events ?? this.events,
      assignedAdmin: assignedAdmin == null
          ? this.assignedAdmin
          : assignedAdmin(),
      correction: correction ?? this.correction,
    );
  }
}
