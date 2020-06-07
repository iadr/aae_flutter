import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);
  

  static const Color cancel = const Color(0xFFFF6D00);
  static const Color confirm = const Color(0xFF1976D2);

  static const Color success = const Color(0xFF0288d1);
  static const Color failure = const Color(0xFFDD2C00);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}