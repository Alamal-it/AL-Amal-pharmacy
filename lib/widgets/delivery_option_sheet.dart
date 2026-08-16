import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/delivery_address.dart';
import '../services/address_service.dart';
import '../address/add_address_map_screen.dart';

enum DeliveryMode { delivery, pickup }

class DeliverySelectionResult {
  final DeliveryMode mode;
  final DeliveryAddress? address;

  const DeliverySelectionResult({required this.mode, this.address});
}

class DeliveryOptionSheet extends StatefulWidget {
  const DeliveryOptionSheet({super.key});

  static Future<DeliverySelectionResult?> show(BuildContext context) {
    return showModalBottomSheet<DeliverySelectionResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DeliveryOptionSheet(),
    );
  }

  @override
  State<DeliveryOptionSheet> createState() => _DeliveryOptionSheetState();
}

class _DeliveryOptionSheetState extends State<DeliveryOptionSheet> {
  String? selectedAddressId;

  @override
  void initState() {
    super.initState();
    selectedAddressId = AddressService.instance.defaultAddress?.id;
  }

  Future<void> addNewAddress() async {
    final result = await Navigator.push<DeliveryAddress>(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressMapScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        selectedAddressId = result.id;
      });
    }
  }

  void confirmDelivery() {
    final addresses = AddressService.instance.addresses;
    if (addresses.isEmpty) return;

    final address = addresses.firstWhere(
      (a) => a.id == selectedAddressId,
      orElse: () => addresses.first,
    );

    Navigator.pop(
      context,
      DeliverySelectionResult(mode: DeliveryMode.delivery, address: address),
    );
  }

  void confirmPickup() {
    Navigator.pop(
      context,
      const DeliverySelectionResult(mode: DeliveryMode.pickup),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addresses = AddressService.instance.addresses;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.primaryDark),
                  ),
                  const Text(
                    'اختر التوصيل أو الاستلام',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'توفّر المنتجات يعتمد على مكانك',
                style: TextStyle(color: AppColors.textGray, fontSize: 11.5),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final address in addresses)
                      _AddressTile(
                        address: address,
                        selected: address.id == selectedAddressId,
                        onTap: () {
                          setState(() {
                            selectedAddressId = address.id;
                          });
                        },
                        onDelete: () {
                          setState(() {
                            AddressService.instance.removeAddress(address.id);
                            if (selectedAddressId == address.id) {
                              selectedAddressId = null;
                            }
                          });
                        },
                      ),
                    const SizedBox(height: 8),
                    _ActionTile(
                      icon: Icons.add,
                      label: 'أضف عنوانا جديدا',
                      onTap: addNewAddress,
                    ),
                    const SizedBox(height: 10),
                    _ActionTile(
                      icon: Icons.storefront_outlined,
                      label: 'استلم من الصيدلية',
                      onTap: confirmPickup,
                    ),
                    const SizedBox(height: 16),
                    if (addresses.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        height: 47,
                        child: ElevatedButton(
                          onPressed:
                              selectedAddressId == null ? null : confirmDelivery,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppColors.primary.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'تأكيد عنوان التوصيل',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddressTile extends StatelessWidget {
  final DeliveryAddress address;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AddressTile({
    required this.address,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline,
                  size: 19, color: AppColors.textGray),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    address.label,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${address.addressLine}, ${address.city}',
                    style: const TextStyle(
                        color: AppColors.textGray, fontSize: 11),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.location_on_outlined,
              color: selected ? AppColors.primary : AppColors.textGray,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}