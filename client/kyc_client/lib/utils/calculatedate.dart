import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('dd-MM-yyyy');
String calculateDate(pickupdate) {
  if (DateTime.now().day - DateTime.parse(pickupdate).day == 0) {
    return 'Today';
  } else if (DateTime.now().day - DateTime.parse(pickupdate).day == 1 ||
      DateTime.now().day - DateTime.parse(pickupdate).day == -30 ||
      DateTime.now().day - DateTime.parse(pickupdate).day == -39 ||
      DateTime.now().day - DateTime.parse(pickupdate).day == -28 ||
      DateTime.now().day - DateTime.parse(pickupdate).day == -27) {
    return 'Yesterday';
  } else {
    return formatter.format(DateTime.parse(pickupdate));
  }
}
