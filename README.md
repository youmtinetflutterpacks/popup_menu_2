# Popup menu 2
**SCREENSHOT** 

![Popup menu 2](https://raw.githubusercontent.com/ymrabti/popup_menu_2/main/example.png)



a pupup menu, for porpose not break the user attention


Supported Platforms:
- **ALL** 

#### Using the Popup menu 2

```dart
ContextualMenu(
    targetWidgetKey: key,
    ctx: context,
    backgroundColor: Colors.red,
    highlightColor: Colors.white,
    onDismiss: () {
        setState(() {
        _counter = _counter * 1.2;
        });
    },
    items: [
        MenuItem(
        press: _incrementCounter,
        title: 'increment',
        textAlign: TextAlign.justify,
        textStyle: const TextStyle(color: Colors.white),
        image: const Icon(Icons.add, color: Colors.white),
        ),
        MenuItem(
        press: _decrementCounter,
        title: 'decrement',
        textAlign: TextAlign.justify,
        textStyle: const TextStyle(color: Colors.white),
        image: const Icon(Icons.remove, color: Colors.white),
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
```
Copyright (c) 2022, youmti.net
All rights reserved.

Redistribution and use in source and binary forms, with or without modification.
