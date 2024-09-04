import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../models/pagination.model/pagination_model.dart';

class AnimatedInfiniteListview<T> extends StatelessWidget {
  final AnimatedInfinitePaginationController<T> delegate;
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfiniteListview({
    required this.delegate,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (options.itemBuilder == null) return const SizedBox();

    return LiveDataBuilder<List<PaginationModel<T>>>(
      data: delegate.items,
      builder: (context, items) => ImplicitlyAnimatedList<PaginationModel<T>>(
        items: items,
        padding: options.padding,
        physics: options.physics,
        reverse: options.reverse,
        shrinkWrap: options.shrinkWrap,
        spawnIsolate: options.spawnIsolate,
        scrollDirection: options.scrollDirection,
        areItemsTheSame: (oldItem, newItem) => delegate.areItemsTheSame(oldItem.item, newItem.item),
        itemBuilder: (context, animation, model, i) => SizeFadeTransition(
          animation: animation,
          child: options.itemBuilder!(
            context,
            model.item,
            i,
          ),
        ),
        updateItemBuilder: (context, animation, model) {
          final index = items.indexOf(model);
          return FadeTransition(
            opacity: animation,
            child: options.itemBuilder!(
              context,
              model.item,
              index,
            ),
          );
        },
      ),
    );
  }
}
