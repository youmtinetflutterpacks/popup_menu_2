import 'package:flutter/material.dart';

class ContextPopupMenuItem {
  Widget? child;
  Future<void> Function()? onTap;

  ContextPopupMenuItem({
    this.child,
    this.onTap,
  });
}
