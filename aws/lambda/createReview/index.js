"use strict";
const AWS = require("aws-sdk");

AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async (event,) => {
  const ddb = new AWS.DynamoDB.DocumentClient();

  const data = JSON.parse(event.body);
const timestamp = new Date().getTime();

console.log("data = "+data);
  const params = {
    TableName: "Reviews",
    Item: {
      trainer_username: data.trainer_username,
      rating: data.rating,
      review: data.review,
      user_username: data.user_username,
      timestamp: timestamp,
    },
  };
  let responseBody;
  let statusCode;

  try {
    const data = await ddb.put(params).promise();
    responseBody = JSON.stringify(data);
    statusCode = 201;
  } catch (err) {
    responseBody = `Unable to put review: ${err}`;
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
