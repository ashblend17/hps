import 'package:flutter/material.dart';
import '../pages/booking_page.dart';
import '../pages/inquiry_page.dart';
import '../pages/gallery_page.dart';
import '../pages/accounts_page.dart';
import '../pages/notification_page.dart';
import '../widgets/app_drawer.dart';

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  State<NavRoot> createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  int currentIndex = 2;

  final List<Widget> _pages = [
    buildScaffold(title: 'Gallery', body: const GalleryPage()),
    buildScaffold(title: 'Inquiry', body: const InquiryPage()),
    buildScaffold(title: 'Booking', body: const BookingPage()),
    buildScaffold(title: 'Accounts', body: const AccountsPage()),
    buildScaffold(title: 'Notifications', body: const NotificationPage()),
  ];

  static Widget buildScaffold({required String title, required Widget body}) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const AppDrawer(),
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
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
      ),
    );
  }
}
