import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  bool? disabled;

  CustomButton(
      {super.key, required this.onPressed, required this.text, this.disabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (disabled == null || disabled == false) {
            onPressed();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled == null || disabled == false
              ? Palette.mainPurple
              : Palette.greySoft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}