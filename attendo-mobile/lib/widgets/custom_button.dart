import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        textColor: Colors.blue.shade700,
        textTheme: ButtonTextTheme.primary,
        minWidth: 100,
        padding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Colors.blue.shade700),
        ),
      ),
    );
  }
}
