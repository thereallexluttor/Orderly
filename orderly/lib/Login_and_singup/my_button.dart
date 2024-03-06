import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;

  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFFB747EB),
          borderRadius: BorderRadius.circular(13),

        ),
        child: const Center(
          child: Text(
            "Ingresar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFamily: "Poppins-L"
            ),
          ),
        ),
      ),
    );
  }
}
