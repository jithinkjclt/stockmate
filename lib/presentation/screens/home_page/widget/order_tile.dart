import 'package:flutter/material.dart';
import 'package:stockmate/core/utils/margin_text.dart';

import '../../../widgets/custom_apptext.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.icon,
    required this.count,
    required this.text,
    required this.backGroundColor,
    required this.boxShadow,
  });

  final IconData icon;
  final String text;
  final int count;
  final Color backGroundColor;
  final Color boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.deviceSize.height / 10,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backGroundColor,
        boxShadow: [
          BoxShadow(
            color: boxShadow.withOpacity(0.5),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // <- allow row to shrink
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: Icon(
              icon,
              color: boxShadow,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                count,
                size: 20,
                weight: FontWeight.w800,
                color: boxShadow,
              ),
              AppText(
                text,
                size: 13,
                weight: FontWeight.w400,
                color: Colors.black,
              ),
            ],
          )
        ],
      ),
    );
  }
}
