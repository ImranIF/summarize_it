import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final double hpadding;
  final double wpadding;
  final double borderRadius;
  final String text;
  final Color color;
  final Function()? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.hpadding,
    required this.wpadding,
    required this.borderRadius,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          onTap: onPressed,
          child: Ink(
            padding: EdgeInsets.only(
                left: wpadding,
                right: wpadding,
                top: hpadding,
                bottom: hpadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: color,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.russoOne()
                      .copyWith(fontSize: 20.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ));
  }
}

class CustomButtonWithIcon extends StatelessWidget {
  final Image icon;
  final double hpadding;
  final double wpadding;
  final double borderRadius;
  final String text;
  final Color color;
  Color textColor = Colors.white;
  double fontsize = 20.0;
  final Function()? onPressed;

  CustomButtonWithIcon(
    this.fontsize,
    this.textColor, {
    super.key,
    required this.text,
    required this.hpadding,
    required this.wpadding,
    required this.borderRadius,
    required this.onPressed,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          onTap: onPressed,
          child: Ink(
            padding: EdgeInsets.only(
                left: wpadding,
                right: wpadding,
                top: hpadding,
                bottom: hpadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: color,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: // if (icon != null) ...[
                    //   icon,
                    //   const SizedBox(width: 10),
                    //   Text(
                    //     text,
                    //     textAlign: TextAlign.center,
                    //     style: GoogleFonts.russoOne()
                    //         .copyWith(fontSize: 20.0, color: Colors.white),
                    //   ),
                    // ] else ...
                    [
                  icon,
                  const SizedBox(width: 10),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.russoOne()
                        .copyWith(fontSize: fontsize, color: textColor),
                  ),
                ]),
          ),
        ));
  }
}
