import 'package:flutter/material.dart';
import 'package:zuvio_kids/features/colors/presentation/widgets/color_objects.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import 'package:zuvio_kids/features/shapes/presentation/widgets/shape_visual.dart';
import '../../domain/entities/puzzle_item_entity.dart';

/// Renders puzzle items across all 4 learning sessions:
/// - Shapes: 12 geometric shapes
/// - Colors: Paintable objects (apple, banana, leaf, balloon, carrot, grapes, flower)
/// - Numbers: Numbers 1–100
/// - Alphabet: Letters A–Z
/// Supports [isSilhouette] mode for shadows matching the sample screen.
/// Layer: Presentation Widget
class PuzzleItemVisual extends StatelessWidget {
  const PuzzleItemVisual({
    super.key,
    required this.item,
    this.size = 56,
    this.isSilhouette = false,
  });

  final PuzzleItemEntity item;
  final double size;
  final bool isSilhouette;

  static const Color silhouetteColor = Color(0xFF1E293B); // Dark navy shadow

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case PuzzleItemType.shape:
        return SizedBox(
          width: size,
          height: size,
          child: ShapeVisualWidget(
            shapeId: item.id,
            size: size,
            color: isSilhouette ? silhouetteColor : Color(item.colorHex),
          ),
        );

      case PuzzleItemType.color:
        final objectName = item.displayText ?? 'apple';
        final visual = SizedBox(
          width: size,
          height: size,
          child: PaintableObjectWidget(
            objectName: objectName,
            appliedColorValue: isSilhouette ? 0xFF1E293B : item.colorHex,
            onTap: () {},
            width: size,
            height: size,
          ),
        );

        if (isSilhouette) {
          return ColorFiltered(
            colorFilter: const ColorFilter.mode(
              silhouetteColor,
              BlendMode.srcIn,
            ),
            child: visual,
          );
        }
        return visual;

      case PuzzleItemType.alphabet:
        final letterText = item.displayText ?? item.name;
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              letterText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size * 0.72,
                fontWeight: FontWeight.w900,
                color: isSilhouette ? silhouetteColor : Color(item.colorHex),
                height: 1.0,
              ),
            ),
          ),
        );

      case PuzzleItemType.number:
        final numText = item.displayText ?? item.name;
        final fontScale = numText.length > 2
            ? 0.42
            : (numText.length > 1 ? 0.54 : 0.68);

        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              numText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size * fontScale,
                fontWeight: FontWeight.w900,
                color: isSilhouette ? silhouetteColor : Color(item.colorHex),
                height: 1.0,
              ),
            ),
          ),
        );

      case PuzzleItemType.animal:
        final avatarWidget = AnimalAvatar(
          avatarType: item.id,
          size: size,
        );

        if (isSilhouette) {
          return ColorFiltered(
            colorFilter: const ColorFilter.mode(
              silhouetteColor,
              BlendMode.srcIn,
            ),
            child: avatarWidget,
          );
        }

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Color(item.colorHex).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(item.colorHex),
              width: 2.5,
            ),
          ),
          padding: EdgeInsets.all(size * 0.08),
          child: avatarWidget,
        );
    }
  }
}
