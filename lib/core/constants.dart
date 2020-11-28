import 'package:flutter/material.dart';

/// Global padding settings
const hPadding = 16.0;
const vPadding = 24.0;
const hEdgeInsets = EdgeInsets.symmetric(horizontal: hPadding);
const vEdgeInsets = EdgeInsets.symmetric(vertical: vPadding);
const wrapEdgeInsets = EdgeInsets.symmetric(
  horizontal: hPadding,
  vertical: vPadding,
);
const innerEdgeInsets = EdgeInsets.all(16);

/// Global delegates
const defaultGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 4 / 5,
);
