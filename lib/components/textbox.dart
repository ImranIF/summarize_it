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
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.shade100,
              blurRadius: 100,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            )
          ],
          shape: BoxShape.rectangle,
        ),
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            //section name
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(text == '' ? "N/a" : text,
                      style: TextStyle(color: Colors.grey.shade600)),

                  //edit button
                  IconButton(onPressed: onPressed, icon: Icon(Icons.settings))
                ],
              ),
              //text
              // Text(text),
            ]));
  }
}

class customTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  customTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.shade100,
              blurRadius: 100,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            )
          ],
          shape: BoxShape.rectangle,
        ),
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            //section name
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
