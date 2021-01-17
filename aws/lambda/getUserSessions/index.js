"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async (event, context) => {
  const ddb = new AWS.DynamoDB.DocumentClient();

  let responseBody;

  const { username } = event.params;

  const params = {
    TableName: "Sessions",
    FilterExpression: "#u = :u",
    ExpressionAttributeNames: {
      "#u": "user_username",
    },
    ExpressionAttributeValues: {
      ":u": username,
    },
  };

  try {
    const data = await ddb.scan(params).promise();
    responseBody = data.Items;
  } catch (err) {
    responseBody = "Unable to get user's sessions";
  }

  return responseBody;
};
