import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  // Sample mock bookings
  final List<Map<String, String>> bookings = const [
    {
      'name': 'Raj Sharma',
      'date': 'June 22, 2025',
      'contact': '+91 9876543210',
      'venue': 'Banquet Hall A',
    },
    {
      'name': 'Anjali & Arjun',
      'date': 'July 5, 2025',
      'contact': '+91 9123456780',
      'venue': 'Garden Venue',
    },
    {
      'name': 'Priya Sen',
      'date': 'August 1, 2025',
      'contact': '+91 9988776655',
      'venue': 'Banquet Hall B',
    },
  ];

  void _makePhoneCall(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Handle failure (show error snackbar, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              booking['date']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text("Party: ${booking['name']}"),
                Text("Venue: ${booking['venue']}"),
                Text("Contact: ${booking['contact']}"),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              color: Colors.green,
              onPressed: () => _makePhoneCall(booking['contact']!),
              tooltip: 'Call Party',
            ),
          ),
        );
      },
    );
  }
}
