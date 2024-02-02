import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  TextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 209, 226, 219),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            //section name
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sectionName,
                      style: TextStyle(color: Colors.grey.shade600)),

                  //edit button
                  IconButton(onPressed: onPressed, icon: Icon(Icons.settings))
                ],
              ),
              //text
              Text(text),
            ]));
  }
}
