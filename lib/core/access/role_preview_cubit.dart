import 'package:flutter_bloc/flutter_bloc.dart';

import '../enums/admin_role.dart';
import '../widgets/admin_shell/admin_section.dart';

class RolePreview {
  const RolePreview({required this.role, required this.sections});

  final AdminRole role;
  final List<AdminSection> sections;

  bool canOpen(AdminSection section) => sections.contains(section);
}

class RolePreviewCubit extends Cubit<RolePreview?> {
  RolePreviewCubit() : super(null);

  void start(AdminRole role, List<AdminSection> sections) =>
      emit(RolePreview(role: role, sections: sections));

  void exit() => emit(null);
}
