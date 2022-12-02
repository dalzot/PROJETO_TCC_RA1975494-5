import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPopupMenuWidget extends StatelessWidget {
  final String currentValue;
  final List options;
  final Function(dynamic)? onSelect;
  final Widget child;
  const CustomPopupMenuWidget({
    required this.currentValue,
    required this.options,
    required this.onSelect,
    required this.child,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        constraints: BoxConstraints(maxHeight: Get.height*.5),
        offset: const Offset(0, 32),
        itemBuilder: (context) {
          return options.map((selected) => PopupMenuItem(
            onTap: () => onSelect!(selected),
            child: Text(selected.toString()),
          )).toList();
        },
        child: child
    );
  }
}
