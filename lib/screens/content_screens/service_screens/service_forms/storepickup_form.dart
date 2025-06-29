import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/utils/utils_widgets/custom_form_widgets.dart';

class StorePickupForm extends StatelessWidget {
  final GlobalKey<FormState> clauFormulari;
  final TextEditingController pickupController;
  final TextEditingController notesController;
  final TextEditingController dateController;
  final TextEditingController timeController;

  const StorePickupForm({
    required this.clauFormulari,
    required this.pickupController,
    required this.notesController,
    required this.dateController,
    required this.timeController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: clauFormulari,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LuggoLabel('storeAddress'.tr()),

          LuggoTextField(
            controller: pickupController,
            hint: 'storeHint'.tr(),
          ),

          LuggoLabel('orderDetails'.tr()),

          LuggoTextField(
            controller: notesController,
            hint: 'orderHint'.tr(),
          ),






          Row(
            children: [
              Expanded(child: 
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LuggoLabel('date'.tr()),
                  ),
                  LuggoReadOnlyField(
                    controller: dateController,
                    hint: 'selectDate'.tr(),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        dateController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(picked);
                      }
                    },
                  ),
                ],
              ),
              ),
              SizedBox(width: 12),
              Expanded(child: 
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LuggoLabel('time'.tr()),
                  ),
                  
                  LuggoReadOnlyField(
                    controller: timeController,
                    hint: 'selectTime'.tr(),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        timeController.text = picked.format(context);
                      }
                    },
                  ),
                ],
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
