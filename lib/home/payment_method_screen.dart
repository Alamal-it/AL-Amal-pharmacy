import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../core/app_strings.dart';
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

  // ---------- التوصيل ----------
  final String? addressLine;
  final String? timeSlot;
  final double? destinationLat;
  final double? destinationLng;

  // ---------- الاستلام من الفرع ----------
  final String? branchName;
  final String? branchMapUrl;
  final double? branchLat;
  final double? branchLng;
  final double? userLat;
  final double? userLng;

  const PaymentMethodScreen({
    super.key,
    required this.totalAmount,
    this.isPickup = true,
    this.addressLine,
    this.timeSlot,
    this.destinationLat,
    this.destinationLng,
    this.branchName,
    this.branchMapUrl,
    this.branchLat,
    this.branchLng,
    this.userLat,
    this.userLng,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // =========================================================
  // الإعدادات
  // =========================================================

  /// رسوم الدفع عند الاستلام
  static const double codFee = 15.0;

  /// رصيد المحفظة المؤقت
  static const double walletBalance = 500;

  PaymentChoice selected = PaymentChoice.mada;

  final Map<PaymentChoice, GlobalKey<FormState>> _formKeys = {
    PaymentChoice.mada: GlobalKey<FormState>(),
    PaymentChoice.card: GlobalKey<FormState>(),
  };

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool obscureCvv = true;
  bool isProcessing = false;

  // =========================================================
  // الحسابات
  // =========================================================

  double get fee => selected == PaymentChoice.cashOnDelivery ? codFee : 0;

  double get grandTotal => widget.totalAmount + fee;

  bool get walletInsufficient =>
      selected == PaymentChoice.wallet && walletBalance < grandTotal;

  String _money(double value) => '${value.toStringAsFixed(2)} ر.س';

  String get _rawNumber => cardNumberController.text.replaceAll(' ', '');

  bool get _isAmex => _rawNumber.startsWith('34') || _rawNumber.startsWith('37');

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
          subtitle: widget.isPickup
              ? 'ادفعي عند استلام الطلب من الفرع'
              : 'ادفعي نقدًا عند وصول المندوب',
          assetPath: null,
          fallbackIcon: Icons.payments_outlined,
          badge: '+${_money(codFee)}',
          badgeColor: Colors.orange,
        ),
        _PaymentOption(
          choice: PaymentChoice.tamara,
          label: AppStrings.tamara,
          subtitle: 'قسّمي مشترياتك بسهولة',
          assetPath: 'lib/assets/tamara_icon.png',
          fallbackIcon: Icons.calendar_month_outlined,
        ),
        _PaymentOption(
          choice: PaymentChoice.tabby,
          label: AppStrings.tabby,
          subtitle: 'ادفعي على دفعات',
          assetPath: 'lib/assets/tabby_icon.png',
          fallbackIcon: Icons.calendar_today_outlined,
        ),
        _PaymentOption(
          choice: PaymentChoice.wallet,
          label: AppStrings.internalWallet,
          subtitle: 'الرصيد المتاح ${_money(walletBalance)}',
          assetPath: null,
          fallbackIcon: Icons.account_balance_wallet_outlined,
          badge: walletBalance < widget.totalAmount ? 'الرصيد غير كافٍ' : null,
          badgeColor: Colors.redAccent,
        ),
      ];

  _PaymentOption get selectedOption =>
      options.firstWhere((o) => o.choice == selected);

  // =========================================================
  // دورة الحياة
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
    if (selected == choice) return;

    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();

    setState(() {
      selected = choice;
    });
  }

  // =========================================================
  // التحقق
  // =========================================================

  bool _luhnValid(String number) {
    var sum = 0;
    var alternate = false;

    for (var i = number.length - 1; i >= 0; i--) {
      var digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;

        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  String? _validateCardNumber(String? value) {
    final clean = value?.replaceAll(' ', '') ?? '';

    if (clean.isEmpty) {
      return 'أدخلي رقم البطاقة';
    }

    final expectedLength = _isAmex ? 15 : 16;

    if (clean.length < expectedLength) {
      return 'رقم البطاقة غير مكتمل';
    }

    if (!_luhnValid(clean)) {
      return 'رقم البطاقة غير صحيح';
    }

    return null;
  }

  String? _validateExpiry(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'مطلوب';
    }

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(text)) {
      return 'MM/YY';
    }

    final month = int.parse(text.substring(0, 2));

    final year = 2000 + int.parse(text.substring(3, 5));

    if (month < 1 || month > 12) {
      return 'شهر غير صحيح';
    }

    final now = DateTime.now();

    if (year < now.year || (year == now.year && month < now.month)) {
      return 'بطاقة منتهية';
    }

    return null;
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textDirection: TextDirection.ltr,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
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
          color: AppColors.primaryDark.withValues(alpha: 0.55),
          fontSize: 12,
        ),
        hintStyle: TextStyle(
          color: AppColors.primaryDark.withValues(alpha: 0.25),
          fontSize: 12,
        ),
        border: border(Colors.transparent),
        enabledBorder: border(AppColors.border.withValues(alpha: 0.55)),
        focusedBorder: border(AppColors.green, 1.4),
        errorBorder: border(Colors.redAccent),
        focusedErrorBorder: border(Colors.redAccent, 1.4),
      ),
    );
  }

  // =========================================================
  // مكونات مساعدة
  // =========================================================

  Widget divider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.border.withValues(alpha: 0.45),
    );
  }

  Widget _detailsWrap(Widget child) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          divider(),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primaryDark.withValues(alpha: 0.58),
              fontSize: 11,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.primaryDark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _noteBox({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.primaryDark.withValues(alpha: 0.72),
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // بيانات البطاقة
  // =========================================================

  Widget buildCardDetails(PaymentChoice choice) {
    return _detailsWrap(
      Form(
        key: _formKeys[choice],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              textInputAction: TextInputAction.next,
              inputFormatters: [_CardNumberFormatter()],
              validator: _validateCardNumber,
            ),

            const SizedBox(height: 12),

            inputField(
              label: 'اسم حامل البطاقة',
              hint: 'الاسم كما هو مكتوب على البطاقة',
              controller: cardHolderController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'أدخلي اسم حامل البطاقة';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: inputField(
                    label: 'تاريخ الانتهاء',
                    hint: 'MM/YY',
                    controller: expiryController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [_ExpiryFormatter()],
                    validator: _validateExpiry,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: inputField(
                    label: 'CVV',
                    hint: '•••',
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    obscureText: obscureCvv,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
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
                        color: AppColors.primaryDark.withValues(alpha: 0.45),
                      ),
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? '';

                      if (v.isEmpty) {
                        return 'مطلوب';
                      }

                      if (v.length < (_isAmex ? 4 : 3)) {
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
                    color: AppColors.primaryDark.withValues(alpha: 0.55),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Apple Pay
  // =========================================================

  Widget buildApplePayDetails() {
    return _detailsWrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
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
              color: AppColors.primaryDark.withValues(alpha: 0.58),
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
    return _detailsWrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Text(
                  'الدفع عند الاستلام',
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
            widget.isPickup
                ? 'ادفعي قيمة الطلب نقدًا عند استلامه من الفرع، ويرجى تجهيز المبلغ.'
                : 'ادفعي قيمة الطلب نقدًا عند وصول المندوب، ويرجى تجهيز المبلغ.',
            style: TextStyle(
              color: AppColors.primaryDark.withValues(alpha: 0.60),
              fontSize: 11,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          _noteBox(
            icon: Icons.info_outline_rounded,
            color: Colors.orange,
            text:
                'تُضاف رسوم الدفع عند الاستلام (${_money(codFee)}) إلى إجمالي طلبك.',
          ),
        ],
      ),
    );
  }

  // =========================================================
  // التقسيط
  // =========================================================

  Widget _buildInstallmentDetails({
    required String name,
    required String assetPath,
    required IconData fallbackIcon,
    required int parts,
  }) {
    final perPart = grandTotal / parts;

    return _detailsWrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 40,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return Icon(
                      fallbackIcon,
                      color: AppColors.primaryDark,
                    );
                  },
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  'قسّمي قيمة طلبك مع $name',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: List.generate(parts, (i) {
              final isFirst = i == 0;

              return Expanded(
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                    end: i == parts - 1 ? 0 : 6,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isFirst
                        ? AppColors.green.withValues(alpha: 0.10)
                        : const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: isFirst
                          ? AppColors.green.withValues(alpha: 0.4)
                          : AppColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isFirst ? 'الحين' : 'الدفعة ${i + 1}',
                        style: TextStyle(
                          color: isFirst
                              ? AppColors.green
                              : AppColors.primaryDark.withValues(alpha: 0.55),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        perPart.toStringAsFixed(2),
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 14),

          _infoRow('قيمة الطلب', _money(grandTotal)),

          const SizedBox(height: 8),

          _infoRow('عدد الدفعات (تقريبي)', '$parts'),

          const SizedBox(height: 12),

          Text(
            'التقسيم أعلاه تقريبي، وتظهر لك الخطة النهائية بعد التحويل إلى $name لإكمال الدفع.',
            style: TextStyle(
              color: AppColors.primaryDark.withValues(alpha: 0.58),
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
    final remaining = walletBalance - grandTotal;

    final enough = remaining >= 0;

    return _detailsWrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _infoRow('الرصيد المتاح', _money(walletBalance)),

          const SizedBox(height: 9),

          _infoRow('قيمة الطلب', _money(grandTotal)),

          const SizedBox(height: 9),

          _infoRow(
            enough ? 'الرصيد بعد الدفع' : 'المبلغ الناقص',
            _money(remaining.abs()),
            valueColor: enough ? AppColors.green : Colors.redAccent,
          ),

          const SizedBox(height: 12),

          _noteBox(
            icon: enough
                ? Icons.account_balance_wallet_outlined
                : Icons.warning_amber_rounded,
            color: enough ? AppColors.green : Colors.redAccent,
            text: enough
                ? 'سيتم خصم قيمة الطلب من رصيد المحفظة.'
                : 'رصيد المحفظة غير كافٍ، اختاري طريقة دفع أخرى.',
          ),
        ],
      ),
    );
  }

  // =========================================================
  // تفاصيل الخيار المختار
  // =========================================================

  Widget buildSelectedDetails(PaymentChoice choice) {
    switch (choice) {
      case PaymentChoice.mada:
      case PaymentChoice.card:
        return buildCardDetails(choice);

      case PaymentChoice.applePay:
        return buildApplePayDetails();

      case PaymentChoice.cashOnDelivery:
        return buildCashDetails();

      case PaymentChoice.tamara:
        return _buildInstallmentDetails(
          name: 'تمارا',
          assetPath: 'lib/assets/tamara_icon.png',
          fallbackIcon: Icons.calendar_month_outlined,
          parts: 3,
        );

      case PaymentChoice.tabby:
        return _buildInstallmentDetails(
          name: 'تابي',
          assetPath: 'lib/assets/tabby_icon.png',
          fallbackIcon: Icons.calendar_today_outlined,
          parts: 4,
        );

      case PaymentChoice.wallet:
        return buildWalletDetails();
    }
  }

  // =========================================================
  // تأكيد الدفع
  // =========================================================

  String get _paymentSummary {
    final label = selectedOption.label;

    if (selected == PaymentChoice.mada || selected == PaymentChoice.card) {
      final raw = _rawNumber;

      if (raw.length >= 4) {
        return '$label •••• ${raw.substring(raw.length - 4)}';
      }
    }

    return label;
  }

  Future<void> confirmPayment() async {
    FocusScope.of(context).unfocus();

    if (selected == PaymentChoice.mada || selected == PaymentChoice.card) {
      final valid = _formKeys[selected]?.currentState?.validate() ?? false;

      if (!valid) {
        HapticFeedback.heavyImpact();
        return;
      }
    }

    if (walletInsufficient) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() {
      isProcessing = true;
    });

    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          totalAmount: grandTotal,
          isPickup: widget.isPickup,
          addressLine: widget.addressLine,
          timeSlot: widget.timeSlot,
          destinationLat: widget.destinationLat,
          destinationLng: widget.destinationLng,
          branchName: widget.branchName,
          branchMapUrl: widget.branchMapUrl,
          branchLat: widget.branchLat,
          branchLng: widget.branchLng,
          userLat: widget.userLat,
          userLng: widget.userLng,
          paymentMethod: _paymentSummary,
        ),
      ),
    );
  }

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
        backgroundColor: const Color(0xFFF4F7F8),

        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primaryDark),
          title: const Text(
            'طريقة الدفع',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        // تم حذف شريط الخطوات (CheckoutStepper) من هنا
        body: ListView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
          children: [
            _summaryCard(),

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
              'اختاري طريقة الدفع وسيظهر لك ما تحتاجينه مباشرة',
              style: TextStyle(
                color: AppColors.primaryDark.withValues(alpha: 0.52),
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 13),

            ...options.map(_optionTile),
          ],
        ),

        bottomNavigationBar: _bottomBar(),
      ),
    );
  }

  // =========================================================
  // ملخص الطلب
  // =========================================================

  Widget _summaryCard() {
    final destinationText = widget.isPickup
        ? (widget.branchName ?? 'استلام من الفرع')
        : (widget.addressLine ?? 'توصيل إلى عنوانك');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  widget.isPickup
                      ? Icons.storefront_outlined
                      : Icons.local_shipping_outlined,
                  color: AppColors.green,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isPickup ? 'الاستلام من الفرع' : 'التوصيل',
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      destinationText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          divider(),

          const SizedBox(height: 14),

          _infoRow('المجموع', _money(widget.totalAmount)),

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: fee > 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 9),
                    child: _infoRow(
                      'رسوم الدفع عند الاستلام',
                      '+ ${_money(fee)}',
                      valueColor: Colors.orange,
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),

          const SizedBox(height: 12),

          divider(),

          const SizedBox(height: 12),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'الإجمالي',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              TweenAnimationBuilder<double>(
                tween: Tween<double>(end: grandTotal),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                builder: (_, value, __) {
                  return Text(
                    _money(value),
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // بطاقة طريقة الدفع
  // =========================================================

  Widget _optionTile(_PaymentOption option) {
    final isSelected = selected == option.choice;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: isSelected
                ? AppColors.green
                : AppColors.border.withValues(alpha: 0.65),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.green.withValues(alpha: 0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              InkWell(
                onTap: () => selectPayment(option.choice),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      _PaymentLogo(
                        option: option,
                        selected: isSelected,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    option.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.primaryDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),

                                if (option.badge != null) ...[
                                  const SizedBox(width: 6),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (option.badgeColor ??
                                              AppColors.green)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Text(
                                      option.badge!,
                                      style: TextStyle(
                                        color: option.badgeColor ??
                                            AppColors.green,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 3),

                            Text(
                              option.subtitle,
                              style: TextStyle(
                                color: AppColors.primaryDark
                                    .withValues(alpha: 0.48),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.green
                                : AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 11,
                                  height: 11,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.green,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: isSelected
                    ? KeyedSubtree(
                        key: ValueKey('details_${option.choice.name}'),
                        child: buildSelectedDetails(option.choice),
                      )
                    : SizedBox(
                        key: ValueKey('empty_${option.choice.name}'),
                        width: double.infinity,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // شريط الدفع السفلي
  // =========================================================

  Widget _bottomBar() {
    final disabled = isProcessing || walletInsufficient;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'الإجمالي',
                    style: TextStyle(
                      color: AppColors.textGray,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(end: grandTotal),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    builder: (_, value, __) {
                      return Text(
                        _money(value),
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 3,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: disabled ? null : confirmPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    disabledBackgroundColor:
                        AppColors.green.withValues(alpha: 0.45),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 17,
                              color: Colors.white,
                            ),

                            const SizedBox(width: 7),

                            Flexible(
                              child: Text(
                                paymentButtonText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
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

// =============================================================
// تنسيق رقم البطاقة
// =============================================================

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 16) {
      digits = digits.substring(0, 16);
    }

    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }

      buffer.write(digits[i]);
    }

    final text = buffer.toString();

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

// =============================================================
// تنسيق تاريخ الانتهاء MM/YY
// =============================================================

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String text;

    if (digits.length >= 3) {
      text = '${digits.substring(0, 2)}/${digits.substring(2)}';
    } else if (digits.length == 2 &&
        newValue.text.length > oldValue.text.length) {
      text = '$digits/';
    } else {
      text = digits;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
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
      duration: const Duration(milliseconds: 200),
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.green.withValues(alpha: 0.08)
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
  final String? badge;
  final Color? badgeColor;

  const _PaymentOption({
    required this.choice,
    required this.label,
    required this.subtitle,
    required this.assetPath,
    required this.fallbackIcon,
    this.badge,
    this.badgeColor,
  });
}