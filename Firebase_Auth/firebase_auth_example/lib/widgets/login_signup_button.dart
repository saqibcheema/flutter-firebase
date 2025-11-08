import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? color;

  const FormButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric( horizontal: 70),
      ),
      child: Text(title,style: TextStyle(color: Colors.white,fontSize: 20),),
    );
  }
}
