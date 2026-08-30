import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class DeliveryInfoScreen extends StatelessWidget {
  const DeliveryInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        centerTitle: true,
        title: const Text(
          'معلومات التوصيل',
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
            title: 'مدة التوصيل',
            body:
                'تاريخ عملية الشحن يعتمد على طلب الشراء الخاص بك، من ناحية المدينة وطريقة الدفع. يرجى الملاحظة أن طلبات الحجز غير مدرجة ضمن الوقت القياسي للشحن الملخص أدناه.\n\n'
                'الحد الأقصى للتوصيل هو 7 أيام عمل للطلبات خارج نطاق تواجدنا، أما في المدن المتواجدين فيها كجازان وأبها وخميس مشيط فإن مدة التوصيل من ساعتين إلى يومي عمل، ويتوقف ذلك على نوعية الأصناف وكمياتها.\n\n'
                'وقت التوصيل يتم بالتقدير وليس مضمونًا. لمراجعة تاريخ ووقت التوصيل المقدّر يرجى مراجعة صفحة المنتج، حيث يتم تحديثها بانتظام بالاعتماد على أحدث المعلومات.',
          ),
          _Section(
            title: 'تنسيق موعد التوصيل',
            body:
                'يعتمد التوصيل على قبول العميل وتحديد موعد التوصيل مع فريق صيدلية الأمل أو شركات الشحن الأخرى. في حال تعذّر الاتصال بالعميل بالموعد المحدد، قد يحصل تأخير في توصيل الشحنة دون أدنى مسؤولية على شركة الأمل.',
          ),
          _Section(
            title: 'التوصيل المجاني',
            body:
                'تتكفل صيدليات الأمل بخدمة التوصيل المجاني للطلبات التي تبلغ 199 ريالًا وأكثر.',
          ),
          _Section(
            title: 'نطاق التغطية',
            body:
                'يرجى الملاحظة أن طلبات الشراء التي يكون مكان إقامة العميل فيها غير محدد ضمن قائمة المدن والأحياء في عنوان الشحن، يحق لصيدليات الأمل إلغاؤها مباشرة.\n\n'
                'إذا تم طلب الشراء لمنتجات كبيرة وصغيرة معًا، فقد يتم توصيلها للمكان المحدد لكن بشحنات مختلفة وأوقات مختلفة.',
          ),
          _Section(
            title: 'الاستلام من الصيدلية',
            body:
                'لا تريدين انتظار التوصيل؟ استلمي من الصيدلية!\n\n'
                'ببساطة اطلبي المنتج من التطبيق واختاري "استلام من الصيدلية" كخيار للتوصيل، وسنقوم بتجهيز طلبك لاستلامه من الفرع الذي تم اختياره.\n\n'
                'الخدمة متاحة في جميع صيدليات الأمل في حال توفر المنتجات، وسيصلك إشعار عند جاهزية طلبك للاستلام.\n\n'
                'يمكن الدفع في الصيدلية عند استلام الطلب، أو عبر التطبيق عند إنشاء الطلب.',
          ),
        ],
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