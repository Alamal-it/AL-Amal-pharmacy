import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../models/loyalty.dart';
import '../services/loyalty_service.dart';

// ============================================================
//  شاشة نقاط الولاء (ديناميكية: كل البيانات تجي من LoyaltyService)
// ============================================================

class _Brand {
  static const Color orange = Color(0xFFF47B20);
  static const Color orangeLight = Color(0xFFFFA24D);
  static const Color orangeDark = Color(0xFFE0580C);
  static const Color tint = Color(0xFFFFF1E4);
  static const Color danger = Color(0xFFE5484D);
  static const Color background = Color(0xFFF6F8FA);
}

const List<String> _arabicMonths = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

String _formatDate(DateTime d) => '${d.day} ${_arabicMonths[d.month - 1]} ${d.year}';

String _formatNumber(num n) {
  final text = n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);
  return text.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
}

class LoyaltyPointsScreen extends StatefulWidget {
  const LoyaltyPointsScreen({super.key});

  @override
  State<LoyaltyPointsScreen> createState() => _LoyaltyPointsScreenState();
}

class _LoyaltyPointsScreenState extends State<LoyaltyPointsScreen> {
  final LoyaltyService _service = LoyaltyService();

  LoyaltyData? _data;
  Object? _error;
  bool _loading = true;
  bool _showAllHistory = false;

  static const int _historyPreview = 5;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ============================================================
  //  تحميل البيانات
  // ============================================================

  Future<void> _load({bool showLoader = false}) async {
    if (showLoader) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final data = await _service.getLoyalty();
      if (!mounted) return;
      setState(() {
        _data = data;
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      if (_data != null) {
        // عندنا بيانات قديمة: نبقيها ونعرض تنبيه بس
        setState(() => _loading = false);
        _snack('تعذر تحديث البيانات، حاولي مرة ثانية');
      } else {
        setState(() {
          _error = e;
          _loading = false;
        });
      }
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(message, style: const TextStyle(fontSize: 12.5)),
        ),
      );
  }

  // ============================================================
  //  استبدال مكافأة
  // ============================================================

  Future<void> _openRedeem(LoyaltyReward reward) async {
    final data = _data;
    if (data == null) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: _RedeemSheet(
          reward: reward,
          balance: data.points,
          service: _service,
          onRedeemed: () => _load(),
        ),
      ),
    );
  }

  // ============================================================
  //  BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _Brand.background,
        appBar: AppBar(
          backgroundColor: _Brand.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primaryDark),
          title: const Text(
            'نقاط الولاء',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _data == null) {
      return const _LoadingSkeleton();
    }

    final data = _data;
    if (data == null) {
      return _ErrorView(
        message: _error is LoyaltyException
            ? (_error as LoyaltyException).message
            : 'صار خطأ غير متوقع، حاولي مرة ثانية',
        onRetry: () => _load(showLoader: true),
      );
    }

    final history = _showAllHistory
        ? data.transactions
        : data.transactions.take(_historyPreview).toList();

    return RefreshIndicator(
      color: _Brand.orange,
      onRefresh: () => _load(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _BalanceCard(data: data),
          const SizedBox(height: 16),
          _NextRewardCard(data: data),

          // ---------- المكافآت ----------
          if (data.rewards.isNotEmpty) ...[
            const SizedBox(height: 28),
            const _SectionTitle('المكافآت المتاحة'),
            const SizedBox(height: 12),
            SizedBox(
              height: 182,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: data.sortedRewards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final reward = data.sortedRewards[i];
                  return _RewardCard(
                    reward: reward,
                    balance: data.points,
                    onRedeem: () => _openRedeem(reward),
                  );
                },
              ),
            ),
          ],

          // ---------- كيف تكسبين النقاط ----------
          if (data.earnRules.isNotEmpty) ...[
            const SizedBox(height: 28),
            const _SectionTitle('كيف تكسبين النقاط؟'),
            const SizedBox(height: 12),
            _Card(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  for (int i = 0; i < data.earnRules.length; i++) ...[
                    _EarnRow(rule: data.earnRules[i]),
                    if (i != data.earnRules.length - 1)
                      Divider(
                        height: 1,
                        indent: 66,
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
                  ],
                ],
              ),
            ),
          ],

          // ---------- سجل النقاط ----------
          const SizedBox(height: 28),
          const _SectionTitle('سجل النقاط'),
          const SizedBox(height: 12),
          if (data.transactions.isEmpty)
            const _EmptyHistory()
          else
            _Card(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  for (int i = 0; i < history.length; i++) ...[
                    _TransactionRow(tx: history[i]),
                    if (i != history.length - 1)
                      Divider(
                        height: 1,
                        indent: 66,
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
                  ],
                  if (data.transactions.length > _historyPreview) ...[
                    Divider(
                      height: 1,
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                    TextButton(
                      onPressed: () => setState(
                        () => _showAllHistory = !_showAllHistory,
                      ),
                      child: Text(
                        _showAllHistory ? 'عرض أقل' : 'عرض كل العمليات',
                        style: const TextStyle(
                          color: _Brand.orange,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 20),
          Center(
            child: Text(
              'النقاط صالحة لمدة ${data.expiryMonths} شهر من تاريخ اكتسابها',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  بطاقة الرصيد (برتقالية)
// ============================================================

class _BalanceCard extends StatelessWidget {
  final LoyaltyData data;
  const _BalanceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final tier = data.currentTier;
    final next = data.nextTier;
    final hasExpiring = data.expiringPoints > 0 && data.expiringOn != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_Brand.orangeLight, _Brand.orangeDark],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _Brand.orange.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // علامة مائية خفيفة
            PositionedDirectional(
              bottom: -26,
              end: -14,
              child: Icon(
                Icons.stars_rounded,
                size: 170,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'رصيدك الحالي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (tier != null) _TierBadge(tier: tier),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: data.points),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (_, value, __) => Text(
                          _formatNumber(value),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            height: 1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'نقطة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _GlassChip(
                    icon: Icons.account_balance_wallet_outlined,
                    text: 'تعادل ${_formatNumber(data.riyalValue)} ريال خصم',
                  ),

                  if (hasExpiring) ...[
                    const SizedBox(height: 8),
                    _GlassChip(
                      icon: Icons.schedule_rounded,
                      text:
                          '${_formatNumber(data.expiringPoints)} نقطة تنتهي ${_formatDate(data.expiringOn!)}',
                    ),
                  ],

                  // ---------- تقدم المستوى ----------
                  if (tier != null) ...[
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: data.tierProgress),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (_, value, __) => LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.28),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      next == null
                          ? 'وصلتي لأعلى مستوى في البرنامج'
                          : 'باقي ${_formatNumber(next.minPoints - data.lifetimePoints)} نقطة للوصول للمستوى ${next.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _GlassChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  final LoyaltyTier tier;
  const _TierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded, color: tier.color, size: 17),
          const SizedBox(width: 4),
          Text(
            tier.name,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  بطاقة التقدم نحو المكافأة القادمة
// ============================================================

class _NextRewardCard extends StatelessWidget {
  final LoyaltyData data;
  const _NextRewardCard({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.rewards.isEmpty) return const SizedBox.shrink();

    final reward = data.nextReward;

    // وصلت لكل المكافآت
    if (reward == null) {
      return const _Card(
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: _Brand.orange),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'ما شاء الله! رصيدك يكفي لكل المكافآت المتاحة',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final remaining = reward.cost - data.points;
    final progress = reward.cost == 0
        ? 1.0
        : (data.points / reward.cost).clamp(0.0, 1.0);

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'باقي ${_formatNumber(remaining)} نقطة للحصول على ${reward.title}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _Brand.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, value, __) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 9,
                backgroundColor: _Brand.tint,
                color: _Brand.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  بطاقة المكافأة
// ============================================================

class _RewardCard extends StatelessWidget {
  final LoyaltyReward reward;
  final int balance;
  final VoidCallback onRedeem;

  const _RewardCard({
    required this.reward,
    required this.balance,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final canRedeem = balance >= reward.cost;
    final missing = reward.cost - balance;

    return Container(
      width: 164,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: canRedeem
              ? _Brand.orange.withValues(alpha: 0.55)
              : AppColors.border.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: canRedeem ? _Brand.tint : const Color(0xFFF1F3F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  reward.icon,
                  color: canRedeem ? _Brand.orange : AppColors.textGray,
                  size: 20,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: canRedeem ? _Brand.tint : const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_formatNumber(reward.cost)} نقطة',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: canRedeem ? _Brand.orangeDark : AppColors.textGray,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            reward.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            reward.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textGray),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: canRedeem
                ? ElevatedButton(
                    onPressed: onRedeem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _Brand.orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'استبدال',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'تحتاجين ${_formatNumber(missing)} نقطة',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textGray,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  شاشة تأكيد الاستبدال (Bottom Sheet)
// ============================================================

enum _RedeemStep { confirm, loading, success, error }

class _RedeemSheet extends StatefulWidget {
  final LoyaltyReward reward;
  final int balance;
  final LoyaltyService service;
  final VoidCallback onRedeemed;

  const _RedeemSheet({
    required this.reward,
    required this.balance,
    required this.service,
    required this.onRedeemed,
  });

  @override
  State<_RedeemSheet> createState() => _RedeemSheetState();
}

class _RedeemSheetState extends State<_RedeemSheet> {
  _RedeemStep _step = _RedeemStep.confirm;
  String? _code;
  String _errorMessage = '';

  Future<void> _redeem() async {
    setState(() => _step = _RedeemStep.loading);

    try {
      final code = await widget.service.redeem(widget.reward.id);
      if (!mounted) return;
      widget.onRedeemed();
      setState(() {
        _code = code;
        _step = _RedeemStep.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e is LoyaltyException
            ? e.message
            : 'تعذر إتمام الاستبدال، حاولي مرة ثانية';
        _step = _RedeemStep.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey(_step),
              child: _content(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_step) {
      case _RedeemStep.confirm:
        return _confirmView();
      case _RedeemStep.loading:
        return _loadingView();
      case _RedeemStep.success:
        return _successView();
      case _RedeemStep.error:
        return _errorView();
    }
  }

  // ---------- تأكيد ----------
  Widget _confirmView() {
    final after = widget.balance - widget.reward.cost;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _bigIcon(widget.reward.icon, _Brand.orange, _Brand.tint),
        const SizedBox(height: 14),
        const Text(
          'تأكيد الاستبدال',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.reward.title,
          style: const TextStyle(fontSize: 13, color: AppColors.textGray),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _SummaryRow(
                label: 'رصيدك الحالي',
                value: '${_formatNumber(widget.balance)} نقطة',
              ),
              const SizedBox(height: 10),
              _SummaryRow(
                label: 'تكلفة المكافأة',
                value: '- ${_formatNumber(widget.reward.cost)} نقطة',
                valueColor: _Brand.danger,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  color: AppColors.border.withValues(alpha: 0.7),
                ),
              ),
              _SummaryRow(
                label: 'رصيدك بعد الاستبدال',
                value: '${_formatNumber(after)} نقطة',
                bold: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _primaryButton('تأكيد الاستبدال', _redeem),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'إلغاء',
            style: TextStyle(color: AppColors.textGray, fontSize: 13),
          ),
        ),
      ],
    );
  }

  // ---------- تحميل ----------
  Widget _loadingView() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              color: _Brand.orange,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'جاري الاستبدال...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- نجاح ----------
  Widget _successView() {
    final code = _code;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _bigIcon(
          Icons.check_circle_rounded,
          AppColors.green,
          AppColors.green.withValues(alpha: 0.12),
        ),
        const SizedBox(height: 14),
        const Text(
          'تم الاستبدال بنجاح',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.reward.title,
          style: const TextStyle(fontSize: 13, color: AppColors.textGray),
        ),
        if (code != null && code.isNotEmpty) ...[
          const SizedBox(height: 18),
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'كود الخصم',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textGray,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _Brand.tint,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _Brand.orange.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                        color: _Brand.orangeDark,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (!mounted) return;
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                          content: Text('تم نسخ الكود'),
                        ),
                      );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.copy_rounded,
                      color: _Brand.orange,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        _primaryButton('تم', () => Navigator.pop(context)),
      ],
    );
  }

  // ---------- خطأ ----------
  Widget _errorView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _bigIcon(
          Icons.error_outline_rounded,
          _Brand.danger,
          _Brand.danger.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 14),
        const Text(
          'ما قدرنا نكمل الاستبدال',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12.5, color: AppColors.textGray),
        ),
        const SizedBox(height: 20),
        _primaryButton('إعادة المحاولة', _redeem),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'إغلاق',
            style: TextStyle(color: AppColors.textGray, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _bigIcon(IconData icon, Color color, Color background) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 34),
    );
  }

  Widget _primaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _Brand.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: bold ? AppColors.primaryDark : AppColors.textGray,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: valueColor ?? AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

// ============================================================
//  صف طريقة كسب النقاط
// ============================================================

class _EarnRow extends StatelessWidget {
  final LoyaltyEarnRule rule;
  const _EarnRow({required this.rule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _Brand.tint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(rule.icon, color: _Brand.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rule.subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textGray,
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

// ============================================================
//  سجل النقاط
// ============================================================

class _TransactionRow extends StatelessWidget {
  final LoyaltyTransaction tx;
  const _TransactionRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final positive = tx.points > 0;

    final IconData icon;
    final Color color;
    switch (tx.type) {
      case LoyaltyTxType.earn:
        icon = Icons.add_shopping_cart_rounded;
        color = AppColors.green;
        break;
      case LoyaltyTxType.bonus:
        icon = Icons.card_giftcard_rounded;
        color = AppColors.green;
        break;
      case LoyaltyTxType.redeem:
        icon = Icons.redeem_rounded;
        color = _Brand.orange;
        break;
      case LoyaltyTxType.expire:
        icon = Icons.hourglass_bottom_rounded;
        color = AppColors.textGray;
        break;
    }

    // \u200E يثبّت علامة +/- في مكانها الصحيح داخل نص عربي
    final amount =
        '\u200E${positive ? '+' : '-'}${_formatNumber(tx.points.abs())}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(tx.date),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: positive ? AppColors.green : _Brand.danger,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: _Brand.tint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: _Brand.orange,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'ما عندك عمليات بعد',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'أول طلب لك بيبدأ يجمع لك النقاط',
              style: TextStyle(fontSize: 11.5, color: AppColors.textGray),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//  حالة التحميل (Skeleton) وحالة الخطأ
// ============================================================

class _LoadingSkeleton extends StatefulWidget {
  const _LoadingSkeleton();

  @override
  State<_LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<_LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bone(double height, {double? width, double radius = 18}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE4E8EC),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _bone(210, radius: 24),
          const SizedBox(height: 16),
          _bone(74),
          const SizedBox(height: 28),
          _bone(16, width: 130, radius: 8),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _bone(150)),
              const SizedBox(width: 12),
              Expanded(child: _bone(150)),
            ],
          ),
          const SizedBox(height: 28),
          _bone(16, width: 150, radius: 8),
          const SizedBox(height: 12),
          _bone(150),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: _Brand.tint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: _Brand.orange,
                size: 36,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'ما قدرنا نحمّل نقاطك',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textGray),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _Brand.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//  عناصر مشتركة
// ============================================================

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: _Brand.orange,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _Card({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}