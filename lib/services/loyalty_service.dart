import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' show Color;
import 'package:http/http.dart' as http;

import '../models/loyalty.dart';

// ============================================================
//  خدمة نقاط الولاء
// ------------------------------------------------------------
//  الحين تشتغل بوضع تجريبي (_useMock = true) عشان تشوفين الشاشة
//  شغالة بالكامل. لما يجهز الـ API:
//    1) حطي _baseUrl الصحيح
//    2) أضيفي التوكن في _headers()
//    3) خلي _useMock = false
// ============================================================

class LoyaltyException implements Exception {
  final String message;
  const LoyaltyException(this.message);

  @override
  String toString() => message;
}

class LoyaltyService {
  // TODO: غيّريها لرابط الـ API الحقيقي.
  static const String _baseUrl = 'https://YOUR-API-DOMAIN/api';

  // TODO: خليها false لما يجهز الـ API.
  static const bool _useMock = true;

  static const Duration _timeout = Duration(seconds: 15);

  Future<Map<String, String>> _headers() async {
    // TODO: أضيفي التوكن هنا مثل: 'Authorization': 'Bearer $token'
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // ------------------------------------------------------------
  //  جلب بيانات الولاء
  //  GET {baseUrl}/loyalty
  // ------------------------------------------------------------

  Future<LoyaltyData> getLoyalty() async {
    if (_useMock) return _MockLoyaltyStore.instance.snapshot();

    try {
      final res = await http
          .get(Uri.parse('$_baseUrl/loyalty'), headers: await _headers())
          .timeout(_timeout);

      if (res.statusCode != 200) {
        throw const LoyaltyException('تعذر تحميل نقاط الولاء، حاولي مرة ثانية');
      }

      final body = jsonDecode(utf8.decode(res.bodyBytes));
      final map = body is Map<String, dynamic> ? body : <String, dynamic>{};
      final data = map['data'] is Map
          ? Map<String, dynamic>.from(map['data'] as Map)
          : map;

      return LoyaltyData.fromJson(data);
    } on LoyaltyException {
      rethrow;
    } on TimeoutException {
      throw const LoyaltyException('انتهت مهلة الاتصال، تأكدي من الإنترنت');
    } catch (_) {
      throw const LoyaltyException('تعذر الاتصال بالسيرفر، تأكدي من الإنترنت');
    }
  }

  // ------------------------------------------------------------
  //  استبدال مكافأة (يرجع كود الخصم إن وجد)
  //  POST {baseUrl}/loyalty/redeem   body: { "reward_id": "..." }
  // ------------------------------------------------------------

  Future<String?> redeem(String rewardId) async {
    if (_useMock) return _MockLoyaltyStore.instance.redeem(rewardId);

    try {
      final res = await http
          .post(
            Uri.parse('$_baseUrl/loyalty/redeem'),
            headers: await _headers(),
            body: jsonEncode({'reward_id': rewardId}),
          )
          .timeout(_timeout);

      final body = jsonDecode(utf8.decode(res.bodyBytes));
      final map = body is Map<String, dynamic> ? body : <String, dynamic>{};

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw LoyaltyException(
          (map['message'] ?? 'تعذر إتمام الاستبدال').toString(),
        );
      }

      return (map['code'] ?? (map['data'] is Map ? map['data']['code'] : null))
          ?.toString();
    } on LoyaltyException {
      rethrow;
    } on TimeoutException {
      throw const LoyaltyException('انتهت مهلة الاتصال، تأكدي من الإنترنت');
    } catch (_) {
      throw const LoyaltyException('تعذر إتمام الاستبدال، حاولي مرة ثانية');
    }
  }
}

// ============================================================
//  بيانات تجريبية (تُحذف لما يجهز الـ API)
// ============================================================

class _MockLoyaltyStore {
  _MockLoyaltyStore._();
  static final _MockLoyaltyStore instance = _MockLoyaltyStore._();

  int _points = 340;
  int _lifetime = 340;

  final List<LoyaltyTransaction> _transactions = [
    LoyaltyTransaction(
      id: 't1',
      title: 'طلب رقم 10482',
      points: 85,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: LoyaltyTxType.earn,
    ),
    LoyaltyTransaction(
      id: 't2',
      title: 'دعوة صديقة',
      points: 50,
      date: DateTime.now().subtract(const Duration(days: 9)),
      type: LoyaltyTxType.bonus,
    ),
    LoyaltyTransaction(
      id: 't3',
      title: 'طلب رقم 10377',
      points: 120,
      date: DateTime.now().subtract(const Duration(days: 21)),
      type: LoyaltyTxType.earn,
    ),
    LoyaltyTransaction(
      id: 't4',
      title: 'طلب رقم 10211',
      points: 85,
      date: DateTime.now().subtract(const Duration(days: 40)),
      type: LoyaltyTxType.earn,
    ),
  ];

  static const List<LoyaltyReward> _rewards = [
    LoyaltyReward(
      id: 'r1',
      title: 'خصم 10 ريال',
      subtitle: 'على طلبك القادم',
      cost: 100,
      iconKey: 'discount',
    ),
    LoyaltyReward(
      id: 'r2',
      title: 'خصم 25 ريال',
      subtitle: 'على طلبك القادم',
      cost: 250,
      iconKey: 'gift',
    ),
    LoyaltyReward(
      id: 'r3',
      title: 'خصم 50 ريال',
      subtitle: 'على طلبك القادم',
      cost: 500,
      iconKey: 'gift',
    ),
  ];

  static const List<LoyaltyTier> _tiers = [
    LoyaltyTier(name: 'برونزي', minPoints: 0, color: Color(0xFFCD7F32)),
    LoyaltyTier(name: 'فضي', minPoints: 500, color: Color(0xFF9EA7B3)),
    LoyaltyTier(name: 'ذهبي', minPoints: 1500, color: Color(0xFFE0A81C)),
  ];

  static const List<LoyaltyEarnRule> _earnRules = [
    LoyaltyEarnRule(
      title: 'تسوقي واكسبي',
      subtitle: 'نقطة عن كل 10 ريال من مشترياتك',
      iconKey: 'shopping',
    ),
    LoyaltyEarnRule(
      title: 'ادعي صديقة',
      subtitle: 'نقاط إضافية عند أول طلب لها',
      iconKey: 'invite',
    ),
    LoyaltyEarnRule(
      title: 'شهر ميلادك',
      subtitle: 'نقاط مضاعفة طول الشهر',
      iconKey: 'birthday',
    ),
  ];

  Future<LoyaltyData> snapshot() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return LoyaltyData(
      points: _points,
      lifetimePoints: _lifetime,
      riyalPerPoint: 0.1,
      expiryMonths: 12,
      expiringPoints: 40,
      expiringOn: DateTime.now().add(const Duration(days: 26)),
      tiers: _tiers,
      rewards: _rewards,
      earnRules: _earnRules,
      transactions: List.of(_transactions),
    );
  }

  Future<String?> redeem(String rewardId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final reward = _rewards.firstWhere(
      (r) => r.id == rewardId,
      orElse: () => throw const LoyaltyException('المكافأة غير موجودة'),
    );

    if (_points < reward.cost) {
      throw const LoyaltyException('رصيدك غير كافٍ لهذي المكافأة');
    }

    _points -= reward.cost;
    _transactions.insert(
      0,
      LoyaltyTransaction(
        id: 'r${DateTime.now().millisecondsSinceEpoch}',
        title: 'استبدال: ${reward.title}',
        points: -reward.cost,
        date: DateTime.now(),
        type: LoyaltyTxType.redeem,
      ),
    );

    final stamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    return 'AMAL-${stamp.toUpperCase().substring(stamp.length - 6)}';
  }
}