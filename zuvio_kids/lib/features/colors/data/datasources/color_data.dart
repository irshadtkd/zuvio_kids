import 'package:zuvio_kids/features/colors/domain/entities/color_item_entity.dart';
import 'package:zuvio_kids/features/colors/domain/entities/color_session_entity.dart';

/// Static catalog of colors, their objects, and palette options.
/// Layer: Data
abstract final class ColorData {
  static const int hexRed = 0xFFFF5252;
  static const int hexYellow = 0xFFFFC72C;
  static const int hexGreen = 0xFF38C172;
  static const int hexBlue = 0xFF3B82F6;
  static const int hexOrange = 0xFFFF7849;
  static const int hexPurple = 0xFF8B5CF6;
  static const int hexPink = 0xFFFF7597;

  // UKG extra colors
  static const int hexWhite = 0xFFF5F5F5;
  static const int hexBlack = 0xFF424242;
  static const int hexBrown = 0xFF8D6E63;
  static const int hexGray = 0xFF90A4AE;
  static const int hexSkyBlue = 0xFF29B6F6;
  static const int hexGolden = 0xFFFFD700;

  /// The 7 colors used for PreKG and LKG.
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

  /// The extended 13-color list for UKG (7 base + 6 additional).
  static const List<ColorItemEntity> ukgItems = [
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
    // UKG additional colors
    ColorItemEntity(
      id: 'white',
      name: 'White',
      objectName: 'cloud',
      colorValue: hexWhite,
      paletteOptions: [hexWhite, hexGray, hexBlue, hexPink, hexYellow],
    ),
    ColorItemEntity(
      id: 'black',
      name: 'Black',
      objectName: 'star',
      colorValue: hexBlack,
      paletteOptions: [hexBlack, hexGray, hexPurple, hexBlue, hexRed],
    ),
    ColorItemEntity(
      id: 'brown',
      name: 'Brown',
      objectName: 'tree',
      colorValue: hexBrown,
      paletteOptions: [hexBrown, hexOrange, hexYellow, hexGreen, hexRed],
    ),
    ColorItemEntity(
      id: 'gray',
      name: 'Gray',
      objectName: 'moon',
      colorValue: hexGray,
      paletteOptions: [hexGray, hexBlack, hexWhite, hexBlue, hexPurple],
    ),
    ColorItemEntity(
      id: 'sky_blue',
      name: 'Sky Blue',
      objectName: 'kite',
      colorValue: hexSkyBlue,
      paletteOptions: [hexSkyBlue, hexBlue, hexGreen, hexWhite, hexPurple],
    ),
    ColorItemEntity(
      id: 'golden',
      name: 'Golden',
      objectName: 'sun',
      colorValue: hexGolden,
      paletteOptions: [hexGolden, hexYellow, hexOrange, hexRed, hexBrown],
    ),
  ];

  static const ColorSessionEntity defaultSession = ColorSessionEntity(
    id: 'colors_session',
    colors: items,
    isCompleted: false,
    starsEarned: 0,
  );

  static const ColorSessionEntity ukgSession = ColorSessionEntity(
    id: 'colors_session',
    colors: ukgItems,
    isCompleted: false,
    starsEarned: 0,
  );
}
