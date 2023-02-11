import 'package:flutter/material.dart' hide AnimatedItemBuilder;
import '../models/pagination_model.dart';
import '../viewmodels/pagination_viewmodel.dart';

class AnimatedGridList<T extends Object> extends StatelessWidget {
  final PaginationEquatable<T> list;
  final PaginationViewModel<T> viewModel;
  final Widget Function(T) itemBuilder;
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  const AnimatedGridList({
    required this.list,
    required this.viewModel,
    required this.itemBuilder,
    required this.gridDelegate,
    this.scrollDirection = Axis.vertical,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: gridDelegate,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.items.length,
      scrollDirection: scrollDirection,
      itemBuilder: (context, index) {
        return itemBuilder.call(list.items[index].item);
      },
    );
  }
}
