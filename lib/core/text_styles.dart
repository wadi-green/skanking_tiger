import 'package:flutter/material.dart';

import 'colors.dart';

TextStyle boxCardTitle(BuildContext context) =>
    Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        );

TextStyle boxCardItemTitle(BuildContext context) =>
    Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          height: 1.25,
        );

TextStyle searchSubtitle(BuildContext context) =>
    Theme.of(context).textTheme.caption.copyWith(
          fontSize: 13,
        );

TextStyle itemTitle(BuildContext context) =>
    Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        );

TextStyle shortDescriptionCaption(BuildContext context) =>
    Theme.of(context).textTheme.bodyText2.copyWith(
          fontSize: 12,
          color: MainColors.grey,
        );

TextStyle roleStyle(BuildContext context) =>
    Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        );

TextStyle detailedTileLabel(BuildContext context) =>
    Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        );

TextStyle detailedTileValue(BuildContext context) =>
    Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 16,
          color: MainColors.darkGrey,
          fontWeight: FontWeight.w600,
        );
