import 'package:zuvio_kids/core/constants/app_strings.dart';
import '../models/animal_model.dart';
import '../models/animal_session_model.dart';

/// Static curriculum containing all 20 animals structured into 2 sessions.
/// Layer: Data Source Data
abstract final class AnimalData {
  /// Session 1 – First 10 Animals
  static const List<AnimalModel> session1Animals = [
    AnimalModel(
      id: 'elephant',
      nameKey: 'animalElephant',
      englishName: 'Elephant',
      svgAsset: '${AppStrings.assetsAnimals}elephant.svg',
      soundAssetId: 'elephant',
      colorValue: 0xFF64B5F6,
    ),
    AnimalModel(
      id: 'cat',
      nameKey: 'animalCat',
      englishName: 'Cat',
      svgAsset: '${AppStrings.assetsAnimals}cat.svg',
      soundAssetId: 'cat',
      colorValue: 0xFFFFB74D,
    ),
    AnimalModel(
      id: 'tiger',
      nameKey: 'animalTiger',
      englishName: 'Tiger',
      svgAsset: '${AppStrings.assetsAnimals}tiger.svg',
      soundAssetId: 'tiger',
      colorValue: 0xFFFF9800,
    ),
    AnimalModel(
      id: 'lion',
      nameKey: 'animalLion',
      englishName: 'Lion',
      svgAsset: '${AppStrings.assetsAnimals}lion.svg',
      soundAssetId: 'lion',
      colorValue: 0xFFFFB300,
    ),
    AnimalModel(
      id: 'cow',
      nameKey: 'animalCow',
      englishName: 'Cow',
      svgAsset: '${AppStrings.assetsAnimals}cow.svg',
      soundAssetId: 'cow',
      colorValue: 0xFF81D4FA,
    ),
    AnimalModel(
      id: 'goat',
      nameKey: 'animalGoat',
      englishName: 'Goat',
      svgAsset: '${AppStrings.assetsAnimals}goat.svg',
      soundAssetId: 'goat',
      colorValue: 0xFFFFCC80,
    ),
    AnimalModel(
      id: 'monkey',
      nameKey: 'animalMonkey',
      englishName: 'Monkey',
      svgAsset: '${AppStrings.assetsAnimals}monkey.svg',
      soundAssetId: 'monkey',
      colorValue: 0xFFBCAAA4,
    ),
    AnimalModel(
      id: 'dog',
      nameKey: 'animalDog',
      englishName: 'Dog',
      svgAsset: '${AppStrings.assetsAnimals}dog.svg',
      soundAssetId: 'dog',
      colorValue: 0xFFFFCC80,
    ),
    AnimalModel(
      id: 'hen',
      nameKey: 'animalHen',
      englishName: 'Hen',
      svgAsset: '${AppStrings.assetsAnimals}hen.svg',
      soundAssetId: 'hen',
      colorValue: 0xFFFF8A80,
    ),
    AnimalModel(
      id: 'horse',
      nameKey: 'animalHorse',
      englishName: 'Horse',
      svgAsset: '${AppStrings.assetsAnimals}horse.svg',
      soundAssetId: 'horse',
      colorValue: 0xFFA1887F,
    ),
  ];

  /// Session 2 – Next 10 Animals
  static const List<AnimalModel> session2Animals = [
    AnimalModel(
      id: 'rabbit',
      nameKey: 'animalRabbit',
      englishName: 'Rabbit',
      svgAsset: '${AppStrings.assetsAnimals}rabbit.svg',
      soundAssetId: 'rabbit',
      colorValue: 0xFFF48FB1,
    ),
    AnimalModel(
      id: 'parrot',
      nameKey: 'animalParrot',
      englishName: 'Parrot',
      svgAsset: '${AppStrings.assetsAnimals}parrot.svg',
      soundAssetId: 'parrot',
      colorValue: 0xFFEF5350,
    ),
    AnimalModel(
      id: 'fish',
      nameKey: 'animalFish',
      englishName: 'Fish',
      svgAsset: '${AppStrings.assetsAnimals}fish.svg',
      soundAssetId: 'fish',
      colorValue: 0xFF4DD0E1,
    ),
    AnimalModel(
      id: 'giraffe',
      nameKey: 'animalGiraffe',
      englishName: 'Giraffe',
      svgAsset: '${AppStrings.assetsAnimals}giraffe.svg',
      soundAssetId: 'giraffe',
      colorValue: 0xFFFFD54F,
    ),
    AnimalModel(
      id: 'zebra',
      nameKey: 'animalZebra',
      englishName: 'Zebra',
      svgAsset: '${AppStrings.assetsAnimals}zebra.svg',
      soundAssetId: 'zebra',
      colorValue: 0xFF90A4AE,
    ),
    AnimalModel(
      id: 'deer',
      nameKey: 'animalDeer',
      englishName: 'Deer',
      svgAsset: '${AppStrings.assetsAnimals}deer.svg',
      soundAssetId: 'deer',
      colorValue: 0xFFD7A86E,
    ),
    AnimalModel(
      id: 'peacock',
      nameKey: 'animalPeacock',
      englishName: 'Peacock',
      svgAsset: '${AppStrings.assetsAnimals}peacock.svg',
      soundAssetId: 'peacock',
      colorValue: 0xFF4DB6AC,
    ),
    AnimalModel(
      id: 'frog',
      nameKey: 'animalFrog',
      englishName: 'Frog',
      svgAsset: '${AppStrings.assetsAnimals}frog.svg',
      soundAssetId: 'frog',
      colorValue: 0xFF81C784,
    ),
    AnimalModel(
      id: 'camel',
      nameKey: 'animalCamel',
      englishName: 'Camel',
      svgAsset: '${AppStrings.assetsAnimals}camel.svg',
      soundAssetId: 'camel',
      colorValue: 0xFFFFB74D,
    ),
    AnimalModel(
      id: 'bear',
      nameKey: 'animalBear',
      englishName: 'Bear',
      svgAsset: '${AppStrings.assetsAnimals}bear.svg',
      soundAssetId: 'bear',
      colorValue: 0xFFBCAAA4,
    ),
  ];

  /// Factory helper to build the 2 default session definitions
  static List<AnimalSessionModel> createDefaultSessions({
    bool session1Completed = false,
    bool session2Completed = false,
    int session1Stars = 0,
    int session2Stars = 0,
  }) {
    return [
      AnimalSessionModel(
        id: AppStrings.sessionAnimals1,
        sessionNumber: 1,
        titleKey: 'animalsSession1Title',
        subtitleKey: 'animalsSession1Subtitle',
        animals: session1Animals,
        isCompleted: session1Completed,
        isLocked: false,
        starsEarned: session1Stars,
      ),
      AnimalSessionModel(
        id: AppStrings.sessionAnimals2,
        sessionNumber: 2,
        titleKey: 'animalsSession2Title',
        subtitleKey: 'animalsSession2Subtitle',
        animals: session2Animals,
        isCompleted: session2Completed,
        isLocked: !session1Completed,
        starsEarned: session2Stars,
      ),
    ];
  }
}
