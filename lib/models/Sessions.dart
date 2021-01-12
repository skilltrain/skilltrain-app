/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Sessions type in your schema. */
@immutable
class Sessions extends Model {
  static const classType = const SessionsType();
  final String id;
  final Trainers TrainerSession;
  final Users UserSession;
  final DateTime session_time;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const Sessions._internal(
      {@required this.id,
      this.TrainerSession,
      this.UserSession,
      this.session_time});

  factory Sessions(
      {@required String id,
      Trainers TrainerSession,
      Users UserSession,
      DateTime session_time}) {
    return Sessions._internal(
        id: id == null ? UUID.getUUID() : id,
        TrainerSession: TrainerSession,
        UserSession: UserSession,
        session_time: session_time);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sessions &&
        id == other.id &&
        TrainerSession == other.TrainerSession &&
        UserSession == other.UserSession &&
        session_time == other.session_time;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Sessions {");
    buffer.write("id=" + id + ", ");
    buffer.write("TrainerSession=" +
        (TrainerSession != null ? TrainerSession.toString() : "null") +
        ", ");
    buffer.write("UserSession=" +
        (UserSession != null ? UserSession.toString() : "null") +
        ", ");
    buffer.write("session_time=" +
        (session_time != null
            ? session_time.toDateTimeIso8601String()
            : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Sessions copyWith(
      {@required String id,
      Trainers TrainerSession,
      Users UserSession,
      DateTime session_time}) {
    return Sessions(
        id: id ?? this.id,
        TrainerSession: TrainerSession ?? this.TrainerSession,
        UserSession: UserSession ?? this.UserSession,
        session_time: session_time ?? this.session_time);
  }

  Sessions.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        TrainerSession = json['TrainerSession'] != null
            ? Trainers.fromJson(
                new Map<String, dynamic>.from(json['TrainerSession']))
            : null,
        UserSession = json['UserSession'] != null
            ? Users.fromJson(new Map<String, dynamic>.from(json['UserSession']))
            : null,
        session_time = DateTimeParse.fromString(json['session_time']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'TrainerSession': TrainerSession?.toJson(),
        'UserSession': UserSession?.toJson(),
        'session_time': session_time?.toDateTimeIso8601String()
      };

  static final QueryField ID = QueryField(fieldName: "sessions.id");
  static final QueryField TRAINERSESSION = QueryField(
      fieldName: "TrainerSession",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: (Trainers).toString()));
  static final QueryField USERSESSION = QueryField(
      fieldName: "UserSession",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: (Users).toString()));
  static final QueryField SESSION_TIME = QueryField(fieldName: "session_time");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Sessions";
    modelSchemaDefinition.pluralName = "Sessions";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PRIVATE, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
        key: Sessions.TRAINERSESSION,
        isRequired: false,
        targetName: "sessionsTrainerSessionId",
        ofModelName: (Trainers).toString()));

    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
        key: Sessions.USERSESSION,
        isRequired: false,
        targetName: "sessionsUserSessionId",
        ofModelName: (Users).toString()));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Sessions.SESSION_TIME,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));
  });
}

class SessionsType extends ModelType<Sessions> {
  const SessionsType();

  @override
  Sessions fromJson(Map<String, dynamic> jsonData) {
    return Sessions.fromJson(jsonData);
  }
}
