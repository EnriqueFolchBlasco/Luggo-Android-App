import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:luggo/utils/utils_widgets/custom_form_widgets.dart';

class TransportForm extends StatelessWidget {
  final GlobalKey<FormState> clauFormulari;
  final TextEditingController pickupController;
  final TextEditingController dropoffController;
  final TextEditingController dateController;
  final TextEditingController timeController;

  const TransportForm({
    required this.clauFormulari,
    required this.pickupController,
    required this.dropoffController,
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
          LuggoLabel('pickupAddress'.tr()),
          LuggoTextField(
            controller: pickupController,
            hint: 'moveFromHint'.tr(),
          ),



          LuggoLabel('dropoffAddress'.tr()),
          LuggoTextField(
            controller: dropoffController,
            hint: 'moveToHint'.tr(),
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
