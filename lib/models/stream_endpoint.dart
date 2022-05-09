
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';


part 'stream_endpoint.g.dart';

///
/// fvm flutter packages pub run  build_runner build
///


@JsonSerializable()
class StreamEndpoint extends Equatable {
  final String name;

  final String url;
  final String key;
  final bool active;

  const StreamEndpoint({required this.name, required this.url, required this.key, required this.active});


  StreamEndpoint copyWith({
    String? name,
    String? url,
    String? key,
    bool? active,

  }) {
    return StreamEndpoint(
      name: name ?? this.name,
      url: url ?? this.url,
      key: key ?? this.key,
      active: active ?? this.active,
    );
  }

  factory StreamEndpoint.fromJson(Map<String, dynamic> json) => _$StreamEndpointFromJson(json);
  Map<String, dynamic> toJson() => _$StreamEndpointToJson(this);

  @override
  List<Object> get props => [
    name,
    url,
    key,
    active,
  ];

}


@JsonSerializable()
class StreamEndpointsList extends Equatable {
  final List<StreamEndpoint> list;

  const StreamEndpointsList({required this.list});

  static const empty = StreamEndpointsList(list: []);

  StreamEndpoint? get activePoint => list.firstWhereOrNull((i) => i.active);

  factory StreamEndpointsList.fromJson(Map<String, dynamic> json) => _$StreamEndpointsListFromJson(json);
  Map<String, dynamic> toJson() => _$StreamEndpointsListToJson(this);

  @override
  List<Object> get props => [
    list,
  ];

}