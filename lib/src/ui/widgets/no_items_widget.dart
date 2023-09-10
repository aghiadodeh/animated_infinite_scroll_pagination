import 'package:animated_infinite_scroll_pagination/src/configuration/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

class NoItemsWidget<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const NoItemsWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder<bool>(
      data: configuration.viewModel.paginationParams.noItemsFound,
      builder: (context, value) => Visibility(
          visible: value, child: Center(child: configuration.noItemsWidget)),
    );
  }
}
