//
//  Generated code. Do not modify.
//  source: lib/proto/patient.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'patient.pbenum.dart';

export 'patient.pbenum.dart';

class Location extends $pb.GeneratedMessage {
  factory Location({
    $core.double? lat,
    $core.double? lng,
  }) {
    final $result = create();
    if (lat != null) {
      $result.lat = lat;
    }
    if (lng != null) {
      $result.lng = lng;
    }
    return $result;
  }
  Location._() : super();
  factory Location.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Location.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Location', createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'lat', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lng', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Location clone() => Location()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Location copyWith(void Function(Location) updates) => super.copyWith((message) => updates(message as Location)) as Location;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Location create() => Location._();
  Location createEmptyInstance() => create();
  static $pb.PbList<Location> createRepeated() => $pb.PbList<Location>();
  @$core.pragma('dart2js:noInline')
  static Location getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location>(create);
  static Location? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get lat => $_getN(0);
  @$pb.TagNumber(1)
  set lat($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLat() => $_has(0);
  @$pb.TagNumber(1)
  void clearLat() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get lng => $_getN(1);
  @$pb.TagNumber(2)
  set lng($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLng() => $_has(1);
  @$pb.TagNumber(2)
  void clearLng() => clearField(2);
}

class PatientData extends $pb.GeneratedMessage {
  factory PatientData({
    $core.int? patientId,
    $core.String? patientName,
    $core.int? age,
    PatientData_Gender? gender,
    $fixnum.Int64? phone,
    $core.Iterable<$core.String>? symptoms,
    $core.double? temperature,
    $core.String? bloodPressure,
    $core.int? heartRate,
    $fixnum.Int64? timestampUnixMs,
    Location? location,
  }) {
    final $result = create();
    if (patientId != null) {
      $result.patientId = patientId;
    }
    if (patientName != null) {
      $result.patientName = patientName;
    }
    if (age != null) {
      $result.age = age;
    }
    if (gender != null) {
      $result.gender = gender;
    }
    if (phone != null) {
      $result.phone = phone;
    }
    if (symptoms != null) {
      $result.symptoms.addAll(symptoms);
    }
    if (temperature != null) {
      $result.temperature = temperature;
    }
    if (bloodPressure != null) {
      $result.bloodPressure = bloodPressure;
    }
    if (heartRate != null) {
      $result.heartRate = heartRate;
    }
    if (timestampUnixMs != null) {
      $result.timestampUnixMs = timestampUnixMs;
    }
    if (location != null) {
      $result.location = location;
    }
    return $result;
  }
  PatientData._() : super();
  factory PatientData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PatientData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PatientData', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'patientId', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'patientName')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'age', $pb.PbFieldType.OU3)
    ..e<PatientData_Gender>(4, _omitFieldNames ? '' : 'gender', $pb.PbFieldType.OE, defaultOrMaker: PatientData_Gender.GENDER_UNKNOWN, valueOf: PatientData_Gender.valueOf, enumValues: PatientData_Gender.values)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'phone', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPS(6, _omitFieldNames ? '' : 'symptoms')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'temperature', $pb.PbFieldType.OF)
    ..aOS(8, _omitFieldNames ? '' : 'bloodPressure')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'heartRate', $pb.PbFieldType.OU3)
    ..aInt64(10, _omitFieldNames ? '' : 'timestampUnixMs')
    ..aOM<Location>(11, _omitFieldNames ? '' : 'location', subBuilder: Location.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PatientData clone() => PatientData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PatientData copyWith(void Function(PatientData) updates) => super.copyWith((message) => updates(message as PatientData)) as PatientData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PatientData create() => PatientData._();
  PatientData createEmptyInstance() => create();
  static $pb.PbList<PatientData> createRepeated() => $pb.PbList<PatientData>();
  @$core.pragma('dart2js:noInline')
  static PatientData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PatientData>(create);
  static PatientData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get patientId => $_getIZ(0);
  @$pb.TagNumber(1)
  set patientId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientName => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPatientName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get age => $_getIZ(2);
  @$pb.TagNumber(3)
  set age($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAge() => $_has(2);
  @$pb.TagNumber(3)
  void clearAge() => clearField(3);

  @$pb.TagNumber(4)
  PatientData_Gender get gender => $_getN(3);
  @$pb.TagNumber(4)
  set gender(PatientData_Gender v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGender() => $_has(3);
  @$pb.TagNumber(4)
  void clearGender() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get phone => $_getI64(4);
  @$pb.TagNumber(5)
  set phone($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPhone() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhone() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.String> get symptoms => $_getList(5);

  @$pb.TagNumber(7)
  $core.double get temperature => $_getN(6);
  @$pb.TagNumber(7)
  set temperature($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTemperature() => $_has(6);
  @$pb.TagNumber(7)
  void clearTemperature() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get bloodPressure => $_getSZ(7);
  @$pb.TagNumber(8)
  set bloodPressure($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasBloodPressure() => $_has(7);
  @$pb.TagNumber(8)
  void clearBloodPressure() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get heartRate => $_getIZ(8);
  @$pb.TagNumber(9)
  set heartRate($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasHeartRate() => $_has(8);
  @$pb.TagNumber(9)
  void clearHeartRate() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get timestampUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set timestampUnixMs($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTimestampUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearTimestampUnixMs() => clearField(10);

  @$pb.TagNumber(11)
  Location get location => $_getN(10);
  @$pb.TagNumber(11)
  set location(Location v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasLocation() => $_has(10);
  @$pb.TagNumber(11)
  void clearLocation() => clearField(11);
  @$pb.TagNumber(11)
  Location ensureLocation() => $_ensure(10);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
