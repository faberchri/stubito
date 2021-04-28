import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum AvalancheRisk {
  low, moderate, considerable, high, veryHigh
}

@immutable
class TourKey extends Equatable {
  static const uuidGen = Uuid();
  final id = uuidGen.v1();

  @override
  List<Object> get props {
    return [id];
  }

}

@immutable
class TourModel extends Equatable {

  final TourKey key;
  final String title;
  final DateTime date;
  final String location;
  final List<String> participants;
  final String routeDescription;
  final AvalancheRisk avalancheRisk;
  final int ascentAltitudeMeters;
  final Duration ascentDuration;
  final String weather;
  final String temperature;
  final String snowCondition;
  final String perceivedRisk;
  final String criticalSections;
  final String remarks;

  TourModel({
    TourKey? key,
    this.title = '',
    DateTime? date,
    this.location = '',
    List<String> participants = const <String>[],
    this.routeDescription = '',
    this.avalancheRisk = AvalancheRisk.moderate,
    this.ascentAltitudeMeters = 500,
    this.ascentDuration = const Duration(hours: 1),
    this.weather = '',
    this.temperature = '',
    this.snowCondition = '',
    this.perceivedRisk  = '',
    this.criticalSections = '',
    this.remarks = '',
  }) :
        this.key = key ?? TourKey(),
        this.date = date ?? DateTime.now(),
        this.participants = List.unmodifiable(participants);

  @override
  List<Object> get props => [
    key,
    title,
    date,
    location,
    participants,
    routeDescription,
    avalancheRisk,
    ascentAltitudeMeters,
    ascentDuration,
    weather,
    temperature,
    snowCondition,
    perceivedRisk,
    criticalSections,
    remarks
  ];

  bool hasAllDefaultValues() {
    final defaultModel = TourModel(key: this.key, date: this.date);
    return defaultModel == this;
  }

  TourModel copy({
    String? title,
    DateTime? date,
    String? location,
    List<String>? participants,
    String? routeDescription,
    AvalancheRisk? avalancheRisk,
    int? ascentAltitudeMeters,
    Duration? ascentDuration,
    String? weather,
    String? temperature,
    String? snowCondition,
    String? perceivedRisk,
    String? criticalSections,
    String? remarks,
  }) {
    return TourModel(
      key: this.key,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      participants: participants ?? this.participants,
      routeDescription: routeDescription ?? this.routeDescription,
      avalancheRisk: avalancheRisk ?? this.avalancheRisk,
      ascentAltitudeMeters: ascentAltitudeMeters ?? this.ascentAltitudeMeters,
      ascentDuration: ascentDuration ?? this.ascentDuration,
      weather: weather ?? this.weather,
      temperature: temperature ?? this.temperature,
      snowCondition: snowCondition ?? this.snowCondition,
      perceivedRisk: perceivedRisk ?? this.perceivedRisk,
      criticalSections: criticalSections ?? this.criticalSections,
      remarks: remarks ?? this.remarks,
    );
  }

}
