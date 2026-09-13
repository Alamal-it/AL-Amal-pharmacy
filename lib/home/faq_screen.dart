import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../services/locale_service.dart';

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({
    required this.question,
    required this.answer,
  });
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? expandedIndex;

  List<FaqItem> get faqs => [
        FaqItem(
          question: AppStrings.faqPrescriptionQuestion,
          answer: AppStrings.faqPrescriptionAnswer,
        ),
        FaqItem(
          question: AppStrings.faqDeliveryQuestion,
          answer: AppStrings.faqDeliveryAnswer,
        ),
        FaqItem(
          question: AppStrings.faqPickupQuestion,
          answer: AppStrings.faqPickupAnswer,
        ),
        FaqItem(
          question: AppStrings.faqPaymentQuestion,
          answer: AppStrings.faqPaymentAnswer,
        ),
        FaqItem(
          question: AppStrings.faqReturnQuestion,
          answer: AppStrings.faqReturnAnswer,
        ),
        FaqItem(
          question: AppStrings.faqOrderQuestion,
          answer: AppStrings.faqOrderAnswer,
        ),
        FaqItem(
          question: AppStrings.faqCoverageQuestion,
          answer: AppStrings.faqCoverageAnswer,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final isArabic = LocaleService.instance.isArabic;
    final textAlign =
        isArabic ? TextAlign.right : TextAlign.left;

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
          AppStrings.faq,
          textAlign: textAlign,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isExpanded = expandedIndex == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isExpanded
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isExpanded
                    ? AppColors.primary
                    : AppColors.border,
                width: isExpanded ? 1.4 : 1,
              ),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      expandedIndex =
                          isExpanded ? null : index;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    child: Row(
                      textDirection: isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Icon(
                          isExpanded
                              ? Icons.remove_circle_outline
                              : Icons.add_circle_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            faq.question,
                            textAlign: textAlign,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      14,
                      0,
                      14,
                      14,
                    ),
                    child: Align(
                      alignment: isArabic
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        faq.answer,
                        textAlign: textAlign,
                        textDirection: isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textGray,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
