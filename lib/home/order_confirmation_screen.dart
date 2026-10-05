import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import '../main_nav/main_nav_screen.dart';
import 'order_rating_screen.dart';
import '../services/order_service.dart';
import '../services/cart_service.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final double totalAmount;

  /// true = استلام من الفرع
  /// false = توصيل
  final bool isPickup;

  // ---------- التوصيل ----------
  final String? addressLine;
  final String? timeSlot;
  final double? destinationLat;
  final double? destinationLng;
  final String? courierName;
  final String? courierPhone;

  // ---------- الاستلام من الفرع (تجي من صفحة اختيار الفرع) ----------
  final String? branchName;
  final String? branchMapUrl;
  final double? branchLat;
  final double? branchLng;

  // موقع العميلة (اختياري) لحساب المسافة
  final double? userLat;
  final double? userLng;

  // ---------- الدفع (يجي من صفحة طريقة الدفع) ----------
  final String? paymentMethod;

  const OrderConfirmationScreen({
    super.key,
    required this.totalAmount,
    this.isPickup = true,
    this.addressLine,
    this.timeSlot,
    this.destinationLat,
    this.destinationLng,
    this.courierName,
    this.courierPhone,
    this.branchName,
    this.branchMapUrl,
    this.branchLat,
    this.branchLng,
    this.userLat,
    this.userLng,
    this.paymentMethod,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  late final String orderNumber;
  late final DateTime createdAt;
  late final int itemsCount;

  GoogleMapController? _mapController;
  Timer? _timer;

  // مرحلة الطلب الحالية (index داخل قائمة المراحل)
  int _stage = 1;
  int _tick = 0;

  // تقدّم المندوب من 0 إلى 1 (محاكاة لين يتم الربط بالـ API)
  double _courierProgress = 0;

  static const List<String> _pickupStages = [
    'تم استلام الطلب',
    'جاري تجهيز الطلب',
    'جاهز للاستلام',
  ];

  static const List<String> _deliveryStages = [
    'تم استلام الطلب',
    'جاري التجهيز',
    'خرج للتوصيل',
    'تم التسليم',
  ];

  List<String> get _stages =>
      widget.isPickup ? _pickupStages : _deliveryStages;

  // =========================================================
  // دورة الحياة
  // =========================================================

  @override
  void initState() {
    super.initState();

    orderNumber = (100000000 + Random().nextInt(899999999)).toString();
    createdAt = DateTime.now();

    _createOrderAndClearCart();
    _startTracking();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // =========================================================
  // إنشاء الطلب ثم تفريغ السلة
  // =========================================================

  void _createOrderAndClearCart() {
    final cart = CartService.instance;

    // نسخة من المنتجات قبل تفريغ السلة
    final orderItems = cart.items.map((item) => item).toList();
    itemsCount = orderItems.length;

    OrderService.instance.addOrder(
      Order(
        orderNumber: orderNumber,
        items: orderItems,
        totalAmount: widget.totalAmount,
        date: createdAt,
        isPickup: widget.isPickup,
      ),
    );

    // بعد إنشاء الطلب تصير السلة فاضية
    cart.clearCart();
  }

  // =========================================================
  // التتبع
  // TODO: استبدليها بقراءة الحالة الحقيقية من الـ API / Firestore
  //       (حالة الطلب + موقع المندوب) بدل هذي المحاكاة.
  // =========================================================

  void _startTracking() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _tick++;

        if (widget.isPickup) {
          if (_tick >= 5 && _stage < 2) _stage = 2;
          if (_stage >= 2) timer.cancel();
        } else {
          if (_tick >= 3 && _stage < 2) _stage = 2;

          if (_stage == 2) {
            _courierProgress = min(0.92, _courierProgress + 0.04);
            if (_courierProgress >= 0.92) timer.cancel();
          }
        }
      });
    });
  }

  // =========================================================
  // المواقع
  // =========================================================

  LatLng? get _branchLatLng =>
      (widget.branchLat != null && widget.branchLng != null)
          ? LatLng(widget.branchLat!, widget.branchLng!)
          : null;

  LatLng? get _userLatLng =>
      (widget.userLat != null && widget.userLng != null)
          ? LatLng(widget.userLat!, widget.userLng!)
          : null;

  LatLng? get _destination =>
      (widget.destinationLat != null && widget.destinationLng != null)
          ? LatLng(widget.destinationLat!, widget.destinationLng!)
          : null;

  LatLng? get _courierStart {
    final branch = _branchLatLng;
    if (branch != null) return branch;

    final destination = _destination;
    if (destination == null) return null;

    return LatLng(destination.latitude - 0.015, destination.longitude - 0.015);
  }

  LatLng? get _courierPosition {
    final start = _courierStart;
    final destination = _destination;
    if (start == null || destination == null) return null;

    return LatLng(
      start.latitude + (destination.latitude - start.latitude) * _courierProgress,
      start.longitude +
          (destination.longitude - start.longitude) * _courierProgress,
    );
  }

  double? get _pickupDistanceKm {
    final user = _userLatLng;
    final branch = _branchLatLng;
    if (user == null || branch == null) return null;

    return Geolocator.distanceBetween(
          user.latitude,
          user.longitude,
          branch.latitude,
          branch.longitude,
        ) /
        1000;
  }

  int get _etaMinutes {
    final courier = _courierPosition;
    final destination = _destination;
    if (courier == null || destination == null) return 20;

    final km = Geolocator.distanceBetween(
          courier.latitude,
          courier.longitude,
          destination.latitude,
          destination.longitude,
        ) /
        1000;

    // متوسط سرعة تقريبية 24 كم/س
    return max(3, (km / 0.4).round());
  }

  bool get _hasMap =>
      widget.isPickup ? _branchLatLng != null : _destination != null;

  // =========================================================
  // الخريطة
  // =========================================================

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (widget.isPickup) {
      final branch = _branchLatLng;
      if (branch != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('branch'),
            position: branch,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: InfoWindow(
              title: widget.branchName ?? 'فرع الاستلام',
            ),
          ),
        );
      }

      final user = _userLatLng;
      if (user != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('user'),
            position: user,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
            infoWindow: const InfoWindow(title: 'موقعك'),
          ),
        );
      }
    } else {
      final destination = _destination;
      if (destination != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: const InfoWindow(title: 'عنوانك'),
          ),
        );
      }

      final origin = _branchLatLng;
      if (origin != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('origin'),
            position: origin,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
            infoWindow: InfoWindow(
              title: widget.branchName ?? 'الصيدلية',
            ),
          ),
        );
      }

      final courier = _courierPosition;
      if (courier != null && _stage >= 2) {
        markers.add(
          Marker(
            markerId: const MarkerId('courier'),
            position: courier,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: const InfoWindow(title: 'المندوب'),
          ),
        );
      }
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (widget.isPickup) {
      final user = _userLatLng;
      final branch = _branchLatLng;
      if (user == null || branch == null) return <Polyline>{};

      return {
        Polyline(
          polylineId: const PolylineId('pickup_route'),
          points: [user, branch],
          color: AppColors.primary,
          width: 3,
          patterns: [PatternItem.dash(18), PatternItem.gap(10)],
        ),
      };
    }

    final courier = _courierPosition;
    final destination = _destination;
    if (courier == null || destination == null || _stage < 2) {
      return <Polyline>{};
    }

    return {
      Polyline(
        polylineId: const PolylineId('delivery_route'),
        points: [courier, destination],
        color: AppColors.primary,
        width: 4,
      ),
    };
  }

  Future<void> _fitCamera() async {
    final controller = _mapController;
    if (controller == null || !mounted) return;

    final points = <LatLng>[];

    if (widget.isPickup) {
      final branch = _branchLatLng;
      final user = _userLatLng;
      if (branch != null) points.add(branch);
      if (user != null) points.add(user);
    } else {
      final destination = _destination;
      final origin = _branchLatLng ?? _courierStart;
      if (destination != null) points.add(destination);
      if (origin != null) points.add(origin);
    }

    if (points.isEmpty) return;

    try {
      if (points.length == 1) {
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(points.first, 15),
        );
        return;
      }

      final lats = points.map((p) => p.latitude);
      final lngs = points.map((p) => p.longitude);

      final minLat = lats.reduce(min);
      final maxLat = lats.reduce(max);
      final minLng = lngs.reduce(min);
      final maxLng = lngs.reduce(max);

      if ((maxLat - minLat).abs() < 0.0005 &&
          (maxLng - minLng).abs() < 0.0005) {
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(points.first, 15),
        );
        return;
      }

      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          70,
        ),
      );
    } catch (_) {}
  }

  Future<void> _openDirections() async {
    final target = widget.isPickup ? _branchLatLng : _destination;

    Uri? uri;

    if (target != null) {
      uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=${target.latitude},${target.longitude}',
      );
    } else if (widget.branchMapUrl != null) {
      uri = Uri.parse(widget.branchMapUrl!);
    }

    if (uri == null) {
      _toast('الموقع غير متوفر حاليًا.');
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) _toast('تعذر فتح خرائط Google.');
    } catch (_) {
      _toast('تعذر فتح خرائط Google.');
    }
  }

  Future<void> _callCourier() async {
    final phone = widget.courierPhone;

    if (phone == null || phone.trim().isEmpty) {
      _toast('رقم المندوب غير متوفر حاليًا.');
      return;
    }

    try {
      await launchUrl(Uri(scheme: 'tel', path: phone.trim()));
    } catch (_) {
      _toast('تعذر إجراء الاتصال.');
    }
  }

  void _copyOrderNumber() {
    Clipboard.setData(ClipboardData(text: orderNumber));
    _toast('تم نسخ رقم الطلب');
  }

  void _toast(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(
            message,
            textDirection: TextDirection.rtl,
          ),
        ),
      );
  }

  // =========================================================
  // تنسيق
  // =========================================================

  String _two(int n) => n.toString().padLeft(2, '0');

  String _formatTime(DateTime t) {
    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final period = t.hour < 12 ? 'ص' : 'م';
    return '$hour:${_two(t.minute)} $period';
  }

  String _formatDate(DateTime d) =>
      '${d.year}/${_two(d.month)}/${_two(d.day)}';

  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} م';
    return '${km.toStringAsFixed(1)} كم';
  }

  IconData _paymentIcon(String method) {
    final m = method.toLowerCase();

    if (m.contains('apple')) return Icons.apple;

    if (m.contains('نقد') ||
        m.contains('كاش') ||
        m.contains('cash') ||
        m.contains('الاستلام')) {
      return Icons.payments_outlined;
    }

    if (m.contains('مدى') ||
        m.contains('بطاق') ||
        m.contains('visa') ||
        m.contains('فيزا') ||
        m.contains('master')) {
      return Icons.credit_card_rounded;
    }

    return Icons.account_balance_wallet_outlined;
  }

  // =========================================================
  // إنهاء الطلب
  // =========================================================

  Future<void> finishOrder() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.border.withValues(alpha: 0.2),
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
                      onPressed: () => Navigator.pop(context),
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
          ),
        );
      },
    );

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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: const Text(
              'إلغاء الطلب؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700),
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
                onPressed: () => Navigator.pop(context, false),
                child: const Text('تراجع'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'نعم، ألغي الطلب',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
        (route) => false,
      );
    }
  }

  // =========================================================
  // الصفحة
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        // نمنع الرجوع لصفحة الدفع بعد إنشاء الطلب
        canPop: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F7F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              widget.isPickup ? 'استلام الطلب' : 'تتبع الطلب',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _statusBanner(),
                      const SizedBox(height: 14),

                      _hasMap ? _mapCard() : _mapPlaceholder(),
                      const SizedBox(height: 14),

                      _card(child: _stagesTracker()),
                      const SizedBox(height: 14),

                      if (!widget.isPickup && _stage >= 2) ...[
                        _courierCard(),
                        const SizedBox(height: 14),
                      ],

                      _detailsCard(),
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: finishOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            widget.isPickup
                                ? 'تم استلام الطلب'
                                : 'تم، متابعة',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      if (!widget.isPickup) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 46,
                          child: OutlinedButton(
                            onPressed: cancelOrder,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
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
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // مكوّنات عامة
  // =========================================================

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.7),
        ),
      ),
      child: child,
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 19, color: AppColors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _divider() => const Divider(height: 24, color: AppColors.border);

  // =========================================================
  // بانر الحالة
  // =========================================================

  Widget _statusBanner() {
    late final String title;
    late final String subtitle;
    late final IconData icon;

    if (widget.isPickup) {
      if (_stage >= 2) {
        title = 'طلبك جاهز للاستلام';
        subtitle = 'توجهي للفرع وشاركي رقم الطلب مع الموظف';
        icon = Icons.check_circle_rounded;
      } else {
        title = 'الصيدلية تجهّز طلبك';
        subtitle =
            'وقت الاستلام المتوقع: ${_formatTime(createdAt.add(const Duration(minutes: 15)))}'
            ' - ${_formatTime(createdAt.add(const Duration(minutes: 25)))}';
        icon = Icons.inventory_2_outlined;
      }
    } else {
      if (_stage >= 2) {
        title = 'طلبك في الطريق إليك';
        subtitle = 'الوصول المتوقع خلال $_etaMinutes دقيقة تقريبًا';
        icon = Icons.delivery_dining_rounded;
      } else {
        title = 'جاري تجهيز طلبك';
        subtitle = widget.timeSlot != null
            ? 'موعد التوصيل: ${widget.timeSlot}'
            : 'سيخرج المندوب للتوصيل قريبًا';
        icon = Icons.inventory_2_outlined;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
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
  // الخريطة
  // =========================================================

  Widget _mapCard() {
    final pickup = widget.isPickup;
    final initialTarget = (pickup ? _branchLatLng : _destination)!;

    final distanceKm = _pickupDistanceKm;

    return Container(
      height: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: 14,
            ),
            markers: _buildMarkers(),
            polylines: _buildPolylines(),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              Future.delayed(const Duration(milliseconds: 400), _fitCamera);
            },
          ),

          // اسم الفرع / العنوان
          Positioned(
            top: 10,
            right: 10,
            child: _mapChip(
              icon: pickup
                  ? Icons.storefront_rounded
                  : Icons.location_on_rounded,
              text: pickup
                  ? (widget.branchName ?? 'فرع الاستلام')
                  : 'عنوان التوصيل',
              maxWidth: 220,
            ),
          ),

          // المسافة / الوقت المتوقع
          if (pickup && distanceKm != null)
            Positioned(
              top: 10,
              left: 10,
              child: _mapChip(
                icon: Icons.near_me_rounded,
                text: _formatDistance(distanceKm),
              ),
            ),

          if (!pickup && _stage >= 2)
            Positioned(
              top: 10,
              left: 10,
              child: _mapChip(
                icon: Icons.timer_outlined,
                text: '$_etaMinutes د',
              ),
            ),

          // زر فتح الخرائط
          Positioned(
            bottom: 10,
            left: 10,
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _openDirections,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        pickup
                            ? Icons.directions_rounded
                            : Icons.open_in_new_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        pickup ? 'الاتجاهات' : 'فتح في الخرائط',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapChip({
    required IconData icon,
    required String text,
    double maxWidth = 160,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.green, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// تظهر إذا إحداثيات الموقع ما وصلت للصفحة.
  Widget _mapPlaceholder() {
    final canOpenLink = widget.isPickup && widget.branchMapUrl != null;

    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.isPickup
                  ? Icons.storefront_rounded
                  : Icons.local_shipping_outlined,
              color: AppColors.green,
              size: 26,
            ),
          ),
          if (canOpenLink) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _openDirections,
              icon: const Icon(
                Icons.map_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              label: const Text(
                'فتح موقع الفرع في خرائط Google',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // مراحل الطلب
  // =========================================================

  Widget _stagesTracker() {
    final stages = _stages;
    final lastIndex = stages.length - 1;

    return Column(
      children: List.generate(stages.length, (i) {
        final isCurrent = i == _stage;
        final isDone = i < _stage || (isCurrent && i == lastIndex);
        final isActive = isDone || isCurrent;
        final isLast = i == lastIndex;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.green
                          : AppColors.border.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: isDone
                        ? const Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Colors.white,
                          )
                        : isCurrent
                            ? Icon(
                                i == 1
                                    ? Icons.inventory_2_outlined
                                    : Icons.local_shipping_outlined,
                                size: 13,
                                color: Colors.white,
                              )
                            : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 2,
                        color: i < _stage
                            ? AppColors.green
                            : AppColors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 3,
                    bottom: isLast ? 0 : 20,
                  ),
                  child: Text(
                    stages[i],
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight:
                          isCurrent ? FontWeight.w800 : FontWeight.w600,
                      color: isActive
                          ? AppColors.primaryDark
                          : AppColors.textGray,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // =========================================================
  // بطاقة المندوب
  // =========================================================

  Widget _courierCard() {
    return _card(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delivery_dining_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.courierName ?? 'مندوب التوصيل',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'مندوب التوصيل',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _callCourier,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.phone_rounded,
                color: AppColors.green,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // تفاصيل الطلب
  // =========================================================

  Widget _detailsCard() {
    final method = widget.paymentMethod ?? 'غير محدد';
    final distanceKm = _pickupDistanceKm;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تفاصيل الطلب',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),

          _infoRow(
            icon: Icons.receipt_long_outlined,
            title: 'رقم الطلب',
            value: '#$orderNumber',
            trailing: IconButton(
              onPressed: _copyOrderNumber,
              icon: const Icon(
                Icons.copy_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),

          _divider(),

          _infoRow(
            icon: widget.isPickup
                ? Icons.storefront_outlined
                : Icons.location_on_outlined,
            title: widget.isPickup ? 'فرع الاستلام' : 'عنوان التوصيل',
            value: widget.isPickup
                ? (widget.branchName ?? 'صيدلية الأمل')
                : (widget.addressLine ?? 'العنوان المحدد'),
            subtitle: (widget.isPickup && distanceKm != null)
                ? 'يبعد عنك ${_formatDistance(distanceKm)} تقريبًا'
                : null,
          ),

          if (!widget.isPickup && widget.timeSlot != null) ...[
            _divider(),
            _infoRow(
              icon: Icons.schedule_rounded,
              title: 'موعد التوصيل',
              value: widget.timeSlot!,
            ),
          ],

          _divider(),

          _infoRow(
            icon: _paymentIcon(method),
            title: 'طريقة الدفع',
            value: method,
          ),

          _divider(),

          _infoRow(
            icon: Icons.calendar_today_outlined,
            title: 'تاريخ الطلب',
            value: '${_formatDate(createdAt)}  •  ${_formatTime(createdAt)}',
          ),

          _divider(),

          _infoRow(
            icon: Icons.shopping_bag_outlined,
            title: 'عدد المنتجات',
            value: '$itemsCount',
          ),

          const Divider(height: 28, color: AppColors.border),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إجمالي الطلب',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGray,
                ),
              ),
              Text(
                '${widget.totalAmount.toStringAsFixed(2)} ر.س',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}