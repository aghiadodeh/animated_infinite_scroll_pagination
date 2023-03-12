import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'app_progress_bar.dart';
import '../../configuration/configuration.dart';

class PaginationFooterLoaderWidget<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const PaginationFooterLoaderWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CombinedLiveDataBuilder.with2<bool, List<PaginationModel>, bool>(
      x1: configuration.viewModel.paginationParams.loading,
      x2: configuration.viewModel.paginationParams.itemsList,
      transform: (x1, x2) => x1 && x2.isNotEmpty,
      builder: (context, value) {
        if (value) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: configuration.loadingWidget ?? const AppProgressBar(),
            ),
          );
        } else {
          final size = configuration.viewModel.paginationParams.lastPage ? 0.0 : 70.0;
          return SizedBox(height: size);
        }
      },
    );
  }
}
