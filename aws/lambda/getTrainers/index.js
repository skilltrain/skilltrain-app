"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async function (event, context) {
  const ddb = new AWS.DynamoDB.DocumentClient();

  const params = {
    TableName: "Trainers",
  };

  let responseBody;
  let statusCode;

  try {
    const data = await ddb.scan(params).promise();
    responseBody = JSON.stringify(data.Items);
    statusCode = 200;
  } catch (error) {
    responseBody = `Unable to get trainers: ${error}`;
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
