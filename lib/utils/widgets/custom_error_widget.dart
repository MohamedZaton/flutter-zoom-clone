import 'package:flutter/material.dart';
import 'package:flutter_zoom_call/core/theme/app_colors.dart';
import 'package:flutter_zoom_call/core/theme/app_text_styles.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({Key? key, required this.errorMsg}) : super(key: key);
  final String errorMsg;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      child: Text(errorMsg,
          style: ZoomAppTextStyles.labelStyle.copyWith(color: Colors.white)),
    ));
  }
}
