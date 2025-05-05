import 'package:flutter/material.dart';
import 'package:luggo/utils/constants.dart';

class BarraProgressoAmazon extends StatelessWidget {
  final int currentStep;

  const BarraProgressoAmazon(this.currentStep);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: currentStep >= 0
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),






            Expanded(
              child: Container(
                height: 2,
                color: currentStep >= 1
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
              ),
            ),
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: currentStep >= 1
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 2,
                color: currentStep >= 2
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
              ),
            ),
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: currentStep >= 2
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],


        ),

        const SizedBox(height: 8),


        Row(
          children: const [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Info',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
