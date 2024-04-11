import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import '../../configuration/configuration.dart';

class PaginationFooterLoaderWidget<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const PaginationFooterLoaderWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with2<bool, List<PaginationModel>>(
      x1: configuration.viewModel.paginationParams.loading,
      x2: configuration.viewModel.paginationParams.itemsList,
      builder: (context, loading, itemsList) {
        if (loading && itemsList.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: configuration.footerLoadingWidget ?? const CircularProgressIndicator.adaptive(),
            ),
          );
        } else {
          final size = configuration.viewModel.paginationParams.lastPage || itemsList.isEmpty ? 0.0 : 70.0;
          return SizedBox(height: size);
        }
      },
    );
  }
}
