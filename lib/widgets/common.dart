import 'package:flutter/material.dart';

import '../core/colors.dart';

/// This file contains the small common widgets shared across many places

Widget get loadingImagePlaceholder => const DecoratedBox(
      decoration: BoxDecoration(color: MainColors.white),
      child: Center(child: CircularProgressIndicator()),
    );

Widget get cardsSpacer => const SizedBox(height: 12);
