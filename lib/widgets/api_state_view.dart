import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/api_exception.dart';

class ApiStateView<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(T data) onData;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;
  final String emptyMessage;

  const ApiStateView({
    super.key,
    required this.snapshot,
    required this.onData,
    this.onRetry,
    this.isEmpty,
    this.emptyMessage = 'لا توجد بيانات حالياً',
  });

  @override
  Widget build(BuildContext context) {
    // ===== حالة التحميل =====
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // ===== حالة الخطأ =====
    if (snapshot.hasError) {
      final error = snapshot.error;
      final message =
          error is ApiException ? error.message : 'حدث خطأ غير متوقع';

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                error is NoInternetException
                    ? Icons.wifi_off_rounded
                    : Icons.error_outline,
                size: 48,
                color: AppColors.textGray,
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontSize: 13,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('إعادة المحاولة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // ===== حالة البيانات الفاضية =====
    final data = snapshot.data;
    if (data == null || (isEmpty != null && isEmpty!(data))) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox_outlined,
                  size: 48, color: AppColors.textGray),
              const SizedBox(height: 14),
              Text(
                emptyMessage,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ===== حالة النجاح =====
    return onData(data);
  }
}