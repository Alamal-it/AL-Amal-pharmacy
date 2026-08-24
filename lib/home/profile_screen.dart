import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../services/user_service.dart';
import '../auth/login_screen.dart';
import 'orders_screen.dart';
import 'favorites_screen.dart';
import 'account_info_screen.dart';
import '../widgets/delivery_option_sheet.dart';
import '../address/add_address_map_screen.dart';
import '../services/address_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});void _showLogoutOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.primaryDark),
                  title: const Text('تسجيل الخروج',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    UserService.instance.isLoggedIn = false;
                    UserService.instance.name = '';
                    UserService.instance.phone = '';
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('حذف الحساب',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDeleteAccount(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('حذف الحساب',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark)),
          content: const Text(
            'سيتم حذف حسابك وكل بياناتك نهائياً. هل تودين المتابعة؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 13, color: AppColors.textGray),
          ),actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء',
                  style: TextStyle(color: AppColors.textGray)),
            ),
            TextButton(
              onPressed: () {
                // TODO: استدعاء API حذف الحساب لما يجهز.
                UserService.instance.isLoggedIn = false;
                UserService.instance.name = '';
                UserService.instance.phone = '';
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('حذف نهائياً',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }void _showTaxInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              const Text(
                'المعلومات الضريبية',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark),
              ),
              const SizedBox(height: 16),
              _taxInfoRow('الاسم التجاري', 'صيدلية الأمل للأدوية'),
              _taxInfoRow('الرقم الضريبي', '310526667300003'),
              _taxInfoRow('تاريخ نفاذ التسجيل', '2020/07/20'),
              const SizedBox(height: 8),
              const Text(
                'شهادة ضريبة القيمة المضافة صادرة من هيئة الزكاة والضريبة والجمارك',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textGray),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }Widget _taxInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark)),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
        ],
      ),
    );
  }

  Future<void> _openSocial(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
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
    title: const Text(
      'حسابي',
      style: TextStyle(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    ),
  ),
  body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
      // ===== بطاقة معلومات المستخدم =====
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                isLoggedIn && user.name.isNotEmpty
                    ? user.name.substring(0, 1)
                    : 'ض',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isLoggedIn && user.name.isNotEmpty
                        ? user.name
                        : 'زائر',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLoggedIn && user.phone.isNotEmpty
                        ? user.phone
                        : 'سجلي دخولك للوصول لكل الميزات',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textGray),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),const SizedBox(height: 16),
      // ===== 1. معلومات الحساب =====
      _MenuTile(
        icon: Icons.person_outline,
        label: 'معلومات الحساب',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountInfoScreen()),
          );
        },
      ),
      _MenuTile(
        icon: Icons.location_on_outlined,
        label: 'العناوين',
        onTap: () async {
          if (AddressService.instance.addresses.isEmpty) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddAddressMapScreen()),
            );
          } else {
            DeliveryOptionSheet.show(context);
          }
        },
      ),
      _MenuTile(
        icon: Icons.favorite_border,
        label: 'قائمة الأمنيات',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritesScreen()),
          );
        },
      ),
      _MenuTile(
        icon: Icons.receipt_long_outlined,
        label: 'طلباتي',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrdersScreen()),
          );
        },
      ),

      const SizedBox(height: 20),
      const Align(
        alignment: Alignment.centerRight,
        child: Text(
          'المساعدة والدعم',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark),
        ),
      ),
      const SizedBox(height: 10),

      // ===== 2. المساعدة والدعم =====
      _MenuTile(
        icon: Icons.local_shipping_outlined,
        label: 'معلومات التوصيل',
        onTap: () {
          // TODO: فتح شاشة معلومات التوصيل لما تجهز.
        },
      ),
      _MenuTile(
        icon: Icons.help_outline,
        label: 'الأسئلة الشائعة',
        onTap: () {
          // TODO: فتح شاشة الأسئلة الشائعة لما تجهز.
        },
      ),
      _MenuTile(
        icon: Icons.support_agent_outlined,
        label: 'اتصل بنا',
        onTap: () {
          // TODO: فتح شاشة التواصل لما تجهز.
        },
      ),
      _MenuTile(
        icon: Icons.info_outline,
        label: 'عن الشركة',
        onTap: () {
          // TODO: فتح شاشة "عن الشركة" لما تجهز.
        },
      ),
      _MenuTile(
        icon: Icons.privacy_tip_outlined,
        label: 'سياسة الخصوصية',
        onTap: () {
          // TODO: فتح شاشة سياسة الخصوصية لما تجهز.
        },
      ),
      _MenuTile(
        icon: Icons.description_outlined,
        label: 'الشروط والأحكام',
        onTap: () {
          // TODO: فتح شاشة الشروط والأحكام لما تجهز.
        },
      ),

      const SizedBox(height: 20),

      // ===== 3. تسجيل الخروج =====
      if (isLoggedIn)
        _MenuTile(
          icon: Icons.logout,
          label: 'تسجيل الخروج',
          isDestructive: true,
          onTap: () => _showLogoutOptions(context),
        )
      else
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('تسجيل الدخول',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ),

      const SizedBox(height: 30),
      const Divider(color: AppColors.border),
      const SizedBox(height: 16),

      // ===== 4. أيقونات التواصل الاجتماعي (روابط حقيقية) =====
      const Text(
        'تابعينا',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12.5,fontWeight: FontWeight.w700,
            color: AppColors.primaryDark),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SocialIcon(
            icon: Icons.camera_alt_outlined,
            onTap: () =>
                _openSocial('https://www.instagram.com/alamalph'),
          ),
          const SizedBox(width: 14),
          _SocialIcon(
            icon: Icons.chat_bubble_outline,
            onTap: () =>
                _openSocial('https://www.snapchat.com/add/alamalph'),
          ),
          const SizedBox(width: 14),
          _SocialIcon(
            icon: Icons.music_note_outlined,
            onTap: () =>
                _openSocial('https://www.tiktok.com/@alamalph'),
          ),
        ],
      ),

      const SizedBox(height: 24),

      // ===== 5. معلومات الشركة الضريبية (زي النهدي) =====
      InkWell(
        onTap: () => _showTaxInfo(context),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: const [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_outlined,
                      color: AppColors.green, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'شهادة ضريبة القيمة المضافة',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'صيدلية الأمل للأدوية — اضغطي للتفاصيل',
                style: TextStyle(fontSize: 10.5, color: AppColors.textGray),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 12),
      const Center(
        child: Text('الإصدار 1.0.0',
            style: TextStyle(fontSize: 10.5, color: AppColors.textGray)),
      ),
      const SizedBox(height: 10),
    ],
  ),
);
} }
class _MenuTile extends StatelessWidget { 
  final IconData icon; 
  final String label; 
  final VoidCallback onTap;
  final bool isDestructive;
const _MenuTile({ required this.icon, required this.label, 
required this.onTap, this.isDestructive = false, });
@override 
Widget build(BuildContext context) { 
  final color = isDestructive ? Colors.red : AppColors.primaryDark;
return InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(12),
  child: Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        const Icon(Icons.chevron_left, color: AppColors.textGray, size: 18),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: color),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, color: color, size: 20),
      ],
    ),
  ),
);
} }
class _SocialIcon extends StatelessWidget {
   final IconData icon; 
   final VoidCallback onTap;
const _SocialIcon({required this.icon, required this.onTap});
@override 
Widget build(BuildContext context) {
   return InkWell( onTap: onTap, borderRadius: BorderRadius.circular(24),
    child: Container( width: 44,
     height: 44,
      decoration: BoxDecoration( border: Border.all(color: AppColors.border),
       shape: BoxShape.circle, ), child: Icon(icon, color: AppColors.primaryDark, size: 20), 
        ),
         );
          } 
            }