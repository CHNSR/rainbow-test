import 'package:flutter/material.dart';

class HomeWidgetsButtons extends StatefulWidget {
  final String pathpic;
  final String title;
  const HomeWidgetsButtons({
    super.key,
    required this.pathpic,
    required this.title,
  });

  @override
  State<HomeWidgetsButtons> createState() => _ToStayButtonsState();
}

class _ToStayButtonsState extends State<HomeWidgetsButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(border: Border.symmetric()),
      child: Column(),
    );
  }
}

//Tab to order button
class TabtoOrderButton extends StatefulWidget {
  const TabtoOrderButton({super.key});

  @override
  State<TabtoOrderButton> createState() => _TabtoOrderButtonState();
}

class _TabtoOrderButtonState extends State<TabtoOrderButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text('Tap to Order'));
  }
}
