import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../animated_infinite_scroll_pagination.dart';
import '../../configuration/configuration.dart';
import '../widgets/item_flex.dart';
import '../widgets/pagination_footer_loader_widget.dart';
import '../widgets/state_widget.dart';

class PaginationAnimatedSliver<T, E extends Exception> extends StatefulWidget {
  final AnimatedPaginationConfiguration<T, E> configuration;

  const PaginationAnimatedSliver({super.key, required this.configuration});

  @override
  State<PaginationAnimatedSliver<T, E>> createState() =>
      _PaginationAnimatedSliverState<T, E>();
}

class _PaginationAnimatedSliverState<T, E extends Exception>
    extends State<PaginationAnimatedSliver<T, E>> {
  AnimatedPaginationConfiguration<T, E> get configuration =>
      widget.configuration;

  PaginationViewModel<T, E> get viewModel => widget.configuration.viewModel;

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with5(
        x1: configuration.viewModel.paginationParams.loading,
        x2: configuration.viewModel.paginationParams.noItemsFound,
        x3: configuration.viewModel.paginationParams.error,
        x4: configuration.viewModel.paginationParams.idle,
        x5: configuration.viewModel.paginationParams.itemsList,
        builder: (context, loading, noItemsFound, error, idle, list) {
          final hasCenteredState = error != null || noItemsFound || idle;
          return CustomScrollView(
            scrollDirection: configuration.scrollDirection,
            controller: configuration.controller,
            physics: configuration.physics,
            shrinkWrap: configuration.shrinkWrap,
            slivers: [
              if (!(configuration.sliverHeader ?? false))
                SliverToBoxAdapter(child: configuration.header),
              if ((configuration.sliverHeader ?? false) &&
                  configuration.header != null)
                configuration.header!,
              SliverVisibility(
                visible: !hasCenteredState,
                maintainAnimation: true,
                maintainState: true,
                sliver: SliverMainAxisGroup(
                  slivers: [
                    SliverLayoutBuilder(
                      builder: (context, _) {
                        if (configuration.child != null) {
                          return SliverToBoxAdapter(
                            child: configuration.child!(context, list),
                          );
                        } else if (configuration.gridDelegate != null) {
                          if (configuration.implicitlyAnimated) {
                            return SliverImplicitlyAnimatedGrid<
                                PaginationModel<T>>(
                              items: list,
                              updateItemBuilder: (context, animation, model) {
                                final index = list.indexWhere((value) =>
                                    configuration.viewModel.areItemsTheSame(
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
                              itemBuilder: (context, animation, item, index) =>
                                  FadeTransition(
                                opacity: animation,
                                child: ItemFlex(
                                    configuration: configuration,
                                    index: index,
                                    model: item,
                                    totalItems: list.length),
                              ),
                              areItemsTheSame: (a, b) => configuration.viewModel
                                  .areItemsTheSame(a.item, b.item),
                              gridDelegate: configuration.gridDelegate!,
                            );
                          }
                          return SliverGrid.builder(
                              gridDelegate: configuration.gridDelegate!,
                              itemBuilder: (context, index) => ItemFlex(
                                  configuration: configuration,
                                  index: index,
                                  model: list[index],
                                  totalItems: list.length),
                              itemCount: list.length);
                        } else {
                          if (configuration.implicitlyAnimated) {
                            return SliverImplicitlyAnimatedList<
                                    PaginationModel<T>>(
                                items: list,
                                updateItemBuilder: (context, animation, model) {
                                  final index = list.indexWhere((value) =>
                                      configuration.viewModel.areItemsTheSame(
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
                                itemBuilder:
                                    (context, animation, item, index) =>
                                        FadeTransition(
                                          opacity: animation,
                                          child: ItemFlex(
                                              configuration: configuration,
                                              index: index,
                                              model: item,
                                              totalItems: list.length),
                                        ),
                                areItemsTheSame: (a, b) => configuration
                                    .viewModel
                                    .areItemsTheSame(a.item, b.item));
                          }
                          return SliverList.builder(
                              itemBuilder: (context, index) => ItemFlex(
                                  configuration: configuration,
                                  index: index,
                                  model: list[index],
                                  totalItems: list.length),
                              itemCount: list.length);
                        }
                      },
                    ),
                    SliverToBoxAdapter(
                        child: PaginationFooterLoaderWidget(configuration)),
                  ],
                ),
              ),
              SliverAnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                reverseDuration: const Duration(milliseconds: 1),
                child: hasCenteredState
                    ? SliverLayoutBuilder(
                        builder: (BuildContext context,
                            SliverConstraints constraints) {
                          return SliverToBoxAdapter(
                            child: SizedBox(
                                height: configuration.scrollDirection ==
                                        Axis.vertical
                                    ? constraints.remainingPaintExtent.clamp(
                                        0, MediaQuery.of(context).size.height)
                                    : double.infinity,
                                width: configuration.scrollDirection ==
                                        Axis.horizontal
                                    ? constraints.remainingPaintExtent.clamp(
                                        0, MediaQuery.of(context).size.width)
                                    : double.infinity,
                                child: StateWidget(
                                  configuration,
                                  noItemsFound: noItemsFound,
                                  idle: idle,
                                  error: error,
                                )),
                          );
                        },
                      )
                    : const SliverToBoxAdapter(),
              )
            ],
          );
        });
  }
}
