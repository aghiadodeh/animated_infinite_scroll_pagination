import 'package:animated_infinite_scroll_pagination/src/models/response_state/response_state.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/layouts/animated_infinite_scrollview.dart';
import 'package:flutter/material.dart';
import '../../models/custom_widget/sliver_custom_widget.dart';
import '../../models/pagination.model/pagination_model.dart';
import '../../types/types.dart';

class AnimatedInfinitePaginationOptions<T> {
  /// builder of each item in list.
  /// width of [itemBuilder] is required when [gridDelegate] == null and [scrollDirection] == [Axis.horizontal]
  final AnimatedInfiniteItemBuilder<T>? itemBuilder;

  /// pass [topWidgets] when you want to place a widget at the top of the first [itemBuilder] widget.
  final List<SliverCustomWidget>? topWidgets;

  /// [loadingWidget] is a widget appears when first page is in loading state.
  final Widget? loadingWidget;

  /// [errorWidget] is a widget appears in the bottom of the scrollView when an exception thrown in pagingController.
  final Widget? errorWidget;

  /// [footerLoadingWidget] is a widget appears when user scroll to bottom of the [AnimatedInfiniteScrollView]
  /// and the nextPage data is in loading state.
  final Widget? footerLoadingWidget;

  /// [noItemsWidget] is a widget appears after fetch first page data and the result is empty
  final Widget? noItemsWidget;

  /// warp [ScrollView] in [RefreshIndicator] when [refreshIndicator] == `true`
  final bool refreshIndicator;

  /// callback called when user swipe refresh to load new list
  final Function()? onRefresh;

  /// Scroll Direction default value is [Axis.vertical]
  /// width of [itemBuilder] is required when [gridDelegate] == null and [scrollDirection] == [Axis.horizontal]
  final Axis scrollDirection;

  /// A delegate that controls the layout of the children within the [GridView].
  final SliverGridDelegate? gridDelegate;

  /// Custom Sliver [Widget] inside [AnimatedInfiniteScrollView]
  final Widget Function(BuildContext context, List<PaginationModel<T>>)? customSliverChild;

  /// Whether to spawn a new isolate on which to calculate the diff on.
  ///
  /// Usually you wont have to specify this value as the MyersDiff implementation will
  /// use its own metrics to decide, whether a new isolate has to be spawned or not for
  /// optimal performance.
  final bool? spawnIsolate;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// How the scroll view should respond to user input.
  /// If an explicit [ScrollBehavior] is provided to [scrollBehavior], the
  /// [ScrollPhysics] provided by that behavior will take precedence after
  /// [physics].
  final ScrollPhysics? physics;

  /// {@macro flutter.widgets.shadow.scrollBehavior}
  ///
  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// Whether the scroll view scrolls in the reading direction.
  final bool reverse;

  /// [AnimatedInfiniteScrollView] padding
  final EdgeInsets padding;

  /// [AnimatedInfiniteScrollView] always scroll by [scrollOffset]
  /// when paging state is [PaginationLoadingState] is [PaginationStateEnum.loading] or [PaginationStateEnum.error],
  ///
  /// which will make [footerLoadingWidget] appearing, you can set [scrollOffset] as [footerLoadingWidget] size
  final double scrollOffset;

  const AnimatedInfinitePaginationOptions({
    this.itemBuilder,
    this.topWidgets,
    this.loadingWidget,
    this.errorWidget,
    this.footerLoadingWidget,
    this.noItemsWidget,
    this.refreshIndicator = true,
    this.onRefresh,
    this.scrollDirection = Axis.vertical,
    this.gridDelegate,
    this.customSliverChild,
    this.spawnIsolate,
    this.cacheExtent,
    this.physics,
    this.scrollBehavior,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    this.padding = EdgeInsets.zero,
    this.scrollOffset = 100,
  });
}
