class ReportsStrings {
  ReportsStrings._();

  static const String title = 'Reports & Complaints';
  static const String subtitle =
      'Reports submitted by shops through the Owner App';

  static const String statusAll = 'All';
  static const String statusPending = 'Pending';
  static const String statusUnderReview = 'Under review';
  static const String statusResolved = 'Resolved';
  static const String statusDismissed = 'Dismissed';

  static const String categoryAll = 'All categories';
  static const String categoryItemNotReturned = 'Item not returned';
  static const String categoryDamagedItem = 'Damaged item';
  static const String categoryPaymentDefault = 'Payment default';
  static const String categoryIdentityMismatch = 'Identity mismatch';
  static const String categoryAbusiveBehaviour = 'Abusive behaviour';

  static const String dateAny = 'Any date';
  static const String dateLast7Days = 'Last 7 days';
  static const String dateLast30Days = 'Last 30 days';
  static const String dateLast90Days = 'Last 90 days';

  static const String searchHint = 'Search report ID or reporting shop';

  static const String reportId = 'Report ID';
  static const String reportingShop = 'Reporting shop';
  static const String category = 'Category';
  static const String submitted = 'Submitted';
  static const String status = 'Status';
  static const String assignedAdmin = 'Assigned admin';
  static const String unassigned = 'Unassigned';
  static const String review = 'Review';

  static const String noReportsTitle = 'No reports yet';
  static const String noReportsMessage =
      'Reports appear here once shops submit them through the Owner App.';
  static const String noMatchesTitle = 'No matching reports';
  static const String noMatchesMessage =
      'Try a different report ID or shop, or clear the filters.';

  static const String detailsSubtitle = 'Report details and review';
  static const String reportNotFound = 'Report not found';
  static const String reportNotFoundMessage =
      'This report does not exist or is no longer available.';
  static const String backToReports = 'Back to Reports & Complaints';
  static const String claimNoticeLead =
      'Reports are claims submitted by a shop and are ';
  static const String claimNoticeEmphasis = 'not treated as confirmed facts';
  static const String claimNoticeTail =
      '. Personal details are masked according to your role.';
  static const String reportedParty = 'Reported party';
  static const String masked = 'Masked';
  static const String reason = 'Reason';
  static const String description = 'Description';
  static const String supportingInformation = 'Supporting information';
  static const String reviewTitle = 'Review';
  static const String assignTo = 'Assign to';
  static const String notifyShop = 'Notify the reporting shop of updates';
  static const String requestClarification = 'Request clarification';
  static const String resolveWithDecision = 'Resolve with decision';
  static const String dismissReport = 'Dismiss report';
  static const String resolveReport = 'Resolve report';
  static const String resolveMessage =
      'Record the outcome of your review. The report is closed as resolved.';
  static const String dismissMessage =
      'Record why this report is dismissed. The report is closed as '
      'dismissed.';
  static const String decisionNotice =
      'A decision records your review outcome. It does not confirm the '
      'report as fact.';
  static const String decisionLabel = 'Decision (required)';
  static const String decisionHint = 'Write a clear, factual note';
  static const String decisionRequired = 'Enter a decision to continue.';
  static const String closedResolvedNote =
      'This report is resolved. Its decision is recorded in the review '
      'history.';
  static const String closedDismissedNote =
      'This report is dismissed. Its reason is recorded in the review '
      'history.';
  static const String reviewHistory = 'Review history';
  static const String eventSubmitted = 'Report submitted';
  static const String eventReviewStarted = 'Review started';
  static const String eventUnassigned = 'Assignment removed';
  static const String eventClarification = 'Clarification requested';
  static const String eventResolved = 'Resolved';
  static const String eventDismissed = 'Dismissed';
  static const String eventCorrectionReceived = 'Correction request received';
  static const String eventCorrectionReviewed = 'Correction reviewed';
  static const String recordedDecision = 'Recorded decision.';
  static const String correctionTitle = 'Correction / appeal';
  static const String correctionAwaitingReview = 'Awaiting review';
  static const String correctionReviewed = 'Reviewed';
  static const String reviewCorrection = 'Review correction';
  static const String closedCorrectionNote =
      'This report is closed. Corrections or appeals can still be reviewed.';
  static const String correctionDialogMessage =
      'Record your review of this correction request. The original decision '
      'stays on record.';
  static const String correctionNotice =
      'Reviewing a correction records your assessment. It does not confirm '
      'either side as fact.';
  static const String correctionNoteLabel = 'Review note (required)';
  static const String correctionNoteRequired =
      'Enter a review note to continue.';
  static const String recordReview = 'Record review';

  static String resolveTitle(String reportId) => 'Resolve $reportId';
  static String correctionDialogTitle(String reportId) =>
      'Review correction for $reportId';
  static String receivedOn(String date) => 'Received $date';
  static String via(String source) => 'Via $source';
  static String correctionReviewedSnack(String reportId) =>
      'Correction review recorded for $reportId.';
  static String dismissTitle(String reportId) => 'Dismiss $reportId';
  static String eventAssigned(String admin) => 'Assigned to $admin';
  static String submittedBy(String shop) => 'By $shop via the Owner App';
  static String actorNote(String actor, String note) => '$actor · $note';
  static String reportLine(String reportId, String date) =>
      '$reportId · Submitted $date';
  static String clarificationSent(String shop, bool notify) => notify
      ? 'Clarification requested. $shop will be notified.'
      : 'Clarification request recorded.';
  static String reportResolved(String reportId) => '$reportId resolved.';
  static String reportDismissed(String reportId) => '$reportId dismissed.';
}
