import 'package:flutter/material.dart';

class MyButton2 extends StatelessWidget {
  final Function()? onTap;

  const MyButton2({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFB747EB),
          borderRadius: BorderRadius.circular(13),

        ),
        child: const Center(
          child: Text(
            "Registrarme",
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
