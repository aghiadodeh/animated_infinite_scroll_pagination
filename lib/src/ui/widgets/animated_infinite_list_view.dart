import 'custom_animated_opacity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../models/pagination.model/pagination_model.dart';

class AnimatedInfiniteListView<T> extends StatelessWidget {
  final AnimatedInfinitePaginationController<T> controller;
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfiniteListView({
    required this.controller,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (options.itemBuilder == null) return const SizedBox();

    if (options.scrollDirection == Axis.horizontal) {
      return LiveDataBuilder<List<PaginationModel<T>>>(
        data: controller.items,
        builder: (context, items) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: items.length, // Number of items
              (BuildContext context, int index) {
                return CustomAnimatedOpacityWidget(
                  child: options.itemBuilder!(context, items[index].item, index),
                );
              },
            ),
          );
        },
      );
    }

    return LiveDataBuilder<List<PaginationModel<T>>>(
      data: controller.items,
      builder: (context, items) => SliverImplicitlyAnimatedList<PaginationModel<T>>(
        items: items,
        spawnIsolate: options.spawnIsolate,
        areItemsTheSame: (oldItem, newItem) => controller.areItemsTheSame(oldItem.item, newItem.item),
        itemBuilder: (context, animation, model, index) => itemBuilder(context, animation, model, index),
        updateItemBuilder: (context, animation, model) {
          final index = items.indexOf(model);
          return updateItemBuilder(context, animation, model, index);
        },
      ),
    );
  }

  Widget itemBuilder(
    BuildContext context,
    Animation<double> animation,
    PaginationModel<T> model,
    int index,
  ) {
    return SizeFadeTransition(
      animation: animation,
      child: options.itemBuilder!(
        context,
        model.item,
        index,
      ),
    );
  }

  Widget updateItemBuilder(
    BuildContext context,
    Animation<double> animation,
    PaginationModel<T> model,
    int index,
  ) {
    return FadeTransition(
      opacity: animation,
      child: options.itemBuilder!(
        context,
        model.item,
        index,
      ),
    );
  }
}
