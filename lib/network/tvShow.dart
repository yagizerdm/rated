import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'tvShow.g.dart';

List<TvShow> tvShowFromJson(String str) => List<TvShow>.from(json.decode(str).map((x) => TvShow.fromJson(x)));

String tvShowToJson(List<TvShow> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable(explicitToJson: true)
class TvShow {
  TvShow({
    required this.id,
    required this.url,
    required this.name,
    required this.type,
    required this.language,
    required this.genres,
    required this.status,
    required this.runtime,
    required this.averageRuntime,
    required this.premiered,
    required this.ended,
    required this.officialSite,
    required this.schedule,
    required this.rating,
    required this.weight,
    required this.network,
    required this.webChannel,
    required this.dvdCountry,
    required this.externals,
    required this.image,
    required this.summary,
    required this.updated,
    required this.links,
  });

  int? id;
  String? url;
  String? name;
  String? type;
  String? language;
  List<String>? genres;
  String? status;
  int? runtime;
  int? averageRuntime;
  DateTime? premiered;
  DateTime? ended;
  String? officialSite;
  Schedule? schedule;
  Rating? rating;
  int? weight;
  Network? network;
  WebChannel? webChannel;
  Country? dvdCountry;
  Externals? externals;
  ApiImage? image;
  String? summary;
  int? updated;
  Links? links;

  factory TvShow.fromJson(Map<String, dynamic> json) => _$TvShowFromJson(json);
  Map<String, dynamic> toJson() => _$TvShowToJson(this);

}

@JsonSerializable()
class Country {
  Country({
    required this.name,
    required this.code,
    required this.timezone,
  });

  String? name;
  String? code;
  String? timezone;

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}

@JsonSerializable()
class Externals {
  Externals({
    required this.tvrage,
    required this.thetvdb,
    required this.imdb,
  });

  int? tvrage;
  int? thetvdb;
  String? imdb;

  factory Externals.fromJson(Map<String, dynamic> json) => _$ExternalsFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalsToJson(this);
}

@JsonSerializable()
class ApiImage {
  ApiImage({
    required this.medium,
    required this.original,
  });

  String? medium;
  String? original;

  factory ApiImage.fromJson(Map<String, dynamic> json) => _$ApiImageFromJson(json);
  Map<String, dynamic> toJson() => _$ApiImageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Links {
  Links({
    required this.self,
    required this.previousepisode,
    required this.nextepisode,
  });

  Previousepisode? self;
  Previousepisode? previousepisode;
  Previousepisode? nextepisode;

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
  Map<String, dynamic> toJson() => _$LinksToJson(this);
}

@JsonSerializable()
class Previousepisode {
  Previousepisode({
    required this.href,
  });

  String? href;

  factory Previousepisode.fromJson(Map<String, dynamic> json) => _$PreviousepisodeFromJson(json);
  Map<String, dynamic> toJson() => _$PreviousepisodeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Network {
  Network({
    required this.id,
    required this.name,
    required this.country,
    required this.officialSite,
  });

  int? id;
  String? name;
  Country? country;
  String? officialSite;

  factory Network.fromJson(Map<String, dynamic> json) => _$NetworkFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkToJson(this);
}

@JsonSerializable()
class Rating {
  Rating({
    required this.average,
  });

  double? average;

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}

@JsonSerializable()
class Schedule {
  Schedule({
    required this.time,
    required this.days,
  });

  String? time;
  List<String>? days;

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WebChannel {
  WebChannel({
    required this.id,
    required this.name,
    required this.country,
    required this.officialSite,
  });

  int? id;
  String? name;
  Country? country;
  String? officialSite;

  factory WebChannel.fromJson(Map<String, dynamic> json) => _$WebChannelFromJson(json);
  Map<String, dynamic> toJson() => _$WebChannelToJson(this);
}
