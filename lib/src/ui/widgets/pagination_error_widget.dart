import 'package:animated_infinite_scroll_pagination/src/configuration/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

class PaginationErrorWidget<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;

  const PaginationErrorWidget(this.configuration, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: LiveDataBuilder<bool>(
          data: configuration.viewModel.paginationParams.error,
          builder: (context, error) {
            if (error) {
              return configuration.errorWidget ?? const SizedBox();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
