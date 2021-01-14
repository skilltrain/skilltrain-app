/* Amplify Params - DO NOT EDIT
	ENV
	REGION
	STORAGE_SKILLTRAINAMPLIFYDB_ARN
	STORAGE_SKILLTRAINAMPLIFYDB_NAME
Amplify Params - DO NOT EDIT */

var AWS = require("aws-sdk");
var region = process.env.REGION;
var ddb_table_name = process.env.STORAGE_SKILLTRAINAMPLIFYDB_NAME;
AWS.config.update({ region: region });
var ddb = new AWS.DynamoDB({ apiVersion: "latest" });

// function write(params, context) {
//   ddb.putItem(params, function (err, data) {
//     if (err) {
//       console.log("Error", err);
//     } else {
//       console.log("Success", data);
//     }
//   });
// }

exports.handler = async function (event, context) {
  //eslint-disable-line

  console.log(event.queryStringParameters);
  console.log(typeof event.queryStringParameters.username);
  var params = {
    TableName: ddb_table_name,
    Item: {
      username: { S: event.queryStringParameters["username"] },
    },
  };

  console.log(params);

  let statusCode;
  let responseBody;

  try {
    const data = await ddb.put(params).promise();
    responseBody = JSON.stringify(data);
    statusCode = 201;
  } catch (err) {
    responseBody = `Unable to put trainer: ${err}`;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body: responseBody,
  };

  return response;
};
