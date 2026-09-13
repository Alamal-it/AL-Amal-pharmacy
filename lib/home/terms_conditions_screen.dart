import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          AppStrings.termsConditions,
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
            body: AppStrings.termsIntro,
          ),
          _Section(
            title: AppStrings.termsRegistrationTitle,
            body: AppStrings.termsRegistrationBody,
          ),
          _Section(
            title: AppStrings.termsCustomerTitle,
            body: AppStrings.termsCustomerBody,
          ),
          _Section(
            title: AppStrings.termsPaymentTitle,
            body: AppStrings.termsPaymentBody,
          ),
          _Section(
            title: AppStrings.termsMedicineTitle,
            body: AppStrings.termsMedicineBody,
          ),
          _Section(
            title: AppStrings.termsCancelOrderTitle,
            body: AppStrings.termsCancelOrderBody,
          ),
          _Section(
            title: AppStrings.termsReturnTitle,
            body: AppStrings.termsReturnBody,
          ),
          _Section(
            title: AppStrings.termsWarrantyTitle,
            body: AppStrings.termsWarrantyBody,
          ),
          _Section(
            title: AppStrings.termsLawTitle,
            body: AppStrings.termsLawBody,
          ),
          _Section(
            title: AppStrings.termsContactTitle,
            body: AppStrings.termsContactBody,
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
    final isArabic = AppStrings.termsConditions == 'الشروط والأحكام';

    final textAlign = isArabic
        ? TextAlign.right
        : TextAlign.left;

    final alignment = isArabic
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Align(
              alignment: alignment,
              child: Text(
                title!,
                textAlign: textAlign,
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
            textAlign: textAlign,
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
