import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:luggo/screens/content_screens/service_screens/service_info_screen.dart';
import 'package:luggo/utils/constants.dart';

class ServiceButtonsGrid extends StatelessWidget {
  const ServiceButtonsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),

        _serviceButton(
          context,
          icon: Icons.local_shipping_outlined,
          title: 'transport'.tr(),
          subtitle: 'transportSubtitle'.tr(),
          serviceType: 'transportService',
        ),
        const SizedBox(height: 10),

        _serviceButton(
          context,
          icon: Icons.fitness_center_outlined,
          title: 'laborOnly'.tr(),
          subtitle: 'laborOnlySubtitle'.tr(),
          serviceType: 'laborService',
        ),
        const SizedBox(height: 10),

        _serviceButton(
          context,
          icon: Icons.moving_outlined,
          title: 'smallMove'.tr(),
          subtitle: 'smallMoveSubtitle'.tr(),
          serviceType: 'smallMoveService',
        ),
        const SizedBox(height: 10),

        _serviceButton(
          context,
          icon: Icons.store_mall_directory_outlined,
          title: 'storePickup'.tr(),
          subtitle: 'storePickupSubtitle'.tr(),
          serviceType: 'storePickupService',
        ),
        const SizedBox(height: 10),

        _serviceButton(
          context,
          icon: Icons.recycling_outlined,
          title: 'recycling'.tr(),
          subtitle: 'recyclingSubtitle'.tr(),
          serviceType: 'recyclingService',
        ),
        const SizedBox(height: 10),

        _serviceButton(
          context,
          icon: Icons.volunteer_activism_outlined,
          title: 'donate'.tr(),
          subtitle: 'donateSubtitle'.tr(),
          serviceType: 'donateService',
        ),

        const SizedBox(height: 10),

        Center(
          child: Text(
            'copyrightNotice'.tr(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontFamily: 'Helvetica',
            ),
          ),
        ),

        const SizedBox(height: 90),
      ],
    );
  }

  Widget _serviceButton(BuildContext context, { required IconData icon, required String title, required String subtitle, required String serviceType}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha(18),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha(15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ServiceInfoScreen(serviceType: serviceType),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: AppColors.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Helvetica',
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // TO DO CAMBIAR ICONO
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 24,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
