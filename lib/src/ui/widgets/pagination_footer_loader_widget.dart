import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

import '../../configuration/configuration.dart';
import 'app_progress_bar.dart';

class PaginationFooterLoaderWidget<T, E extends Exception>
    extends StatelessWidget {
  final AnimatedPaginationConfiguration<T, E> configuration;

  const PaginationFooterLoaderWidget(this.configuration, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultipleLiveDataBuilder.with2<bool, List<PaginationModel>>(
      x1: configuration.viewModel.paginationParams.loading,
      x2: configuration.viewModel.paginationParams.itemsList,
      builder: (context, loading, itemsList) {
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 100),
          crossFadeState: loading &&
                  itemsList.isNotEmpty &&
                  !configuration.viewModel.paginationParams.isRefresh
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child:
                  configuration.footerLoadingWidget ?? const AppProgressBar(),
            ),
          ),
          secondChild: SizedBox(
              height: configuration.scrollDirection == Axis.vertical
                  ? configuration.viewModel.paginationParams.lastPage ||
                          itemsList.isEmpty
                      ? 0.0
                      : 70.0
                  : 0,
              width: configuration.scrollDirection == Axis.horizontal
                  ? configuration.viewModel.paginationParams.lastPage ||
                          itemsList.isEmpty
                      ? 0.0
                      : 70.0
                  : 0),
        );
      },
    );
  }
}
