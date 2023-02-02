import '../../animated_infinite_scroll_pagination.dart';
import 'animated_pagination_scroll.dart';
import 'package:flutter/material.dart';

class AnimatedInfiniteScrollView<T extends Object> extends StatefulWidget {
  /// class extends [PaginationViewModel].
  final PaginationViewModel<T> viewModel;

  /// ScrollPhysics of scrollView.
  final ScrollPhysics? physics;

  /// builder of each item in list.
  final Widget Function(T) itemBuilder;

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
  final Widget Function(PaginationEquatable<T>)? child;

  const AnimatedInfiniteScrollView({
    required this.viewModel,
    required this.itemBuilder,
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
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedInfiniteScrollView<T>> createState() => _AnimatedInfiniteScrollViewState<T>();
}

class _AnimatedInfiniteScrollViewState<T extends Object> extends State<AnimatedInfiniteScrollView<T>> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _onRefresh() async {
    _refreshIndicatorKey.currentState?.show();
    widget.onRefresh?.call();
    widget.viewModel.refresh();
    await widget.viewModel.getPaginationList();
    return Future.value();
  }

  Widget _buildScrollView() {
    return AnimatedPaginationScrollView(
      viewModel: widget.viewModel,
      itemBuilder: widget.itemBuilder,
      physics: widget.physics,
      loadingWidget: widget.loadingWidget,
      errorWidget: widget.errorWidget,
      topWidget: widget.topWidget,
      footerLoadingWidget: widget.footerLoadingWidget,
      gridDelegate: widget.gridDelegate,
      scrollDirection: widget.scrollDirection,
      noItemsWidget: widget.noItemsWidget,
      child: widget.child,
    );
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
              child: _buildScrollView(),
              onRefresh: _onRefresh,
            )
          : _buildScrollView(),
    );
  }
}
