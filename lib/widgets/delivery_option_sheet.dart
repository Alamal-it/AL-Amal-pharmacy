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
  DeliveryMode selectedMode = DeliveryMode.delivery;
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

  void confirm() {
    if (selectedMode == DeliveryMode.pickup) {
      Navigator.pop(
        context,
        const DeliverySelectionResult(mode: DeliveryMode.pickup),
      );
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final addresses = AddressService.instance.addresses;
    final canConfirm = selectedMode == DeliveryMode.pickup ||
        (selectedMode == DeliveryMode.delivery && addresses.isNotEmpty);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.95,
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
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // ===== بطاقة توصيل للمنزل =====
                    _OptionCard(
                      icon: Icons.local_shipping_outlined,
                      title: 'توصيل للمنزل',
                      subtitle: 'يصلك طلبك خلال 30-60 دقيقة',
                      selected: selectedMode == DeliveryMode.delivery,
                      onTap: () =>
                          setState(() => selectedMode = DeliveryMode.delivery),
                    ),
                    const SizedBox(height: 10),

                    // ===== بطاقة استلام من الفرع =====
                    _OptionCard(
                      icon: Icons.storefront_outlined,
                      title: 'استلام من الفرع',
                      subtitle: 'استلمي طلبك من أقرب فرع، بدون رسوم',
                      selected: selectedMode == DeliveryMode.pickup,
                      onTap: () =>
                          setState(() => selectedMode = DeliveryMode.pickup),
                    ),

                    // ===== عناوين محفوظة (تظهر فقط عند اختيار توصيل) =====
                    if (selectedMode == DeliveryMode.delivery) ...[
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'عنوان التوصيل',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      _ActionTile(
                        icon: Icons.add,
                        label: 'أضف عنوانا جديدا',
                        onTap: addNewAddress,
                      ),
                    ],

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 47,
                      child: ElevatedButton(
                        onPressed: canConfirm ? confirm : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.green.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'متابعة',
                          style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.green.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.green : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryDark, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.green : AppColors.border,
            ),
          ],
        ),
      ),
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
              Icons.location_on_outlined,color: selected ? AppColors.primary : AppColors.textGray,
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