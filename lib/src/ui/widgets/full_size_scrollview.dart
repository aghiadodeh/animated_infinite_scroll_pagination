import 'package:flutter/material.dart';

import '../../configuration/configuration.dart';

class FullSizeScrollView<T extends Object> extends StatelessWidget {
  final AnimatedPaginationConfiguration<T> configuration;
  final Widget child;

  const FullSizeScrollView({
    required this.configuration,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          physics:
              configuration.physics ?? const AlwaysScrollableScrollPhysics(),
          scrollDirection: configuration.scrollDirection,
          padding: configuration.padding,
          child: ConstrainedBox(
            // expand child
            constraints: BoxConstraints(
              minHeight: constraint.maxHeight,
              minWidth: configuration.scrollDirection == Axis.horizontal
                  ? constraint.maxWidth
                  : double.infinity,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
