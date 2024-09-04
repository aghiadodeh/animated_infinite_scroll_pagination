import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../widgets/animated_infinite_center_widget.dart';

class AnimatedInfiniteScrollView<T> extends StatefulWidget {
  /// instance from class that extends [AnimatedInfinitePaginationController]
  final AnimatedInfinitePaginationController<T> delegate;

  /// configuration of animated infinite scrollView
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfiniteScrollView({
    required this.delegate,
    required this.options,
    super.key,
  });

  @override
  State<AnimatedInfiniteScrollView<T>> createState() => _AnimatedInfiniteScrollViewState<T>();
}

class _AnimatedInfiniteScrollViewState<T> extends State<AnimatedInfiniteScrollView<T>> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverStack(
            insetOnOverlap: false, // defaults to false,
            children: [
              MultiSliver(
                children: [
                  SliverPositioned.fill(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 8,
                            color: Colors.black26,
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )
            ]),
      ],
    );
    // return LayoutBuilder(
    //   builder: (context, constraints) => Container(),
    // );
  }
}
