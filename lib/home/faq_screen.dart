import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? expandedIndex;// TODO: استبدال هذي القائمة بأسئلة حقيقية من الـ API أو من مديرك لاحقاً.
  final List<FaqItem> faqs = const [
    FaqItem(
      question: 'كيف أقدر أطلب دواء يحتاج وصفة طبية؟',
      answer:
          'من الصفحة الرئيسية اضغطي على "رفع وصفة"، صوّري الوصفة أو اختاريها من المعرض، وسيقوم فريقنا بمراجعتها والتواصل معك لإتمام الطلب.',
    ),
    FaqItem(
      question: 'كم تستغرق مدة التوصيل؟',
      answer:
          'عادة يصل طلبك خلال 30 إلى 60 دقيقة داخل نطاق التغطية، وتقدرين تحددين موعد توصيل مناسب لك عند إتمام الطلب.',
    ),
    FaqItem(
      question: 'هل أقدر أستلم طلبي من الفرع مباشرة؟',
      answer:
          'نعم، عند إتمام الشراء اختاري "استلام من الفرع" وحددي أقرب فرع لك من الخريطة، وسيكون طلبك جاهزاً للاستلام في الوقت المحدد.',
    ),
    FaqItem(
      question: 'ما هي طرق الدفع المتاحة؟',
      answer:
          'نوفر الدفع عبر مدى، فيزا/ماستركارد، Apple Pay، الدفع عند الاستلام، بالإضافة إلى خدمتي تمارا وتابي للتقسيط.',
    ),
    FaqItem(
      question: 'هل أقدر أرجع أو أستبدل منتج بعد الاستلام؟',
      answer:
          'نعم، يمكنك التواصل مع خدمة العملاء خلال 24 ساعة من الاستلام لطلب الإرجاع أو الاستبدال وفق سياسة الاستبدال والاسترجاع الخاصة بنا.',
    ),
    FaqItem(
      question: 'كيف أتابع حالة طلبي؟',
      answer:
          'من صفحة "حسابي" اضغطي على "طلباتي" لمتابعة حالة كل طلب لحظة بلحظة، من التجهيز وحتى التسليم.',
    ),
    FaqItem(
      question: 'هل التطبيق متوفر في كل مناطق المملكة؟',
      answer:
          'حالياً نغطي المنطقة الجنوبية من المملكة العربية السعودية عبر شبكة فروعنا، ونعمل على التوسع تباعاً لمناطق أخرى.',
    ),
  ];@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        centerTitle: true,
        title: Text(
          AppStrings.faq,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isExpanded = expandedIndex
          == index;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isExpanded
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded ? AppColors.primary : AppColors.border,
            width: isExpanded ? 1.4 : 1,
          ),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                child: Row(
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
                        textAlign: TextAlign.right,
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
            ),if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        faq.answer,
                        textAlign: TextAlign.right,
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