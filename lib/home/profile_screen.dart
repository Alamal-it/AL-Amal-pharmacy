import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../services/user_service.dart';
import '../services/locale_service.dart';
import '../auth/login_screen.dart';
import 'orders_screen.dart';
import 'favorites_screen.dart';
import 'account_info_screen.dart';
import 'about_company_screen.dart';
import '../widgets/delivery_option_sheet.dart';
import '../address/add_address_map_screen.dart';
import '../services/address_service.dart';
import 'faq_screen.dart';
import 'delivery_info_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'loyalty_points_screen.dart';
import 'my_prescriptions_screen.dart';
import 'family_members_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedCountry = AppStrings.saudiArabia;

  // =========================
  // تأكيد تسجيل الخروج
  // =========================
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text(
            AppStrings.logoutConfirmTitle,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          content: Text(
            AppStrings.logoutConfirmBody,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppStrings.cancel,
                style: const TextStyle(
                  color: AppColors.textGray,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                UserService.instance.isLoggedIn = false;
                UserService.instance.name = '';
                UserService.instance.phone = '';

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                AppStrings.logout,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // تأكيد حذف الحساب
  // =========================
  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text(
            AppStrings.deleteConfirmTitle,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          content: Text(
            AppStrings.deleteConfirmBody,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppStrings.cancel,
                style: const TextStyle(
                  color: AppColors.textGray,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: استدعاء API حذف الحساب لما يجهز.

                Navigator.pop(context);

                UserService.instance.isLoggedIn = false;
                UserService.instance.name = '';
                UserService.instance.phone = '';

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                AppStrings.deleteConfirmButton,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // الدولة واللغة
  // =========================
  void _showPreferences(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Text(
                    AppStrings.preferences,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      AppStrings.country,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // =========================
                  // السعودية فقط
                  // =========================
                  Row(
                    children: [
                      _prefChip(
                        AppStrings.saudiArabia,
                        selectedCountry,
                        (val) {
                          setModalState(
                            () => selectedCountry = val,
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      AppStrings.language,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _prefChip(
                        AppStrings.arabic,
                        LocaleService.instance.isArabic
                            ? AppStrings.arabic
                            : '',
                        (val) {
                          LocaleService.instance.setLocale(
                            const Locale('ar'),
                          );

                          setModalState(() {});
                          setState(() {});
                        },
                      ),

                      const SizedBox(width: 8),

                      _prefChip(
                        AppStrings.english,
                        !LocaleService.instance.isArabic
                            ? AppStrings.english
                            : '',
                        (val) {
                          LocaleService.instance.setLocale(
                            const Locale('en'),
                          );

                          setModalState(() {});
                          setState(() {});
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _prefChip(
    String label,
    String selectedValue,
    Function(String) onSelect,
  ) {
    final isSelected = label == selectedValue;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelect(label),
      selectedColor: AppColors.primary.withOpacity(0.12),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected
            ? AppColors.primary
            : AppColors.textGray,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppColors.primary
              : AppColors.border,
        ),
      ),
    );
  }

  // =========================
  // المعلومات الضريبية
  // =========================
  void _showTaxInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: AppColors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.vatCertificate,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _taxInfoRow(
                'الاسم التجاري',
                'صيدلية الأمل للأدوية',
              ),

              _taxInfoRow(
                'الاسم النظامي',
                'شركة الأمل المتقدمة الطبية',
              ),

              _taxInfoRow(
                'الرقم الضريبي',
                '310526667300003',
              ),

              _taxInfoRow(
                'رقم الشهادة',
                '100261178410787',
              ),

              _taxInfoRow(
                'تاريخ نفاذ التسجيل',
                '2020/07/20',
              ),

              const SizedBox(height: 12),

              const Text(
                'شهادة تسجيل ضريبة القيمة المضافة صادرة من هيئة الزكاة والضريبة والجمارك — المملكة العربية السعودية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textGray,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _taxInfoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // فتح روابط التواصل
  // =========================
  Future<void> _openSocial(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // =========================
  // BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    final user = UserService.instance;
    final isLoggedIn = user.isLoggedIn;

    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.myAccount,
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
          // =========================
          // معلومات الحساب
          // =========================

          _MenuTile(
            icon: Icons.person_outline,
            label: AppStrings.accountInfo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AccountInfoScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.location_on_outlined,
            label: AppStrings.addresses,
            onTap: () async {
              if (AddressService.instance.addresses.isEmpty) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddAddressMapScreen(),
                  ),
                );
              } else {
                DeliveryOptionSheet.show(context);
              }
            },
          ),

          _MenuTile(
            icon: Icons.favorite_border,
            label: AppStrings.wishlist,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FavoritesScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.receipt_long_outlined,
            label: AppStrings.myOrders,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const OrdersScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.card_giftcard_outlined,
            label: AppStrings.loyaltyPoints,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const LoyaltyPointsScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.camera_alt_outlined,
            label: AppStrings.myPrescriptions,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MyPrescriptionsScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.groups_outlined,
            label: AppStrings.familyMembers,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FamilyMembersScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              AppStrings.preferences,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),

          const SizedBox(height: 10),

          _MenuTile(
            icon: Icons.language_outlined,
            label: AppStrings.countryAndLanguage,
            onTap: () => _showPreferences(context),
          ),

          const SizedBox(height: 20),

          // =========================
          // المساعدة والدعم
          // =========================

          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              AppStrings.helpAndSupport,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),

          const SizedBox(height: 10),

          _MenuTile(
            icon: Icons.local_shipping_outlined,
            label: AppStrings.deliveryInfo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const DeliveryInfoScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.help_outline,
            label: AppStrings.faq,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FaqScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.support_agent_outlined,
            label: AppStrings.contactUs,
            onTap: () {
              // TODO: فتح شاشة التواصل لما تجهز.
            },
          ),

          _MenuTile(
            icon: Icons.info_outline,
            label: AppStrings.aboutCompany,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AboutCompanyScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.privacy_tip_outlined,
            label: AppStrings.privacyPolicy,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const PrivacyPolicyScreen(),
                ),
              );
            },
          ),

          _MenuTile(
            icon: Icons.description_outlined,
            label: AppStrings.termsConditions,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const TermsConditionsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // =========================
          // تسجيل الدخول / الخروج
          // =========================

          if (isLoggedIn) ...[
            _MenuTile(
              icon: Icons.logout,
              label: AppStrings.logout,
              isDestructive: true,
              onTap: () => _confirmLogout(context),
            ),

            _MenuTile(
              icon: Icons.delete_outline,
              label: AppStrings.deleteAccount,
              isDestructive: true,
              onTap: () => _confirmDeleteAccount(context),
            ),
          ] else
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppStrings.login,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 30),

          const Divider(
            color: AppColors.border,
          ),

          const SizedBox(height: 16),

          // =========================
          // التواصل الاجتماعي
          // =========================

          Text(
            AppStrings.stayConnected,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIcon(
                assetPath:
                    'lib/assets/instagram_icon.png',
                fallbackIcon:
                    Icons.camera_alt_outlined,
                onTap: () => _openSocial(
                  'https://www.instagram.com/alamalph',
                ),
              ),

              const SizedBox(width: 14),

              _SocialIcon(
                assetPath:
                    'lib/assets/snapchat_icon.png',
                fallbackIcon:
                    Icons.chat_bubble_outline,
                onTap: () => _openSocial(
                  'https://www.snapchat.com/add/alamalph',
                ),
              ),

              const SizedBox(width: 14),

              _SocialIcon(
                assetPath:
                    'lib/assets/tiktok_icon.png',
                fallbackIcon:
                    Icons.music_note_outlined,
                onTap: () => _openSocial(
                  'https://www.tiktok.com/@alamalph',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =========================
          // الشهادة الضريبية
          // =========================

          InkWell(
            onTap: () => _showTaxInfo(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        color: AppColors.green,
                        size: 18,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        AppStrings.vatCertificate,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    AppStrings.tapForDetails,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              '${AppStrings.version} 1.0.0',
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textGray,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ======================================================
// Menu Tile
// ======================================================

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.red
        : AppColors.primaryDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive
                ? Colors.red.withOpacity(0.3)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              LocaleService.instance.isArabic
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              color: AppColors.textGray,
              size: 18,
            ),

            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),

            const SizedBox(width: 10),

            Icon(
              icon,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// Social Icon
// ======================================================

class _SocialIcon extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.assetPath,
    required this.fallbackIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.border,
          ),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              AppColors.primaryDark,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              assetPath,
              width: 22,
              height: 22,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) {
                return Icon(
                  fallbackIcon,
                  color: AppColors.primaryDark,
                  size: 20,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}