import '../../../../core/theme/app_color.dart';
import 'package:flutter/material.dart';

class CustomTabs extends StatefulWidget {
  const CustomTabs({
    required this.tabs,
    required this.labels,
    Key? key}) : super(key: key);

  final List<Widget> tabs;
  final List<String> labels;

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: _tabController!.length,
      child: Column(
        children: [
          Container(
            color: appDarkPrimaryColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor: appWhiteColor,
              unselectedLabelColor: appWhiteColor.withOpacity(0.5),
              labelColor: appWhiteColor,
              tabs: widget.labels.map((e) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
                  child: Text(e),
                ),
              ).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabs,
            ),
          )
        ],
      ),
    );
  }
}
