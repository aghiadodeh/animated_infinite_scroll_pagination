import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../models/response_state/response_state.dart';

class AnimatedInfiniteCenterWidget<T> extends StatelessWidget {
  final AnimatedInfinitePaginationController<T> delegate;
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfiniteCenterWidget({
    required this.delegate,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with3(
      x1: delegate.items,
      x2: delegate.paginationState,
      x3: delegate.emptyList,
      builder: (context, items, paginationState, emptyList) {
        if (delegate.page == 1) {
          if (paginationState.state == PaginationStateEnum.loading) {
            // loading
            return options.loadingWidget ?? const CircularProgressIndicator.adaptive();
          } else if (paginationState.state == PaginationStateEnum.error) {
            // error
            return options.errorWidget ?? const SizedBox();
          } else if (emptyList) {
            // no items found
            return options.noItemsWidget ?? const SizedBox();
          }
        }

        return const SizedBox();
      },
    );
  }
}
