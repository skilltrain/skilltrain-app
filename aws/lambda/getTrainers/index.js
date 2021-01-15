"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async function (event, context) {
  const ddb = new AWS.DynamoDB.DocumentClient();

  const queries = event.queryStringParameters;

  let responseBody;
  let statusCode;

  const getQueryExpression = fields => {
    let exp = {
      FilterExpression: "",
      ExpressionAttributeNames: {},
      ExpressionAttributeValues: {},
    };
    Object.entries(fields).forEach(([key, item]) => {
      exp.FilterExpression += ` #${key} = :${key} AND`;
      exp.ExpressionAttributeNames[`#${key}`] = key;
      exp.ExpressionAttributeValues[`:${key}`] = item;
    });
    console.log(exp.FilterExpression);
    exp.FilterExpression = exp.FilterExpression.slice(0, -4);
    console.log(exp.FilterExpression);

    return exp;
  };

  let expression = queries ? getQueryExpression(queries) : null;

  const params = {
    TableName: "Trainers",
    ...expression,
  };

  try {
    const data = await ddb.scan(params).promise();
    responseBody = JSON.stringify(data.Items);
    statusCode = 200;
  } catch (error) {
    responseBody = `Unable to get Trainers: ${error}`;
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
