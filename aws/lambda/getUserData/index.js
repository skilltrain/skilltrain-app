"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = function (event, context, callback) {
  const ddb = new AWS.DynamoDB.DocumentClient();

  const params = {
    TableName: "Users",
    Key: {
      username: event.pathParameters.username,
    },
  };

  ddb.get(params, (error, result) => {
    if (error) {
      console.error(error);
      callback(null, {
        statusCode: error.statusCode || 501,
        headers: { "Content-Type": "text/plain" },
        body: "Couldn't fetch user.",
      });
      return;
    }
    //return item
    const response = {
      statusCode: 200,
      body: JSON.stringify(result.Item),
    };
    callback(null, response);
  });
};
