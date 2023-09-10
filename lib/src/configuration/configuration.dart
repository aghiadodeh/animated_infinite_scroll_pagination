import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';

class AnimatedPaginationConfiguration<T extends Object> {
  final PaginationViewModel<T> viewModel;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext context, int index, T item)? itemBuilder;
  final Widget Function(BuildContext context, int index, T item)?
      separatorBuilder;
  final Widget? topWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? footerLoadingWidget;
  final Widget? noItemsWidget;
  final Axis scrollDirection;
  final SliverGridDelegate? gridDelegate;
  final Widget Function(List<PaginationModel<T>>)? child;
  final EdgeInsets? padding;
  final bool? spawnIsolate;
  final bool? fixedTopWidget;

  AnimatedPaginationConfiguration({
    required this.viewModel,
    required this.itemBuilder,
    required this.scrollDirection,
    required this.gridDelegate,
    required this.child,
    required this.topWidget,
    required this.footerLoadingWidget,
    required this.loadingWidget,
    required this.errorWidget,
    required this.physics,
    required this.noItemsWidget,
    required this.padding,
    required this.spawnIsolate,
    required this.separatorBuilder,
    required this.fixedTopWidget,
  }) {
    assert((child != null || itemBuilder != null) &&
        !(child != null && itemBuilder != null));
    assert((topWidget == null && fixedTopWidget == null) ||
        (topWidget != null && fixedTopWidget != null));
  }
}
