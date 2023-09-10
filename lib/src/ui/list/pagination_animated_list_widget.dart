import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';

import '../../configuration/configuration.dart';

class PaginationAnimatedListWidget<T extends Object> extends StatefulWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const PaginationAnimatedListWidget(this.configuration, {Key? key})
      : super(key: key);

  @override
  State<PaginationAnimatedListWidget<T>> createState() =>
      _PaginationAnimatedListWidgetState<T>();
}

class _PaginationAnimatedListWidgetState<T extends Object>
    extends State<PaginationAnimatedListWidget<T>> {
  PaginationViewModel<T> get viewModel => widget.configuration.viewModel;

  Widget itemBuilder(BuildContext context, int index, T item) {
    if (widget.configuration.separatorBuilder == null) {
      return widget.configuration.itemBuilder!(context, index, item);
    }
    if (widget.configuration.scrollDirection == Axis.horizontal) {
      return Row(
        children: [
          widget.configuration.itemBuilder!(context, index, item),
          widget.configuration.separatorBuilder!(context, index, item),
        ],
      );
    }
    return Column(
      children: [
        widget.configuration.itemBuilder!(context, index, item),
        widget.configuration.separatorBuilder!(context, index, item),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder<List<PaginationModel<T>>>(
      data: viewModel.paginationParams.itemsList,
      builder: (context, list) => list.isEmpty
          ? const SizedBox()
          : ImplicitlyAnimatedList<PaginationModel<T>>(
              spawnIsolate: widget.configuration.spawnIsolate,
              items: list,
              physics: widget.configuration.topWidget == null
                  ? widget.configuration.physics
                  : const NeverScrollableScrollPhysics(),
              scrollDirection: widget.configuration.scrollDirection,
              areItemsTheSame: (a, b) => widget.configuration.viewModel
                  .areItemsTheSame(a.item, b.item),
              itemBuilder: (context, animation, item, index) =>
                  SizeFadeTransition(
                key: ObjectKey(item),
                animation: animation,
                child: itemBuilder(context, index, item.item),
              ),
              updateItemBuilder: (context, animation, model) {
                final index = list.indexWhere((value) => widget
                    .configuration.viewModel
                    .areItemsTheSame(value.item, model.item));
                return FadeTransition(
                  opacity: animation,
                  child: itemBuilder(context, index, model.item),
                );
              },
            ),
    );
  }
}
