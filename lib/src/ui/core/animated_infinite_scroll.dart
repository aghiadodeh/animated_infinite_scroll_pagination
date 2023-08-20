import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:animated_infinite_scroll_pagination/src/configuration/configuration.dart';
import 'package:flutter/material.dart';
import 'animated_pagination_scrollview.dart';

class AnimatedInfiniteScrollView<T extends Object> extends StatefulWidget {
  /// class extends [PaginationViewModel].
  final PaginationViewModel<T> viewModel;

  /// ScrollPhysics of scrollView.
  final ScrollPhysics? physics;

  /// builder of each item in list.
  final Widget Function(int index, T item)? itemBuilder;

  /// pass [topWidget] when you want to place a widget at the top of the first [itemBuilder] widget.
  final Widget? topWidget;

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
  final Widget Function(List<PaginationModel<T>>)? child;

  /// scroll-view padding
  final EdgeInsets? padding;

  /// Whether to spawn a new isolate on which to calculate the diff on.
  ///
  /// Usually you wont have to specify this value as the MyersDiff implementation will
  /// use its own metrics to decide, whether a new isolate has to be spawned or not for
  /// optimal performance.
  final bool? spawnIsolate;

  const AnimatedInfiniteScrollView({
    required this.viewModel,
    this.itemBuilder,
    this.topWidget,
    this.footerLoadingWidget,
    this.loadingWidget,
    this.errorWidget,
    this.noItemsWidget,
    this.physics,
    this.refreshIndicator = false,
    this.onRefresh,
    this.scrollDirection = Axis.vertical,
    this.gridDelegate,
    this.child,
    this.padding,
    this.spawnIsolate,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedInfiniteScrollView<T>> createState() => _AnimatedInfiniteScrollViewState<T>();
}

class _AnimatedInfiniteScrollViewState<T extends Object> extends State<AnimatedInfiniteScrollView<T>> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  AnimatedPaginationConfiguration<T> get configuration => AnimatedPaginationConfiguration(
        viewModel: widget.viewModel,
        itemBuilder: widget.itemBuilder,
        child: widget.child,
        errorWidget: widget.errorWidget,
        footerLoadingWidget: widget.footerLoadingWidget,
        gridDelegate: widget.gridDelegate,
        loadingWidget: widget.loadingWidget,
        noItemsWidget: widget.noItemsWidget,
        physics: widget.physics,
        scrollDirection: widget.scrollDirection,
        topWidget: widget.topWidget,
        padding: widget.padding,
        spawnIsolate: widget.spawnIsolate,
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
        if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
          if (widget.viewModel.paginationParams.page > 1 && widget.viewModel.paginationParams.total == 0) {
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
              child: AnimatedPaginationScrollView(configuration),
              onRefresh: _onRefresh,
            )
          : AnimatedPaginationScrollView(configuration),
    );
  }
}
