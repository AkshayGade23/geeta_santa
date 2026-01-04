import 'package:flutter/material.dart';
import 'package:geeta_santha/core/constants/colors.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';

class NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isNext;

  const NavButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isNext = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: scaleWidth(context, 18), vertical: scaleHeight(context, 10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: primaryBlue),
        ),
        child: Row(
          children: isNext
              ? [
                  Text(label,
                      style: const TextStyle(color: Colors.white)),
                   SizedBox(width: scaleWidth(context, 4)),
                  Icon(icon, color: Colors.white),
                ]
              : [
                  Icon(icon, color: Colors.white),
                SizedBox(width: scaleWidth(context, 4)),
                  Text(label,
                      style: const TextStyle(color: Colors.white)),
                ],
        ),
      ),
    );
  }
}
