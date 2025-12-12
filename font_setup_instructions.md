# Font Setup Instructions

## Download Required Fonts

### 1. Poppins Font (for English)
- Go to: https://fonts.google.com/specimen/Poppins
- Click "Download family" button
- Extract the ZIP file
- Copy these files to `fonts/` directory:
  - `Poppins-Regular.ttf`
  - `Poppins-Medium.ttf`
  - `Poppins-SemiBold.ttf`
  - `Poppins-Bold.ttf`

### 2. Cairo Font (for Arabic)
- Go to: https://fonts.google.com/specimen/Cairo
- Click "Download family" button
- Extract the ZIP file
- Copy these files to `fonts/` directory:
  - `Cairo-Regular.ttf`
  - `Cairo-Medium.ttf`
  - `Cairo-SemiBold.ttf`
  - `Cairo-Bold.ttf`

## Alternative: Use Google Fonts Package

You can also use the `google_fonts` package instead of downloading fonts manually:

```yaml
dependencies:
  google_fonts: ^6.1.0
```

Then in your code:
```dart
import 'package:google_fonts/google_fonts.dart';

// For English
Text('Hello', style: GoogleFonts.poppins())

// For Arabic
Text('مرحبا', style: GoogleFonts.cairo())
```

## After Downloading Fonts

1. Run `flutter pub get`
2. The fonts will be automatically available in your app
3. Use the font configuration in your theme or individual widgets
