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

import 'package:protobuf/protobuf.dart' as $pb;

class PatientData_Gender extends $pb.ProtobufEnum {
  static const PatientData_Gender GENDER_UNKNOWN = PatientData_Gender._(0, _omitEnumNames ? '' : 'GENDER_UNKNOWN');
  static const PatientData_Gender GENDER_MALE = PatientData_Gender._(1, _omitEnumNames ? '' : 'GENDER_MALE');
  static const PatientData_Gender GENDER_FEMALE = PatientData_Gender._(2, _omitEnumNames ? '' : 'GENDER_FEMALE');
  static const PatientData_Gender GENDER_OTHER = PatientData_Gender._(3, _omitEnumNames ? '' : 'GENDER_OTHER');

  static const $core.List<PatientData_Gender> values = <PatientData_Gender> [
    GENDER_UNKNOWN,
    GENDER_MALE,
    GENDER_FEMALE,
    GENDER_OTHER,
  ];

  static final $core.Map<$core.int, PatientData_Gender> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PatientData_Gender? valueOf($core.int value) => _byValue[value];

  const PatientData_Gender._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
