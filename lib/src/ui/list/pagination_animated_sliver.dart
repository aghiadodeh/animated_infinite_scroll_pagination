import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../animated_infinite_scroll_pagination.dart';
import '../../configuration/configuration.dart';
import '../widgets/pagination_footer_loader_widget.dart';
import '../widgets/state_widget.dart';
import '../widgets/item_flex.dart';

class PaginationAnimatedSliver<T> extends StatefulWidget {
  final AnimatedPaginationConfiguration<T> configuration;
  final bool error;
  final bool noItemsFound;
  final bool loading;
  final bool idle;

  const PaginationAnimatedSliver({super.key,
    required this.configuration,
    required this.error,
    required this.noItemsFound,
    required this.loading,
    required this.idle});

  @override
  State<PaginationAnimatedSliver<T>> createState() =>
      _PaginationAnimatedSliverState();
}

class _PaginationAnimatedSliverState<T>
    extends State<PaginationAnimatedSliver<T>> {
  AnimatedPaginationConfiguration<T> get configuration => widget.configuration;

  PaginationViewModel<T> get viewModel => widget.configuration.viewModel;

  final layoutRowKey = UniqueKey();
  final layoutColumnKey = UniqueKey();
  final layoutGridKey = UniqueKey();
  final layoutListKey = UniqueKey();
  final layoutScrollViewKey = UniqueKey();

  Widget builder({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) {
    if (configuration.scrollDirection == Axis.horizontal) {
      return Row(
          key: layoutRowKey,
          mainAxisAlignment: mainAxisAlignment,
          children: children);
    } else {
      return Column(
          key: layoutColumnKey,
          mainAxisAlignment: mainAxisAlignment,
          children: children);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder(
        data: configuration.viewModel.paginationParams.itemsList,
        builder: (context, list) {
          final hasCenteredState =
              widget.error || widget.noItemsFound || widget.idle;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: hasCenteredState
                ? builder(children: [
              if ((configuration.sliverTopWidget ?? false) &&
                  configuration.topWidget != null)
                CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: configuration.scrollDirection,
                  slivers: [
                    configuration.topWidget!,
                  ],
                ),
              if (!(configuration.sliverTopWidget ?? false))
                configuration.topWidget ?? const SizedBox.shrink(),
              StateWidget(
                configuration,
                noItemsFound: widget.noItemsFound,
                idle: widget.idle,
                error: widget.error,
              ),
            ])
                : CustomScrollView(
              key: layoutScrollViewKey,
              scrollDirection: configuration.scrollDirection,
              physics: widget.idle
                  ? const NeverScrollableScrollPhysics()
                  : configuration.physics,
              slivers: [
                if (!(configuration.sliverTopWidget ?? false) &&
                    (configuration.fixedTopWidget ?? false) &&
                    configuration.topWidget != null)
                  SliverPinnedHeader(child: configuration.topWidget!),
                if (!(configuration.sliverTopWidget ?? false) &&
                    !(configuration.fixedTopWidget ?? false))
                  SliverToBoxAdapter(child: configuration.topWidget),
                if ((configuration.sliverTopWidget ?? false) &&
                    configuration.topWidget != null)
                  configuration.topWidget!,
                SliverVisibility(
                  visible: !widget.idle,
                  maintainAnimation: true,
                  maintainState: true,
                  sliver: MultiSliver(
                    children: [
                      SliverLayoutBuilder(
                        builder: (context, _) {
                          if (configuration.child != null) {
                            return SliverToBoxAdapter(
                              child: configuration.child!(list),
                            );
                          } else if (configuration.gridDelegate != null) {
                            return SliverAnimatedGrid(
                                key: layoutGridKey,
                                initialItemCount: list.length,
                                itemBuilder: (context, index,
                                    animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: ItemFlex(
                                          configuration: configuration,
                                          index: index,
                                          model: list[index],
                                          totalItems: list.length),
                                    ),
                                gridDelegate:
                                configuration.gridDelegate!);
                          } else {
                            return SliverImplicitlyAnimatedList<
                                PaginationModel<T>>(
                                key: layoutListKey,
                                items: list,
                                updateItemBuilder:
                                    (context, animation, model) {
                                  final index = list.indexWhere((value) =>
                                      configuration.viewModel
                                          .areItemsTheSame(
                                          value.item, model.item));
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ItemFlex(
                                        configuration: configuration,
                                        index: index,
                                        model: model,
                                        totalItems: list.length),
                                  );
                                },
                                itemBuilder: (context, animation, item,
                                    index) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: ItemFlex(
                                          configuration: configuration,
                                          index: index,
                                          model: item,
                                          totalItems: list.length),
                                    ),
                                areItemsTheSame: (a, b) =>
                                    configuration
                                        .viewModel
                                        .areItemsTheSame(a.item, b.item));
                          }
                        },
                      ),
                      SliverToBoxAdapter(
                          child: PaginationFooterLoaderWidget(
                              configuration)),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
