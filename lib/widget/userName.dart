import 'package:flutter/material.dart';
import 'package:simba_coding_project/models/users_model.dart';
import 'package:simba_coding_project/services/services.dart';
import 'package:simba_coding_project/widget/app_large_text.dart';
import 'package:provider/provider.dart';

class UserName extends StatelessWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Service>(builder: (context, service, child) {
      UsersModel? _usermodel = service.loggedInUser;

      String? name = _usermodel != null ? _usermodel.displayName : 'User';
      return AppLargeText(
        text: name,
      );
    });
  }
}
