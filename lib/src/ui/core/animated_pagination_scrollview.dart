import 'package:animated_infinite_scroll_pagination/src/ui/list/pagination_animated_flex.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

import '../../configuration/configuration.dart';
import '../list/pagination_animated_sliver.dart';

class AnimatedPaginationScrollView<T extends Object> extends StatefulWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const AnimatedPaginationScrollView(this.configuration, {Key? key})
      : super(key: key);

  @override
  State<AnimatedPaginationScrollView<T>> createState() =>
      _AnimatedPaginationScrollViewState<T>();
}

class _AnimatedPaginationScrollViewState<T extends Object>
    extends State<AnimatedPaginationScrollView<T>> {
  AnimatedPaginationConfiguration<T> get configuration => widget.configuration;

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with4<bool, bool, bool, bool>(
      x1: configuration.viewModel.paginationParams.loading,
      x2: configuration.viewModel.paginationParams.noItemsFound,
      x3: configuration.viewModel.paginationParams.error,
      x4: configuration.viewModel.paginationParams.idle,
      builder: (context, loading, noItemsFound, error, idle) =>
          !(configuration.fixedTopWidget ?? false)
              ? Container(
                  padding: configuration.padding,
                  child: PaginationAnimatedSliver(
                    configuration: widget.configuration,
                    error: error,
                    idle: idle,
                    loading: loading,
                    noItemsFound: noItemsFound,
                  ),
                )
              : Container(
                  padding: configuration.padding,
                  child: PaginationAnimatedFlex(
                      configuration: configuration,
                      noItemsFound: noItemsFound,
                      loading: loading,
                      error: error,
                      idle: idle),
                ),
    );
  }
}
