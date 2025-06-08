import 'package:flutter/material.dart';
import 'pages/gallery_page.dart';
import 'pages/inquiry_page.dart';
import 'pages/booking_page.dart';
import 'pages/accounts_page.dart';
import 'pages/notification_page.dart';
import 'widgets/app_drawer.dart';
import 'widgets/bottom_nav.dart';

void main() => runApp(const HotelOpsApp());

class HotelOpsApp extends StatelessWidget {
  const HotelOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Operations',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const NavRoot(),
      restorationScopeId: 'root',
    );
  }
}

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  State<NavRoot> createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> with RestorationMixin {
  final RestorableInt _index = RestorableInt(0);
  @override
  String? get restorationId => 'nav_root';
  @override
  void restoreState(RestorationBucket? oldBucket, bool initial) {
    registerForRestoration(_index, 'current_index');
  }

  late final List<Widget> _pages = [
    buildScaffold(title: 'Gallery', body: const GalleryPage()),
    buildScaffold(title: 'Inquiry', body: const InquiryPage()),
    buildScaffold(title: 'Booking', body: const BookingPage()),
    buildScaffold(title: 'Accounts', body: const AccountsPage()),
    buildScaffold(title: 'Notifications', body: const NotificationPage()),
  ];

  Widget buildScaffold({required String title, required Widget body}) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const AppDrawer(), // See below
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index.value, children: _pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _index.value,
        onTap: (i) => setState(() => _index.value = i),
      ),
    );
  }
}
