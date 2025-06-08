import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.photo_library_outlined),
          selectedIcon: Icon(Icons.photo_library),
          label: 'Gallery',
        ),
        NavigationDestination(
          icon: Icon(Icons.question_answer_outlined),
          label: 'Inquiry',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_note_outlined),
          label: 'Booking',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Accounts',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          label: 'Alerts',
        ),
      ],
    );
  }
}
