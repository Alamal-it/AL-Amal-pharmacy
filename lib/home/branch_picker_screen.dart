import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/app_colors.dart';
import 'payment_method_screen.dart';

class PharmacyBranch {
  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final LatLng location;

  const PharmacyBranch({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.location,
  });
}

class BranchPickerScreen extends StatefulWidget {
  final double totalAmount;

  const BranchPickerScreen({super.key, required this.totalAmount});

  @override
  State<BranchPickerScreen> createState() => _BranchPickerScreenState();
}

class _BranchPickerScreenState extends State<BranchPickerScreen> {
  static const LatLng defaultCenter = LatLng(16.8892, 42.5511);

  GoogleMapController? mapController;
  String? selectedBranchId;

  // TODO: استبدال هذي القائمة بفروع حقيقية من الـ API لما يجهزها المدير.
  final List<PharmacyBranch> branches = const [
    PharmacyBranch(
      id: '1',
      name: 'فرع الصفا',
      address: 'حي السويس، شارع الأمير سلطان',
      distanceKm: 0.43,
      location: LatLng(16.8920, 42.5530),
    ),
    PharmacyBranch(
      id: '2',
      name: 'فرع الروضة',
      address: 'حي الروضة، جازان',
      distanceKm: 4.48,
      location: LatLng(16.8790, 42.5460),
    ),
    PharmacyBranch(
      id: '3',
      name: 'فرع الشاطئ',
      address: 'حي الشاطئ، جازان',
      distanceKm: 6.10,
      location: LatLng(16.9010, 42.5600),
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedBranchId = branches.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_forward,
                        color: AppColors.primaryDark),
                  ),
                  const Expanded(
                    child: Text(
                      'استلام من الفرع',
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
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: defaultCenter,
                zoom: 12,
              ),
              onMapCreated: (controller) => mapController = controller,
              markers: branches.map((branch) {
                return Marker(
                  markerId: MarkerId(branch.id),
                  position: branch.location,
                  infoWindow: InfoWindow(title: branch.name),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    branch.id == selectedBranchId
                        ? BitmapDescriptor.hueGreen
                        : BitmapDescriptor.hueAzure,
                  ),
                  onTap: () => setState(() => selectedBranchId = branch.id),
                );
              }).toSet(),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2)),],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'الصيدليات القريبة منك',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: branches.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final branch = branches[index];
                        final isSelected = branch.id == selectedBranchId;

                        return InkWell(
                          onTap: () {
                            setState(() => selectedBranchId = branch.id);
                            mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                  branch.location, 14),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        branch.name,
                                        style: const TextStyle(
                                          color: AppColors.primaryDark,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        branch.address,
                                        style: const TextStyle(
                                          color: AppColors.textGray,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${branch.distanceKm} كم',
                                  style: const TextStyle(
                                    color: AppColors.primary,fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 47,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentMethodScreen(
                                totalAmount: widget.totalAmount,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'تأكيد الفرع',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
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