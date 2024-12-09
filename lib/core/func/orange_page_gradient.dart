import 'package:flutter/material.dart';

LinearGradient myPageGradient() {
  return const LinearGradient(
    colors: [Color(0XFFF95A3B), Color(0XFFF96713)],
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.bottomCenter,
    stops: [0.0, 0.8],
    tileMode: TileMode.mirror,
  );
}
