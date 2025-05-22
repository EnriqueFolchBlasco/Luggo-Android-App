import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/utils/utils_widgets/custom_form_widgets.dart';

class UserInfoForm extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController dniController;
  final TextEditingController telefonoController;
  final TextEditingController emailController;

  const UserInfoForm({
    super.key,
    required this.nombreController,
    required this.dniController,
    required this.telefonoController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LuggoLabel('fullName'.tr()),
        LuggoTextField(controller: nombreController, hint: 'fullNameHint'.tr()),

        LuggoLabel('dniOptional'.tr()),
        LuggoTextField(controller: dniController, hint: 'dniHint'.tr()),

        LuggoLabel('phone'.tr()),
        LuggoTextField(controller: telefonoController, hint: 'phoneHint'.tr()),

        LuggoLabel('email'.tr()),
        LuggoTextField(controller: emailController, hint: 'emailHint'.tr()),
      ],
    );
  }
}
