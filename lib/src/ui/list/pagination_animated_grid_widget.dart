import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../configuration/configuration.dart';
import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';

class PaginationAnimatedGridWidget<T extends Object> extends StatefulWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const PaginationAnimatedGridWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  State<PaginationAnimatedGridWidget<T>> createState() => _PaginationAnimatedGridWidgetState<T>();
}

class _PaginationAnimatedGridWidgetState<T extends Object> extends State<PaginationAnimatedGridWidget<T>> {
  PaginationViewModel<T> get viewModel => widget.configuration.viewModel;

  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder<List<PaginationModel<T>>>(
      data: viewModel.paginationParams.itemsList,
      builder: (context, list) => GridView.builder(
        key: const Key("itemsList"),
        gridDelegate: widget.configuration.gridDelegate!,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        scrollDirection: widget.configuration.scrollDirection,
        itemBuilder: (context, index) {
          return widget.configuration.itemBuilder?.call(index, list[index].item);
        },
      ),
    );
  }
}
