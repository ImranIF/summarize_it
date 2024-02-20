import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final IconData prefixIcon;
  bool readonly = false;

  CustomTextField(this.readonly,
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.labelText,
      required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.black,
      ),
      readOnly: readonly,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 175, 140, 76).withOpacity(0.5),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
          backgroundColor: Color.fromARGB(255, 177, 226, 211),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
            icon: const Icon(Icons.clear), onPressed: () => controller.clear()),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color.fromARGB(255, 175, 140, 76)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color.fromARGB(255, 76, 172, 175)),
        ),
        fillColor: const Color.fromARGB(255, 177, 226, 211),
        filled: true,
      ),
    );
  }
}

class CustomTextFieldWithCheck extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final IconData prefixIcon;
  void Function(String)? onChanged;
  bool readonly = false;

  CustomTextFieldWithCheck(this.readonly,
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.hintText,
      required this.obscureText,
      required this.labelText,
      required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.black,
      ),
      readOnly: readonly,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 175, 140, 76).withOpacity(0.5),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
          backgroundColor: Color.fromARGB(255, 177, 226, 211),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
            icon: const Icon(Icons.clear), onPressed: () => controller.clear()),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color.fromARGB(255, 175, 140, 76)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color.fromARGB(255, 76, 172, 175)),
        ),
        fillColor: const Color.fromARGB(255, 177, 226, 211),
        filled: true,
      ),
    );
  }
}

class CustomTextFieldWithFunction extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final IconData prefixIcon;
  bool readonly = false;
  void Function()? onPressed;

  CustomTextFieldWithFunction(this.readonly, this.onPressed,
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.labelText,
      required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.black,
      ),
      readOnly: readonly,
      onTap: onPressed,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 175, 140, 76).withOpacity(0.5),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
          backgroundColor: Color.fromARGB(255, 177, 226, 211),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
            icon: const Icon(Icons.clear), onPressed: () => controller.clear()),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color.fromARGB(255, 175, 140, 76)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color.fromARGB(255, 76, 172, 175)),
        ),
        fillColor: const Color.fromARGB(255, 177, 226, 211),
        filled: true,
      ),
    );
  }
}
