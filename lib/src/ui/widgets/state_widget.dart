import 'package:flutter/material.dart';

import '../../configuration/configuration.dart';
import 'app_progress_bar.dart';

class StateWidget<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;
  final bool loading;
  final bool noItemsFound;
  final bool error;

  const StateWidget(this.configuration,
      {Key? key,
      required this.loading,
      required this.noItemsFound,
      required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading &&
        configuration.viewModel.paginationParams.total == 0 &&
        configuration.viewModel.paginationParams.page == 1) {
      return configuration.loadingWidget ??
          const Center(child: AppProgressBar());
    }
    if (error) {
      return Expanded(
          child: configuration.errorWidget ?? const SizedBox.shrink());
    }
    if (noItemsFound) {
      return Expanded(child: Center(child: configuration.noItemsWidget));
    }
    return const SizedBox.shrink();
  }
}
