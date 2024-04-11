import 'package:animated_infinite_scroll_pagination/src/configuration/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

class PaginationLoaderWidget<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const PaginationLoaderWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder<bool>(
      data: configuration.viewModel.paginationParams.loading,
      builder: (context, loading) {
        if (loading && configuration.viewModel.paginationParams.total == 0 && configuration.viewModel.paginationParams.page == 1) {
          return configuration.loadingWidget ??
              const Center(
                child: CircularProgressIndicator.adaptive(),
              );
        }
        return const SizedBox();
      },
    );
  }
}
