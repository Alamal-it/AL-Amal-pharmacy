class DeliveryAddress {
  final String id;
  final String label; // المنزل / العمل / آخر
  final String addressLine;
  final String city;
  final double latitude;
  final double longitude;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  DeliveryAddress copyWith({
    String? id,
    String? label,
    String? addressLine,
    String? city,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}