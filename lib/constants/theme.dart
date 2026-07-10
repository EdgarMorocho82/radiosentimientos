import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors.
  static const headerColor = Color(0xFF083160);
  static const foregroundColor = Color(0xFFffffff);
  static const backgroundColor = Color(0xFFffffff);
  static const buttonPlay = Color(0xFFffffff);

  //Icons
  static const iconSideBar = Color(0xFFffffff);
  static const iconSleepTimer = Color(0xFFffffff);
  static const iconSocialColor = Color(0xFFffffff);

  //Box Border Icons  //Remove box border change 0.05 -> 0.0
  static final boxSocialIconColor =
      iconSocialColor.withAlpha((0.05 * 255).round());
  static final boxIconSleepTimer = headerColor.withAlpha((0.5 * 255).round());
  static final boxButtonPlay = buttonPlay.withAlpha((0.05 * 255).round());

  //Sidebar
  static const sidebarBackground = Color(0xFF083160);
  static const sidebarTextColor = foregroundColor;

  // Constants for detailed customization.
  static const appBarColor = headerColor;
  static const appBarFontColor = foregroundColor;

  static const metadataColor = Color(0xFFffffff);

  static const controlButtonColor = headerColor;
  static const buttonSplashColor = Color(0xFF6488DF);
  static const controlButtonIconColor = foregroundColor;

  //Volume
  static const iconVolume = Color(0xFFffffff);
  static const activeColor = Color(0xFFffffff);
  static final inactiveColor = iconVolume.withAlpha((0.3 * 255).round());
  static const thumbColor = Color(0xFFffffff);

  //Cover Image
  static const artworkShadowColor = Color(0x30000000);
  static const artworkShadowOffset = Offset(2.0, 2.0);
  static const artworkShadowRadius = 8.0;

  //About Us
  static const aboutUsTitleColor = headerColor;
  static const aboutUsDescriptionColor = headerColor;
  static const aboutUsFontColor = foregroundColor;
  static const aboutUsContainerTitleColor = Color(0xFF083160);
  static const aboutContainerBackgroundColor = headerColor;

  //Sleep Timer
  static const timerTrackColor = Color(0xFF083160);
  static final timerTrackInativeColor = headerColor.withOpacity(0.10);
  static const progressBarColor = Color(0xFF083160);
  static const shadowColor = Color(0xFF083160);
  static const controlColor = Color(0xFFffffff);

  //Font
  static const fontWeight = 0.9;
}
