import 'package:flutter/material.dart' hide AnimatedItemBuilder;
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import '../models/pagination_model.dart';
import '../viewmodels/pagination_viewmodel.dart';

class AppImplicitlyAnimatedList<T extends Object> extends StatelessWidget {
  final PaginationEquatable<T> list;
  final PaginationViewModel<T> viewModel;
  final Widget Function(T) itemBuilder;
  final Axis scrollDirection;
  const AppImplicitlyAnimatedList({
    required this.list,
    required this.viewModel,
    required this.itemBuilder,
    required this.scrollDirection,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: ImplicitlyAnimatedList<PaginationModel<T>>(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        items: list.items,
        scrollDirection: scrollDirection,
        areItemsTheSame: (a, b) => viewModel.areItemsTheSame(a.item, b.item),
        itemBuilder: (context, animation, item, i) {
          return SizeFadeTransition(
            animation: animation,
            child: itemBuilder.call(item.item),
          );
        },
        updateItemBuilder: (context, animation, item) {
          return FadeTransition(
            opacity: animation,
            child: itemBuilder.call(item.item),
          );
        },
      ),
    );
  }
}
