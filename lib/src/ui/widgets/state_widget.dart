import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

import '../../configuration/configuration.dart';
import 'app_progress_bar.dart';

class StateWidget<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;
  const StateWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with3<bool, bool, bool>(
      x1: configuration.viewModel.paginationParams.loading,
      x2: configuration.viewModel.paginationParams.noItemsFound,
      x3: configuration.viewModel.paginationParams.error,
      builder: (context, loading, noItemsFound, error) {
        if (loading && configuration.viewModel.paginationParams.total == 0 && configuration.viewModel.paginationParams.page == 1) {
          return configuration.loadingWidget ?? const Center(child: AppProgressBar());
        }
        if (error) {
          return configuration.errorWidget ?? const SizedBox();
        }
        if (noItemsFound) {
          return Center(child: configuration.noItemsWidget);
        }
        return const SizedBox();
      },
    );
  }
}
