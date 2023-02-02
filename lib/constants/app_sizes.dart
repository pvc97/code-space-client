import 'package:flutter/material.dart';

/// Constant sizes to be used in the app (paddings, gaps, rounded corners etc.)
class Sizes {
  Sizes._();
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
  static const s48 = 48.0;
  static const s64 = 64.0;
  static const s200 = 200.0;
  static const s300 = 300.0;
}

class Box extends SizedBox {
  const Box({
    super.width,
    super.height,
    super.key,
    super.child,
  });

  static const w4 = Box(width: Sizes.s4);
  static const w8 = Box(width: Sizes.s8);
  static const w12 = Box(width: Sizes.s12);
  static const w16 = Box(width: Sizes.s16);
  static const w20 = Box(width: Sizes.s20);
  static const w24 = Box(width: Sizes.s24);
  static const w32 = Box(width: Sizes.s32);
  static const w48 = Box(width: Sizes.s48);
  static const w64 = Box(width: Sizes.s64);

  static const h4 = Box(height: Sizes.s4);
  static const h8 = Box(height: Sizes.s8);
  static const h12 = Box(height: Sizes.s12);
  static const h16 = Box(height: Sizes.s16);
  static const h20 = Box(height: Sizes.s20);
  static const h24 = Box(height: Sizes.s24);
  static const h32 = Box(height: Sizes.s32);
  static const h48 = Box(height: Sizes.s48);
  static const h64 = Box(height: Sizes.s64);
}
