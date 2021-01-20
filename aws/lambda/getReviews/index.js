"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async function (event, context) {
  const ddb = new AWS.DynamoDB.DocumentClient();

  const params = {
    TableName: "Reviews",
  };

  let responseBody;
let statusCode;
  try {
    const data = await ddb.scan(params).promise();
    responseBody = JSON.stringify(data.Items);
        statusCode = 200;

  } catch (error) {
        statusCode: 403,

    responseBody = `Unable to get reviews: ${error}`;
  }
const response = {
      statusCode: statusCode,

  body: responseBody,

      headers: {
      "Content-Type": "application/json",
    },
 
  }
  return response;
};
