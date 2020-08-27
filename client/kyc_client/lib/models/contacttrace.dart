import 'package:kyc_client/api/databaseProvider.dart';

class ContactTrace {
  int id;
  String journeycode;
  String rider;
  String client;
  String source;
  String destination;
  String pickuptime;
  bool infected;
  bool uploaded;

  ContactTrace({
    this.id,
    this.journeycode,
    this.rider,
    this.client,
    this.source,
    this.destination,
    this.pickuptime,
    this.infected,
    this.uploaded,
  });

  ContactTrace.fromJson(dynamic jsonData) {
    id = jsonData[DatabaseProvider.COLUMN_ID];
    journeycode = jsonData[DatabaseProvider.COLUMN_JOURNEYCODE];
    rider = jsonData[DatabaseProvider.COLUMN_RIDER];
    client = jsonData[DatabaseProvider.COLUMN_CLIENT];
    source = jsonData[DatabaseProvider.COLUMN_SOURCE];
    destination = jsonData[DatabaseProvider.COLUMN_DESTINATION];
    pickuptime = jsonData[DatabaseProvider.COLUMN_PICKUPTIME];
    infected = jsonData[DatabaseProvider.COLUMN_INFECTED] == 1;
    uploaded = jsonData[DatabaseProvider.COLUMN_UPLOADED] == 1;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_JOURNEYCODE: journeycode,
      DatabaseProvider.COLUMN_RIDER: rider,
      DatabaseProvider.COLUMN_CLIENT: client,
      DatabaseProvider.COLUMN_SOURCE: source,
      DatabaseProvider.COLUMN_DESTINATION: destination,
      DatabaseProvider.COLUMN_PICKUPTIME: pickuptime,
      DatabaseProvider.COLUMN_INFECTED: infected ? 1 : 0,
      DatabaseProvider.COLUMN_UPLOADED: uploaded ? 1 : 0,
    };
    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }
    return map;
  }
}
