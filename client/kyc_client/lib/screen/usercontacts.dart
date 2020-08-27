import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kyc_client/api/databaseProvider.dart';
import 'package:kyc_client/models/contacttrace.dart';
import 'package:kyc_client/screen/searchcontact.dart';
import 'package:kyc_client/utils/calculatedate.dart';

class UserContacts extends StatefulWidget {
  final String type;
  final List<ContactTrace> allcontacts;
  UserContacts({this.type, this.allcontacts});
  @override
  _UserContactsState createState() => _UserContactsState();
}

class _UserContactsState extends State<UserContacts> {
  final dbprovider = DatabaseProvider.db;

  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  List<ContactTrace> _contacts = [
    ContactTrace(
      journeycode: 'KAKEMBO',
      rider: 'Mike',
      client: 'Kakembo',
      source: 'Kyebando',
      destination: 'Kawempe',
      pickuptime: DateTime.now().toUtc().toString(),
      infected: false,
      uploaded: false,
    ),
  ];
  List<ContactTrace> selectedContacts;

  DateTime _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final _dateFocusNode = FocusNode();

  bool _isSearching = false;
  @override
  void initState() {
    super.initState();

    selectedContacts = [];

    _selectedDate = DateTime.now();
  }

  Widget _leading(snapshot) {
    return Column(
      children: <Widget>[
        Text(
          DateFormat.d().format(
            DateTime.parse(snapshot.pickuptime).toLocal(),
          ),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 32.0, color: Colors.blue),
        ),
        Text(
          DateFormat.E().format(
            DateTime.parse(snapshot.pickuptime),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.type);
    if (widget.type == 'Today') {
      setState(() {
        widget.allcontacts.map((contact) {
          print(contact.pickuptime);
          if (DateTime.parse(contact.pickuptime)
              .toLocal()
              .toString()
              .contains(DateTime.now().toString().substring(0, 11)))
            selectedContacts..add(contact);
        }).toList();
      });
    } else if (widget.type == 'Infected') {
      setState(() {
        widget.allcontacts.map((contact) {
          if (contact.infected) {
            selectedContacts..add(contact);
          }
        }).toList();
      });
    } else {
      setState(() {
        selectedContacts = widget.allcontacts;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(' Contacts - ' + widget.type),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: ContactSearch(selectedContacts));
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final user = selectedContacts[index];
            return ListTile(
              leading: widget.type == 'Infected'
                  ? _leading(selectedContacts[index])
                  : Icon(Icons.compare_arrows),
              title: Text(user.journeycode),
              subtitle: Stack(
                children: <Widget>[
                  Positioned(
                    child: Text(user.source),
                  ),
                  Positioned(
                    top: -5,
                    left: (MediaQuery.of(context).size.width * 0.63 / 3),
                    child: Text(
                      '...',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width * 0.75 / 3),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'To',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    left: (MediaQuery.of(context).size.width * 0.50 / 3) * 2,
                    child: Text(
                      '...',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width * 0.66 / 3) * 2,
                    child: Text(user.destination),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    calculateDate(user.pickuptime),
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    TimeOfDay.fromDateTime(
                            DateTime.parse(user.pickuptime).toLocal())
                        .format(context)
                        .toString(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
          itemCount: selectedContacts.length,
        ),
      ),
    );
  }
}
