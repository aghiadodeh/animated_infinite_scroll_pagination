import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../models/pagination.model/pagination_model.dart';

class AnimatedInfiniteGridview<T> extends StatelessWidget {
  final AnimatedInfinitePaginationController<T> delegate;
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfiniteGridview({
    required this.delegate,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (options.itemBuilder == null || options.gridDelegate == null) return const SizedBox();

    return LiveDataBuilder<List<PaginationModel<T>>>(
      data: delegate.items,
      builder: (context, items) => GridView.builder(
        itemCount: items.length,
        padding: options.padding,
        physics: options.physics,
        reverse: options.reverse,
        shrinkWrap: options.shrinkWrap,
        gridDelegate: options.gridDelegate!,
        scrollDirection: options.scrollDirection,
        itemBuilder: (context, index) => TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 350),
          child: options.itemBuilder!(
            context,
            items[index].item,
            index,
          ),
          builder: (context, value, child) => Opacity(
            child: child,
            opacity: value,
          ),
        ),
      ),
    );
  }
}
