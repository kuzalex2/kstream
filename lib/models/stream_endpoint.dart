
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

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

  factory StreamEndpoint.fromJson(Map<String, dynamic> json) => _$StreamEndpointFromJson(json);
  Map<String, dynamic> toJson() => _$StreamEndpointToJson(this);

  @override
  List<Object> get props => [
    name,
    url,
    key,
  ];

}