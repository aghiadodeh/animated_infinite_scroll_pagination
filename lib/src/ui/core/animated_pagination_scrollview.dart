import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/list/pagination_animated_grid_widget.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/list/pagination_animated_list_widget.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/widgets/pagination_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

import '../../configuration/configuration.dart';
import '../widgets/pagination_footer_loader_widget.dart';
import '../widgets/state_widget.dart';

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

  Widget builder({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) {
    if (configuration.scrollDirection == Axis.horizontal) {
      return Row(mainAxisAlignment: mainAxisAlignment, children: children);
    } else {
      return Column(mainAxisAlignment: mainAxisAlignment, children: children);
    }
  }

  Widget buildScrollLayout(BuildContext context, bool loading,
          bool noItemsFound, bool error, bool idle) =>
      builder(
        mainAxisAlignment:
            idle ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              final hasCenteredState = error || noItemsFound;
              if (idle) {
                return Expanded(child: PaginationLoaderWidget(configuration));
              } else if (configuration.child != null) {
                if (!hasCenteredState) {
                  return Expanded(
                    child: LiveDataBuilder<List<PaginationModel<T>>>(
                      data: configuration.viewModel.paginationParams.itemsList,
                      builder: (context, items) => configuration.child!(items),
                    ),
                  );
                }
              } else if (configuration.gridDelegate != null) {
                if (!hasCenteredState) {
                  return Expanded(
                      child: PaginationAnimatedGridWidget(configuration));
                }
              } else {
                if (!hasCenteredState) {
                  return Expanded(
                      child: PaginationAnimatedListWidget(configuration));
                }
              }
              return const SizedBox.shrink();
            },
          ),
          if (!idle)
            StateWidget(
              configuration,
              noItemsFound: noItemsFound,
              loading: loading,
              error: error,
            ),
          PaginationFooterLoaderWidget(configuration),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with4<bool, bool, bool, bool>(
      x1: configuration.viewModel.paginationParams.loading,
      x2: configuration.viewModel.paginationParams.noItemsFound,
      x3: configuration.viewModel.paginationParams.error,
      x4: configuration.viewModel.paginationParams.idle,
      builder: (context, loading, noItemsFound, error, idle) =>
          ((!(configuration.fixedTopWidget ?? false) &&
                      configuration.topWidget != null) ||
                  configuration.topWidget == null)
              ? CustomScrollView(
                  scrollDirection: configuration.scrollDirection,
                  physics: widget.configuration.physics,
                  slivers: [
                    SliverToBoxAdapter(child: configuration.topWidget),
                    SliverFillRemaining(
                      child: buildScrollLayout(
                          context, loading, noItemsFound, error, idle),
                    )
                  ],
                )
              : builder(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    configuration.topWidget!,
                    Expanded(
                        child: buildScrollLayout(
                            context, loading, noItemsFound, error, idle))
                  ],
                ),
    );
  }
}
