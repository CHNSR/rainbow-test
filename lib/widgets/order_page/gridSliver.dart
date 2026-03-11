//for header tomorow
import 'package:flutter/material.dart';

class SubCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SubCategoryHeaderDelegate(this.child);

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(color: Colors.white, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
