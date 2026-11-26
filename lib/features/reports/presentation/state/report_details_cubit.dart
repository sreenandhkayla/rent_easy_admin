import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/shop_report.dart';
import '../../data/reports_mock_data.dart';
import 'report_details_state.dart';

class ReportDetailsCubit extends Cubit<ReportDetailsState> {
  ReportDetailsCubit(this.reportId) : super(const ReportDetailsState());

  final String? reportId;

  void load() {
    final String? id = reportId;
    final ShopReport? report = id == null ? null : ReportsMockData.report(id);
    emit(
      ReportDetailsState(
        status: report == null
            ? ReportDetailsStatus.notFound
            : ReportDetailsStatus.loaded,
        report: report,
        updatedAt: DateTime.now(),
        notifyShop: state.notifyShop,
      ),
    );
  }

  void setNotifyShop(bool value) => emit(state.copyWith(notifyShop: value));

  void assign(String? admin, {required String actor}) => _change(
    (id) => ReportsMockData.assign(
      id,
      admin: admin,
      actor: actor,
      now: DateTime.now(),
    ),
  );

  void requestClarification({required String actor}) => _change(
    (id) => ReportsMockData.requestClarification(
      id,
      actor: actor,
      now: DateTime.now(),
    ),
  );

  void resolve(String decision, {required String actor}) => _change(
    (id) => ReportsMockData.close(
      id,
      status: ReportStatus.resolved,
      note: decision,
      actor: actor,
      now: DateTime.now(),
    ),
  );

  void dismiss(String reason, {required String actor}) => _change(
    (id) => ReportsMockData.close(
      id,
      status: ReportStatus.dismissed,
      note: reason,
      actor: actor,
      now: DateTime.now(),
    ),
  );

  void assignCorrection(String? admin) =>
      _change((id) => ReportsMockData.assignCorrection(id, admin: admin));

  void reviewCorrection(String note, {required String actor}) => _change(
    (id) => ReportsMockData.reviewCorrection(
      id,
      note: note,
      actor: actor,
      now: DateTime.now(),
    ),
  );

  void _change(void Function(String id) action) {
    final String? id = state.report?.reportId;
    if (id == null) return;
    action(id);
    load();
  }
}
