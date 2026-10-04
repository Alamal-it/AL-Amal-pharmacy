import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_strings.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import 'order_confirmation_screen.dart';

enum PaymentChoice {
  mada,
  card,
  applePay,
  cashOnDelivery,
  tamara,
  tabby,
  wallet,
}

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;

  final bool isPickup;
  final String? addressLine;
  final String? timeSlot;
  final double? destinationLat;
  final double? destinationLng;

  const PaymentMethodScreen({
    super.key,
    required this.totalAmount,
    this.isPickup = true,
    this.addressLine,
    this.timeSlot,
    this.destinationLat,
    this.destinationLng,
  });

  @override
  State<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState
    extends State<PaymentMethodScreen> {
  PaymentChoice selected = PaymentChoice.mada;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController cardNumberController =
      TextEditingController();

  final TextEditingController cardHolderController =
      TextEditingController();

  final TextEditingController expiryController =
      TextEditingController();

  final TextEditingController cvvController =
      TextEditingController();

  bool obscureCardNumber = true;
  bool obscureCvv = true;
  bool isProcessing = false;

  // =========================================================
  // طرق الدفع
  // =========================================================

  List<_PaymentOption> get options => [
        _PaymentOption(
          choice: PaymentChoice.mada,
          label: AppStrings.mada,
          subtitle: 'بطاقة مدى البنكية',
          assetPath: 'lib/assets/mada_icon.png',
          fallbackIcon: Icons.credit_card,
        ),
        _PaymentOption(
          choice: PaymentChoice.card,
          label: AppStrings.visaMastercard,
          subtitle: 'Visa / Mastercard',
          assetPath: 'lib/assets/visa_mastercard_icon.png',
          fallbackIcon: Icons.credit_card_outlined,
        ),
        _PaymentOption(
          choice: PaymentChoice.applePay,
          label: AppStrings.applePay,
          subtitle: 'دفع سريع وآمن',
          assetPath: 'lib/assets/apple_pay_icon.png',
          fallbackIcon: Icons.apple,
        ),
        _PaymentOption(
          choice: PaymentChoice.cashOnDelivery,
          label: AppStrings.cashOnDelivery,
          subtitle: 'الدفع عند استلام الطلب',
          assetPath: null,
          fallbackIcon: Icons.payments_outlined,
        ),
        _PaymentOption(
          choice: PaymentChoice.tamara,
          label: AppStrings.tamara,
          subtitle: 'قسّم مشترياتك بسهولة',
          assetPath: 'lib/assets/tamara_icon.png',
          fallbackIcon: Icons.calendar_month_outlined,
        ),
        _PaymentOption(
          choice: PaymentChoice.tabby,
          label: AppStrings.tabby,
          subtitle: 'ادفع على دفعات',
          assetPath: 'lib/assets/tabby_icon.png',
          fallbackIcon: Icons.calendar_today_outlined,
        ),
        _PaymentOption(
          choice: PaymentChoice.wallet,
          label: AppStrings.internalWallet,
          subtitle: 'استخدم رصيد محفظتك',
          assetPath: null,
          fallbackIcon:
              Icons.account_balance_wallet_outlined,
        ),
      ];

  // =========================================================
  // Dispose
  // =========================================================

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();

    super.dispose();
  }

  // =========================================================
  // اختيار طريقة الدفع
  // =========================================================

  void selectPayment(PaymentChoice choice) {
    FocusScope.of(context).unfocus();

    setState(() {
      selected = choice;
    });
  }

  // =========================================================
  // تنسيق رقم البطاقة
  // =========================================================

  String formatCardNumber(String value) {
    final clean = value.replaceAll(' ', '');

    final buffer = StringBuffer();

    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }

      buffer.write(clean[i]);
    }

    return buffer.toString();
  }

  // =========================================================
  // حقل الإدخال
  // =========================================================

  Widget inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textDirection: TextDirection.ltr,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        color: AppColors.primaryDark,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          color: AppColors.primaryDark.withValues(
            alpha: 0.55,
          ),
          fontSize: 12,
        ),
        hintStyle: TextStyle(
          color: AppColors.primaryDark.withValues(
            alpha: 0.25,
          ),
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: AppColors.border.withValues(
              alpha: 0.55,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: AppColors.green,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // بيانات البطاقة
  // =========================================================

  Widget buildCardDetails() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          Container(
            height: 1,
            color: AppColors.border.withValues(
              alpha: 0.45,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'بيانات البطاقة',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          inputField(
            label: 'رقم البطاقة',
            hint: '0000 0000 0000 0000',
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            obscureText: obscureCardNumber,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureCardNumber =
                      !obscureCardNumber;
                });
              },
              icon: Icon(
                obscureCardNumber
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 19,
                color: AppColors.primaryDark
                    .withValues(alpha: 0.45),
              ),
            ),
            onChanged: (value) {
              final formatted =
                  formatCardNumber(value);

              if (formatted != value) {
                cardNumberController.value =
                    TextEditingValue(
                  text: formatted,
                  selection:
                      TextSelection.collapsed(
                    offset: formatted.length,
                  ),
                );
              }
            },
            validator: (value) {
              final clean =
                  value?.replaceAll(' ', '') ?? '';

              if (clean.isEmpty) {
                return 'أدخل رقم البطاقة';
              }

              if (clean.length < 15) {
                return 'رقم البطاقة غير مكتمل';
              }

              return null;
            },
          ),

          const SizedBox(height: 12),

          inputField(
            label: 'اسم حامل البطاقة',
            hint: 'الاسم كما هو مكتوب على البطاقة',
            controller: cardHolderController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'أدخل اسم حامل البطاقة';
              }

              return null;
            },
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: inputField(
                  label: 'تاريخ الانتهاء',
                  hint: 'MM/YY',
                  controller: expiryController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'مطلوب';
                    }

                    if (!RegExp(
                      r'^\d{2}/\d{2}$',
                    ).hasMatch(value.trim())) {
                      return 'MM/YY';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: inputField(
                  label: 'CVV',
                  hint: '•••',
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: obscureCvv,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureCvv = !obscureCvv;
                      });
                    },
                    icon: Icon(
                      obscureCvv
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 19,
                      color: AppColors.primaryDark
                          .withValues(alpha: 0.45),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'مطلوب';
                    }

                    if (value.length < 3) {
                      return 'غير صحيح';
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: AppColors.green,
              ),
              const SizedBox(width: 6),
              Text(
                'بيانات الدفع محمية ومشفرة',
                style: TextStyle(
                  color: AppColors.primaryDark
                      .withValues(alpha: 0.55),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Apple Pay
  // =========================================================

  Widget buildApplePayDetails() {
    return buildExpandableDetails(
      child: Column(
        children: [
          const SizedBox(height: 16),

          divider(),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.05,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.apple,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Text(
                  'الدفع السريع باستخدام Apple Pay',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            'سيتم فتح Apple Pay لإتمام الدفع باستخدام البطاقة المحفوظة على جهازك.',
            style: TextStyle(
              color: AppColors.primaryDark
                  .withValues(alpha: 0.58),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // الدفع عند الاستلام
  // =========================================================

  Widget buildCashDetails() {
    return buildExpandableDetails(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          divider(),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  'الدفع عند استلام الطلب',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'يمكنك دفع قيمة الطلب نقدًا عند وصول المندوب. يرجى تجهيز المبلغ عند الاستلام.',
            style: TextStyle(
              color: AppColors.primaryDark
                  .withValues(alpha: 0.60),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // تمارا
  // =========================================================

  Widget buildTamaraDetails() {
    return buildExpandableDetails(
      child: Column(
        children: [
          const SizedBox(height: 16),

          divider(),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 52,
                height: 40,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'lib/assets/tamara_icon.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primaryDark,
                    );
                  },
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  'قسّم قيمة طلبك مع تمارا',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _installmentRow(
            'قيمة الطلب',
            '${widget.totalAmount.toStringAsFixed(2)} ر.س',
          ),

          const SizedBox(height: 8),

          _installmentRow(
            'طريقة الدفع',
            'حسب الخطة المتاحة',
          ),

          const SizedBox(height: 12),

          Text(
            'سيتم تحويلك إلى تمارا لإكمال عملية الدفع وفق الخطة المتاحة لك.',
            style: TextStyle(
              color: AppColors.primaryDark
                  .withValues(alpha: 0.58),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // تابي
  // =========================================================

  Widget buildTabbyDetails() {
    return buildExpandableDetails(
      child: Column(
        children: [
          const SizedBox(height: 16),

          divider(),

          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 52,
                height: 40,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'lib/assets/tabby_icon.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.primaryDark,
                    );
                  },
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  'قسّم قيمة طلبك مع تابي',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _installmentRow(
            'قيمة الطلب',
            '${widget.totalAmount.toStringAsFixed(2)} ر.س',
          ),

          const SizedBox(height: 8),

          _installmentRow(
            'طريقة الدفع',
            'حسب الخطة المتاحة',
          ),

          const SizedBox(height: 12),

          Text(
            'سيتم تحويلك إلى تابي لإكمال عملية الدفع وفق الخطة المتاحة لك.',
            style: TextStyle(
              color: AppColors.primaryDark
                  .withValues(alpha: 0.58),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // المحفظة
  // =========================================================

  Widget buildWalletDetails() {
    const double walletBalance = 500;

    return buildExpandableDetails(
      child: Column(
        children: [
          const SizedBox(height: 16),

          divider(),

          const SizedBox(height: 16),

          _installmentRow(
            'الرصيد المتاح',
            '${walletBalance.toStringAsFixed(2)} ر.س',
          ),

          const SizedBox(height: 9),

          _installmentRow(
            'قيمة الطلب',
            '${widget.totalAmount.toStringAsFixed(2)} ر.س',
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(
                alpha: 0.07,
              ),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.green,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'سيتم خصم قيمة الطلب من رصيد المحفظة.',
                    style: TextStyle(
                      color: AppColors.primaryDark
                          .withValues(alpha: 0.65),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Container التفاصيل
  // =========================================================

  Widget buildExpandableDetails({
    required Widget child,
  }) {
    return AnimatedSize(
      duration: const Duration(
        milliseconds: 280,
      ),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }

  // =========================================================
  // خط فاصل
  // =========================================================

  Widget divider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.border.withValues(
        alpha: 0.45,
      ),
    );
  }

  // =========================================================
  // صف التقسيط
  // =========================================================

  Widget _installmentRow(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primaryDark
                  .withValues(alpha: 0.58),
              fontSize: 11,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // تفاصيل الخيار المختار
  // =========================================================

  Widget buildSelectedDetails(
    PaymentChoice choice,
  ) {
    switch (choice) {
      case PaymentChoice.mada:
      case PaymentChoice.card:
        return buildCardDetails();

      case PaymentChoice.applePay:
        return buildApplePayDetails();

      case PaymentChoice.cashOnDelivery:
        return buildCashDetails();

      case PaymentChoice.tamara:
        return buildTamaraDetails();

      case PaymentChoice.tabby:
        return buildTabbyDetails();

      case PaymentChoice.wallet:
        return buildWalletDetails();
    }
  }

  // =========================================================
  // تأكيد الدفع
  // =========================================================

  Future<void> confirmPayment() async {
    FocusScope.of(context).unfocus();

    if (selected == PaymentChoice.mada ||
        selected == PaymentChoice.card) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    setState(() {
      isProcessing = true;
    });

    // =======================================================
    // مؤقت إلى أن يتم ربط HyperPay / بوابة الدفع
    // =======================================================

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    final orderNumber =
        (100000000 +
                DateTime.now().millisecondsSinceEpoch %
                    899999999)
            .toString();

    OrderService.instance.addOrder(
      Order(
        orderNumber: orderNumber,
        items: List.from(
          CartService.instance.items,
        ),
        totalAmount: widget.totalAmount,
        date: DateTime.now(),
        isPickup: widget.isPickup,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          totalAmount: widget.totalAmount,
          isPickup: widget.isPickup,
          addressLine: widget.addressLine,
          timeSlot: widget.timeSlot,
          destinationLat: widget.destinationLat,
          destinationLng: widget.destinationLng,
        ),
      ),
    );
  }

  // =========================================================
  // زر التأكيد
  // =========================================================

  String get paymentButtonText {
    switch (selected) {
      case PaymentChoice.mada:
        return 'الدفع عبر مدى';

      case PaymentChoice.card:
        return 'الدفع بالبطاقة';

      case PaymentChoice.applePay:
        return 'الدفع باستخدام Apple Pay';

      case PaymentChoice.cashOnDelivery:
        return 'تأكيد الطلب';

      case PaymentChoice.tamara:
        return 'المتابعة مع تمارا';

      case PaymentChoice.tabby:
        return 'المتابعة مع تابي';

      case PaymentChoice.wallet:
        return 'الدفع من المحفظة';
    }
  }

  // =========================================================
  // الواجهة
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),

        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: AppColors.primaryDark,
          ),
          title: const Text(
            'طريقة الدفع',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            120,
          ),
          children: [
            // =================================================
            // إجمالي الطلب
            // =================================================

            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.border.withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(
                        alpha: 0.09,
                      ),
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.green,
                    ),
                  ),

                  const SizedBox(width: 11),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إجمالي الطلب',
                          style: TextStyle(
                            color:
                                AppColors.primaryDark,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'اختر طريقة الدفع المناسبة',
                          style: TextStyle(
                            color:
                                AppColors.primaryDark,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '${widget.totalAmount.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'طرق الدفع',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'اختر طريقة الدفع وسيظهر لك ما تحتاجه مباشرة',
              style: TextStyle(
                color: AppColors.primaryDark
                    .withValues(alpha: 0.52),
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 13),

            // =================================================
            // بطاقات الدفع
            // =================================================

            ...options.map(
              (option) {
                final bool isSelected =
                    selected == option.choice;

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Material(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(17),
                    child: InkWell(
                      onTap: () {
                        selectPayment(
                          option.choice,
                        );
                      },
                      borderRadius:
                          BorderRadius.circular(17),
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 220,
                        ),
                        padding: const EdgeInsets.all(
                          14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(17),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.green
                                : AppColors.border
                                    .withValues(
                                    alpha: 0.65,
                                  ),
                            width:
                                isSelected ? 1.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors
                                        .green
                                        .withValues(
                                      alpha: 0.07,
                                    ),
                                    blurRadius: 12,
                                    offset:
                                        const Offset(
                                      0,
                                      4,
                                    ),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            // =================================
                            // رأس البطاقة
                            // =================================

                            Row(
                              children: [
                                _PaymentLogo(
                                  option: option,
                                  selected:
                                      isSelected,
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        option.label,
                                        style:
                                            const TextStyle(
                                          color: AppColors
                                              .primaryDark,
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight
                                                  .w800,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        option.subtitle,
                                        style: TextStyle(
                                          color: AppColors
                                              .primaryDark
                                              .withValues(
                                            alpha: 0.48,
                                          ),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                AnimatedContainer(
                                  duration:
                                      const Duration(
                                    milliseconds: 180,
                                  ),
                                  width: 22,
                                  height: 22,
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors
                                              .green
                                          : AppColors
                                              .border,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child:
                                              Container(
                                            width: 11,
                                            height: 11,
                                            decoration:
                                                const BoxDecoration(
                                              shape: BoxShape
                                                  .circle,
                                              color: AppColors
                                                  .green,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),

                            // =================================
                            // التفاصيل تحت الخيار مباشرة
                            // =================================

                            AnimatedSwitcher(
                              duration:
                                  const Duration(
                                milliseconds: 260,
                              ),
                              switchInCurve:
                                  Curves.easeOutCubic,
                              switchOutCurve:
                                  Curves.easeInCubic,
                              transitionBuilder:
                                  (child, animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -1,
                                  child:
                                      FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: isSelected
                                  ? buildSelectedDetails(
                                      option.choice,
                                    )
                                  : const SizedBox(
                                      key: ValueKey(
                                        'empty',
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        // =====================================================
        // زر الدفع
        // =====================================================

        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              16,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.07,
                  ),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isProcessing ? null : confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  disabledBackgroundColor:
                      AppColors.green.withValues(
                    alpha: 0.55,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2.3,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 17,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            paymentButtonText,
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// شعار طريقة الدفع
// =============================================================

class _PaymentLogo extends StatelessWidget {
  final _PaymentOption option;
  final bool selected;

  const _PaymentLogo({
    required this.option,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.green.withValues(
                alpha: 0.08,
              )
            : const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: option.assetPath != null
          ? Image.asset(
              option.assetPath!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return Icon(
                  option.fallbackIcon,
                  color: AppColors.primaryDark,
                  size: 24,
                );
              },
            )
          : Icon(
              option.fallbackIcon,
              color: AppColors.primaryDark,
              size: 24,
            ),
    );
  }
}

// =============================================================
// بيانات طريقة الدفع
// =============================================================

class _PaymentOption {
  final PaymentChoice choice;
  final String label;
  final String subtitle;
  final String? assetPath;
  final IconData fallbackIcon;

  const _PaymentOption({
    required this.choice,
    required this.label,
    required this.subtitle,
    required this.assetPath,
    required this.fallbackIcon,
  });
}
