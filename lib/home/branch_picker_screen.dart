import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import '../widgets/checkout_stepper.dart';
import 'payment_method_screen.dart';

class PharmacyBranch {
  final String id;
  final String name;
  final String mapUrl;

  const PharmacyBranch({
    required this.id,
    required this.name,
    required this.mapUrl,
  });
}

class BranchPickerScreen extends StatefulWidget {
  final double totalAmount;

  const BranchPickerScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<BranchPickerScreen> createState() => _BranchPickerScreenState();
}

class _BranchPickerScreenState extends State<BranchPickerScreen> {
  static const LatLng defaultCenter = LatLng(17.0000, 42.6000);

  GoogleMapController? mapController;

  String? selectedBranchId;
  String? nearestBranchId;

  Position? userPosition;
  bool isLoadingLocation = true;
  bool isResolvingBranches = false;
  bool isMapReady = false;

  final TextEditingController noteController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  final Map<String, LatLng> _branchLocations = <String, LatLng>{};

  final Set<Marker> _markers = <Marker>{};

  final List<PharmacyBranch> branches = const [
    PharmacyBranch(
      id: '1',
      name: 'صيدلية افق جازان المطار',
      mapUrl: 'https://goo.gl/maps/sKUimbp9JdvAaDJg8',
    ),
    PharmacyBranch(
      id: '2',
      name: 'المحافظه 2',
      mapUrl: 'https://goo.gl/maps/hykG1uFksdkW3NLS6',
    ),
    PharmacyBranch(
      id: '3',
      name: 'صيدلية مخطط 6',
      mapUrl: 'https://goo.gl/maps/nuSA5Bp9yphWHFUQ9',
    ),
    PharmacyBranch(
      id: '4',
      name: 'صيدلية افق جازان الدغارير',
      mapUrl: 'https://goo.gl/maps/fj19ksyMzd8j9vvy9',
    ),
    PharmacyBranch(
      id: '5',
      name: 'صيدليه افق الشبيلي احد المسارحه',
      mapUrl: 'https://goo.gl/maps/gF5U8GmCstho7wNT8',
    ),
    PharmacyBranch(
      id: '6',
      name: 'صيدلية الامل المجمع - صامطة',
      mapUrl: 'https://goo.gl/maps/8veW3qSr8GrBKdAf8',
    ),
    PharmacyBranch(
      id: '7',
      name: 'صيدلية الامل الخط العام الجديدة همس',
      mapUrl: 'https://maps.app.goo.gl/FqSb6RrjcmK9r83c8',
    ),
    PharmacyBranch(
      id: '8',
      name: 'صيدلية افق جازان سوق الحكمى',
      mapUrl: 'https://goo.gl/maps/DQeK6imhyeUqdHeZ8',
    ),
    PharmacyBranch(
      id: '9',
      name: 'صيدلية الامل الماسيه البنك الاهلى صامطه',
      mapUrl: 'https://goo.gl/maps/aq9tdGHXbtQTTmXN7',
    ),
    PharmacyBranch(
      id: '10',
      name: 'صيدلية الامل الدغارير',
      mapUrl: 'https://goo.gl/maps/NMbhj9xeRUiFyYWj9',
    ),
    PharmacyBranch(
      id: '11',
      name: 'صيدلية افق جازان مقابل عزيز',
      mapUrl: 'https://goo.gl/maps/undNuVYceX8zwt3MA',
    ),
    PharmacyBranch(
      id: '12',
      name: 'صيدلية الامل الدفاع الدنى',
      mapUrl: 'https://goo.gl/maps/zd1c42bt6wLC244G9',
    ),
    PharmacyBranch(
      id: '13',
      name: 'صيدلية بنى مالك',
      mapUrl: 'https://goo.gl/maps/Emu9RGi2Z7CpkUfW7',
    ),
    PharmacyBranch(
      id: '14',
      name: 'صيدلية الحياه ابها',
      mapUrl: 'https://goo.gl/maps/khmUqaBYAfb7iTzS9',
    ),
    PharmacyBranch(
      id: '15',
      name: 'صيدلية ابو بكر ابها شمسان',
      mapUrl: 'https://goo.gl/maps/kCPQ5k3o4fcpSzTD8',
    ),
    PharmacyBranch(
      id: '16',
      name: 'صيدلية افق جازان ابوعريش الرفاعى',
      mapUrl: 'https://maps.app.goo.gl/9J3gAXkrxVnv7CU66',
    ),
    PharmacyBranch(
      id: '17',
      name: 'صيدلية ناصر ابها',
      mapUrl: 'https://goo.gl/maps/p7mDAQK8QxJMYMcp8',
    ),
    PharmacyBranch(
      id: '18',
      name: 'الغروي خميس مشيط',
      mapUrl: 'https://goo.gl/maps/R4kWx6aCWU8Un5XH6',
    ),
    PharmacyBranch(
      id: '19',
      name: 'صيدلية شباعة خميس مشيط',
      mapUrl: 'https://goo.gl/maps/YwMBKuVUkF8xPuER9',
    ),
    PharmacyBranch(
      id: '20',
      name: 'صيدليات افق جازان بيش 1',
      mapUrl: 'https://goo.gl/maps/UujJJkXZhfUY2ivbA',
    ),
    PharmacyBranch(
      id: '21',
      name: 'صيدلية واحة الدواء الركوبة',
      mapUrl: 'https://goo.gl/maps/FdJEETJaK8SHGoco9',
    ),
    PharmacyBranch(
      id: '22',
      name: 'صيدلية الامل الركوبة',
      mapUrl: 'https://goo.gl/maps/HVxRBZvEEQsdMH349',
    ),
    PharmacyBranch(
      id: '23',
      name: 'صيدلية الامل الكربوس',
      mapUrl: 'https://goo.gl/maps/pXK26sKnWPkxPo5k8',
    ),
    PharmacyBranch(
      id: '24',
      name: 'صيدلية الفيصل خميس',
      mapUrl: 'https://goo.gl/maps/fk5wfRt36RSwSJVD8',
    ),
    PharmacyBranch(
      id: '25',
      name: 'صيدلية ريم صبيا',
      mapUrl: 'https://goo.gl/maps/nf58RXAQbb9JvMhZ6',
    ),
    PharmacyBranch(
      id: '26',
      name: 'صيدلية الأمل السوق',
      mapUrl: 'https://goo.gl/maps/tZgxDfUFpzAMabPT7',
    ),
    PharmacyBranch(
      id: '27',
      name: 'صيدلية الأمل الخط العام القديمة( دحمان)',
      mapUrl: 'https://goo.gl/maps/LhhVkejQKhm16bja7',
    ),
    PharmacyBranch(
      id: '28',
      name: 'صيدلية فيفا صبيا',
      mapUrl: 'https://maps.app.goo.gl/QtBQS6M286APK3ZS8',
    ),
    PharmacyBranch(
      id: '29',
      name: 'صيدلية الامل المستوصف',
      mapUrl: 'https://goo.gl/maps/FBoa7pVzRanU31xeA',
    ),
    PharmacyBranch(
      id: '30',
      name: 'صيدلية صامطه 2 الطالبي',
      mapUrl: 'https://goo.gl/maps/tbmVHjjHMADSsXxs7',
    ),
    PharmacyBranch(
      id: '31',
      name: 'صيدلية صامطه 1 البنك الأهلي',
      mapUrl: 'https://goo.gl/maps/YS5VgSTFmtS75xhE8',
    ),
    PharmacyBranch(
      id: '32',
      name: 'صيدلية الهيثم جازان',
      mapUrl: 'https://goo.gl/maps/G4pSEWFe65yx5nZi6',
    ),
    PharmacyBranch(
      id: '33',
      name: 'صيدلية المضايا 2',
      mapUrl: 'https://goo.gl/maps/FDXLrNyDUNHdx22v7',
    ),
    PharmacyBranch(
      id: '34',
      name: 'صيدلية واحة الدواء أبو حجر 1',
      mapUrl: 'https://goo.gl/maps/iv32jw26n65rU1Wu5',
    ),
    PharmacyBranch(
      id: '35',
      name: 'صيدلية صامطه 4 سوق الخضار',
      mapUrl: 'https://goo.gl/maps/VKTTPi4znBw8FPU66',
    ),
    PharmacyBranch(
      id: '36',
      name: 'صيدلية المطار 1 جازان',
      mapUrl: 'https://goo.gl/maps/HTUiqxakk6JKSwn97',
    ),
    PharmacyBranch(
      id: '37',
      name: 'صيدلية الهلال صبيا',
      mapUrl: 'https://maps.app.goo.gl/obNXib9tkamRGg56A',
    ),
    PharmacyBranch(
      id: '38',
      name: 'صيدلية المضايا 1',
      mapUrl: 'https://goo.gl/maps/sGiuUH3S7pNFwo5eA',
    ),
    PharmacyBranch(
      id: '39',
      name: 'صيدلية ظبيا 1',
      mapUrl: 'https://maps.app.goo.gl/pwiQUb1x44jJsPCj9',
    ),
    PharmacyBranch(
      id: '40',
      name: 'صيدلية ظبيا 2',
      mapUrl: 'https://maps.app.goo.gl/hdzdtw2z6HeCEmcX9',
    ),
    PharmacyBranch(
      id: '41',
      name: 'صيدلية الهدى صبيا',
      mapUrl: 'https://goo.gl/maps/icuciEEZUKnimtUc9',
    ),
    PharmacyBranch(
      id: '42',
      name: 'صيدلية النخيل',
      mapUrl: 'https://goo.gl/maps/3zN1USmH5viiz4Sr6',
    ),
    PharmacyBranch(
      id: '43',
      name: 'صيدلية الشفا بيش',
      mapUrl: 'https://goo.gl/maps/C1spxHBUDdhyLqh36',
    ),
    PharmacyBranch(
      id: '44',
      name: 'صيدلية ظبيا 3',
      mapUrl: 'https://maps.app.goo.gl/2hcV2wM2jVwe18Qq5',
    ),
    PharmacyBranch(
      id: '45',
      name: 'صيدلية محمد ناصر صبيا',
      mapUrl: 'https://goo.gl/maps/wFNH6uMhjDx7AoubA',
    ),
    PharmacyBranch(
      id: '46',
      name: 'صيدلية دار الدواء جازان',
      mapUrl: 'https://goo.gl/maps/HuFD8qppC3u1iutV6',
    ),
    PharmacyBranch(
      id: '47',
      name: 'صيدلية القمري 1',
      mapUrl: 'https://goo.gl/maps/roS8QKfChVt1hKGn9',
    ),
    PharmacyBranch(
      id: '48',
      name: 'صيدلية ضمد',
      mapUrl: 'https://goo.gl/maps/F1yBAKEyQk7jaoD68',
    ),
    PharmacyBranch(
      id: '49',
      name: 'ابو عريش المطعم',
      mapUrl: 'https://maps.app.goo.gl/qP9FGfJ2BmenCGXNA',
    ),
    PharmacyBranch(
      id: '50',
      name: 'صيدلية الامل ابوعريش',
      mapUrl: 'https://maps.app.goo.gl/9ix7fGdgwRm4r5DC8',
    ),
    PharmacyBranch(
      id: '51',
      name: 'صيدلية السلامة السفلى بيش',
      mapUrl: 'https://goo.gl/maps/x3weFcpq4sLm9hPSA',
    ),
    PharmacyBranch(
      id: '52',
      name: 'صيدلية الحسيني صبيا',
      mapUrl: 'https://goo.gl/maps/gWeoXnhJzs5csCFq6',
    ),
    PharmacyBranch(
      id: '53',
      name: 'صيدلية محلية 1',
      mapUrl: 'https://goo.gl/maps/smXsxjzfeGjxzPbx6',
    ),
    PharmacyBranch(
      id: '54',
      name: 'صيدلية الجربة',
      mapUrl: 'https://goo.gl/maps/YsqekYQoNcxgWZq38',
    ),
    PharmacyBranch(
      id: '55',
      name: 'صيدلية الحقو',
      mapUrl: 'https://goo.gl/maps/CPMU45KeUnsygZo88',
    ),
    PharmacyBranch(
      id: '56',
      name: 'صيدلية ناصر بيش',
      mapUrl: 'https://goo.gl/maps/R8XcqhnwJpuhmfsm6',
    ),
    PharmacyBranch(
      id: '57',
      name: 'صيدلية المحلة ريتاج',
      mapUrl: 'https://goo.gl/maps/nfDBiRGH5LMhgHBt6',
    ),
    PharmacyBranch(
      id: '58',
      name: 'صيدلية ابو بكر صبيا',
      mapUrl: 'https://goo.gl/maps/78cGP8U5sfxgE4Fq8',
    ),
    PharmacyBranch(
      id: '59',
      name: 'صيدلية الريث',
      mapUrl: 'https://goo.gl/maps/69gew5xmX6U6iiCw9',
    ),
    PharmacyBranch(
      id: '60',
      name: 'صيدلية العارضة المستوصف',
      mapUrl: 'https://goo.gl/maps/DgVziTNpxjdC1231A',
    ),
    PharmacyBranch(
      id: '61',
      name: 'صيدلية العارضة بطحان',
      mapUrl: 'https://goo.gl/maps/w2sFwAYoLW4MkFZF7',
    ),
    PharmacyBranch(
      id: '62',
      name: 'صيدلية الامل الدرب 1',
      mapUrl: 'https://goo.gl/maps/9QRzwsPGKtJDwb6s6',
    ),
    PharmacyBranch(
      id: '63',
      name: 'صيدلية ناصر الدرب',
      mapUrl: 'https://goo.gl/maps/PeMS8RZY4YnNFy1W9',
    ),
    PharmacyBranch(
      id: '64',
      name: 'صيدلية المضايا 3',
      mapUrl: 'https://goo.gl/maps/NT7dams3MgucoD8R9',
    ),
    PharmacyBranch(
      id: '65',
      name: 'صيدلية ابو القعايد',
      mapUrl: 'https://goo.gl/maps/RSSWx4E1XmFWL92Z8',
    ),
    PharmacyBranch(
      id: '66',
      name: 'صيدلية الريان 1',
      mapUrl: 'https://goo.gl/maps/jJKRTwXep5SfCbHx8',
    ),
    PharmacyBranch(
      id: '67',
      name: 'صيدلية الريان 2',
      mapUrl: 'https://goo.gl/maps/uZN3r3i2MJDUivHS9',
    ),
    PharmacyBranch(
      id: '68',
      name: 'صيدلية عبد الله الدرب',
      mapUrl: 'https://goo.gl/maps/abddXkA6H5s1i8Fa9',
    ),
    PharmacyBranch(
      id: '69',
      name: 'صيدلية فاروق الدرب',
      mapUrl: 'https://goo.gl/maps/9HLgkwQhfG5XKZhb9',
    ),
    PharmacyBranch(
      id: '70',
      name: 'صيدلية ابو بكر فرسان - مريع',
      mapUrl: 'https://goo.gl/maps/Dtk4s7UpQzfqwMCX6',
    ),
    PharmacyBranch(
      id: '71',
      name: 'صيدلية افق جازان فرسان',
      mapUrl: 'https://goo.gl/maps/yEQtwtNbKtorJjja8',
    ),
    PharmacyBranch(
      id: '72',
      name: 'صيدلية الأمل الشقيق',
      mapUrl: 'https://goo.gl/maps/DPRAoV4ThSyCuqbS7',
    ),
    PharmacyBranch(
      id: '73',
      name: 'صيدلية فيفا الجبل',
      mapUrl: 'https://maps.app.goo.gl/SiNs5akq2wgMi51QA',
    ),
    PharmacyBranch(
      id: '74',
      name: 'صيدلية افق جازان بجوار المحافظة',
      mapUrl: 'https://goo.gl/maps/oBAXiqYpCD2cVveQ6',
    ),
    PharmacyBranch(
      id: '75',
      name: 'صيدلية أبو حجر الاسكان',
      mapUrl: 'https://goo.gl/maps/n43KENrsUfJWtpjU7',
    ),
    PharmacyBranch(
      id: '76',
      name: 'صيدلية الجلديه صامطة',
      mapUrl: 'https://goo.gl/maps/nS7u5Dg45JkeQ2Fs7',
    ),
    PharmacyBranch(
      id: '77',
      name: 'صيدلية صامطة البرج',
      mapUrl: 'https://goo.gl/maps/nbZy9t776TMwrP797',
    ),
    PharmacyBranch(
      id: '78',
      name: 'صيدلية ابو عريش الطريق الدولي',
      mapUrl: 'https://maps.app.goo.gl/Uj9TSX1h8Rqhx9xw9',
    ),
    PharmacyBranch(
      id: '79',
      name: 'صيدلية الجلدية صبيا الجديده',
      mapUrl: 'https://goo.gl/maps/jL7ufRVsQfa3mCc37',
    ),
    PharmacyBranch(
      id: '80',
      name: 'صيدلية المطار 3 الجديدة',
      mapUrl: 'https://maps.app.goo.gl/aWUhFkgch9LVdoL89',
    ),
    PharmacyBranch(
      id: '81',
      name: 'صيدلية القمري 3',
      mapUrl: 'https://goo.gl/maps/F6Gy8yawLiLYr9SJ8',
    ),
    PharmacyBranch(
      id: '82',
      name: 'صيدلية محلية 2',
      mapUrl: 'https://goo.gl/maps/PUKnVyb1cdu2iguH9',
    ),
    PharmacyBranch(
      id: '83',
      name: 'احد المسارحة حي القسوم',
      mapUrl: 'https://maps.app.goo.gl/Nuh7F1uwDsYs4H3b8?g_st=iw',
    ),
    PharmacyBranch(
      id: '84',
      name: 'ابها حي اليمانية',
      mapUrl: 'https://goo.gl/maps/mMztZhf9rSQXCUs88',
    ),
    PharmacyBranch(
      id: '85',
      name: 'مخطط 6 الجديدة',
      mapUrl: 'https://goo.gl/maps/nuSA5Bp9yphWHFUQ9',
    ),
    PharmacyBranch(
      id: '86',
      name: 'هروب',
      mapUrl: 'https://maps.app.goo.gl/PPbJDYMtssoKwnTh9',
    ),
    PharmacyBranch(
      id: '87',
      name: 'الشقيق 2',
      mapUrl: 'https://maps.app.goo.gl/N7wyHkB3R9aR29m36',
    ),
    PharmacyBranch(
      id: '88',
      name: 'ديحمة',
      mapUrl: 'https://maps.app.goo.gl/PUVjo5JraVFohSk29',
    ),
    PharmacyBranch(
      id: '89',
      name: 'السويس',
      mapUrl: 'https://maps.app.goo.gl/xDmUR19xZjHYrZJr5',
    ),
    PharmacyBranch(
      id: '90',
      name: 'الطرشية',
      mapUrl: 'https://maps.app.goo.gl/MXLFaFnDFA7ihi4v7',
    ),
    PharmacyBranch(
      id: '91',
      name: 'الضاحية',
      mapUrl: 'https://maps.app.goo.gl/1i2gmbRAxe52Kk3e6',
    ),
  ];

  @override
  void initState() {
    super.initState();

    if (branches.isNotEmpty) {
      selectedBranchId = branches.first.id;
    }

    searchController.addListener(() {
      if (!mounted) return;
      setState(() {
        searchQuery = searchController.text;
      });
    });

    _initializeBranches();
  }

  @override
  void dispose() {
    noteController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeBranches() async {
    await _getUserLocation();
    await _resolveBranchLocations();
  }

  Future<void> _getUserLocation() async {
    if (!mounted) return;

    setState(() {
      isLoadingLocation = true;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            isLoadingLocation = false;
          });
          _showLocationMessage('فعّلي خدمة الموقع من إعدادات الجهاز لعرض أقرب فرع.');
        }
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            isLoadingLocation = false;
          });
          _showLocationMessage(
            permission == LocationPermission.deniedForever
                ? 'صلاحية الموقع مرفوضة نهائيًا. يمكنك تفعيلها من إعدادات التطبيق.'
                : 'اسمحي للتطبيق بالوصول إلى موقعك لعرض أقرب فرع.',
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20,
        ),
      );

      if (!mounted) return;

      setState(() {
        userPosition = position;
        isLoadingLocation = false;
      });

      await _moveCameraTo(
        LatLng(position.latitude, position.longitude),
        zoom: 13.5,
      );

      _rebuildMarkers();

      if (_branchLocations.isNotEmpty) {
        _selectNearestBranch(moveCamera: false);
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoadingLocation = false;
      });

      _showLocationMessage('تعذر تحديد موقعك حاليًا. يمكنك اختيار الفرع يدويًا.');
    }
  }

  Future<void> _resolveBranchLocations() async {
    if (!mounted) return;

    setState(() {
      isResolvingBranches = true;
    });

    final client = http.Client();

    try {
      // Resolve in small batches so the phone is not flooded with requests.
      for (var start = 0; start < branches.length; start += 6) {
        final end = (start + 6 > branches.length) ? branches.length : start + 6;
        final batch = branches.sublist(start, end);

        await Future.wait(
          batch.map(
            (branch) => _resolveSingleBranch(client, branch),
          ),
        );

        if (mounted) {
          _rebuildMarkers();

          if (userPosition != null) {
            _selectNearestBranch(moveCamera: false);
          }

          setState(() {});
        }
      }
    } finally {
      client.close();

      if (mounted) {
        setState(() {
          isResolvingBranches = false;
        });
      }
    }
  }

  Future<void> _resolveSingleBranch(
    http.Client client,
    PharmacyBranch branch,
  ) async {
    try {
      final response = await client
          .get(Uri.parse(branch.mapUrl))
          .timeout(const Duration(seconds: 8));

      final finalUri = response.request?.url;

      LatLng? coordinates;

      if (finalUri != null) {
        coordinates = _extractCoordinates(finalUri.toString());

        if (coordinates == null) {
          coordinates = _extractCoordinatesFromQuery(finalUri);
        }
      }

      // Some Google Maps redirects keep the coordinates inside the returned HTML.
      coordinates ??= _extractCoordinates(response.body);

      if (coordinates != null) {
        _branchLocations[branch.id] = coordinates;
      }
    } catch (_) {
      // A branch can still be opened normally in Google Maps even if its
      // coordinates cannot be resolved here.
    }
  }

  LatLng? _extractCoordinatesFromQuery(Uri uri) {
    const keys = <String>[
      'query',
      'q',
      'destination',
      'center',
    ];

    for (final key in keys) {
      final value = uri.queryParameters[key];
      if (value == null) continue;

      final result = _extractCoordinates(value);
      if (result != null) return result;
    }

    return null;
  }

  LatLng? _extractCoordinates(String value) {
    final decoded = Uri.decodeComponent(value);

    final patterns = <RegExp>[
      RegExp(
        r'@(-?\d{1,3}(?:\.\d+)?),(-?\d{1,3}(?:\.\d+)?)',
      ),
      RegExp(
        r'!3d(-?\d{1,3}(?:\.\d+)?)!4d(-?\d{1,3}(?:\.\d+)?)',
      ),
      RegExp(
        r'(-?\d{1,3}\.\d+)\s*,\s*(-?\d{1,3}\.\d+)',
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(decoded);
      if (match == null) continue;

      final latitude = double.tryParse(match.group(1)!);
      final longitude = double.tryParse(match.group(2)!);

      if (latitude == null || longitude == null) continue;

      if (latitude.abs() <= 90 && longitude.abs() <= 180) {
        return LatLng(latitude, longitude);
      }
    }

    return null;
  }

  void _rebuildMarkers() {
    final markers = <Marker>{};

    for (final branch in branches) {
      final location = _branchLocations[branch.id];
      if (location == null) continue;

      final isSelected = branch.id == selectedBranchId;
      final isNearest = branch.id == nearestBranchId;

      markers.add(
        Marker(
          markerId: MarkerId('branch_${branch.id}'),
          position: location,
          zIndexInt: isSelected ? 100 : (isNearest ? 90 : 1),
          infoWindow: InfoWindow(
            title: isNearest ? '⭐ الأقرب إليك' : branch.name,
            snippet: _distanceText(branch),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueAzure,
          ),
          onTap: () {
            selectBranch(branch, moveCamera: false);
          },
        ),
      );
    }

    if (userPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('my_location'),
          position: LatLng(
            userPosition!.latitude,
            userPosition!.longitude,
          ),
          zIndexInt: 200,
          infoWindow: const InfoWindow(
            title: 'موقعك الحالي',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
    });
  }

  double? _distanceTo(PharmacyBranch branch) {
    final user = userPosition;
    final branchLocation = _branchLocations[branch.id];

    if (user == null || branchLocation == null) return null;

    return Geolocator.distanceBetween(
          user.latitude,
          user.longitude,
          branchLocation.latitude,
          branchLocation.longitude,
        ) /
        1000;
  }

  String _distanceText(PharmacyBranch branch) {
    final distance = _distanceTo(branch);

    if (distance == null) {
      return 'الموقع متوفر على خرائط Google';
    }

    if (distance < 1) {
      return '${(distance * 1000).round()} م تقريبًا';
    }

    return '${distance.toStringAsFixed(1)} كم تقريبًا';
  }

  List<PharmacyBranch> get filteredBranches {
    final query = searchQuery.trim().toLowerCase();

    final result = branches.where((branch) {
      if (query.isEmpty) return true;
      return branch.name.toLowerCase().contains(query);
    }).toList();

    result.sort((a, b) {
      final da = _distanceTo(a);
      final db = _distanceTo(b);

      if (da != null && db != null) {
        return da.compareTo(db);
      }

      if (da != null) return -1;
      if (db != null) return 1;

      return a.id.compareTo(b.id);
    });

    return result;
  }

  PharmacyBranch? get selectedBranch {
    if (selectedBranchId == null) return null;

    for (final branch in branches) {
      if (branch.id == selectedBranchId) {
        return branch;
      }
    }

    return null;
  }

  PharmacyBranch? get nearestBranch {
    if (nearestBranchId == null) return null;

    for (final branch in branches) {
      if (branch.id == nearestBranchId) {
        return branch;
      }
    }

    return null;
  }

  void _selectNearestBranch({bool moveCamera = true}) {
    if (userPosition == null || _branchLocations.isEmpty) return;

    PharmacyBranch? nearest;
    double? shortestDistance;

    for (final branch in branches) {
      final distance = _distanceTo(branch);
      if (distance == null) continue;

      if (shortestDistance == null || distance < shortestDistance) {
        shortestDistance = distance;
        nearest = branch;
      }
    }

    if (nearest == null) return;

    final changed = nearestBranchId != nearest.id;

    if (mounted) {
      setState(() {
        nearestBranchId = nearest!.id;

        // Automatically choose the nearest branch when the customer first
        // opens this screen.
        if (selectedBranchId == null || changed) {
          selectedBranchId = nearest.id;
        }
      });
    }

    _rebuildMarkers();

    if (moveCamera) {
      final location = _branchLocations[nearest.id];
      if (location != null) {
        _moveCameraTo(location, zoom: 15.2);
      }
    }
  }

  Future<void> _moveCameraTo(
    LatLng target, {
    double zoom = 14,
  }) async {
    if (mapController == null) return;

    try {
      await mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: target,
            zoom: zoom,
          ),
        ),
      );
    } catch (_) {}
  }

  void selectBranch(
    PharmacyBranch branch, {
    bool moveCamera = true,
  }) {
    setState(() {
      selectedBranchId = branch.id;
    });

    _rebuildMarkers();

    final location = _branchLocations[branch.id];
    if (moveCamera && location != null) {
      _moveCameraTo(location, zoom: 15.2);
    }
  }

  Future<void> _openSelectedDirections() async {
    final branch = selectedBranch;
    if (branch == null) return;

    final location = _branchLocations[branch.id];

    if (location != null) {
      final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=${location.latitude},${location.longitude}',
      );

      try {
        final opened = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (opened) return;
      } catch (_) {}
    }

    await openBranchLocation(branch);
  }

  Future<void> openBranchLocation(PharmacyBranch branch) async {
    final uri = Uri.parse(branch.mapUrl);

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        _showLocationMessage('تعذر فتح موقع الفرع.');
      }
    } catch (_) {
      if (!mounted) return;
      _showLocationMessage('تعذر فتح خرائط Google.');
    }
  }

  void _showLocationMessage(String message) {
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
          content: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      );
  }

  void confirmBranch() {
    final branch = selectedBranch;

    if (branch == null) {
      _showLocationMessage('اختاري الفرع أولًا لإكمال الطلب.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(
          totalAmount: widget.totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleBranches = filteredBranches;
    final nearest = nearestBranch;
    final selected = selectedBranch;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            const CheckoutStepper(currentStep: 0),
            Expanded(
              child: Column(
                children: [
                  _buildSearchAndStatus(visibleBranches),
                  Expanded(
                    flex: 5,
                    child: _buildMap(nearest),
                  ),
                  Expanded(
                    flex: 7,
                    child: _buildBranchesPanel(
                      visibleBranches,
                      selected,
                      nearest,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primaryDark,
              size: 20,
            ),
          ),
          Expanded(
            child: Column(
              children: const [
                Text(
                  'استلام من الفرع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'اختاري أقرب فرع لك واستلمي طلبك بسهولة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSearchAndStatus(List<PharmacyBranch> visibleBranches) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Column(
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.75),
              ),
            ),
            child: TextField(
              controller: searchController,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحثي باسم الفرع أو المدينة...',
                hintStyle: const TextStyle(
                  color: AppColors.textGray,
                  fontSize: 12,
                ),
                prefixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: searchController.clear,
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 19,
                          color: AppColors.textGray,
                        ),
                      )
                    : null,
                suffixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _statusChip(
                  icon: isLoadingLocation
                      ? Icons.gps_not_fixed_rounded
                      : Icons.my_location_rounded,
                  title: isLoadingLocation
                      ? 'جاري تحديد موقعك...'
                      : userPosition != null
                          ? 'تم تحديد موقعك'
                          : 'حدد موقعك للأقرب',
                  onTap: _getUserLocation,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${visibleBranches.length} فرع',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.green.withValues(alpha: 0.16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Icon(
              icon,
              color: AppColors.green,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(PharmacyBranch? nearest) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: defaultCenter,
            zoom: 7.5,
          ),
          markers: _markers,
          myLocationEnabled: userPosition != null,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          buildingsEnabled: true,
          onMapCreated: (controller) {
            mapController = controller;
            isMapReady = true;

            final user = userPosition;
            if (user != null) {
              _moveCameraTo(
                LatLng(user.latitude, user.longitude),
                zoom: 13.5,
              );
            }
          },
        ),

        Positioned(
          top: 12,
          right: 12,
          child: _mapBadge(),
        ),

        Positioned(
          left: 14,
          bottom: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (nearest != null && _distanceTo(nearest) != null)
                _nearestMapCard(nearest),
              const SizedBox(height: 8),
              _mapLocationButton(),
            ],
          ),
        ),

        if (isResolvingBranches)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
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
              child: const Row(
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 7),
                  Text(
                    'تحديث مواقع الفروع',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _mapBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.storefront_rounded,
            color: AppColors.green,
            size: 18,
          ),
          SizedBox(width: 6),
          Text(
            'فروع صيدلية الأمل',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nearestMapCard(PharmacyBranch branch) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => selectBranch(branch),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 210,
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.green.withValues(alpha: 0.25),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.near_me_rounded,
                  color: AppColors.green,
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الأقرب إليك',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      branch.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _distanceText(branch),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mapLocationButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final user = userPosition;
          if (user == null) {
            await _getUserLocation();
            return;
          }

          await _moveCameraTo(
            LatLng(user.latitude, user.longitude),
            zoom: 15,
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.my_location_rounded,
            color: AppColors.primary,
            size: 21,
          ),
        ),
      ),
    );
  }

  Widget _buildBranchesPanel(
    List<PharmacyBranch> visibleBranches,
    PharmacyBranch? selected,
    PharmacyBranch? nearest,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 4,
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
            child: Row(
              children: [
                if (nearest != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      _distanceText(nearest),
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'أقرب الفروع إليك',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      userPosition != null
                          ? 'مرتبة حسب المسافة من موقعك'
                          : 'اختاري فرع الاستلام المناسب',
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: visibleBranches.isEmpty
                ? _emptyBranches()
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
                    itemCount: visibleBranches.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final branch = visibleBranches[index];

                      return _BranchCard(
                        branch: branch,
                        isSelected: branch.id == selected?.id,
                        isNearest: branch.id == nearest?.id,
                        distanceText: _distanceText(branch),
                        onTap: () => selectBranch(branch),
                        onOpenMap: () => openBranchLocation(branch),
                        onDirections: () => _openDirectionsFor(branch),
                      );
                    },
                  ),
          ),

          _buildBottomAction(selected),
        ],
      ),
    );
  }

  Future<void> _openDirectionsFor(PharmacyBranch branch) async {
    final location = _branchLocations[branch.id];

    if (location != null) {
      final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=${location.latitude},${location.longitude}',
      );

      try {
        if (await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        )) {
          return;
        }
      } catch (_) {}
    }

    await openBranchLocation(branch);
  }

  Widget _emptyBranches() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 30,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'لم نجد فرعًا بهذا الاسم',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'جرّبي اسم مدينة أو جزءًا من اسم الفرع',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGray,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(PharmacyBranch? selected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Column(
        children: [
          if (selected != null)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'الفرع المختار',
                        style: TextStyle(
                          color: AppColors.textGray,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selected.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _openSelectedDirections,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.directions_rounded,
                          color: AppColors.primary,
                          size: 17,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'الاتجاهات',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'إجمالي الطلب',
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
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
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: confirmBranch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تأكيد الفرع والمتابعة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 7),
                        Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final PharmacyBranch branch;
  final bool isSelected;
  final bool isNearest;
  final String distanceText;
  final VoidCallback onTap;
  final VoidCallback onOpenMap;
  final VoidCallback onDirections;

  const _BranchCard({
    required this.branch,
    required this.isSelected,
    required this.isNearest,
    required this.distanceText,
    required this.onTap,
    required this.onOpenMap,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.green.withValues(alpha: 0.045)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.green
                  : isNearest
                      ? AppColors.green.withValues(alpha: 0.45)
                      : AppColors.border,
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: [
              if (isSelected || isNearest)
                BoxShadow(
                  color: AppColors.green.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Row(
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: onDirections,
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.directions_rounded,
                        color: AppColors.primary,
                        size: 19,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    distanceText,
                    style: TextStyle(
                      color: isNearest
                          ? AppColors.green
                          : AppColors.textGray,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 5,
                      runSpacing: 4,
                      children: [
                        if (isNearest)
                          _smallBadge(
                            'الأقرب إليك',
                            AppColors.green,
                          ),
                        if (isSelected)
                          _smallBadge(
                            'مختار',
                            AppColors.primary,
                          ),
                      ],
                    ),

                    if (isNearest || isSelected)
                      const SizedBox(height: 5),

                    Text(
                      branch.name,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textGray,
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        const Flexible(
                          child: Text(
                            'موقع الفرع متوفر على خرائط Google',
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 9),

              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.green
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.green
                        : AppColors.border,
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 17,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
