import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/admin_permission.dart';
import '../state/admin_session_cubit.dart';

extension AdminPermissionContext on BuildContext {
  bool canPerform(AdminPermission permission) =>
      select<AdminSessionCubit, bool>(
        (session) => session.state.account?.can(permission) ?? false,
      );
}
