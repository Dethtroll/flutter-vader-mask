# vader-mask

[![pub package](https://img.shields.io/pub/v/vader_mask.svg)](https://pub.dartlang.org/packages/vader_mask)

The Flutter package provides implementations of TextInputFormatter

## How to use

```dart
import 'package:vader_mask/vader_mask.dart';
```

### Mobile phone formatter

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Mobile number',
    prefixText: '+7 ',
  ),
  inputFormatters: <TextInputFormatter>[
    PhoneFormatter()
  ],
  keyboardType: TextInputType.phone,
  maxLength: 15,
  autofocus: true,
)
```