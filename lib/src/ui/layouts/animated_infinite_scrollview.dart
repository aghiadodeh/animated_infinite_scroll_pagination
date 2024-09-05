import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../core/options/animated_infinite_pagination_options.dart';
import '../../core/controllers/animated_infinite_pagination_controller.dart';
import '../../models/response_state/response_state.dart';
import '../widgets/animated_infinite_center_widget.dart';
import '../widgets/animated_infinite_footer_widget.dart';
import '../widgets/animated_infinite_grid_view.dart';
import '../widgets/animated_infinite_list_view.dart';

class AnimatedInfiniteScrollView<T> extends StatefulWidget {
  /// instance from class that extends [AnimatedInfinitePaginationController]
  final AnimatedInfinitePaginationController<T> controller;

  /// configuration of animated infinite scrollView
  final AnimatedInfinitePaginationOptions<T> options;

  const AnimatedInfiniteScrollView({
    required this.controller,
    required this.options,
    super.key,
  });

  @override
  State<AnimatedInfiniteScrollView<T>> createState() => AnimatedInfiniteScrollViewState<T>();
}

class AnimatedInfiniteScrollViewState<T> extends State<AnimatedInfiniteScrollView<T>> with ObserverMixin {
  final scrollController = ScrollController();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    doRegister();
    scrollController.addListener(observeScrollOffset);
  }

  /// handle swipe refresh event
  Future<void> onRefresh() async {
    final controller = widget.controller;
    if (controller.paginationState.value.state != PaginationStateEnum.loading) {
      refreshIndicatorKey.currentState?.show();
      controller.refresh();
      await controller.fetchNewChunk();
    }
  }

  /// listen on infinite scroll
  void observeScrollOffset() {
    final currentOffset = scrollController.offset;
    final maxOffset = scrollController.position.maxScrollExtent;

    if (currentOffset == maxOffset) {
      final controller = widget.controller;
      final page = controller.page;
      final total = controller.total;
      final paginationState = controller.paginationState.value;

      if (!(page > 1 && total == 0) && paginationState.state != PaginationStateEnum.loading) {
        // request new chunk of data
        controller.fetchNewChunk();
      }
    }
  }

  @override
  FutureOr<void> registerObservers() {
    widget.controller.paginationState.observe(this, observePaginationState);
  }

  void observePaginationState(PaginationState<T> paginationState) {
    final controller = widget.controller;
    if (paginationState.state == PaginationStateEnum.loading || paginationState.state == PaginationStateEnum.error) {
      final items = controller.items.value;
      // jump to bottom of scrollView
      if (scrollController.hasClients && items.isNotEmpty && !controller.refreshing) {
        Future.delayed(
          const Duration(milliseconds: 100),
          scrollBottom,
        );
      }
    } else if (scrollController.hasClients && paginationState is PaginationSuccessState && controller.lastPage) {
      Future.delayed(
        const Duration(milliseconds: 200),
        scrollBy,
      );
    }
  }

  void scrollBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void scrollBy({int offset = 100}) {
    try {
      scrollController.animateTo(
        scrollController.offset + offset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void dispose() {
    doUnregister();
    scrollController.removeListener(observeScrollOffset);
    scrollController.dispose();
    super.dispose();
  }

  Widget get animatedInfiniteScrollView {
    final options = widget.options;
    final topWidgets = widget.options.topWidgets;
    return Stack(
      children: [
        /// fill viewPort
        CustomScrollView(
          controller: scrollController,
          scrollDirection: widget.options.scrollDirection,
          slivers: [
            /// top widget
            if (topWidgets != null)
              ...topWidgets
                  .map(
                    (topWidget) => topWidget.isSliver ? topWidget.child : SliverToBoxAdapter(child: topWidget.child),
                  )
                  .toList(),

            /// custom sliver child
            if (options.itemBuilder == null && options.customSliverChild != null)
              LiveDataBuilder(
                data: widget.controller.items,
                builder: (context, items) => options.customSliverChild!(context, items),
              ),

            /// gridView
            if (options.itemBuilder != null && options.gridDelegate != null)
              AnimatedInfiniteGridView(
                controller: widget.controller,
                options: widget.options,
              ),

            /// listView
            if (options.itemBuilder != null && options.gridDelegate == null)
              AnimatedInfiniteListView(
                controller: widget.controller,
                options: widget.options,
              ),

            /// footer
            SliverToBoxAdapter(
              child: AnimatedInfinitePaginationFooterWidget(
                controller: widget.controller,
                options: widget.options,
              ),
            ),
          ],
        ),

        /// center state widget
        Positioned.fill(
          child: AnimatedInfiniteCenterWidget(
            controller: widget.controller,
            options: widget.options,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.options.refreshIndicator
        ? RefreshIndicator(
            onRefresh: onRefresh,
            key: refreshIndicatorKey,
            child: animatedInfiniteScrollView,
          )
        : animatedInfiniteScrollView;
  }
}
