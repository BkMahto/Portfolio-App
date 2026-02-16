class VisitorModel {
  final String id;
  final VisitorInfo info;
  final List<VisitorEvent> events;

  VisitorModel({required this.id, required this.info, required this.events});

  factory VisitorModel.fromMap(String id, Map<dynamic, dynamic> map) {
    final infoMap = map['info'] as Map<dynamic, dynamic>? ?? {};
    final eventsMap = map['events'] as Map<dynamic, dynamic>? ?? {};

    final eventsList = eventsMap.entries.map((e) {
      return VisitorEvent.fromMap(e.value as Map<dynamic, dynamic>);
    }).toList();

    // Sort events by timestamp descending
    eventsList.sort((a, b) => b.serverTimestamp.compareTo(a.serverTimestamp));

    return VisitorModel(
      id: id,
      info: VisitorInfo.fromMap(infoMap),
      events: eventsList,
    );
  }
}

class VisitorInfo {
  final String browser;
  final String city;
  final String country;
  final String ip;
  final String language;
  final int lastVisit;
  final double latitude;
  final double longitude;
  final String org;
  final String postal;
  final String readableTime;
  final String region;
  final String screenSize;

  VisitorInfo({
    required this.browser,
    required this.city,
    required this.country,
    required this.ip,
    required this.language,
    required this.lastVisit,
    required this.latitude,
    required this.longitude,
    required this.org,
    required this.postal,
    required this.readableTime,
    required this.region,
    required this.screenSize,
  });

  factory VisitorInfo.fromMap(Map<dynamic, dynamic> map) {
    return VisitorInfo(
      browser: map['browser']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      country: map['country']?.toString() ?? '',
      ip: map['ip']?.toString() ?? '',
      language: map['language']?.toString() ?? '',
      lastVisit: map['last_visit'] as int? ?? 0,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      org: map['org']?.toString() ?? '',
      postal: map['postal']?.toString() ?? '',
      readableTime: map['readable_time']?.toString() ?? '',
      region: map['region']?.toString() ?? '',
      screenSize: map['screen_size']?.toString() ?? '',
    );
  }
}

class VisitorEvent {
  final String eventName;
  final String readableTime;
  final int serverTimestamp;
  final String? skillCategory;
  final String? skillName;
  final String? method;

  VisitorEvent({
    required this.eventName,
    required this.readableTime,
    required this.serverTimestamp,
    this.skillCategory,
    this.skillName,
    this.method,
  });

  factory VisitorEvent.fromMap(Map<dynamic, dynamic> map) {
    return VisitorEvent(
      eventName: map['event_name']?.toString() ?? '',
      readableTime: map['readable_time']?.toString() ?? '',
      serverTimestamp: map['server_timestamp'] as int? ?? 0,
      skillCategory: map['skill_category']?.toString(),
      skillName: map['skill_name']?.toString(),
      method: map['method']?.toString(),
    );
  }
}
