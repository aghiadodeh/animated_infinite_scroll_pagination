import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/list/pagination_animated_grid_widget.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/list/pagination_animated_list_widget.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/widgets/full_size_scrollview.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/widgets/pagination_error_widget.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/widgets/pagination_footer_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../configuration/configuration.dart';

class AnimatedPaginationScrollView<T extends Object> extends StatefulWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const AnimatedPaginationScrollView(this.configuration, {Key? key}) : super(key: key);

  @override
  State<AnimatedPaginationScrollView<T>> createState() => _AnimatedPaginationScrollViewState<T>();
}

class _AnimatedPaginationScrollViewState<T extends Object> extends State<AnimatedPaginationScrollView<T>> {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // scroll view
        FullSizeScrollView(
          configuration: configuration,
          child: builder(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              configuration.topWidget ?? const SizedBox(),
              Builder(
                builder: (context) {
                  if (configuration.child != null) {
                    return LiveDataBuilder<List<PaginationModel<T>>>(
                      data: configuration.viewModel.paginationParams.itemsList,
                      builder: (context, items) => configuration.child!(context, items),
                    );
                  } else if (configuration.gridDelegate != null) {
                    return PaginationAnimatedGridWidget(configuration);
                  } else {
                    return PaginationAnimatedListWidget(configuration);
                  }
                },
              ),
              PaginationFooterLoaderWidget(configuration),
              PaginationErrorWidget(configuration),
            ],
          ),
        ),

        // loading widget
        LiveDataBuilder<bool>(
          data: configuration.viewModel.paginationParams.loading,
          builder: (context, loading) {
            if (loading && configuration.viewModel.paginationParams.total == 0 && configuration.viewModel.paginationParams.page == 1) {
              return configuration.loadingWidget ?? const CircularProgressIndicator.adaptive();
            }
            return const SizedBox();
          },
        ),

        // no items widget
        LiveDataBuilder<bool>(
          data: configuration.viewModel.paginationParams.noItemsFound,
          builder: (context, noItemsFound) {
            if (noItemsFound && configuration.noItemsWidget != null) {
              return configuration.noItemsWidget!;
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
/*
return FullSizeScrollView(
      configuration: configuration,
      child: LiveDataBuilder<bool>(
        data: configuration.viewModel.paginationParams.idle,
        builder: (context, idle) => builder(
          mainAxisAlignment: idle ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
          children: [
            configuration.topWidget ?? const SizedBox(),
            Builder(
              builder: (context) {
                if (idle) {
                  return PaginationLoaderWidget(configuration);
                } else if (configuration.child != null) {
                  return LiveDataBuilder<List<PaginationModel<T>>>(
                    data: configuration.viewModel.paginationParams.itemsList,
                    builder: (context, items) => configuration.child!(context, items),
                  );
                } else if (configuration.gridDelegate != null) {
                  return PaginationAnimatedGridWidget(configuration);
                } else {
                  return PaginationAnimatedListWidget(configuration);
                }
              },
            ),
            if (!idle) StateWidget(configuration),
            PaginationFooterLoaderWidget(configuration),
            if (idle) const SizedBox(),
          ],
        ),
      ),
    );
 */