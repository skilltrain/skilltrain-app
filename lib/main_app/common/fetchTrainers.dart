import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_core/amplify_core.dart';

//Fetch All Trainer Data
Future fetchFilteredTrainers(genre) async {
  final response = await http.get(
      'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers?genre=$genre');

  if (response.statusCode == 200) {
    var res = await jsonDecode(response.body);
    for (var trainer in res) {
      trainer["sessionPhoto"] = await getUrl(trainer["sessionPhoto"]);
      trainer["profilePhoto"] = await getUrl(trainer["profilePhoto"]);
    }
    return res;
  } else {
    throw Exception('Failed to load album');
  }
}

Future fetchTrainers() async {
  final response = await http.get(
      'https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers');

  if (response.statusCode == 200) {
    var res = await jsonDecode(response.body);
    for (var trainer in res) {
      trainer["sessionPhoto"] = await getUrl(trainer["sessionPhoto"]);
      trainer["profilePhoto"] = await getUrl(trainer["profilePhoto"]);
    }
    return res;
  } else {
    throw Exception('Failed to load album');
  }
}

Future getUrl(key) async {
  try {
    S3GetUrlOptions options =
        S3GetUrlOptions(accessLevel: StorageAccessLevel.guest, expires: 30000);
    GetUrlResult result =
        await Amplify.Storage.getUrl(key: key, options: options);
    return result.url;
  } catch (e) {
    print(e.toString());
  }
}
