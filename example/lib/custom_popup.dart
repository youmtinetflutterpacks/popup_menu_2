import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu.dart';

void main() {
  runApp(const MyApp());
}

class ChatModel {
  String content;
  bool isMe;

  ChatModel(
    this.content, {
    this.isMe = false,
  });
}

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomPopupMenu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<ChatModel> messages;
  late List<ItemModel> menuItems;
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    messages = [
      ChatModel('Are you there?'),
      ChatModel('What\'s wrong? Can I help you?', isMe: true),
      ChatModel('Nothing, just checking to see if you are here'),
      ChatModel('What on earth are you talking about? I\'m still working.',
          isMe: true),
      ChatModel('？', isMe: true),
      ChatModel('Let’s start introducing Flutter'),
      ChatModel(
          'Flutter is Google\'s mobile UI framework that can quickly build high-quality native user interfaces on iOS and Android. Flutter can work with existing code. Flutter is being used by more and more developers and organizations around the world, and Flutter is completely free and open source.'),
      ChatModel('That\'s it？？？', isMe: true),
      ChatModel('Are you there?'),
      ChatModel('What\'s wrong? Can I help you?', isMe: true),
      ChatModel('Nothing, just checking to see if you are here'),
      ChatModel('What on earth are you talking about? I\'m still working.',
          isMe: true),
      ChatModel('？', isMe: true),
      ChatModel('Let’s start introducing Flutter'),
      ChatModel(
          'Flutter is Google\'s mobile UI framework that can quickly build high-quality native user interfaces on iOS and Android. Flutter can work with existing code. Flutter is being used by more and more developers and organizations around the world, and Flutter is completely free and open source.'),
      ChatModel('That\'s it？？？', isMe: true),
    ];
    menuItems = [
      ItemModel('Start a group chat', Icons.chat_bubble),
      ItemModel('add friends', Icons.group_add),
      ItemModel('scan it', Icons.settings_overscan),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPopupMenu'),
        actions: <Widget>[
          CustomPopupMenu(
            enablePassEvent: true,
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: const Color(0xFF4C4C4C),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: getMenuItems(),
                  ),
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Column(
                children: messages
                    .map(
                      (message) => MessageContent(
                        message,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  List<GestureDetector> getMenuItems() {
    return menuItems
        .map(
          (item) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              log("onTap");
              _controller.hideMenu();
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(
                    item.icon,
                    size: 15,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}

// ignore: must_be_immutable
class MessageContent extends StatelessWidget {
  MessageContent(this.message, {Key? key}) : super(key: key);

  final ChatModel message;
  List<ItemModel> menuItems = [
    ItemModel('copy', Icons.content_copy),
    ItemModel('Forward', Icons.send),
    ItemModel('collect', Icons.collections),
    ItemModel('delete', Icons.delete),
    ItemModel('Choice', Icons.playlist_add_check),
    ItemModel('Quote', Icons.format_quote),
    ItemModel('remind', Icons.add_alert),
    ItemModel('Search', Icons.search),
  ];

  Widget _buildLongPressMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 220,
        color: const Color(0xFF4C4C4C),
        child: GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          crossAxisCount: 5,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: menuItems
              .map(
                (item) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      item.icon,
                      size: 20,
                      color: Colors.white,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isMe, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: isMe ? Colors.blueAccent : Colors.pinkAccent,
        width: size,
        height: size,
        child: Icon(
          isMe ? Icons.face : Icons.tag_faces,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = message.isMe;
    double avatarSize = 40;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: isMe ? 0 : 10, left: isMe ? 10 : 0),
            child: CustomPopupMenu(
              menuBuilder: () => GestureDetector(
                child: _buildAvatar(isMe, 100),
                onLongPress: () {
                  log("onLongPress");
                },
                onTap: () {
                  log("onTap");
                },
              ),
              barrierColor: Colors.transparent,
              pressType: PressType.singleClick,
              arrowColor: isMe ? Colors.blueAccent : Colors.pinkAccent,
              position: PreferredPosition.top,
              child: _buildAvatar(isMe, avatarSize),
            ),
          ),
          CustomPopupMenu(
            menuBuilder: _buildLongPressMenu,
            barrierColor: Colors.transparent,
            pressType: PressType.longPress,
            child: Container(
              padding: const EdgeInsets.all(0),
              constraints: BoxConstraints(maxWidth: 240, minHeight: avatarSize),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xff98e165) : const Color(0xFFFCBD47),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Text(message.content),
            ),
          )
        ],
      ),
    );
  }
}
