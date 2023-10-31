import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:animated_infinite_scroll_pagination/src/configuration/configuration.dart';
import 'package:flutter/material.dart';

import 'animated_pagination_scrollview.dart';

class AnimatedInfiniteScrollView<T, E extends Exception>
    extends StatefulWidget {
  /// class extends [PaginationViewModel].
  final PaginationViewModel<T, E> viewModel;

  /// ScrollPhysics of scrollView.
  final ScrollPhysics? physics;

  /// builder of each item in list.
  final Widget Function(BuildContext context, int index, T item)? itemBuilder;

  /// builder of items separator in list.
  final Widget Function(BuildContext context, int index, T item)?
      separatorBuilder;

  /// pass [header] when you want to place a widget at the top of the first [itemBuilder] widget.
  final Widget? header;

  /// [loadingWidget] is a widget appears when first page is in loading state.
  final Widget? loadingWidget;

  /// [errorWidget] is a widget appears in the bottom of the scrollView when an exception thrown in [viewModel].
  final Widget? errorWidget;

  /// [footerLoadingWidget] is a widget appears when user scroll to bottom of the [AnimatedPaginationScrollView]
  /// and the nextPage data is in loading state.
  final Widget? footerLoadingWidget;

  /// [noItemsWidget] is a widget appears after fetch first page data and the result is empty
  final Widget? noItemsWidget;

  /// warp [ScrollView] in [RefreshIndicator] when [refreshIndicator] == `true`
  final bool refreshIndicator;

  /// callback called when user swipe refresh to load new list
  final Function()? onRefresh;

  /// Scroll Direction default value is [Axis.vertical]
  final Axis scrollDirection;

  /// A delegate that controls the layout of the children within the [GridView].
  final SliverGridDelegate? gridDelegate;

  /// Custom [Widget] inside [AnimatedPaginationScrollView]
  final Widget Function(BuildContext context, List<PaginationModel<T>>)?
      childBuilder;

  /// scroll-view padding
  final EdgeInsetsGeometry? padding;

  /// Whether to spawn a new isolate on which to calculate the diff on.
  ///
  /// Usually you wont have to specify this value as the MyersDiff implementation will
  /// use its own metrics to decide, whether a new isolate has to be spawned or not for
  /// optimal performance.
  final bool? spawnIsolate;

  final bool? sliverHeader;

  final bool implicitlyAnimated;

  final ScrollController? controller;

  final bool shrinkWrap;

  const AnimatedInfiniteScrollView.builder({
    required this.viewModel,
    required final Widget Function(BuildContext context, int index, T item)
        builder,
    this.header,
    this.footerLoadingWidget,
    this.loadingWidget,
    this.errorWidget,
    this.noItemsWidget,
    this.physics,
    this.refreshIndicator = false,
    this.onRefresh,
    this.scrollDirection = Axis.vertical,
    this.gridDelegate,
    this.padding,
    this.spawnIsolate,
    Key? key,
    this.separatorBuilder,
    this.sliverHeader,
    this.implicitlyAnimated = true,
    this.controller,
    this.shrinkWrap = false,
  })  : childBuilder = null,
        itemBuilder = builder,
        super(key: key);

  const AnimatedInfiniteScrollView.child({
    required this.viewModel,
    required Widget Function(BuildContext context, List<PaginationModel<T>>)
        builder,
    this.header,
    this.footerLoadingWidget,
    this.loadingWidget,
    this.errorWidget,
    this.noItemsWidget,
    this.physics,
    this.refreshIndicator = false,
    this.onRefresh,
    this.scrollDirection = Axis.vertical,
    this.gridDelegate,
    this.padding,
    this.spawnIsolate,
    Key? key,
    this.separatorBuilder,
    this.sliverHeader,
    this.implicitlyAnimated = true,
    this.controller,
    this.shrinkWrap = false,
  })  : itemBuilder = null,
        childBuilder = builder,
        super(key: key);

  @override
  State<AnimatedInfiniteScrollView<T, E>> createState() =>
      _AnimatedInfiniteScrollViewState<T, E>();
}

class _AnimatedInfiniteScrollViewState<T, E extends Exception>
    extends State<AnimatedInfiniteScrollView<T, E>> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  AnimatedPaginationConfiguration<T, E> get configuration =>
      AnimatedPaginationConfiguration(
        shrinkWrap: widget.shrinkWrap,
        viewModel: widget.viewModel,
        controller: widget.controller,
        itemBuilder: widget.itemBuilder,
        child: widget.childBuilder,
        errorWidget: widget.errorWidget,
        footerLoadingWidget: widget.footerLoadingWidget,
        gridDelegate: widget.gridDelegate,
        loadingWidget: widget.loadingWidget,
        noItemsWidget: widget.noItemsWidget,
        physics: widget.physics,
        scrollDirection: widget.scrollDirection,
        header: widget.header,
        padding: widget.padding,
        spawnIsolate: widget.spawnIsolate,
        separatorBuilder: widget.separatorBuilder,
        implicitlyAnimated: widget.implicitlyAnimated,
        sliverHeader: widget.header == null ? null : widget.sliverHeader,
      );

  Future<void> _onRefresh() async {
    _refreshIndicatorKey.currentState?.show();
    widget.onRefresh?.call();
    widget.viewModel.refresh();
    await widget.viewModel.getPaginationList();
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      key: UniqueKey(),
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          if (widget.viewModel.paginationParams.page > 1 &&
              widget.viewModel.paginationParams.total == 0) {
            // do nothing
          } else {
            widget.viewModel.getPaginationList();
          }
        }
        return true;
      },
      child: widget.refreshIndicator
          ? RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _onRefresh,
              child: AnimatedPaginationScrollView(configuration),
            )
          : AnimatedPaginationScrollView(configuration),
    );
  }
}
