import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/app_colors.dart';
import '../widgets/checkout_stepper.dart';
import '../main_nav/main_nav_screen.dart';
import 'order_rating_screen.dart';
import '../services/order_service.dart';
import '../services/cart_service.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final double totalAmount;

  // true = استلام من الفرع
  // false = توصيل
  final bool isPickup;

  final String? addressLine;
  final String? timeSlot;
  final double? destinationLat;
  final double? destinationLng;

  const OrderConfirmationScreen({
    super.key,
    required this.totalAmount,
    this.isPickup = true,
    this.addressLine,
    this.timeSlot,
    this.destinationLat,
    this.destinationLng,
  }); 

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState
    extends State<OrderConfirmationScreen> {
  late final String orderNumber;

  // =========================================================
  // مراحل تتبع طلب التوصيل
  // =========================================================

  static const int currentDeliveryStage = 2;

  static const List<String> deliveryStages = [
    'تم استلام الطلب',
    'جاري التجهيز',
    'خرج للتوصيل',
    'تم التسليم',
  ];

  // =========================================================
  // إنشاء الطلب
  // =========================================================

  @override
  void initState() {
    super.initState();

    orderNumber =
        (100000000 + Random().nextInt(899999999)).toString();

    _createOrderAndClearCart();
  }

  // =========================================================
  // إنشاء الطلب ثم تفريغ السلة
  // =========================================================

  void _createOrderAndClearCart() {
    final cart = CartService.instance;

    // نأخذ نسخة من المنتجات الموجودة في السلة
    // قبل تفريغها.
    final orderItems = cart.items
        .map((item) => item)
        .toList();

    // إنشاء الطلب بالمنتجات الحالية
    OrderService.instance.addOrder(
      Order(
        orderNumber: orderNumber,
        items: orderItems,
        totalAmount: widget.totalAmount,
        date: DateTime.now(),
        isPickup: widget.isPickup,
      ),
    );

    // =======================================================
    // مهم جدًا:
    // بعد إنشاء الطلب يتم تفريغ السلة.
    //
    // بهذه الطريقة:
    // 1- المنتجات تدخل في الطلب.
    // 2- السلة تصبح فارغة.
    // 3- رقم السلة في الرئيسية يرجع صفر.
    // =======================================================

    cart.clearCart();
  }

  // =========================================================
  // إنهاء الطلب
  // =========================================================

  Future<void> finishOrder() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
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
                // علامة الصح
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  widget.isPickup
                      ? 'تم استلام طلبك بنجاح'
                      : 'تم تأكيد طلبك بنجاح',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'شكراً لثقتك بصيدلية الأمل',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textGray,
                  ),
                ),

                const SizedBox(height: 16),

                // رقم الطلب
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.border.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'رقم الطلب: #$orderNumber',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'تم',
                      style: TextStyle(
                        fontSize: 14,
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
      },
    );

    // بعد الضغط على تم ننتقل للتقييم
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => OrderRatingScreen(
            orderNumber: orderNumber,
            isPickup: widget.isPickup,
          ),
        ),
        (route) => false,
      );
    }
  }

  // =========================================================
  // إلغاء الطلب
  // =========================================================

  Future<void> cancelOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            'إلغاء الطلب؟',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'هل أنتِ متأكدة من إلغاء هذا الطلب؟ '
            'لا يمكن التراجع عن هذا الإجراء.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: 12.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('تراجع'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'نعم، ألغي الطلب',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavScreen(),
        ),
        (route) => false,
      );
    }
  }

  // =========================================================
  // الصفحة
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      // =======================================================
      // AppBar
      // =======================================================

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.isPickup
              ? 'استلام الطلب'
              : 'تتبع الطلب #$orderNumber',
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      // =======================================================
      // المحتوى
      // =======================================================

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===================================================
            // شريط الخطوات
            // ===================================================

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: CheckoutStepper(
                currentStep: 2,
              ),
            ),

            const SizedBox(height: 10),

            // ===================================================
            // الخريطة / مكان الاستلام
            // ===================================================

            widget.isPickup
                ? _pickupPlaceholder()
                : _deliveryLiveMap(),

            const SizedBox(height: 18),

            // ===================================================
            // حالة الاستلام
            // ===================================================

            if (widget.isPickup) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '01:30 ص - 01:20 ص',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'جاهز للاستلام',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    _dot(active: true),
                    _line(active: true),
                    _dot(active: false),
                    _line(active: false),
                    _dot(active: false),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  'الصيدلية بتجهز طلبك الحين',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                  ),
                ),
              ),
            ]

            // ===================================================
            // حالة التوصيل
            // ===================================================

            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: _deliveryStagesTracker(),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: _courierCard(),
              ),
            ],

            const SizedBox(height: 20),

            const Divider(
              color: AppColors.border,
            ),

            // ===================================================
            // رقم الطلب
            // ===================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#$orderNumber',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    widget.isPickup
                        ? 'شارك الرقم مع الموظف'
                        : 'احتفظي برقم الطلب للمتابعة',
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              color: AppColors.border,
            ),

            // ===================================================
            // الفرع / العنوان
            // ===================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isPickup
                          ? Icons.storefront_outlined
                          : Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.green,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.isPickup
                              ? 'صيدلية الأمل — الفرع الأقرب'
                              : 'التوصيل إلى عنوانك',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          widget.isPickup
                              ? 'مفتوح حتى 12:00 ص'
                              : (widget.addressLine ??
                                  'العنوان المحدد'),
                          style: const TextStyle(
                            color: AppColors.textGray,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===================================================
            // الاتجاهات
            // ===================================================

            if (widget.isPickup) ...[
              const SizedBox(height: 6),

              TextButton.icon(
                onPressed: () {
                  // يمكن ربط الخرائط هنا لاحقًا.
                },
                icon: const Icon(
                  Icons.directions_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
                label: const Text(
                  'احصل على الاتجاهات',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),

            const Divider(
              color: AppColors.border,
            ),

            const SizedBox(height: 16),

            // ===================================================
            // إجمالي الطلب
            // ===================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.totalAmount.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const Text(
                    'إجمالي الطلب',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===================================================
            // زر إنهاء الطلب
            // ===================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                10,
              ),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: finishOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.isPickup
                        ? 'استلمت طلبك الحين'
                        : 'تم، متابعة',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // ===================================================
            // زر إلغاء الطلب
            // ===================================================

            if (!widget.isPickup)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  20,
                ),
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: cancelOrder,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'إلغاء الطلب',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // شكل الاستلام
  // =========================================================

  Widget _pickupPlaceholder() {
    return Container(
      height: 190,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.green.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // خريطة التوصيل
  // =========================================================

  Widget _deliveryLiveMap() {
    if (widget.destinationLat == null ||
        widget.destinationLng == null) {
      return Container(
        height: 190,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.border.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.local_shipping_outlined,
          size: 46,
          color: AppColors.primary,
        ),
      );
    }

    final destination = LatLng(
      widget.destinationLat!,
      widget.destinationLng!,
    );

    // موقع تجريبي للمندوب
    final courierPosition = LatLng(
      destination.latitude - 0.01,
      destination.longitude - 0.01,
    );

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: destination,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId(
              'destination',
            ),
            position: destination,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: const InfoWindow(
              title: 'عنوانك',
            ),
          ),
          Marker(
            markerId: const MarkerId(
              'courier',
            ),
            position: courierPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: const InfoWindow(
              title: 'المندوب',
            ),
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId(
              'route',
            ),
            points: [
              courierPosition,
              destination,
            ],
            color: AppColors.primary,
            width: 4,
          ),
        },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        scrollGesturesEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
      ),
    );
  }

  // =========================================================
  // مراحل التوصيل
  // =========================================================

  Widget _deliveryStagesTracker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: List.generate(
          deliveryStages.length,
          (index) {
            final isDone =
                index < currentDeliveryStage;

            final isCurrent =
                index == currentDeliveryStage;

            final isLast =
                index == deliveryStages.length - 1;

            return Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: isLast ? 0 : 22,
                    ),
                    child: Text(
                      deliveryStages[index],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isCurrent
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: (isDone || isCurrent)
                            ? AppColors.primaryDark
                            : AppColors.textGray,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: (isDone || isCurrent)
                            ? AppColors.green
                            : AppColors.border
                                .withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: isDone
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : isCurrent
                              ? const Icon(
                                  Icons.local_shipping,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                    ),

                    if (!isLast)
                      Container(
                        width: 2,
                        height: 22,
                        color: isDone
                            ? AppColors.green
                            : AppColors.border,
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // بطاقة المندوب
  // =========================================================

  Widget _courierCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // ربط الاتصال الحقيقي لاحقًا.
            },
            icon: const Icon(
              Icons.phone_outlined,
              color: AppColors.primary,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: const [
                Text(
                  'عبدالله كريم',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'مندوب التوصيل',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delivery_dining,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // نقاط الحالة
  // =========================================================

  Widget _dot({
    required bool active,
  }) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: active
            ? AppColors.green
            : AppColors.border,
        shape: BoxShape.circle,
      ),
    );
  }

  // =========================================================
  // الخط بين النقاط
  // =========================================================

  Widget _line({
    required bool active,
  }) {
    return Expanded(
      child: Container(
        height: 3,
        color: active
            ? AppColors.green
            : AppColors.border,
      ),
    );
  }
}