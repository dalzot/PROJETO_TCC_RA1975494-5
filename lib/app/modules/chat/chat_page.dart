import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        pageTitle: 'Conversas',
        body: EmptyListWidget());
  }
}
