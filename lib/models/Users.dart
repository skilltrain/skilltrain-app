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

/** This is an auto generated class representing the Users type in your schema. */
@immutable
class Users extends Model {
  static const classType = const UsersType();
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

  const Users._internal(
      {@required this.id,
      this.first_name,
      this.last_name,
      @required this.username,
      this.email});

  factory Users(
      {@required String id,
      String first_name,
      String last_name,
      @required String username,
      String email}) {
    return Users._internal(
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
    return other is Users &&
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

    buffer.write("Users {");
    buffer.write("id=" + id + ", ");
    buffer.write("first_name=" + first_name + ", ");
    buffer.write("last_name=" + last_name + ", ");
    buffer.write("username=" + username + ", ");
    buffer.write("email=" + email);
    buffer.write("}");

    return buffer.toString();
  }

  Users copyWith(
      {@required String id,
      String first_name,
      String last_name,
      @required String username,
      String email}) {
    return Users(
        id: id ?? this.id,
        first_name: first_name ?? this.first_name,
        last_name: last_name ?? this.last_name,
        username: username ?? this.username,
        email: email ?? this.email);
  }

  Users.fromJson(Map<String, dynamic> json)
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

  static final QueryField ID = QueryField(fieldName: "users.id");
  static final QueryField FIRST_NAME = QueryField(fieldName: "first_name");
  static final QueryField LAST_NAME = QueryField(fieldName: "last_name");
  static final QueryField USERNAME = QueryField(fieldName: "username");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Users";
    modelSchemaDefinition.pluralName = "Users";

    modelSchemaDefinition.authRules = [
      AuthRule(
          authStrategy: AuthStrategy.PRIVATE, operations: [ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.FIRST_NAME,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.LAST_NAME,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.USERNAME,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.EMAIL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class UsersType extends ModelType<Users> {
  const UsersType();

  @override
  Users fromJson(Map<String, dynamic> jsonData) {
    return Users.fromJson(jsonData);
  }
}
