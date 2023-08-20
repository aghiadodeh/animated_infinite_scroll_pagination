import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/list/pagination_animated_grid_widget.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/list/pagination_animated_list_widget.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/widgets/full_size_scrollview.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/widgets/pagination_footer_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../configuration/configuration.dart';
import '../widgets/state_widget.dart';

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
    return FullSizeScrollView(
      configuration: configuration,
      child: builder(
        children: [
          configuration.topWidget ?? const SizedBox(),
          Builder(
            builder: (context) {
              if (configuration.child != null) {
                return LiveDataBuilder<List<PaginationModel<T>>>(
                  data: configuration.viewModel.paginationParams.itemsList,
                  builder: (context, items) => configuration.child!(items),
                );
              } else if (configuration.gridDelegate != null) {
                return PaginationAnimatedGridWidget(configuration);
              } else {
                return PaginationAnimatedListWidget(configuration);
              }
            },
          ),
          StateWidget(configuration),
          PaginationFooterLoaderWidget(configuration),
          const SizedBox(),
        ],
      ),
    );
  }
}
