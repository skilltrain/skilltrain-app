"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async function (event, context) {
const ddb = new AWS.DynamoDB.DocumentClient();
  
  let statusCode = 0;
  let responseBody = {};
  
  const params = {
    TableName: "Sessions",
    Key: {
      id: event.pathParameters.id,
    },
  };

  try {
 const data = await ddb.get(params).promise();
 responseBody = JSON.stringify(data.Item);
    statusCode = 200;

  } catch (error) {
  
    responseBody = `Unable to get session: ${error}`;
    statusCode = 403;
  }

 const response = {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body: responseBody,
  };
  
  console.log(response);
  return response;

};





