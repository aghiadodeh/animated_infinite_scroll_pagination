import 'package:flutter/material.dart';

class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedGridState> listKey;
  final Widget Function(
          E item, int index, BuildContext context, Animation<double> animation)
      removedItemBuilder;
  final List<E> _items;

  SliverAnimatedGridState get _animatedGrid => listKey.currentState!;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedGrid.insertItem(index);
  }

  void insertAllItems(int index, Iterable<E> items) {
    final itemsList = items.toList();
    for (int i = 0; i < items.length; i++) {
      insert(index + i, itemsList[i]);
    }
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedGrid.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(removedItem, index, context, animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
