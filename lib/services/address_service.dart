import '../models/delivery_address.dart';

// TODO: هذا تخزين مؤقت بالذاكرة فقط (يروح لما يقفل التطبيق).
// لاحقًا نربطه بـ API حقيقي أو بتخزين محلي دائم (shared_preferences / hive).
class AddressService {
  AddressService._internal();
  static final AddressService instance = AddressService._internal();

  final List<DeliveryAddress> _addresses = [];

  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);

  void addAddress(DeliveryAddress address) {
    if (address.isDefault) {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
    _addresses.add(address);
  }

  void removeAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
  }

  DeliveryAddress? get defaultAddress {
    if (_addresses.isEmpty) return null;
    return _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.first,
    );
  }
}