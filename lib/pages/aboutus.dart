import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sass/sass.dart' as sass;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AboutUs extends StatelessWidget {
  final int rating = 5;
  final String sassCode = '''
      <html>
      <head>
        <style>
        ${compileSassToCss('''
            \$link-color: #76453B;
            \$primary-color: #A2ECA9;
            \$secondary-color: #5CAFAA;
            \$text-size: 16;
            \$sz:40px;
            \$font-family: 'Cormorant Garamond', serif;
            \$text-color: #38775d;
            @mixin linear-gradient-bg{
              background: linear-gradient(to bottom, \$primary-color, \$secondary-color);
            }

            body {
              @include linear-gradient-bg;
              font-family: \$font-family;
              margin: 0;
              padding: 0;
              display: flex;
              justify-content: center;
              align-items: center;
              flex-direction: column;
              height: 100vh;
              }

            .heading{
              font-size: \$text-size * 3.5;
              color: \$text-color;
              font-weight: bold;
              font-family: 'Georama', sans-serif;
              margin-bottom: 10%;
              letter-spacing: 10px;
            }
        
            .container {
              display: flex;
              flex-direction: column;
              justify-content: space-between;
              align-items: center;
              font-size: \$sz;
              background-color: \$secondary-color;
              color: #ffffff;
              padding: 5%;
              position: relative;
              overflow: hidden;
              height: 20vh;
              width: 50vw;
              border-radius: 60px;

              --border-angle: 0turn; // For animation.
                --main-bg: conic-gradient(
                    from var(--border-angle),
                    #213,
                    #112 5%,
                    #112 60%,
                    #213 95%
                  );
                
                border: solid 5px transparent;
                border-radius: 2em;
                --gradient-border: conic-gradient(from var(--border-angle), transparent 25%, #08f, #f03 99%, transparent);
                
                background: 
                  var(--main-bg) padding-box,
                  var(--gradient-border) border-box, 
                  var(--main-bg) border-box;
                
                background-position: center center;

                animation: bg-spin 3s linear infinite;
                @keyframes bg-spin {
                  to {
                    --border-angle: 1turn;
                  }
                }

              }

            @property --border-angle {
              syntax: "<angle>";
              inherits: true;
              initial-value: 0turn;
            }

            .about-us{
              display: flex;
              justify-content: center;
              align-items: center;
              flex-direction: column;

              .title {
                font-size: \$text-size * 2.5;
                color: \$text-color;
                font-weight: bold;
                margin-bottom: 10px;
              }
              h2{
                font-size: \$text-size * 3;
                color: \$primary-color;
                font-weight: bold;
                font-family: 'Georama', sans-serif;
                letter-spacing: 10px;
              }
            }

            .container span {
                margin-bottom: 20px;
                a{
                  color: \$link-color;
                  text-decoration: none;
                  font-weight: bold;
                }
              }
          ''')}
        </style>
      </head>
      <body>
        <div class="heading"> ABOUT US </div>
        <div class="container">
          <div class="about-us">
              <span class = "title">Developed By</span>
              <h2>Imran Farid</h2>
          </div>
          <span>For queries, contact me at: <a href="#">imranfarid@yandex.com</a></span>
        </div>
      </body>
      </html>
    ''';

  AboutUs({super.key});

  static String compileSassToCss(String sassCode) {
    // ignore: deprecated_member_use
    final cssCode = sass.compileString(sassCode);
    return cssCode.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          // return value < 1 ? const Skeletonizer() : signInForm(context);
          return ShaderMask(
            shaderCallback: (rect) {
              return RadialGradient(
                radius: value * 5,
                colors: const [
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                  Colors.transparent
                ],
                stops: [0.0, 0.45, 0.60, 1.0],
                center: FractionalOffset(0.50, 0.75),
              ).createShader(rect);
            },
            child: child,
          );
        },
        child: InAppWebView(
          initialData: InAppWebViewInitialData(data: sassCode),
        ),
      ),
    );
  }
}
