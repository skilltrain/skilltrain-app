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

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Trainers type in your schema. */
@immutable
class Trainers extends Model {
  static const classType = const TrainersType();
  final String id;
  final String first_name;
  final String last_name;
  final String username;
  final String email;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const Trainers._internal(
      {@required this.id,
      this.first_name,
      this.last_name,
      this.username,
      this.email});

  factory Trainers(
      {@required String id,
      String first_name,
      String last_name,
      String username,
      String email}) {
    return Trainers._internal(
        id: id == null ? UUID.getUUID() : id,
        first_name: first_name,
        last_name: last_name,
        username: username,
        email: email);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Trainers &&
        id == other.id &&
        first_name == other.first_name &&
        last_name == other.last_name &&
        username == other.username &&
        email == other.email;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Trainers {");
    buffer.write("id=" + id + ", ");
    buffer.write("first_name=" + first_name + ", ");
    buffer.write("last_name=" + last_name + ", ");
    buffer.write("username=" + username + ", ");
    buffer.write("email=" + email);
    buffer.write("}");

    return buffer.toString();
  }

  Trainers copyWith(
      {@required String id,
      String first_name,
      String last_name,
      String username,
      String email}) {
    return Trainers(
        id: id ?? this.id,
        first_name: first_name ?? this.first_name,
        last_name: last_name ?? this.last_name,
        username: username ?? this.username,
        email: email ?? this.email);
  }

  Trainers.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        first_name = json['first_name'],
        last_name = json['last_name'],
        username = json['username'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'username': username,
        'email': email
      };

  static final QueryField ID = QueryField(fieldName: "trainers.id");
  static final QueryField FIRST_NAME = QueryField(fieldName: "first_name");
  static final QueryField LAST_NAME = QueryField(fieldName: "last_name");
  static final QueryField USERNAME = QueryField(fieldName: "username");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Trainers";
    modelSchemaDefinition.pluralName = "Trainers";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PRIVATE, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Trainers.FIRST_NAME,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Trainers.LAST_NAME,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Trainers.USERNAME,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Trainers.EMAIL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class TrainersType extends ModelType<Trainers> {
  const TrainersType();

  @override
  Trainers fromJson(Map<String, dynamic> jsonData) {
    return Trainers.fromJson(jsonData);
  }
}
