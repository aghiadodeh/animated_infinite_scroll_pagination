import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/widgets/ItemFlex.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

import '../../configuration/configuration.dart';

class PaginationAnimatedGridWidget<T> extends StatefulWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const PaginationAnimatedGridWidget(this.configuration, {Key? key})
      : super(key: key);

  @override
  State<PaginationAnimatedGridWidget<T>> createState() =>
      _PaginationAnimatedGridWidgetState<T>();
}

class _PaginationAnimatedGridWidgetState<T>
    extends State<PaginationAnimatedGridWidget<T>> {
  PaginationViewModel<T> get viewModel => widget.configuration.viewModel;

  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder<List<PaginationModel<T>>>(
      data: viewModel.paginationParams.itemsList,
      builder: (context, list) => GridView.builder(
        key: const Key("itemsList"),
        gridDelegate: widget.configuration.gridDelegate!,
        physics: widget.configuration.physics,
        itemCount: list.length,
        scrollDirection: widget.configuration.scrollDirection,
        itemBuilder: (context, index) {
          return ItemFlex(
              configuration: widget.configuration,
              index: index,
              model: list[index],
              totalItems: list.length);
        },
      ),
    );
  }
}
