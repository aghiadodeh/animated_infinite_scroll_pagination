import 'package:flutter/material.dart';

import '../../configuration/configuration.dart';
import '../sliver/pagination_animated_sliver.dart';

class AnimatedPaginationScrollView<T, E extends Exception>
    extends StatefulWidget {
  final AnimatedPaginationConfiguration<T, E> configuration;

  const AnimatedPaginationScrollView(this.configuration, {Key? key})
      : super(key: key);

  @override
  State<AnimatedPaginationScrollView<T, E>> createState() =>
      _AnimatedPaginationScrollViewState<T, E>();
}

class _AnimatedPaginationScrollViewState<T, E extends Exception>
    extends State<AnimatedPaginationScrollView<T, E>> {
  AnimatedPaginationConfiguration<T, E> get configuration =>
      widget.configuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: configuration.padding ?? EdgeInsets.zero,
      child: PaginationAnimatedSliver(
        configuration: widget.configuration,
      ),
    );
  }
}
