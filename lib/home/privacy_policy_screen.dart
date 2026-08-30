import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // محتوى عربي ثابت — نجبر RTL دايمًا بغض النظر عن لغة التطبيق.
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primaryDark),
          centerTitle: true,
          title: const Text(
            'سياسة الخصوصية',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _Section(
              body:
                  'نحن على علم بمسؤوليتنا تجاه حماية معلوماتك الشخصية ونأخذ هذا الأمر بجدية تامة. نقوم بتخزين ومعالجة معلوماتك الشخصية من خلال خوادمنا المحمية بأجهزة وبرامج ذات تقنية أمنية عالية.\n\n'
                  'في حال اعتراضك على معالجتنا لمعلوماتك الشخصية، يمكنك إرسال طلبك إلى admin@alamalph.com أو تجنب استخدام خدمات التطبيق.',
            ),
            _Section(
              title: 'التسجيل — حسابي الشخصي',
              body:
                  'تتضمن عملية التسجيل معلوماتك الشخصية التي تزودنا بها لإتمام معاملاتك وللتواصل معك. تشكل هذه المعلومات جزءًا من سجلك الخاص لتعاملاتك مع خدماتنا.\n\n'
                  'أنتِ مسؤولة عن المحافظة على سرية حسابك الشخصي وكلمة المرور، وعن جميع العمليات التي تتم من خلال حسابك. في حال الشك بوجود عمليات مشبوهة، يرجى إخطارنا فورًا.',
            ),
            _Section(
              title: 'إلغاء حسابك الشخصي',
              body:
                  'تستطيعين في أي وقت إلغاء وحذف حسابك الشخصي، كما يحق لنا حذف الحساب في أي وقت إذا تأكدنا أنه احتيالي أو أن استخدامه لا يتوافق مع سياسة الخصوصية وشروط الاستخدام لدينا.',
            ),
            _Section(
              title: 'التواصل الإلكتروني',
              body:
                  'باستخدامك للتطبيق وخدماتنا الإلكترونية، فإنك توافقين على استقبال رسائلنا الإلكترونية بجميع أشكالها (بريد إلكتروني، نشرات دورية، إشعارات). يمكنك إلغاء استلام الرسائل الترويجية بالضغط على خيار إلغاء الاشتراك المتوفر أسفل الرسائل.\n\n'
                  'يحق لنا مراقبة وتسجيل وحفظ أي تواصل معك لأغراض تدريبية بهدف تحسين جودة الخدمة المقدمة.',
            ),
            _Section(
              title: 'ملفات السجل وملفات تعريف الارتباط',
              body:
                  'نقوم بجمع بيانات تشمل عنوان بروتوكول الإنترنت (IP) الخاص بك، ومزود خدمة الإنترنت، والمتصفح المستخدم، ووقت وصفحات الزيارة.\n\n'
                  'نستخدم ملفات تعريف الارتباط (Cookies) لتحسين تجربة الاستخدام وتخصيصها، مثل حفظ تفضيلاتك الشخصية وتسجيل الدخول التلقائي لبعض الميزات.',
            ),
            _Section(
              title: 'للتواصل معنا',
              body: 'إن كانت لديك أي استفسارات بخصوص سياسة الخصوصية، يمكنك التواصل معنا عبر:\n\n'
                  'البريد الإلكتروني: admin@alamalph.com\n\n'
                  'العنوان: مدينة جازان، المنطقة الصناعية، جازان 82511، المملكة العربية السعودية.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String? title;
  final String body;

  const _Section({this.title, required this.body});

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