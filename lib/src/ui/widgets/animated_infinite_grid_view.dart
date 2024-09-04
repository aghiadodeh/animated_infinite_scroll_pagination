import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../models/pagination.model/pagination_model.dart';

class AnimatedInfiniteGridView<T> extends StatelessWidget {
  final AnimatedInfinitePaginationController<T> controller;
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfiniteGridView({
    required this.controller,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (options.itemBuilder == null || options.gridDelegate == null) return const SizedBox();

    return LiveDataBuilder<List<PaginationModel<T>>>(
      data: controller.items,
      builder: (context, items) => SliverGrid(
        gridDelegate: options.gridDelegate!,
        delegate: SliverChildBuilderDelegate(
          childCount: items.length,
          (BuildContext context, int index) {
            return options.itemBuilder!(context, items[index].item, index);
          },
        ),
      ),
    );
  }
}
