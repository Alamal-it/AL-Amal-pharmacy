import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
import '../core/app_strings.dart';

enum PaymentMethod { insurance, cash }

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState
    extends State<UploadPrescriptionScreen> {
  File? selectedImage;

  final TextEditingController noteController = TextEditingController();
  final TextEditingController membershipController =
      TextEditingController();
  final TextEditingController idController = TextEditingController();

  PaymentMethod paymentMethod = PaymentMethod.cash;

  String? selectedInsuranceCompany;
  bool isSubmitting = false;

  // شركات التأمين
  List<String> get insuranceCompanies => [
        AppStrings.insuranceBupa,
        AppStrings.insuranceTawuniya,
        AppStrings.insuranceMedgulf,
        AppStrings.insuranceWalaa,
        AppStrings.insuranceAlRajhi,
        AppStrings.insuranceOther,
      ];

  @override
  void dispose() {
    noteController.dispose();
    membershipController.dispose();
    idController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    AppStrings.takePrescriptionPhoto,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    AppStrings.chooseFromGallery,
                  ),
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
  }

  bool get canSubmit {
    if (selectedImage == null) {
      return false;
    }

    if (paymentMethod == PaymentMethod.insurance) {
      return selectedInsuranceCompany != null &&
          membershipController.text.trim().isNotEmpty &&
          idController.text.trim().isNotEmpty;
    }

    return true;
  }

  Future<void> submitPrescription() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.attachPrescriptionFirst,
          ),
        ),
      );
      return;
    }

    if (paymentMethod == PaymentMethod.insurance) {
      if (selectedInsuranceCompany == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.selectInsuranceFirst,
            ),
          ),
        );
        return;
      }

      if (membershipController.text.trim().isEmpty ||
          idController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.completeInsuranceData,
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      isSubmitting = true;
    });

    // TODO:
    // رفع الصورة وبيانات التأمين/الدفع إلى الـ API الحقيقي
    // عندما يكون جاهزًا.

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isSubmitting = false;
    });

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
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  AppStrings.prescriptionSentSuccessfully,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  paymentMethod == PaymentMethod.insurance
                      ? AppStrings.insuranceCoverageCheckingMessage
                      : AppStrings.prescriptionReviewMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
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
                    child: Text(
                      AppStrings.doneButton,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.primaryDark,
        ),
        centerTitle: true,
        title: Text(
          AppStrings.wasfaty,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ==================================================
            // شعار وصفتي
            // ==================================================

            Center(
              child: Image.asset(
                'lib/assets/wasfaty_logo.png',
                height: 80,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              AppStrings.prescriptionDescription,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textGray,
                fontSize: 12.5,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // منطقة الصورة
            // ==================================================

            InkWell(
              onTap: showImageSourceSheet,
              borderRadius: BorderRadius.circular(14),

              child: Container(
                height: 200,

                decoration: BoxDecoration(
                  color: AppColors.border.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border,
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
                              color: AppColors.primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            AppStrings.attachPrescription,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            AppStrings.cameraOrGallery,
                            style: const TextStyle(
                              color: AppColors.textGray,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )

                    : Stack(
                        fit: StackFit.expand,
                        children: [

                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),

                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned(
                            top: 8,
                            left: 8,

                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedImage = null;
                                });
                              },

                              child: Container(
                                padding: const EdgeInsets.all(6),

                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // طريقة الدفع
            // ==================================================

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.paymentMethodTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: _PaymentOptionCard(
                    icon: Icons.payments_outlined,
                    label: AppStrings.cashPayment,
                    selected:
                        paymentMethod == PaymentMethod.cash,
                    onTap: () {
                      setState(() {
                        paymentMethod = PaymentMethod.cash;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _PaymentOptionCard(
                    icon: Icons.health_and_safety_outlined,
                    label: AppStrings.medicalInsurance,
                    selected:
                        paymentMethod == PaymentMethod.insurance,
                    onTap: () {
                      setState(() {
                        paymentMethod =
                            PaymentMethod.insurance;
                      });
                    },
                  ),
                ),
              ],
            ),

            // ==================================================
            // بيانات التأمين
            // ==================================================

            if (paymentMethod == PaymentMethod.insurance) ...[

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppStrings.insuranceInformation,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: selectedInsuranceCompany,
                isExpanded: true,
                alignment: Alignment.centerRight,

                decoration: InputDecoration(
                  hintText: AppStrings.selectInsuranceCompany,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                items: insuranceCompanies
                    .map(
                      (company) => DropdownMenuItem<String>(
                        value: company,
                        alignment: Alignment.centerRight,
                        child: Text(
                          company,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    )
                    .toList(),

                onChanged: (value) {
                  setState(() {
                    selectedInsuranceCompany = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              TextField(
                controller: membershipController,
                textAlign: TextAlign.right,

                decoration: InputDecoration(
                  hintText:
                      AppStrings.insuranceMembershipNumber,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: idController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  hintText: AppStrings.idOrIqamaNumber,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color:
                      AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Row(
                  children: [

                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 16,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        AppStrings.insuranceVerificationNotice,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ==================================================
            // الملاحظات
            // ==================================================

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.additionalNotesOptional,
                style: const TextStyle(
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
                hintText: AppStrings.prescriptionNoteHint,
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGray,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // زر الإرسال
            // ==================================================

            SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed:
                    isSubmitting ? null : submitPrescription,

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
                              AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )

                    : Text(
                        AppStrings.sendPrescription,
                        style: const TextStyle(
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
  }
}

// ======================================================
// كرت طريقة الدفع
// ======================================================

class _PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),

        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),

        child: Column(
          children: [

            Icon(
              icon,
              color: selected
                  ? AppColors.primary
                  : AppColors.textGray,
              size: 26,
            ),

            const SizedBox(height: 8),

            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected
                    ? AppColors.primary
                    : AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

