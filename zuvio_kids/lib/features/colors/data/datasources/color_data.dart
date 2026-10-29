import 'package:zuvio_kids/features/colors/domain/entities/color_item_entity.dart';
import 'package:zuvio_kids/features/colors/domain/entities/color_session_entity.dart';

/// Static catalog of all 7 colors, their objects, and palette options.
/// Layer: Data
abstract final class ColorData {
  static const int hexRed = 0xFFFF5252;
  static const int hexYellow = 0xFFFFC72C;
  static const int hexGreen = 0xFF38C172;
  static const int hexBlue = 0xFF3B82F6;
  static const int hexOrange = 0xFFFF7849;
  static const int hexPurple = 0xFF8B5CF6;
  static const int hexPink = 0xFFFF7597;

  /// The 7 colors in sequence
  static const List<ColorItemEntity> items = [
    ColorItemEntity(
      id: 'red',
      name: 'Red',
      objectName: 'apple',
      colorValue: hexRed,
      paletteOptions: [hexRed, hexYellow, hexGreen, hexBlue, hexPurple],
    ),
    ColorItemEntity(
      id: 'yellow',
      name: 'Yellow',
      objectName: 'banana',
      colorValue: hexYellow,
      paletteOptions: [hexRed, hexYellow, hexGreen, hexBlue, hexOrange],
    ),
    ColorItemEntity(
      id: 'green',
      name: 'Green',
      objectName: 'leaf',
      colorValue: hexGreen,
      paletteOptions: [hexPink, hexYellow, hexGreen, hexBlue, hexPurple],
    ),
    ColorItemEntity(
      id: 'blue',
      name: 'Blue',
      objectName: 'balloon',
      colorValue: hexBlue,
      paletteOptions: [hexRed, hexYellow, hexGreen, hexBlue, hexPurple],
    ),
    ColorItemEntity(
      id: 'orange',
      name: 'Orange',
      objectName: 'carrot',
      colorValue: hexOrange,
      paletteOptions: [hexRed, hexOrange, hexYellow, hexGreen, hexBlue],
    ),
    ColorItemEntity(
      id: 'purple',
      name: 'Purple',
      objectName: 'grapes',
      colorValue: hexPurple,
      paletteOptions: [hexRed, hexYellow, hexGreen, hexPurple, hexPink],
    ),
    ColorItemEntity(
      id: 'pink',
      name: 'Pink',
      objectName: 'flower',
      colorValue: hexPink,
      paletteOptions: [hexYellow, hexGreen, hexBlue, hexOrange, hexPink],
    ),
  ];

  static const ColorSessionEntity defaultSession = ColorSessionEntity(
    id: 'colors_session',
    colors: items,
    isCompleted: false,
    starsEarned: 0,
  );
}
