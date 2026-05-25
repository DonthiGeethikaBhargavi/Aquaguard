// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_insight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AiInsightModel _$AiInsightModelFromJson(Map<String, dynamic> json) {
  return _AiInsightModel.fromJson(json);
}

/// @nodoc
mixin _$AiInsightModel {
  String get id => throw _privateConstructorUsedError;
  String get pondId => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  AiInsightType get type => throw _privateConstructorUsedError;
  AiInsightSeverity get severity => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get recommendation => throw _privateConstructorUsedError;

  /// Serializes this AiInsightModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiInsightModelCopyWith<AiInsightModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiInsightModelCopyWith<$Res> {
  factory $AiInsightModelCopyWith(
    AiInsightModel value,
    $Res Function(AiInsightModel) then,
  ) = _$AiInsightModelCopyWithImpl<$Res, AiInsightModel>;
  @useResult
  $Res call({
    String id,
    String pondId,
    String deviceId,
    String title,
    String description,
    AiInsightType type,
    AiInsightSeverity severity,
    double confidence,
    DateTime timestamp,
    String? recommendation,
  });
}

/// @nodoc
class _$AiInsightModelCopyWithImpl<$Res, $Val extends AiInsightModel>
    implements $AiInsightModelCopyWith<$Res> {
  _$AiInsightModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pondId = null,
    Object? deviceId = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? severity = null,
    Object? confidence = null,
    Object? timestamp = null,
    Object? recommendation = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            pondId: null == pondId
                ? _value.pondId
                : pondId // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AiInsightType,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as AiInsightSeverity,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            recommendation: freezed == recommendation
                ? _value.recommendation
                : recommendation // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiInsightModelImplCopyWith<$Res>
    implements $AiInsightModelCopyWith<$Res> {
  factory _$$AiInsightModelImplCopyWith(
    _$AiInsightModelImpl value,
    $Res Function(_$AiInsightModelImpl) then,
  ) = __$$AiInsightModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String pondId,
    String deviceId,
    String title,
    String description,
    AiInsightType type,
    AiInsightSeverity severity,
    double confidence,
    DateTime timestamp,
    String? recommendation,
  });
}

/// @nodoc
class __$$AiInsightModelImplCopyWithImpl<$Res>
    extends _$AiInsightModelCopyWithImpl<$Res, _$AiInsightModelImpl>
    implements _$$AiInsightModelImplCopyWith<$Res> {
  __$$AiInsightModelImplCopyWithImpl(
    _$AiInsightModelImpl _value,
    $Res Function(_$AiInsightModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pondId = null,
    Object? deviceId = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? severity = null,
    Object? confidence = null,
    Object? timestamp = null,
    Object? recommendation = freezed,
  }) {
    return _then(
      _$AiInsightModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        pondId: null == pondId
            ? _value.pondId
            : pondId // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AiInsightType,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as AiInsightSeverity,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        recommendation: freezed == recommendation
            ? _value.recommendation
            : recommendation // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AiInsightModelImpl implements _AiInsightModel {
  const _$AiInsightModelImpl({
    required this.id,
    required this.pondId,
    required this.deviceId,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.confidence,
    required this.timestamp,
    this.recommendation,
  });

  factory _$AiInsightModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiInsightModelImplFromJson(json);

  @override
  final String id;
  @override
  final String pondId;
  @override
  final String deviceId;
  @override
  final String title;
  @override
  final String description;
  @override
  final AiInsightType type;
  @override
  final AiInsightSeverity severity;
  @override
  final double confidence;
  @override
  final DateTime timestamp;
  @override
  final String? recommendation;

  @override
  String toString() {
    return 'AiInsightModel(id: $id, pondId: $pondId, deviceId: $deviceId, title: $title, description: $description, type: $type, severity: $severity, confidence: $confidence, timestamp: $timestamp, recommendation: $recommendation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiInsightModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pondId, pondId) || other.pondId == pondId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.recommendation, recommendation) ||
                other.recommendation == recommendation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    pondId,
    deviceId,
    title,
    description,
    type,
    severity,
    confidence,
    timestamp,
    recommendation,
  );

  /// Create a copy of AiInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiInsightModelImplCopyWith<_$AiInsightModelImpl> get copyWith =>
      __$$AiInsightModelImplCopyWithImpl<_$AiInsightModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AiInsightModelImplToJson(this);
  }
}

abstract class _AiInsightModel implements AiInsightModel {
  const factory _AiInsightModel({
    required final String id,
    required final String pondId,
    required final String deviceId,
    required final String title,
    required final String description,
    required final AiInsightType type,
    required final AiInsightSeverity severity,
    required final double confidence,
    required final DateTime timestamp,
    final String? recommendation,
  }) = _$AiInsightModelImpl;

  factory _AiInsightModel.fromJson(Map<String, dynamic> json) =
      _$AiInsightModelImpl.fromJson;

  @override
  String get id;
  @override
  String get pondId;
  @override
  String get deviceId;
  @override
  String get title;
  @override
  String get description;
  @override
  AiInsightType get type;
  @override
  AiInsightSeverity get severity;
  @override
  double get confidence;
  @override
  DateTime get timestamp;
  @override
  String? get recommendation;

  /// Create a copy of AiInsightModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiInsightModelImplCopyWith<_$AiInsightModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
