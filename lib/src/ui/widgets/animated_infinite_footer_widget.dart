import 'custom_animated_opacity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../models/response_state/response_state.dart';

class AnimatedInfinitePaginationFooterWidget<T> extends StatelessWidget {
  final AnimatedInfinitePaginationController<T> controller;
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfinitePaginationFooterWidget({
    required this.controller,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with2(
      x1: controller.items,
      x2: controller.paginationState,
      builder: (context, items, paginationState) {
        if (items.isNotEmpty) {
          // loading widget
          if (paginationState.state == PaginationStateEnum.loading) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomAnimatedOpacityWidget(
                    child: options.footerLoadingWidget ?? CircularProgressIndicator.adaptive(),
                  ),
                ),
              ],
            );
          } else if (paginationState.state == PaginationStateEnum.error) {
            // error widget
            return CustomAnimatedOpacityWidget(
              child: options.errorWidget ??
                  TextButton(
                    onPressed: controller.fetchNewChunk,
                    child: Text(
                      "Error, Try Again",
                      style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                  ),
            );
          }
        }
        return SizedBox(height: controller.lastPage ? 0 : 100);
      },
    );
  }
}