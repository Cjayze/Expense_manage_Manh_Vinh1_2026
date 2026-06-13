import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  const NavButton({super.key, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text, 
        style: TextStyle(
          color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
          fontSize: 14
        ),
      ),
    );
  }
}
