import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

import '../../configuration/configuration.dart';

class StateWidget<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;
  const StateWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with2<bool, bool>(
      x1: configuration.viewModel.paginationParams.noItemsFound,
      x2: configuration.viewModel.paginationParams.error,
      builder: (context, noItemsFound, error) {
        if (error) {
          return configuration.errorWidget ?? const SizedBox();
        }
        if (noItemsFound && configuration.noItemsWidget != null) {
          return configuration.noItemsWidget!;
        }
        return const SizedBox();
      },
    );
  }
}
