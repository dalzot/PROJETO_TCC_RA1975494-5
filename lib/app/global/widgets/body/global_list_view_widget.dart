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
