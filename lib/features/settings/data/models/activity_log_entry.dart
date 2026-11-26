class ActivityLogEntry {
  const ActivityLogEntry({
    required this.at,
    required this.actor,
    required this.action,
    required this.target,
    this.reason,
  });

  final DateTime at;
  final String actor;
  final String action;
  final String target;
  final String? reason;
}
