import 'package:flutter/widgets.dart';

typedef AnimatedInfiniteItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);
