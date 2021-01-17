"use strict";
const AWS = require("aws-sdk");

AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async (event, context, callback) => {
  const ddb = new AWS.DynamoDB.DocumentClient();
  const dateUpdated = new Date().getTime();
  const data = JSON.parse(event.body);

const generateUpdateQuery = (fields) => {
    let exp = {
        UpdateExpression: 'set',
        ExpressionAttributeNames: {},
        ExpressionAttributeValues: {}
    }
    Object.entries(fields).forEach(([key, item]) => {
        exp.UpdateExpression += ` #${key} = :${key},`;
        exp.ExpressionAttributeNames[`#${key}`] = key;
        exp.ExpressionAttributeValues[`:${key}`] = item
    })
    exp.UpdateExpression = exp.UpdateExpression.slice(0, -1);
    return exp
}

let expression = generateUpdateQuery(data)

let params = {
    TableName: "Sessions",
        Key: {
      id: event.pathParameters.id,
    },
    ReturnValues: "ALL_NEW",
    ...expression
}

console.log(params);
  let responseBody;
  let statusCode;

  try {
    const data = await ddb.update(params).promise();
    responseBody = JSON.stringify(data);
    statusCode = 201;
  } catch (err) {
    responseBody = `Unable to update trainer: ${err}`;
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

