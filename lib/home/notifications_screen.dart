import 'package:flutter/material.dart';
import '../core/app_colors.dart';

enum NotificationType { order, offer, general }

class AppNotification {
  final NotificationType type;
  final String title;
  final String body;
  final String time;
  bool isRead;

  AppNotification({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // TODO: استبدال هذي القائمة بإشعارات حقيقية من الـ API لما يجهز.
  final List<AppNotification> notifications = [
    AppNotification(
      type: NotificationType.order,
      title: 'تم تأكيد طلبك',
      body: 'طلبك رقم #123456789 قيد التجهيز الآن',
      time: 'قبل 10 دقائق',
    ),
    AppNotification(
      type: NotificationType.offer,
      title: 'خصم 20% على الفيتامينات',
      body: 'استفيدي من العرض الآن قبل انتهائه',
      time: 'قبل ساعتين',
    ),
    AppNotification(
      type: NotificationType.order,
      title: 'تم توصيل طلبك',
      body: 'نتمنى أن تكوني راضية عن تجربتك معنا',
      time: 'أمس',
      isRead: true,
    ),
    AppNotification(
      type: NotificationType.general,
      title: 'مرحباً بك في صيدلية الأمل',
      body: 'استكشفي كل خدماتنا من التطبيق',
      time: 'قبل 3 أيام',
      isRead: true,
    ),
  ];IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.receipt_long_outlined;
      case NotificationType.offer:
        return Icons.local_offer_outlined;
      case NotificationType.general:
        return Icons.notifications_none;
    }
  }

  Color _colorFor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return AppColors.primary;
      case NotificationType.offer:
        return Colors.red;
      case NotificationType.general:
        return AppColors.green;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in notifications) {
        n.isRead = true;
      }
    });
  }@override Widget build(BuildContext context) { final hasUnread = notifications.any((n) => !n.isRead);
return Scaffold(
  backgroundColor: AppColors.white,
  appBar: AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.primaryDark),
    centerTitle: true,
    title: const Text(
      'الإشعارات',
      style: TextStyle(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    ),
    actions: [
      if (hasUnread)
        TextButton(
          onPressed: _markAllAsRead,
          child: const Text(
            'تحديد الكل كمقروء',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    ],
  ),
  body: notifications.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration:BoxDecoration(
                      color: AppColors.border.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none,
                        size: 40, color: AppColors.textGray),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد إشعارات حالياً',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'ستظهر هنا آخر التحديثات المتعلقة بطلباتك وعروضنا',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGray, fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final n = notifications[index];return Dismissible(
                  key: ValueKey(n.hashCode),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    setState(() => notifications.removeAt(index));
                  },
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 22),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() => n.isRead = true);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: n.isRead
                            ? AppColors.white
                            : AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: n.isRead
                              ? AppColors.border
                              : AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!n.isRead)
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            const SizedBox(width: 8),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  n.title,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: n.isRead
                                        ? FontWeight.w600
                                        : FontWeight.w700,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  n.body,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  n.time,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: _colorFor(n.type).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_iconFor(n.type),
                                color: _colorFor(n.type), size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}