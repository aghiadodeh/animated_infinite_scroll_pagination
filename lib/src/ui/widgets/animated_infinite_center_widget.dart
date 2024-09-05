import 'custom_animated_opacity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../models/response_state/response_state.dart';

class AnimatedInfiniteCenterWidget<T> extends StatelessWidget {
  final AnimatedInfinitePaginationController<T> controller;
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfiniteCenterWidget({
    required this.controller,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with3(
      x1: controller.items,
      x2: controller.paginationState,
      x3: controller.emptyList,
      builder: (context, items, paginationState, emptyList) {
        if (controller.page == 1) {
          if (paginationState.state == PaginationStateEnum.loading && !controller.refreshing) {
            // loading
            return options.loadingWidget ??
                Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CustomAnimatedOpacityWidget(
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                  ),
                );
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
