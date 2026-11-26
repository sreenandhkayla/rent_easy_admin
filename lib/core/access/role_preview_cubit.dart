import 'package:flutter_bloc/flutter_bloc.dart';

import '../enums/admin_role.dart';

class RolePreviewCubit extends Cubit<AdminRole?> {
  RolePreviewCubit() : super(null);

  void start(AdminRole role) => emit(role);

  void exit() => emit(null);
}
