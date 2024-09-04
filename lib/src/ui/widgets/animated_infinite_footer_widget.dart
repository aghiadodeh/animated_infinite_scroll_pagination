import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../models/response_state/response_state.dart';

class AnimatedInfinitePaginationFooterWidget<T> extends StatelessWidget {
  final AnimatedInfinitePaginationController<T> delegate;
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfinitePaginationFooterWidget({
    required this.delegate,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with2(
      x1: delegate.items,
      x2: delegate.paginationState,
      builder: (context, items, paginationState) {
        if (items.isNotEmpty) {
          // loading widget
          if (paginationState.state == PaginationStateEnum.loading) {
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 350),
              child: options.footerLoadingWidget ?? CircularProgressIndicator.adaptive(),
              builder: (context, value, child) => Opacity(
                child: child,
                opacity: value,
              ),
            );
          } else if (paginationState.state == PaginationStateEnum.error) {
            // error widget
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 350),
              child: options.errorWidget ??
                  TextButton(
                    onPressed: delegate.fetchNewChunk,
                    child: Text(
                      "Error, Try Again",
                      style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                  ),
              builder: (context, value, child) => Opacity(
                child: child,
                opacity: value,
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
/*
return LiveDataBuilder<PaginationState<T>>(
      data: delegate.paginationState,
      builder: (context, paginationState) {
        if (paginationState.state == PaginationStateEnum.loading) {
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 350),
            child: options.footerLoadingWidget ?? CircularProgressIndicator.adaptive(),
            builder: (context, value, child) => Opacity(
              child: child,
              opacity: value,
            ),
          );
        } else if (paginationState.state == PaginationStateEnum.error) {
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 350),
            child: options.errorWidget ?? CircularProgressIndicator.adaptive(),
            builder: (context, value, child) => Opacity(
              child: child,
              opacity: value,
            ),
          );
        }

        return const SizedBox();
      },
    );
 */
