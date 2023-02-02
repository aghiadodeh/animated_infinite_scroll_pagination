import '../models/pagination_model.dart';
import 'pagination_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

class PaginationScrollView extends StatelessWidget {
  final PaginationParams paginationParams;
  final Widget child;
  final ScrollPhysics? physics;
  final Widget? loadingWidget;
  final Axis scrollDirection;

  const PaginationScrollView({
    required this.paginationParams,
    required this.child,
    this.physics,
    this.loadingWidget,
    this.scrollDirection = Axis.vertical,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          physics: physics ?? const AlwaysScrollableScrollPhysics(),
          scrollDirection: scrollDirection,
          child: ConstrainedBox(
            // expand child
            constraints: BoxConstraints(
              minHeight: constraint.maxHeight,
              minWidth: scrollDirection == Axis.horizontal ? constraint.maxWidth : double.infinity,
            ),
            child: CombinedLiveDataBuilder.with2<bool, PaginationEquatable, bool>(
              key: UniqueKey(),
              x1: paginationParams.loading,
              x2: paginationParams.itemsList,
              transform: (x1, x2) => x1 && x2.items.isEmpty && paginationParams.total == 0 && paginationParams.page == 1,
              builder: (context, value) {
                if (value) {
                  return loadingWidget ?? const Center(child: AppProgressBar());
                } else {
                  return child;
                }
              },
            ),
          ),
        );
      },
    );
  }
}
