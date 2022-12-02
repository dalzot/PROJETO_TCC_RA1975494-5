import 'package:flutter/material.dart';

class GlobalListViewWidget extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  const GlobalListViewWidget({Key? key, required this.children, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: padding,
      children: children,
    );
  }
}

class GlobalListViewBuilderWidget extends StatelessWidget {
  final dynamic itemCount;
  final dynamic itemBuilder;
  final EdgeInsets? padding;
  const GlobalListViewBuilderWidget({Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

class SingleChildScrollViewWidget extends StatelessWidget {
  final Widget child;
  const SingleChildScrollViewWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}
