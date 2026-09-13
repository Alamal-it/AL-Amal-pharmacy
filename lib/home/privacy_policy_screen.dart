import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          AppStrings.privacyPolicy,
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
            body: AppStrings.privacyIntro,
          ),

          _Section(
            title: AppStrings.privacyRegistrationTitle,
            body: AppStrings.privacyRegistrationBody,
          ),

          _Section(
            title: AppStrings.privacyDeleteTitle,
            body: AppStrings.privacyDeleteBody,
          ),

          _Section(
            title: AppStrings.privacyElectronicTitle,
            body: AppStrings.privacyElectronicBody,
          ),

          _Section(
            title: AppStrings.privacyCookiesTitle,
            body: AppStrings.privacyCookiesBody,
          ),

          _Section(
            title: AppStrings.privacyContactTitle,
            body: AppStrings.privacyContactBody,
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
    final isArabic = AppStrings.privacyPolicy == 'سياسة الخصوصية';

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          if (title != null) ...[
            Align(
              alignment: isArabic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,

              child: Text(
                title!,

                textAlign: isArabic
                    ? TextAlign.right
                    : TextAlign.left,

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

            textAlign: isArabic
                ? TextAlign.right
                : TextAlign.left,

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

