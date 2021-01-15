"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async function (event, context) {
const ddb = new AWS.DynamoDB.DocumentClient();
  
  let statusCode = 0;
  let responseBody = {};
  
  const params = {
    TableName: "Trainers",
    Key: {
      username: event.pathParameters.username,
    },
  };

  try {
 const data = await ddb.get(params).promise();
 responseBody = JSON.stringify(data.Item);
    statusCode = 200;

  } catch (error) {
  
    responseBody = `Unable to get sessions: ${error}`;
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

  // ddb.get(params, (error, result) => {
  //   if (error) {
  //     console.error(error);
  //     callback(null, {
  //       statusCode: error.statusCode || 501,
  //       headers: { "Content-Type": "text/plain" },
  //       body: "Couldn't fetch trainer.",
  //     });
  //     return;
  //   }
  //   //return item
  //   const response = {
  //     statusCode: 200,
  //     body: JSON.stringify(result.Item),
  //   };
  //   callback(null, response);
  // });
};





