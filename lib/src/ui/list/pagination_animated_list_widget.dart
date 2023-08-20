import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import '../../configuration/configuration.dart';
import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';

class PaginationAnimatedListWidget<T extends Object> extends StatefulWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const PaginationAnimatedListWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  State<PaginationAnimatedListWidget<T>> createState() => _PaginationAnimatedListWidgetState<T>();
}

class _PaginationAnimatedListWidgetState<T extends Object> extends State<PaginationAnimatedListWidget<T>> {
  PaginationViewModel<T> get viewModel => widget.configuration.viewModel;
  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder<List<PaginationModel<T>>>(
      data: viewModel.paginationParams.itemsList,
      builder: (context, list) => list.isEmpty
          ? const SizedBox()
          : ImplicitlyAnimatedList<PaginationModel<T>>(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              spawnIsolate: widget.configuration.spawnIsolate,
              items: list,
              padding: widget.configuration.padding,
              scrollDirection: widget.configuration.scrollDirection,
              areItemsTheSame: (a, b) => widget.configuration.viewModel.areItemsTheSame(a.item, b.item),
              itemBuilder: (context, animation, item, i) => SizeFadeTransition(
                key: ObjectKey(item),
                animation: animation,
                child: widget.configuration.itemBuilder?.call(i, item.item),
              ),
              updateItemBuilder: (context, animation, item) {
                final index = list.indexOf(item);
                return FadeTransition(
                  opacity: animation,
                  child: widget.configuration.itemBuilder?.call(index, item.item),
                );
              },
            ),
    );
  }
}
