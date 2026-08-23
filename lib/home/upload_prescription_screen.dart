import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  File? selectedImage;
  final TextEditingController noteController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
  Future<void> pickImage(ImageSource source)
   async {
     final picker = ImagePicker();
     final picked = await picker.pickImage(source: source, imageQuality: 80);
     if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
  });
}
}
void showImageSourceSheet() {
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
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.primary),
                  title: const Text('التقاط صورة بالكاميرا'),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined,
                      color: AppColors.primary),
                  title: const Text('اختيار من المعرض'),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }Future<void> submitPrescription() async { if (selectedImage == null) { ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('الرجاء إرفاق صورة الوصفة أولاً')), ); return; }
setState(() => isSubmitting = true);

// TODO: رفع الصورة والملاحظة إلى الـ API الحقيقي لما يجهز.
await Future.delayed(const Duration(seconds: 1));

if (!mounted) return;
setState(() => isSubmitting = false);

showDialog(
  context: context,
  builder: (context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 36),
            ),
            const SizedBox(height: 18),
            const Text(
              'تم إرسال وصفتك بنجاح',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'سيتم مراجعتها والتواصل معك قريباً',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textGray),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('تم',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
}
@override Widget build(BuildContext context) { return Scaffold( backgroundColor: AppColors.white, appBar: AppBar( backgroundColor: AppColors.white, elevation: 0, iconTheme: const IconThemeData(color: AppColors.primaryDark), centerTitle: true, title: const Text( 'رفع وصفة طبية', style: TextStyle( color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 16, ), ), ), body: SingleChildScrollView( padding: const EdgeInsets.all(16), child: Column( crossAxisAlignment: CrossAxisAlignment.stretch, children: [ const Text( 'ارفعي صورة واضحة لوصفتك الطبية وسيقوم فريقنا بمراجعتها وتجهيز طلبك', textAlign: TextAlign.right, style: TextStyle( color: AppColors.textGray, fontSize: 12.5, height: 1.6, ), ), const SizedBox(height: 20),
        // ===== منطقة الصورة =====
        InkWell(
          onTap: showImageSourceSheet,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.border.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.border,
                style: BorderStyle.solid,
              ),
            ),
            child: selectedImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined,color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'اضغطي لإرفاق صورة الوصفة',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'كاميرا أو من المعرض',
                        style: TextStyle(
                            color: AppColors.textGray, fontSize: 11),
                      ),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(selectedImage!,
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: InkWell(
                          onTap: () =>
                              setState(() => selectedImage = null),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'ملاحظات إضافية (اختياري)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: noteController,
          textAlign: TextAlign.right,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'مثال: أحتاج توصيل بسرعة',
            hintStyle:
                const TextStyle(fontSize: 12, color: AppColors.textGray),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 28),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : submitPrescription,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'إرسال الوصفة',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    ),
  ),
);
} }