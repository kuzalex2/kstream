// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_endpoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamEndpoint _$StreamEndpointFromJson(Map<String, dynamic> json) =>
    StreamEndpoint(
      name: json['name'] as String,
      url: json['url'] as String,
      key: json['key'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$StreamEndpointToJson(StreamEndpoint instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'key': instance.key,
      'active': instance.active,
    };

StreamEndpointsList _$StreamEndpointsListFromJson(Map<String, dynamic> json) =>
    StreamEndpointsList(
      list: (json['list'] as List<dynamic>)
          .map((e) => StreamEndpoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StreamEndpointsListToJson(
        StreamEndpointsList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
