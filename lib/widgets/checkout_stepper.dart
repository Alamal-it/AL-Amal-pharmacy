import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CheckoutStepper extends StatelessWidget {
  final int currentStep; // 0 = العنوان، 1 = الدفع، 2 = التسليم

  const CheckoutStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _stepCircle(
          icon: Icons.local_shipping_outlined,
          stepIndex: 2,
        ),
        _stepLine(active: currentStep >= 1),
        _stepCircle(
          icon: Icons.credit_card,
          stepIndex: 1,
        ),
        _stepLine(active: currentStep >= 2),
        _stepCircle(
          icon: Icons.check,
          stepIndex: 0,
        ),
      ],
    );
  }

  Widget _stepCircle({required IconData icon, required int stepIndex}) {
    final bool done = currentStep > stepIndex;
    final bool active = currentStep == stepIndex;
    final bool highlighted = done || active;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryDark : AppColors.border,
        shape: BoxShape.circle,
      ),
      child: Icon(
        done ? Icons.check : icon,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _stepLine({required bool active}) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? AppColors.primaryDark : AppColors.border,
      ),
    );
  }
}