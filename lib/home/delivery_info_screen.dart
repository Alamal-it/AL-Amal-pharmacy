import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_strings.dart';

class DeliveryInfoScreen extends StatelessWidget {
  const DeliveryInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.primaryDark,
        ),
        centerTitle: true,
        title: Text(
          AppStrings.deliveryInfo,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: AppStrings.deliveryDuration,
            body: AppStrings.deliveryDurationBody,
          ),

          _Section(
            title: AppStrings.deliverySchedule,
            body: AppStrings.deliveryScheduleBody,
          ),

          _Section(
            title: AppStrings.freeDelivery,
            body: AppStrings.freeDeliveryBody,
          ),

          _Section(
            title: AppStrings.coverageArea,
            body: AppStrings.coverageAreaBody,
          ),

          _Section(
            title: AppStrings.pickupFromPharmacy,
            body: AppStrings.pickupFromPharmacyBody,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String? title;
  final String body;

  const _Section({
    this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                title!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            body,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textGray,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}