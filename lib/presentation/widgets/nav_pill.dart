import 'package:flutter/material.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';

/// 🔘 Modern pill navigation
class NavPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isNext;

  const NavPill({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: scaleWidth(context, 20), vertical: scaleHeight(context, 12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFFF4F5FB),
        ),
        child: Row(
          children: [
            if (!isNext) Icon(icon, size: scaleWidth(context, 20)),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (isNext) Icon(icon, size: scaleWidth(context, 20)),
          ],
        ),
      ),
    );
  }
}
