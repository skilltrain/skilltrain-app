"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async (event, context) => {
  const ddb = new AWS.DynamoDB.DocumentClient();

  let responseBody;

  console.log(event);

  const { username } = event.params;
  const { date } = event.query;

  let filter = "#t = :tu";
  let attrNames = {
    "#t": "trainer_username",
  };

  let attrVals = {
    ":tu": username,
  };

  if (date) {
    attrNames = {
      "#t": "trainer_username",
      "#d": "date",
    };
    attrVals = {
      ":tu": username,
      ":d": date,
    };
    filter = "#t = :tu AND #d = :d";
  }

  const params = {
    TableName: "Sessions",
    FilterExpression: filter,
    ExpressionAttributeNames: attrNames,
    ExpressionAttributeValues: attrVals,
  };

  try {
    const data = await ddb.scan(params).promise();
    responseBody = data.Items;
  } catch (err) {
    responseBody = "Unable to get trainer's sessions";
  }

  if (date) {
    responseBody = responseBody.sort((a, b) =>
      a.start_time > b.start_time ? 1 : -1
    );
  }

  return responseBody;
};
