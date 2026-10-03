import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  static const LatLng defaultCenter = LatLng(16.8892, 42.5511);

  GoogleMapController? mapController;

  String? selectedBranchId;

  final TextEditingController noteController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  /// جميع الفروع المرسلة من الإدارة.
  /// روابط Google Maps هي الروابط الأصلية للفروع.
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

  List<PharmacyBranch> get filteredBranches {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return branches;
    }

    return branches.where((branch) {
      return branch.name.toLowerCase().contains(query);
    }).toList();
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
  }

  @override
  void dispose() {
    noteController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> openBranchLocation(PharmacyBranch branch) async {
    final uri = Uri.parse(branch.mapUrl);

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر فتح موقع الفرع'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح خرائط Google'),
        ),
      );
    }
  }

  void selectBranch(PharmacyBranch branch) {
    setState(() {
      selectedBranchId = branch.id;
    });
  }

  void confirmBranch() {
    final branch = selectedBranch;

    if (branch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار فرع أولاً'),
        ),
      );
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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'استلام من الفرع',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
            child: const CheckoutStepper(
              currentStep: 0,
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: Column(
                    children: [
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: TextField(
                          controller: searchController,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintText: 'ابحثي عن اسم الفرع...',
                            hintStyle: const TextStyle(
                              color: AppColors.textGray,
                              fontSize: 12,
                            ),
                            prefixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    onPressed: searchController.clear,
                                    icon: const Icon(
                                      Icons.close,
                                      size: 19,
                                      color: AppColors.textGray,
                                    ),
                                  )
                                : null,
                            suffixIcon: const Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${visibleBranches.length} فرع',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            'اختاري الفرع المناسب للاستلام',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: defaultCenter,
                          zoom: 8.5,
                        ),
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        compassEnabled: true,
                      ),

                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.location_on,
                                color: AppColors.green,
                                size: 18,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'فروع صيدلية الأمل',
                                style: TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            12,
                            16,
                            8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.green.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${visibleBranches.length}',
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'الصيدليات القريبة منك',
                                style: TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: visibleBranches.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.search_off,
                                          size: 42,
                                          color: AppColors.textGray,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'لا يوجد فرع بهذا الاسم',
                                          style: TextStyle(
                                            color: AppColors.primaryDark,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    2,
                                    16,
                                    12,
                                  ),
                                  itemCount: visibleBranches.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 9),
                                  itemBuilder: (context, index) {
                                    final branch = visibleBranches[index];
                                    final isSelected =
                                        branch.id == selectedBranchId;

                                    return _BranchCard(
                                      branch: branch,
                                      isSelected: isSelected,
                                      onTap: () {
                                        selectBranch(branch);
                                      },
                                      onOpenMap: () {
                                        openBranchLocation(branch);
                                      },
                                    );
                                  },
                                ),
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            8,
                            16,
                            8,
                          ),
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
                              if (selectedBranch != null)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.green.withValues(
                                      alpha: 0.06,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.green.withValues(
                                        alpha: 0.25,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppColors.green,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          selectedBranch!.name,
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.primaryDark,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'الفرع المختار',
                                        style: TextStyle(
                                          color: AppColors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  'هل تحتاج ملاحظة؟ (اختياري)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 7),

                              TextField(
                                controller: noteController,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: 'مثال: اتصل قبل الوصول',
                                  hintStyle: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textGray,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF8F9FA),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.3,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: confirmBranch,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.green,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'تأكيد الفرع والمتابعة للدفع',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}

class _BranchCard extends StatelessWidget {
  final PharmacyBranch branch;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onOpenMap;

  const _BranchCard({
    required this.branch,
    required this.isSelected,
    required this.onTap,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.green.withValues(alpha: 0.055)
                : Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isSelected
                  ? AppColors.green
                  : AppColors.border,
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.green.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? AppColors.green
                    : AppColors.border,
                size: 22,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.green.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'مختار',
                              style: TextStyle(
                                color: AppColors.green,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        Flexible(
                          child: Text(
                            branch.name,
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: Text(
                            'الموقع متوفر على خرائط Google',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        InkWell(
                          onTap: onOpenMap,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(
                                alpha: 0.07,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.directions,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'الموقع',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
}