import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  /// Returns a new [ErrorResponse] instance.
  ErrorResponse({required this.message, this.errors});

  String message;
  List<String>? errors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorResponse && other.message == message;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (message.isEmpty ? 0 : message.hashCode);

  @override
  String toString() => 'ErrorResponse[message=$message]';

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  /// Returns a new [ActionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ErrorResponse? fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  static List<ErrorResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ErrorResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ErrorResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ErrorResponse> mapFromJson(dynamic json) {
    final map = <String, ErrorResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ErrorResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ActionResponse-objects as value to a dart map
  static Map<String, List<ErrorResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ErrorResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ErrorResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
