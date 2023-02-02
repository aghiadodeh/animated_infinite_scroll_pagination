import 'package:animated_infinite_scroll_pagination/src/ui/grid_animated_list.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/implicitly_animated_list.dart';
import 'package:animated_infinite_scroll_pagination/src/ui/pagination_error.dart';
import '../models/pagination_model.dart';
import 'pagination_scroll_view.dart';
import '../viewmodels/pagination_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';
import 'pagination_loader.dart';

class AnimatedPaginationScrollView<T extends Object> extends StatelessWidget {
  final PaginationViewModel<T> viewModel;
  final ScrollPhysics? physics;
  final Widget Function(T) itemBuilder;
  final Widget? topWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? footerLoadingWidget;
  final Widget? noItemsWidget;
  final Axis scrollDirection;
  final SliverGridDelegate? gridDelegate;
  final Widget Function(PaginationEquatable<T>)? child;

  const AnimatedPaginationScrollView({
    required this.viewModel,
    required this.itemBuilder,
    required this.topWidget,
    required this.footerLoadingWidget,
    required this.loadingWidget,
    required this.errorWidget,
    required this.physics,
    required this.scrollDirection,
    required this.gridDelegate,
    required this.noItemsWidget,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget builder({required List<Widget> children}) {
      if (scrollDirection == Axis.horizontal) {
        return Row(children: children);
      } else {
        return Column(children: children);
      }
    }

    return PaginationScrollView(
      key: UniqueKey(),
      physics: physics,
      paginationParams: viewModel.paginationParams,
      loadingWidget: loadingWidget,
      scrollDirection: scrollDirection,
      child: builder(
        children: [
          if (topWidget != null) topWidget!,
          LiveDataBuilder<PaginationEquatable<T>>(
            key: UniqueKey(),
            data: viewModel.paginationParams.itemsList,
            builder: (context, list) {
              if (list.items.isEmpty && noItemsWidget != null) return noItemsWidget!;
              if (child != null) return child!.call(list);
              if (gridDelegate == null) {
                return AppImplicitlyAnimatedList(
                  list: list,
                  viewModel: viewModel,
                  itemBuilder: itemBuilder,
                  scrollDirection: scrollDirection,
                );
              } else {
                return AnimatedGridList(
                  list: list,
                  viewModel: viewModel,
                  itemBuilder: itemBuilder,
                  gridDelegate: gridDelegate!,
                  scrollDirection: scrollDirection,
                );
              }
            },
          ),
          PaginationError(
            paginationParams: viewModel.paginationParams,
            errorWidget: errorWidget,
          ),
          PaginationLoader(
            paginationParams: viewModel.paginationParams,
            loadingWidget: footerLoadingWidget,
          ),
        ],
      ),
    );
  }
}
