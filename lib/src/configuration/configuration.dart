import 'package:animated_infinite_scroll_pagination/animated_infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';

class AnimatedPaginationConfiguration<T, E extends Exception> {
  final PaginationViewModel<T, E> viewModel;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext context, int index, T item)? itemBuilder;
  final Widget Function(BuildContext context, int index, T item)?
      separatorBuilder;
  final Widget? header;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? footerLoadingWidget;
  final Widget? noItemsWidget;
  final Axis scrollDirection;
  final SliverGridDelegate? gridDelegate;
  final Widget Function(BuildContext context, List<PaginationModel<T>>)? child;
  final EdgeInsetsGeometry? padding;
  final bool? spawnIsolate;
  final bool? sliverHeader;
  final bool implicitlyAnimated;
  final ScrollController? controller;
  final bool shrinkWrap;

  AnimatedPaginationConfiguration({
    required this.viewModel,
    required this.shrinkWrap,
    required this.itemBuilder,
    required this.controller,
    required this.scrollDirection,
    required this.gridDelegate,
    required this.child,
    required this.header,
    required this.footerLoadingWidget,
    required this.loadingWidget,
    required this.errorWidget,
    required this.physics,
    required this.noItemsWidget,
    required this.padding,
    required this.spawnIsolate,
    required this.separatorBuilder,
    required this.sliverHeader,
    required this.implicitlyAnimated,
  }) {
    assert((child != null || itemBuilder != null) &&
        !(child != null && itemBuilder != null));
  }
}
