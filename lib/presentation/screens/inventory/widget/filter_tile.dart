import 'package:flutter/material.dart';
import 'package:stockmate/core/constants/colors.dart';
import 'package:stockmate/presentation/widgets/custom_apptext.dart';

class FilterTile extends StatelessWidget {
  final bool isSelected;
  final String label;

  const FilterTile({
    super.key,
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2),
        ],
        borderRadius: BorderRadius.circular(5),
        color: isSelected ? primaryColor : const Color(0xFFF4F4F4),
        border: Border.all(
          color: isSelected ? primaryColor : Colors.white,
        ),
      ),
      child: Center(
        child: AppText(
          label,
          size: 14,
          weight: FontWeight.w700,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
