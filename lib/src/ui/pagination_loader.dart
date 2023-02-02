import '../models/pagination_model.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

class PaginationLoader extends StatelessWidget {
  final PaginationParams paginationParams;
  final Widget? loadingWidget;

  const PaginationLoader({required this.paginationParams, this.loadingWidget, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CombinedLiveDataBuilder.with2<bool, PaginationEquatable, bool>(
      x1: paginationParams.loading,
      x2: paginationParams.itemsList,
      transform: (x1, x2) => x1 && x2.items.isNotEmpty,
      builder: (context, value) {
        if (value) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: loadingWidget ?? const AppProgressBar(),
            ),
          );
        } else {
          final size = paginationParams.lastPage ? 0.0 : 70.0;
          return SizedBox(height: size);
        }
      },
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Platform.isIOS
          ? const CupertinoActivityIndicator()
          : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
    );
  }
}
