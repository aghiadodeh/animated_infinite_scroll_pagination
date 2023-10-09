import 'package:animated_infinite_scroll_pagination/src/configuration/configuration.dart';
import 'package:flutter/material.dart';

import '../../../animated_infinite_scroll_pagination.dart';

class ItemFlex<T, E extends Exception> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T, E> configuration;
  final int index;
  final int totalItems;
  final PaginationModel<T> model;

  const ItemFlex(
      {super.key,
      required this.configuration,
      required this.index,
      required this.model,
      required this.totalItems});

  Widget builder({required List<Widget> children}) {
    if (configuration.scrollDirection == Axis.horizontal) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children);
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = model.item;
    return builder(
      children: [
        configuration.itemBuilder!(context, index, item),
        Visibility(
            visible: configuration.separatorBuilder != null &&
                index != totalItems - 1,
            child: configuration.separatorBuilder?.call(context, index, item) ??
                const SizedBox.shrink()),
      ],
    );
  }
}
