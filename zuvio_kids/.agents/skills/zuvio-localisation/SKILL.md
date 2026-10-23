---
name: zuvio-localisation
description: >-
  Use this skill when adding, modifying, or reviewing any user-facing string
  in the ZuvioKids project. Covers ARB file structure, key naming rules,
  English and Malayalam translations, intl plural/select syntax, and how to
  wire new strings into the generated AppLocalizations class.
---

# ZuvioKids Localisation Skill

Follow every step in order when adding or modifying any user-facing string.

---

## ARB File Locations

```
lib/core/l10n/
├── app_en.arb   ← English (source of truth)
└── app_ml.arb   ← Malayalam
```

The generated Dart class is referenced as:
```dart
import 'package:zuvio_kids/core/l10n/app_localizations.dart';

final l10n = AppLocalizations.of(context)!;
```

---

## Key Naming Convention

| Category           | Prefix       | Example key              |
|--------------------|--------------|--------------------------|
| Screen/page title  | `title`      | `titleLetterTracing`     |
| Button labels      | `btn`        | `btnNext`, `btnRetry`    |
| Instruction text   | `instruction`| `instructionDrawLetter`  |
| Error messages     | `error`      | `errorNetworkUnavailable`|
| Validation msgs    | `validation` | `validationRequiredField`|
| Notification text  | `notify`     | `notifyProgressSaved`    |
| Heading / subtitle | `heading`    | `headingChooseLevel`     |
| Hint / placeholder | `hint`       | `hintSearchActivity`     |
| Tooltip            | `tooltip`    | `tooltipPlaySound`       |
| Success messages   | `success`    | `successActivityComplete`|

Keys must be `lowerCamelCase`.

---

## Step-by-Step: Adding a New String

### 1. Add to `app_en.arb`

```json
{
  "@@locale": "en",

  "btnNext": "Next",
  "@btnNext": {
    "description": "Label for the Next navigation button"
  },

  "instructionDrawLetter": "Trace the letter {letter} with your finger.",
  "@instructionDrawLetter": {
    "description": "Instruction shown on the tracing screen",
    "placeholders": {
      "letter": {
        "type": "String",
        "example": "A"
      }
    }
  }
}
```

### 2. Add to `app_ml.arb`

```json
{
  "@@locale": "ml",

  "btnNext": "അടുത്തത്",
  "@btnNext": {
    "description": "Label for the Next navigation button"
  },

  "instructionDrawLetter": "നിങ്ങളുടെ വിരൽ ഉപയോഗിച്ച് {letter} എഴുതുക.",
  "@instructionDrawLetter": {
    "description": "Instruction shown on the tracing screen",
    "placeholders": {
      "letter": {
        "type": "String",
        "example": "A"
      }
    }
  }
}
```

### 3. Reference in Dart code

```dart
// Simple string
Text(l10n.btnNext)

// String with placeholder
Text(l10n.instructionDrawLetter(letter: 'A'))
```

### 4. Regenerate (if not using `generate: true`)

```bash
flutter gen-l10n
```

Or ensure `pubspec.yaml` has:
```yaml
flutter:
  generate: true
```

And `l10n.yaml` at project root:
```yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

---

## Plural & Select Patterns

### Plural
```json
"itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
"@itemCount": {
  "placeholders": { "count": { "type": "int" } }
}
```

Malayalam plural:
```json
"itemCount": "{count, plural, =0{ഒന്നും ഇല്ല} =1{ഒരു ഇനം} other{{count} ഇനങ്ങൾ}}"
```

### Select (gender, category, etc.)
```json
"greetUser": "{gender, select, male{Good morning, sir!} female{Good morning, ma'am!} other{Good morning!}}",
"@greetUser": {
  "placeholders": { "gender": { "type": "String" } }
}
```

---

## Locale Registration in `main.dart` / `AppWidget`

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```

`AppLocalizations.supportedLocales` will include `en` and `ml` automatically
once both ARB files are present.

---

## Rules

1. **Never** use a raw string literal for a user-facing text in a widget.
2. **Always** add the `@key` metadata entry in both ARB files.
3. **Always** provide a meaningful `"description"` in the metadata.
4. Malayalam translations must be reviewed for accuracy — do not rely on
   machine translation alone.
5. Run `flutter analyze` after adding new strings to confirm the generated
   class compiles cleanly.
