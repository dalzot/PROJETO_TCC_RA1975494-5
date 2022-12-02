import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/modules/sign_up/controller/sign_up_controller.dart';
import 'package:flutter/material.dart';

class CustomCheckboxWidget extends StatefulWidget {
  final Text? parent;
  final List<dynamic>? children;
  final List<String>? checkList;
  final Color? parentCheckboxColor;
  final Color? childrenCheckboxColor;
  final Function(String checked)? onCheck;
  final Function(String unchecked)? onUncheck;

  const CustomCheckboxWidget({
    Key? key,
    required this.parent,
    required this.children,
    this.checkList,
    this.parentCheckboxColor,
    this.childrenCheckboxColor,
    this.onCheck,
    this.onUncheck,
  }) : super(key: key);

  static final Map<String?, bool?> _isParentSelected = {};
  static get isParentSelected => _isParentSelected;
  static final Map<String?, List<String?>> _selectedChildrenMap = {};
  static get selectedChildrens => _selectedChildrenMap;

  @override
  ExpansionCheckboxState createState() => ExpansionCheckboxState();
}

class ExpansionCheckboxState
    extends State<CustomCheckboxWidget> {
  bool? _parentValue = false;

  List<bool?> _childrenValue = [];

  @override
  void initState() {
    super.initState();
    _childrenValue = List.filled(widget.children!.length, false);
    CustomCheckboxWidget._selectedChildrenMap
        .addAll({widget.parent!.data: []});
    CustomCheckboxWidget._isParentSelected
        .addAll({widget.parent!.data: false});
    checkToFill();
  }

  void checkToFill() {
    if(widget.checkList!.isNotEmpty) {
      for (int i = 0; i < widget.children!.length; i++) {
//        _childCheckBoxClick(i);
        _childrenValue[i] = widget.checkList!.contains(widget.children![i].data);
      }
      _parentCheckboxUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Row(
        children: [
          Checkbox(
            value: _parentValue,
            splashRadius: 0.0,
            activeColor: widget.parentCheckboxColor,
            onChanged: null,
            tristate: true,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(child: widget.parent!),
        ],
      ),
      children: [
        for (int i = 0; i < widget.children!.length; i++)
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Row(
              children: [
                Checkbox(
                  splashRadius: 0.0,
                  activeColor: widget.childrenCheckboxColor,
                  value: _childrenValue[i],
                  onChanged: (value) => _childCheckBoxClick(i),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _childCheckBoxClick(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: widget.children![i],
                    )
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _childCheckBoxClick(int i) {
    setState(() {
      _childrenValue[i] = !_childrenValue[i]!;
      if (!_childrenValue[i]!) {
        CustomCheckboxWidget._selectedChildrenMap
            .update(widget.parent!.data, (value) {
          value.removeWhere((element) => element == widget.children![i].data);

          if(widget.onUncheck != null) widget.onUncheck!(widget.children![i].data);
          return value;
        });
      } else {
        CustomCheckboxWidget._selectedChildrenMap
            .update(widget.parent!.data, (value) {
          value.add(widget.children![i].data);

          if(widget.onCheck != null) widget.onCheck!(widget.children![i].data);
          return value;
        });
      }
      _parentCheckboxUpdate();
    });
  }

  void _parentCheckboxUpdate() {
    setState(() {
      if (_childrenValue.contains(false) && _childrenValue.contains(true)) {
        _parentValue = null;
        CustomCheckboxWidget._isParentSelected
            .update(widget.parent!.data, (value) => false);
      } else {
        _parentValue = _childrenValue.first;
        CustomCheckboxWidget._isParentSelected
            .update(widget.parent!.data, (value) => _childrenValue.first);
      }
    });
  }
}

/// Custom Checkbox
class CustomCheckbox extends StatefulWidget {
  final List<dynamic>? children;
  final List<String>? checkList;
  final Color? childrenCheckboxColor;
  final Function(String checked)? onCheck;
  final Function(String unchecked)? onUncheck;

  const CustomCheckbox({
    Key? key,
    required this.children,
    this.childrenCheckboxColor,
    this.checkList,
    this.onCheck,
    this.onUncheck,
  }) : super(key: key);

  static final Map<String?, List<String?>> _selectedChildrenMap = {};
  static get selectedChildrens => _selectedChildrenMap;

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  List<bool?> _childrenValue = [];

  @override
  void initState() {
    super.initState();
    _childrenValue = List.filled(widget.children!.length, false);
    checkToFill();
  }

  void checkToFill() {
    if(widget.checkList!.isNotEmpty) {
      for (int i = 0; i < widget.children!.length; i++) {
        _childrenValue[i] = widget.checkList!.contains(widget.children![i].data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.children!.length; i++)
          Row(
            children: [
              Checkbox(
                splashRadius: 0.0,
                activeColor: widget.childrenCheckboxColor,
                value: _childrenValue[i],
                onChanged: (value) => _childCheckBoxClick(i),
              ),
              Expanded(
                child: InkWell(
                    onTap: () => _childCheckBoxClick(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: widget.children![i],
                    )
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _childCheckBoxClick(int i) {
    setState(() {
      _childrenValue[i] = !_childrenValue[i]!;
      if (!_childrenValue[i]!) {
//        CustomCheckboxWidget._selectedChildrenMap
//            .update(widget.parent!.data, (value) {
//          value.removeWhere((element) => element == widget.children![i].data);

          if(widget.onUncheck != null) widget.onUncheck!(widget.children![i].data);
//          return value;
//        });
      } else {
//        CustomCheckboxWidget._selectedChildrenMap
//            .update(widget.parent!.data, (value) {
//          value.add(widget.children![i].data);

          if(widget.onCheck != null) widget.onCheck!(widget.children![i].data);
//          return value;
//        });
      }
    });
  }
}
