import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/locale_service.dart';
import '../core/app_strings.dart';

class AboutCompanyScreen extends StatelessWidget {
  const AboutCompanyScreen({super.key});

  static const String _aboutAr =
      'تأسست شركة الأمل المتقدمة الطبية عام 1997، حيث بدأت كأحد فروع صيدليات الأمل لتتوسع لاحقاً وتصبح منظومة متكاملة في قطاع الرعاية الصحية والصيدلانية في المنطقة الجنوبية من المملكة العربية السعودية.\n\nعلى مدار أكثر من 25 عاماً، نجحت الشركة في بناء شبكة واسعة من الخدمات الصحية التي تلبي احتياجات المجتمع بجودة عالية وكفاءة ومعايير احترافية.';

  static const String _aboutEn =
      'Alamal Advanced Medical Company was founded in 1997, starting as one of the Alamal Pharmacies branches before growing into a fully integrated healthcare and pharmaceutical system across the southern region of Saudi Arabia.\n\nOver more than 25 years, the company has built a wide network of health services that meet the community\'s needs with high quality, efficiency, and professional standards.';

  @override
  Widget build(BuildContext context) {
    final isAr = LocaleService.instance.isArabic;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        centerTitle: true,
        title: Text(
          AppStrings.aboutCompany,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== شعار/هيدر الشركة =====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'lib/assets/alamal.png',
                      width: 54,
                      height: 54,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.local_pharmacy_outlined,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isAr ? 'صيدلية الأمل للأدوية' : 'Alamal Pharmacy',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAr ? 'رعاية صحية موثوقة منذ 1997' : 'Trusted care since 1997',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ===== إحصاءات سريعة (زي التطبيقات الاحترافية) =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '25+',
                      label: isAr ? 'سنة خبرة' : 'Years of experience',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: '99+',
                      label: isAr ? 'فرع' : 'Branches',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: '1997',
                      label: isAr ? 'سنة التأسيس' : 'Founded',
                    ),
                  ),
                ],
              ),
            ),

            // ===== النص التعريفي =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffF7F9FC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  isAr ? _aboutAr : _aboutEn,
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray,
                    height: 1.9,
                  ),
                ),
              ),
            ),

            // ===== قيم الشركة =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment:
                        isAr ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      isAr ? 'قيمنا' : 'Our Values',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ValueTile(
                    icon: Icons.verified_user_outlined,
                    title: isAr ? 'الجودة والموثوقية' : 'Quality & Trust',
                    subtitle: isAr
                        ? 'منتجات وخدمات صحية بأعلى معايير الجودة'
                        : 'Health products and services at the highest quality standards',
                    isAr: isAr,
                  ),
                  _ValueTile(
                    icon: Icons.favorite_border,
                    title: isAr ? 'رعاية إنسانية' : 'Compassionate Care',
                    subtitle: isAr
                        ? 'نضع صحتك وراحتك في مقدمة أولوياتنا'
                        : 'Your health and comfort are always our priority',
                    isAr: isAr,
                  ),
                  _ValueTile(
                    icon: Icons.bolt_outlined,
                    title: isAr ? 'سرعة وكفاءة' : 'Speed & Efficiency',
                    subtitle: isAr
                        ? 'توصيل سريع وخدمة تعتمد عليها في أي وقت'
                        : 'Fast delivery and reliable service, anytime',
                    isAr: isAr,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGray),
          ),
        ],
      ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isAr;

  const _ValueTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}