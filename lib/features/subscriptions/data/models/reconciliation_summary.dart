class ReconciliationSummary {
  const ReconciliationSummary({
    required this.matched,
    required this.unmatched,
    required this.pending,
    required this.refunds,
  });

  final int matched;
  final int unmatched;
  final int pending;
  final int refunds;
}
