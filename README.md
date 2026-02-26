# This is a fork of [popup_menu](https://pub.dev/packages/popup_menu) by [@chinabrant](https://github.com/chinabrant)
<div align="center">

# popup_menu_2

Lightweight and customizable Flutter popup menus designed to keep user attention on the current context.

[![pub package](https://img.shields.io/pub/v/popup_menu_2.svg)](https://pub.dev/packages/popup_menu_2)
[![pub likes](https://img.shields.io/pub/likes/popup_menu_2.svg)](https://pub.dev/packages/popup_menu_2/score)
[![pub points](https://img.shields.io/pub/points/popup_menu_2.svg?color=blue)](https://pub.dev/packages/popup_menu_2/score)
[![platform](https://img.shields.io/badge/platform-flutter-blue)](https://flutter.dev)

[![GitHub stars](https://img.shields.io/github/stars/ymrabti/popup_menu_2.svg?style=flat&logo=github&colorB=&label=Stars)](https://github.com/ymrabti/popup_menu_2/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/ymrabti/popup_menu_2.svg?style=flat&logo=github&colorB=&label=Issues)](https://github.com/ymrabti/popup_menu_2/issues)
[![GitHub license](https://img.shields.io/github/license/ymrabti/popup_menu_2.svg?style=flat&logo=github&colorB=&label=License)](https://github.com/ymrabti/popup_menu_2/blob/main/LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/ymrabti/popup_menu_2.svg?style=flat&logo=github&colorB=&label=Last%20Commit)](https://github.com/ymrabti/popup_menu_2/commits/main)


[![Build status](https://github.com/ymrabti/popup_menu_2/workflows/Publish%20to%20pub.dev/badge.svg?style=flat&logo=github&colorB=&label=Build)](https://github.com/youmtinetflutterpacks/popup_menu_2)


</div>


## ✨ Highlights

- Context-aware popup positioning.
- Supports both tap and long-press triggers.
- Grid-style menu with configurable columns.
- Dismiss-on-click-away behavior.
- Works across Flutter-supported platforms.

## 📸 Preview

<p align="center">
    <img src="https://raw.githubusercontent.com/ymrabti/popup_menu_2/main/screen-1.jpg" width="220" alt="popup preview 1" />
    <img src="https://raw.githubusercontent.com/ymrabti/popup_menu_2/main/screen-2.jpg" width="220" alt="popup preview 2" />
</p>

## 📦 Installation

Add dependency to your `pubspec.yaml`:

```yaml
dependencies:
    popup_menu_2: ^0.1.6
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### ContextualMenu

```dart
import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu_2.dart';

final GlobalKey targetKey = GlobalKey();

ContextualMenu(
    targetWidgetKey: targetKey,
    maxColumns: 2,
    dismissOnClickAway: true,
    backgroundColor: Colors.black87,
    items: [
        ContextPopupMenuItem(
            onTap: () async {},
            child: const Icon(Icons.add, color: Colors.white),
        ),
        ContextPopupMenuItem(
            onTap: () async {},
            child: const Icon(Icons.remove, color: Colors.white),
        ),
    ],
    child: Icon(Icons.more_vert, key: targetKey),
)
```

### CustomPopupMenu + Controller

```dart
import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu_2.dart';

final controller = CustomPopupMenuController();

CustomPopupMenu(
    controller: controller,
    pressType: PressType.singleClick,
    menuBuilder: () => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Hello from popup_menu_2'),
    ),
    child: const Icon(Icons.touch_app),
)
```

## ⚙️ Core Options

- `ContextualMenu`: `maxColumns`, `dismissOnClickAway`, `position`, `backgroundColor`, `highlightColor`, `lineColor`.
- `CustomPopupMenu`: `pressType`, `showArrow`, `arrowColor`, `barrierColor`, `position`, `menuOnChange`, `enablePassEvent`.

## 📄 License

Distributed under the BSD 3-Clause license. See [LICENSE](LICENSE).

## 🔗 More Packages

- [Power Geojson](https://pub.dev/packages/power_geojson)
- [Flutter Azimuth](https://pub.dev/packages/flutter_azimuth)
- [Map Contextual Menu](https://pub.dev/packages/longpress_popup)
- [Simple Logger](https://pub.dev/packages/console_tools)

---

## 👨‍💻 Developer Card

<div align="center">
    <img src="https://avatars.githubusercontent.com/u/47449165?v=4" alt="Younes M'rabti avatar" width="120" height="120" style="border-radius: 50%;" />

### Younes M'rabti

📧 Email: [admin@youmti.net](mailto:admin@youmti.net)  
🌐 Website: [youmti.net](https://www.youmti.net/)  
💼 LinkedIn: [younesmrabti1996](https://www.linkedin.com/in/younesmrabti1996/)
</div>
