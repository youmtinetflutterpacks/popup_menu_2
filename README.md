# Popup menu 2

**SCREENSHOT**

<img src="https://raw.githubusercontent.com/ymrabti/popup_menu_2/main/screen-1.jpg" width="20%">
<img src="https://raw.githubusercontent.com/ymrabti/popup_menu_2/main/screen-2.jpg" width="20%">

a pupup menu, for porpose not break the user attention

Supported Platforms:

- **ALL**

#### Using the Popup menu 2

```dart
ContextualMenu(
key: keyState,
targetWidgetKey: key,
maxColumns: 2,
backgroundColor: Colors.red,
dismissOnClickAway: true,
items: [
    ContextPopupMenuItem(
    onTap: _incrementCounter,
    child: const Icon(Icons.add, color: Colors.white),
    ),
    ContextPopupMenuItem(
    onTap: _decrementCounter,
    child: const Icon(Icons.remove, color: Colors.white),
    ),
],
child: Icon(
    Icons.add,
    key: key,
    color: Colors.white,
),
)

```

## License

Copyright (c) 2022, youmti.net
All rights reserved.

Redistribution and use in source and binary forms, with or without modification.

## Checkout my other Packages you may like

- [PowerGeojson](https://pub.dev/packages/power_geojson)
- [ConsoleLogger](https://pub.dev/packages/console_tools)
