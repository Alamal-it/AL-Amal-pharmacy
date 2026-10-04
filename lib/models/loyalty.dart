import 'package:flutter/material.dart';

// ============================================================
//  موديلات برنامج نقاط الولاء
//  كل مفاتيح الـ JSON مجمّعة هنا في fromJson، فلو مطوّر الـ API
//  غيّر أسماء الحقول تعدلينها في مكان واحد بس.
// ============================================================

/// يحوّل مفتاح الأيقونة القادم من الـ API إلى أيقونة.
IconData loyaltyIconFor(String? key) {
  switch (key) {
    case 'shopping':
      return Icons.shopping_bag_outlined;
    case 'invite':
      return Icons.person_add_alt_1_outlined;
    case 'birthday':
      return Icons.cake_outlined;
    case 'discount':
      return Icons.local_offer_outlined;
    case 'gift':
      return Icons.redeem_outlined;
    case 'review':
      return Icons.rate_review_outlined;
    default:
      return Icons.stars_rounded;
  }
}

Color _colorFromHex(String? hex, {Color fallback = const Color(0xFF9EA7B3)}) {
  if (hex == null) return fallback;
  var h = hex.replaceAll('#', '').trim();
  if (h.length == 6) h = 'FF$h';
  final value = int.tryParse(h, radix: 16);
  return value == null ? fallback : Color(value);
}

// ------------------------------------------------------------
//  المستوى (برونزي / فضي / ذهبي ...)
// ------------------------------------------------------------

class LoyaltyTier {
  final String name;
  final int minPoints;
  final Color color;

  const LoyaltyTier({
    required this.name,
    required this.minPoints,
    required this.color,
  });

  factory LoyaltyTier.fromJson(Map<String, dynamic> j) => LoyaltyTier(
        name: (j['name'] ?? '').toString(),
        minPoints: (j['min_points'] as num?)?.toInt() ?? 0,
        color: _colorFromHex(j['color']?.toString()),
      );
}

// ------------------------------------------------------------
//  المكافأة
// ------------------------------------------------------------

class LoyaltyReward {
  final String id;
  final String title;
  final String subtitle;
  final int cost;
  final String? iconKey;

  const LoyaltyReward({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cost,
    this.iconKey,
  });

  IconData get icon => loyaltyIconFor(iconKey);

  factory LoyaltyReward.fromJson(Map<String, dynamic> j) => LoyaltyReward(
        id: (j['id'] ?? '').toString(),
        title: (j['title'] ?? '').toString(),
        subtitle: (j['subtitle'] ?? '').toString(),
        cost: (j['cost'] as num?)?.toInt() ?? 0,
        iconKey: j['icon']?.toString(),
      );
}

// ------------------------------------------------------------
//  طريقة كسب النقاط
// ------------------------------------------------------------

class LoyaltyEarnRule {
  final String title;
  final String subtitle;
  final String? iconKey;

  const LoyaltyEarnRule({
    required this.title,
    required this.subtitle,
    this.iconKey,
  });

  IconData get icon => loyaltyIconFor(iconKey);

  factory LoyaltyEarnRule.fromJson(Map<String, dynamic> j) => LoyaltyEarnRule(
        title: (j['title'] ?? '').toString(),
        subtitle: (j['subtitle'] ?? '').toString(),
        iconKey: j['icon']?.toString(),
      );
}

// ------------------------------------------------------------
//  عملية في سجل النقاط
// ------------------------------------------------------------

enum LoyaltyTxType { earn, bonus, redeem, expire }

class LoyaltyTransaction {
  final String id;
  final String title;

  /// موجب = إضافة، سالب = خصم.
  final int points;
  final DateTime date;
  final LoyaltyTxType type;

  const LoyaltyTransaction({
    required this.id,
    required this.title,
    required this.points,
    required this.date,
    required this.type,
  });

  factory LoyaltyTransaction.fromJson(Map<String, dynamic> j) {
    LoyaltyTxType parse(String? t) {
      switch (t) {
        case 'bonus':
          return LoyaltyTxType.bonus;
        case 'redeem':
          return LoyaltyTxType.redeem;
        case 'expire':
          return LoyaltyTxType.expire;
        default:
          return LoyaltyTxType.earn;
      }
    }

    return LoyaltyTransaction(
      id: (j['id'] ?? '').toString(),
      title: (j['title'] ?? '').toString(),
      points: (j['points'] as num?)?.toInt() ?? 0,
      date: DateTime.tryParse(j['date']?.toString() ?? '')?.toLocal() ??
          DateTime.now(),
      type: parse(j['type']?.toString()),
    );
  }
}

// ------------------------------------------------------------
//  بيانات الولاء كاملة للمستخدمة
// ------------------------------------------------------------

class LoyaltyData {
  /// الرصيد الحالي القابل للاستبدال.
  final int points;

  /// إجمالي النقاط المكتسبة طول الوقت (يحدد المستوى).
  final int lifetimePoints;

  /// قيمة النقطة الواحدة بالريال.
  final double riyalPerPoint;

  /// مدة صلاحية النقاط بالأشهر.
  final int expiryMonths;

  /// نقاط قريبة الانتهاء وتاريخ انتهائها (اختياري).
  final int expiringPoints;
  final DateTime? expiringOn;

  final List<LoyaltyTier> tiers;
  final List<LoyaltyReward> rewards;
  final List<LoyaltyEarnRule> earnRules;
  final List<LoyaltyTransaction> transactions;

  const LoyaltyData({
    required this.points,
    required this.lifetimePoints,
    required this.riyalPerPoint,
    required this.expiryMonths,
    this.expiringPoints = 0,
    this.expiringOn,
    this.tiers = const [],
    this.rewards = const [],
    this.earnRules = const [],
    this.transactions = const [],
  });

  factory LoyaltyData.fromJson(Map<String, dynamic> j) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) parse) {
      final raw = (j[key] as List?) ?? const [];
      return raw
          .map((e) => parse(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return LoyaltyData(
      points: (j['points'] as num?)?.toInt() ?? 0,
      lifetimePoints: (j['lifetime_points'] as num?)?.toInt() ??
          (j['points'] as num?)?.toInt() ??
          0,
      riyalPerPoint: (j['riyal_per_point'] as num?)?.toDouble() ?? 0.1,
      expiryMonths: (j['expiry_months'] as num?)?.toInt() ?? 12,
      expiringPoints: (j['expiring_points'] as num?)?.toInt() ?? 0,
      expiringOn: DateTime.tryParse(j['expiring_on']?.toString() ?? '')
          ?.toLocal(),
      tiers: list('tiers', LoyaltyTier.fromJson),
      rewards: list('rewards', LoyaltyReward.fromJson),
      earnRules: list('earn_rules', LoyaltyEarnRule.fromJson),
      transactions: list('transactions', LoyaltyTransaction.fromJson),
    );
  }

  // ---------------- قيم محسوبة ----------------

  double get riyalValue => points * riyalPerPoint;

  List<LoyaltyTier> get _sortedTiers =>
      [...tiers]..sort((a, b) => a.minPoints.compareTo(b.minPoints));

  List<LoyaltyReward> get sortedRewards =>
      [...rewards]..sort((a, b) => a.cost.compareTo(b.cost));

  LoyaltyTier? get currentTier {
    final sorted = _sortedTiers;
    if (sorted.isEmpty) return null;
    var current = sorted.first;
    for (final t in sorted) {
      if (lifetimePoints >= t.minPoints) current = t;
    }
    return current;
  }

  LoyaltyTier? get nextTier {
    for (final t in _sortedTiers) {
      if (t.minPoints > lifetimePoints) return t;
    }
    return null;
  }

  /// نسبة التقدم نحو المستوى القادم (1.0 لو في أعلى مستوى).
  double get tierProgress {
    final cur = currentTier;
    final next = nextTier;
    if (cur == null || next == null) return 1;
    final span = next.minPoints - cur.minPoints;
    if (span <= 0) return 1;
    return ((lifetimePoints - cur.minPoints) / span).clamp(0.0, 1.0);
  }

  /// أقرب مكافأة ما وصلت لها الحين (null لو وصلت لكل المكافآت).
  LoyaltyReward? get nextReward {
    for (final r in sortedRewards) {
      if (points < r.cost) return r;
    }
    return null;
  }
}