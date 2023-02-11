import 'package:flutter/material.dart' hide AnimatedItemBuilder;
import 'package:flutterx_live_data/flutterx_live_data.dart';

import '../models/pagination_model.dart';

class PaginationError extends StatelessWidget {
  final PaginationParams paginationParams;
  final Widget? errorWidget;
  const PaginationError({required this.paginationParams, required this.errorWidget, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: LiveDataBuilder<bool>(
          data: paginationParams.error,
          builder: (context, error) {
            if (error) {
              return errorWidget ?? const Text("Error");
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
