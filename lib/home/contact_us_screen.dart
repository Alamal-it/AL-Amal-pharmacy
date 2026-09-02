import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // =========================
  // بيانات التواصل — عدّلي القيم هنا لو تغيّرت
  // =========================
  static const String _phoneNumber = '966535555440';
  static const String _email = 'online@alamalph.com';
  static const String _workingHours =
      'الأحد - الخميس، من 10 صباحًا حتى 6 مساءً';

  Future<void> _launch(BuildContext context, Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.unableToOpenApp)),
      );
    }
  }

  void _call(BuildContext context) =>
      _launch(context, Uri(scheme: 'tel', path: _phoneNumber));

  void _sendEmail(BuildContext context) =>
      _launch(context, Uri(scheme: 'mailto', path: _email));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.contactUs,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            AppStrings.contactInformation,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),

          const SizedBox(height: 16),

          _ContactCard(
            children: [
              _ContactRow(
                icon: Icons.call_outlined,
                label: _phoneNumber,
                onTap: () => _call(context),
              ),
              const _RowDivider(),
              _InfoRow(
                icon: Icons.access_time_outlined,
                label: AppStrings.workingHours,
              ),
              const _RowDivider(),
              _ContactRow(
                icon: Icons.mail_outline,
                label: _email,
                onTap: () => _sendEmail(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// بطاقة تجميع صفوف معلومات الاتصال
// ======================================================

class _ContactCard extends StatelessWidget {
  final List<Widget> children;

  const _ContactCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
    );
  }
}

// ======================================================
// صف قابل للضغط (اتصال / إيميل)
// ======================================================

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryDark),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// صف معلومة عادية (غير قابل للضغط)
// ======================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textGray),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textGray,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}