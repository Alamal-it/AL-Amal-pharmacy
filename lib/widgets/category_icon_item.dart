import 'package:flutter/material.dart';

class CategoryIconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CategoryIconItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xffF7F9FC),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xffDDE5EF)),
            ),
            child: Icon(icon, color: const Color(0xff0E4595), size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff123B72),
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}