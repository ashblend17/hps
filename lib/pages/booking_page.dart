import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late final Box<Booking> bookingsBox;
  final List<String> _venueOptions = ['Garden', 'Hall', 'Rooms'];
  final Set<String> _selectedVenues = {};

  @override
  void initState() {
    super.initState();
    bookingsBox = Hive.box<Booking>('bookingsBox');
  }

  @override
  Widget build(BuildContext context) {
    final groupedBookings = _groupBookingsByMonth();

    return Scaffold(
      appBar: AppBar(title: const Text("Bookings")),
      body: groupedBookings.isEmpty
          ? const Center(child: Text("No bookings yet."))
          : ListView.builder(
              itemCount: groupedBookings.length,
              itemBuilder: (context, index) {
                final month = groupedBookings.keys.elementAt(index);
                final items = groupedBookings[month]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        month,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...items.map(
                      (booking) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(
                            "${booking.name} (${_formatDateRange(booking.startDate, booking.endDate)})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Contact: ${booking.contact}"),
                              Text("Venues: ${booking.venues.join(', ')}"),
                              Text("Advance: ₹${booking.advance}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.call,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Would call ${booking.contact}',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _showEditBookingDialog(booking),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookingDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Map<String, List<Booking>> _groupBookingsByMonth() {
    final List<Booking> bookings = bookingsBox.values.toList();
    bookings.sort((a, b) => a.startDate.compareTo(b.startDate));

    final Map<String, List<Booking>> grouped = {};

    for (var booking in bookings) {
      final String month = DateFormat('MMMM yyyy').format(booking.startDate);
      grouped.putIfAbsent(month, () => []).add(booking);
    }

    return grouped;
  }

  void _showEditBookingDialog(Booking booking) {
    final nameController = TextEditingController(text: booking.name);
    final contactController = TextEditingController(text: booking.contact);
    final advanceController = TextEditingController(text: booking.advance);
    DateTimeRange selectedDateRange = DateTimeRange(
      start: booking.startDate,
      end: booking.endDate,
    );
    _selectedVenues
      ..clear()
      ..addAll(booking.venues);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Booking'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Contact'),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        'From ${DateFormat('dd MMM').format(selectedDateRange.start)} '
                        'to ${DateFormat('dd MMM').format(selectedDateRange.end)}',
                      ),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                          initialDateRange: selectedDateRange,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDateRange = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Venue(s):",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ..._venueOptions.map((venue) {
                      return CheckboxListTile(
                        title: Text(venue),
                        value: _selectedVenues.contains(venue),
                        onChanged: (bool? selected) {
                          setDialogState(() {
                            if (selected == true) {
                              _selectedVenues.add(venue);
                            } else {
                              _selectedVenues.remove(venue);
                            }
                          });
                        },
                      );
                    }),
                    TextField(
                      controller: advanceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Advance Amount (₹)',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    booking.name = nameController.text;
                    booking.contact = contactController.text;
                    booking.startDate = selectedDateRange.start;
                    booking.endDate = selectedDateRange.end;
                    booking.venues = _selectedVenues.toList();
                    booking.advance = advanceController.text;
                    await booking.save();

                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddBookingDialog() {
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final advanceController = TextEditingController();
    DateTimeRange? selectedDateRange;
    _selectedVenues.clear();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Booking'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Contact'),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        selectedDateRange == null
                            ? 'Select Date Range'
                            : 'From ${DateFormat('dd MMM').format(selectedDateRange!.start)} '
                                  'to ${DateFormat('dd MMM').format(selectedDateRange!.end)}',
                      ),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                          barrierColor: Colors.black54,
                          helpText: 'Select Booking Dates',
                          saveText: 'Select',
                          cancelText: 'Cancel',
                          initialDateRange: selectedDateRange,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDateRange = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Venue(s):",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ..._venueOptions.map((venue) {
                      return CheckboxListTile(
                        title: Text(venue),
                        value: _selectedVenues.contains(venue),
                        onChanged: (bool? selected) {
                          setDialogState(() {
                            if (selected == true) {
                              _selectedVenues.add(venue);
                            } else {
                              _selectedVenues.remove(venue);
                            }
                          });
                        },
                      );
                    }),
                    TextField(
                      controller: advanceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Advance Amount (₹)',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedDateRange != null) {
                      final booking = Booking(
                        name: nameController.text,
                        contact: contactController.text,
                        startDate: selectedDateRange!.start,
                        endDate: selectedDateRange!.end,
                        venues: _selectedVenues.toList(),
                        advance: advanceController.text,
                      );

                      await bookingsBox.add(booking);
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final s = DateFormat('dd MMM').format(start);
    final e = DateFormat('dd MMM').format(end);
    return start == end ? s : "$s - $e";
  }
}
