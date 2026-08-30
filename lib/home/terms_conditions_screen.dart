import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // هذا المحتوى عربي بالكامل وثابت (مو مترجم)، فنجبر الاتجاه RTL دايمًا
    // بغض النظر عن لغة التطبيق العامة، عشان النص يبقى من اليمين ثابت
    // ولا يتأثر لو المستخدم مبدّل التطبيق للإنجليزي.
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
            'الشروط والأحكام',
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
                  'أهلاً بكم في تطبيق صيدليات الأمل الإلكتروني. باستخدامك للتطبيق فإنك تقرّين وتوافقين على أنك قرأتِ وفهمتِ بنود وأحكام هذه الاتفاقية وطريقة استخدام التطبيق، وأنك بكامل الأهلية المعتبرة شرعًا وقانونًا.\n\n'
                  'هذه الشروط قابلة للتعديل من قبلنا في أي وقت، واستمرار استخدامك للتطبيق بعد نشر أي تغيير يعني موافقتك على الشروط المعدّلة.',
            ),
            _Section(
              title: 'شروط التسجيل',
              body:
                  '• أن تكوني بالغة السن القانونية (18 عامًا) لتتمكني من شراء المنتجات.\n'
                  '• أن تكوني قادرة على تقديم عنوان داخل المملكة العربية السعودية لتسليم المنتجات.\n'
                  '• لا يحق لأي شخص استخدام التطبيق إذا أُلغيت عضويته من قبل صيدلية الأمل.\n'
                  '• لا يحق لأي عميل استخدام بريد إلكتروني واحد أو رقم جوال واحد لفتح أكثر من حساب.',
            ),
            _Section(
              title: 'التزامات العميل',
              body:
                  '• المحافظة على سرية حسابك وكلمة المرور، وتحمل مسؤولية جميع الأنشطة التي تتم من خلاله.\n'
                  '• إخطارنا فورًا عن أي استخدام غير مصرح به لحسابك.\n'
                  '• تقديم معلومات كاملة وحقيقية ودقيقة عن نفسك.\n'
                  '• عدم استخدام التطبيق بما يخالف الأنظمة والقوانين المعمول بها في المملكة العربية السعودية.',
            ),
            _Section(
              title: 'الدفع',
              body:
                  'يوفر التطبيق إمكانية الدفع عند الاستلام أو عبر الإنترنت. جميع عمليات الدفع تتم بالريال السعودي، ويتم قبول البطاقات الائتمانية الصادرة من بنوك سعودية عبر بوابة الدفع الإلكترونية المعتمدة.\n\n'
                  'نحن لا نقوم بتخزين معلومات بطاقتك الائتمانية على التطبيق، وجميع البيانات المدخلة عبر بوابة الدفع يتم تشفيرها لأغراض الحماية الأمنية.',
            ),
            _Section(
              title: 'تنبيه هام حول منتجات الأدوية',
              body:
                  'يجب استشارة الطبيب المختص حول كيفية استخدام الأدوية. لا نبيع الأدوية التي تتطلب وصفة طبية إلا بوصفة، ويحق لنا إيقاف أي طلب نتأكد أنه كميات بيع وليست كميات استخدام.',
            ),
            _Section(
              title: 'إلغاء الطلب',
              body:
                  'يحق لصيدلية الأمل إلغاء الطلب في حال: رفض عملية الدفع، تأخر العميل عن الدفع لأكثر من 12 ساعة، خطأ في عنوان التوصيل أو معلومات الاتصال، أو عدم استلام الطلب خلال المدة المحددة.\n\n'
                  'يحق للعميل إلغاء طلبه قبل شحنه بالتواصل معنا مباشرة.',
            ),
            _Section(
              title: 'الاسترجاع والاستبدال ورد المدفوعات',
              body:
                  'في حال عدم رضاك عن المنتج أو وجود خلل فيه، يمكنك خلال 3 أيام من الاستلام طلب إعادة المنتج، ولن يتم رد المبلغ إلا بعد استلامنا للمنتج وفحص حالته.\n\n'
                  'استثناءات لا تُرجع أو تُستبدل: منتجات الصحة والجمال (أجهزة حلاقة، عناية بالفم والأسنان)، الأصناف التي تحتاج تبريدًا (كالإنسولين)، أصناف درجة الحرارة الثابتة (حليب وأكل الأطفال)، والمنتجات المصروفة عبر التأمين الطبي.',
            ),
            _Section(
              title: 'الضمان',
              body: 'يكون الضمان فقط للأجهزة الطبية حسب ضمان الوكيل.',
            ),
            _Section(
              title: 'القانون المنظم',
              body:
                  'تخضع جميع شروط الخدمة وتُفسر وفقًا للقوانين المعمول بها في المملكة العربية السعودية، وفي حال نشوء أي نزاع يتم اللجوء للتحكيم.',
            ),
            _Section(
              title: 'للتواصل معنا',
              body: 'البريد الإلكتروني: admin@alamalph.com\n\n'
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