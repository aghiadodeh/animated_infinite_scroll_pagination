import 'package:flutter/material.dart';

import '../../configuration/configuration.dart';
import 'app_progress_bar.dart';

class StateWidget<T> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;
  final bool idle;
  final bool noItemsFound;
  final bool error;

  const StateWidget(this.configuration,
      {Key? key,
      required this.idle,
      required this.noItemsFound,
      required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: idle
              ? configuration.loadingWidget ??
                  const Center(
                    key: ValueKey('AppProgressBar'),
                    child: AppProgressBar(),
                  )
              : error
                  ? configuration.errorWidget ?? const SizedBox.shrink()
                  : noItemsFound
                      ? configuration.noItemsWidget ?? const SizedBox.shrink()
                      : const SizedBox.shrink()),
    );
  }
}
