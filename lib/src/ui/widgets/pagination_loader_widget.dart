import 'package:animated_infinite_scroll_pagination/src/configuration/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

import 'app_progress_bar.dart';

class PaginationLoaderWidget<T, E extends Exception> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T, E> configuration;

  const PaginationLoaderWidget(this.configuration, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder<bool>(
      data: configuration.viewModel.paginationParams.loading,
      builder: (context, loading) => Visibility(
        visible: loading &&
            configuration.viewModel.paginationParams.total == 0 &&
            configuration.viewModel.paginationParams.page == 1,
        child: configuration.loadingWidget ??
            const Center(child: AppProgressBar()),
      ),
    );
  }
}
