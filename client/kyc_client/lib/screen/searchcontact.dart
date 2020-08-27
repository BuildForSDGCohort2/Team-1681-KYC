import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kyc_client/models/contacttrace.dart';
import 'package:kyc_client/utils/calculatedate.dart';

class ContactSearch extends SearchDelegate<ContactTrace> {
  List<ContactTrace> userContacts;
  ContactSearch(this.userContacts);
  DateTime _selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.add_event, progress: transitionAnimation),
        onPressed: () async {
          DateTime _pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(1920),
              lastDate: DateTime.now().add(Duration(days: 1)));
          if (_pickedDate != null) {
            _selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
            );
            query = formatter.format(_selectedDate).toString();
          } else {
            query = '';
          }
        },
      ),
      IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: transitionAnimation,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    final contactList = query.isEmpty
        ? userContacts
        : userContacts
            .where((contact) =>
                contact.client.toLowerCase().contains(query.toLowerCase()) ||
                contact.journeycode
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                contact.rider.toLowerCase().contains(query.toLowerCase()) ||
                contact.source.toLowerCase().contains(query.toLowerCase()) ||
                contact.destination
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                contact.pickuptime.contains(query))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        final ContactTrace contact = contactList[index];
        return ListTile(
          onTap: () {
            print(contact.pickuptime);
          },
          title: Text(contact.journeycode),
          subtitle: Text(contact.destination),
          trailing: Column(
            children: <Widget>[
              Text(
                calculateDate(contact.pickuptime),
                style: TextStyle(fontSize: 11),
              ),
              Text(
                TimeOfDay.fromDateTime(
                        DateTime.parse(contact.pickuptime).toLocal())
                    .format(context)
                    .toString(),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
      itemCount: contactList.length,
    );
  }
}
