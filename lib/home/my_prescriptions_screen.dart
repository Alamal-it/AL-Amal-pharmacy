import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'upload_prescription_screen.dart';
class MyPrescriptionsScreen extends StatelessWidget
 { const MyPrescriptionsScreen({super.key});
@override Widget build(BuildContext context)
 { // TODO: استبدال هذا بقائمة وصفات حقيقية من الـ API لما يجهز. 
 final prescriptions = <Map<String, String>>[];
return Scaffold(
  backgroundColor: AppColors.white,
  appBar: AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.primaryDark),
    centerTitle: true,
    title: const Text(
      'وصفتي',
      style: TextStyle(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    ),
  ),body: prescriptions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.border.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_outlined,
                        size: 40, color: AppColors.textGray),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد وصفات مرفوعة',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'ارفعي وصفتك الطبية ليتم مراجعتها وتجهيز طلبك',
                    style: TextStyle(color: AppColors.textGray, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UploadPrescriptionScreen(),
                        ),
                      );
                    },icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('رفع وصفة جديدة',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ): ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: prescriptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = prescriptions[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.description_outlined,
                            color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item['date'] ?? '',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['status'] ?? '',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),floatingActionButton: prescriptions.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadPrescriptionScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}