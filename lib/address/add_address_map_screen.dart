import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../core/app_colors.dart';
import '../models/delivery_address.dart';
import '../services/address_service.dart';

class AddAddressMapScreen extends StatefulWidget {
  const AddAddressMapScreen({super.key});

  @override
  State<AddAddressMapScreen> createState() => _AddAddressMapScreenState();
}

class _AddAddressMapScreenState extends State<AddAddressMapScreen> {
  // موقع افتراضي مؤقت فقط إلى أن يتم تحديد موقع المستخدم الحقيقي
  static const LatLng defaultCenter = LatLng(16.8892, 42.5511);

  GoogleMapController? mapController;

  LatLng currentCenter = defaultCenter;

  String cityText = 'جاري تحديد الموقع...';
  String addressLine = '';

  bool resolvingAddress = false;
  bool gettingLocation = false;

  String selectedType = 'المنزل';
  bool setAsDefault = false;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // تحديد موقع المستخدم الحقيقي
  // ============================================================

  Future<void> goToMyLocation() async {
    if (gettingLocation) return;

    if (mounted) {
      setState(() {
        gettingLocation = true;
        cityText = 'جاري تحديد الموقع...';
      });
    }

    try {
      // التأكد من أن خدمة الموقع مفعلة
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فعّلي خدمة الموقع أولاً'),
          ),
        );

        await Geolocator.openLocationSettings();
        return;
      }

      // التحقق من صلاحية الموقع
      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'يجب السماح للتطبيق بالوصول إلى موقعك',
            ),
          ),
        );

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'صلاحية الموقع مرفوضة. فعّليها من إعدادات التطبيق',
            ),
          ),
        );

        await Geolocator.openAppSettings();
        return;
      }

    final position = await Geolocator.getCurrentPosition(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.high,
  ),
);

      final target = LatLng(
        position.latitude,
        position.longitude,
      );

      currentCenter = target;

      // تحريك الخريطة مباشرة إلى موقع المستخدم
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            target,
            18,
          ),
        );
      }

      // جلب العنوان من الإحداثيات
      await resolveAddressFromLatLng(target);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذّر تحديد موقعك الحالي'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          gettingLocation = false;
        });
      }
    }
  }

  // ============================================================
  // تحويل الإحداثيات إلى عنوان
  // ============================================================

  Future<void> resolveAddressFromLatLng(
    LatLng position,
  ) async {
    if (!mounted) return;

    setState(() {
      resolvingAddress = true;
    });

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final p = placemarks.first;

        setState(() {
          cityText =
              (p.locality != null && p.locality!.isNotEmpty)
                  ? p.locality!
                  : (p.administrativeArea ?? 'غير محدد');

          final parts = [
            p.subLocality,
            p.street,
          ]
              .where(
                (e) => e != null && e.isNotEmpty,
              )
              .toList();

          addressLine = parts.isNotEmpty
              ? parts.join(' - ')
              : (p.name ?? '');
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          addressLine = 'تعذّر تحديد العنوان تلقائيًا';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          resolvingAddress = false;
        });
      }
    }
  }

  // ============================================================
  // البحث عن عنوان
  // ============================================================

  Future<void> searchAddress(String query) async {
    if (query.trim().isEmpty) return;

    try {
      final locations = await locationFromAddress(
        query,
      );

      if (locations.isNotEmpty) {
        final loc = locations.first;

        final target = LatLng(
          loc.latitude,
          loc.longitude,
        );

        currentCenter = target;

        await mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            target,
            17,
          ),
        );

        await resolveAddressFromLatLng(target);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ما لقينا نتائج لهذا البحث',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تعذّر البحث، حاولي مرة ثانية',
            ),
          ),
        );
      }
    }
  }

  // ============================================================
  // حفظ العنوان
  // ============================================================

  void confirmLocation() {
    final address = DeliveryAddress(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      label: selectedType,
      addressLine: addressLine.isEmpty
          ? cityText
          : addressLine,
      city: cityText,
      latitude: currentCenter.latitude,
      longitude: currentCenter.longitude,
      isDefault: setAsDefault,
    );

    AddressService.instance.addAddress(address);

    Navigator.pop(
      context,
      address,
    );
  }

  // ============================================================
  // واجهة الشاشة
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ======================================================
          // العنوان العلوي
          // ======================================================

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'إضافة عنوان التسليم',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // ======================================================
          // الخريطة
          // ======================================================

          Expanded(
            flex: 3,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      const CameraPosition(
                    target: defaultCenter,
                    zoom: 12,
                  ),

                  // عند إنشاء الخريطة نحدد موقع المستخدم الحقيقي
                  onMapCreated:
                      (GoogleMapController controller) async {
                    mapController = controller;

                    await goToMyLocation();
                  },

                  // تحديث الإحداثيات مع تحريك الخريطة
                  onCameraMove: (position) {
                    currentCenter =
                        position.target;
                  },

                  // بعد توقف الخريطة نحدث العنوان
                  onCameraIdle: () {
                    resolveAddressFromLatLng(
                      currentCenter,
                    );
                  },

                  // إظهار نقطة موقع المستخدم
                  myLocationEnabled: true,

                  // نستخدم الزر الخاص بنا
                  myLocationButtonEnabled: false,

                  zoomControlsEnabled: false,

                  compassEnabled: true,
                ),

                // ==================================================
                // الدبوس الثابت في منتصف الخريطة
                // ==================================================

                const IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 36,
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 42,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // البحث
                // ==================================================

                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 46,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.08),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                searchController,
                            textAlign:
                                TextAlign.right,
                            textInputAction:
                                TextInputAction.search,
                            onSubmitted:
                                searchAddress,
                            decoration:
                                const InputDecoration(
                              isCollapsed: true,
                              border:
                                  InputBorder.none,
                              hintText:
                                  'ابحث عن عنوانك',
                              hintStyle:
                                  TextStyle(
                                color:
                                    AppColors.textGray,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        IconButton(
                          onPressed: () {
                            searchAddress(
                              searchController.text,
                            );
                          },
                          icon: const Icon(
                            Icons.search,
                            color:
                                AppColors.textGray,
                          ),
                          padding:
                              EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // زر موقعي الحالي
                // ==================================================

                Positioned(
                  right: 16,
                  bottom: 65,
                  child: Material(
                    color: Colors.white,
                    elevation: 4,
                    borderRadius:
                        BorderRadius.circular(12),
                    child: InkWell(
                      onTap: goToMyLocation,
                      borderRadius:
                          BorderRadius.circular(12),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: gettingLocation
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color:
                                        AppColors
                                            .primary,
                                  ),
                                )
                              : const Icon(
                                  Icons.my_location,
                                  color:
                                      AppColors.primary,
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // رسالة أسفل الخريطة
                // ==================================================

                Positioned(
                  bottom: 14,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.95),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'ابحث أو حرك الخريطة لتغيير الموقع',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // معلومات العنوان
          // ======================================================

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        alignment:
                            Alignment.center,
                        decoration:
                            const BoxDecoration(
                          color: Color(0xffF7F9FC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color:
                              AppColors.primary,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Text(
                              cityText,
                              textAlign:
                                  TextAlign.right,
                              style:
                                  const TextStyle(
                                color:
                                    AppColors
                                        .primaryDark,
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),

                            Text(
                              resolvingAddress
                                  ? 'جاري تحديد العنوان...'
                                  : (addressLine
                                          .isEmpty
                                      ? '—'
                                      : addressLine),
                              textAlign:
                                  TextAlign.right,
                              style:
                                  const TextStyle(
                                color:
                                    AppColors.textGray,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const Align(
                    alignment:
                        Alignment.centerRight,
                    child: Text(
                      'نوع العنوان',
                      style: TextStyle(
                        color:
                            AppColors.primaryDark,
                        fontSize: 12.5,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      for (final type in [
                        'آخر',
                        'العمل',
                        'المنزل'
                      ])
                        Padding(
                          padding:
                              const EdgeInsets.only(
                            left: 8,
                          ),
                          child: ChoiceChip(
                            label: Text(type),
                            selected:
                                selectedType ==
                                    type,
                            onSelected: (_) {
                              setState(() {
                                selectedType =
                                    type;
                              });
                            },
                            selectedColor:
                                AppColors.primary
                                    .withValues(
                                  alpha: 0.12,
                                ),
                            labelStyle:
                                TextStyle(
                              color:
                                  selectedType ==
                                          type
                                      ? AppColors
                                          .primary
                                      : AppColors
                                          .textGray,
                              fontWeight:
                                  FontWeight.w600,
                              fontSize: 12,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                              side: BorderSide(
                                color:
                                    selectedType ==
                                            type
                                        ? AppColors
                                            .primary
                                        : AppColors
                                            .border,
                              ),
                            ),
                            backgroundColor:
                                Colors.white,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Switch(
                        value: setAsDefault,
                        activeColor:
                            AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            setAsDefault =
                                value;
                          });
                        },
                      ),

                      const Text(
                        'تعيين كعنوان افتراضي',
                        style: TextStyle(
                          color:
                              AppColors.primaryDark,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    height: 47,
                    child: ElevatedButton(
                      onPressed:
                          resolvingAddress
                              ? null
                              : confirmLocation,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryDark,
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                        ),
                      ),
                      child: const Text(
                        'حفظ العنوان',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
