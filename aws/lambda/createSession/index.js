"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = function (event, context, callback) {
  const ddb = new AWS.DynamoDB.DocumentClient();

  const data = JSON.parse(event.body);

  const params = {
    TableName: "Sessions",
    Item: {
      id:data.id,
      trainer_username: data.trainer_username,
      user_username: data.user_username,
      date: data.date,
      sessionCode: data.sessionCode,
      complete: data.complete,
      status: data.status,
      start_time: data.start_time,
      end_time: data.end_time,
    
    },
  };

  ddb.put(params, error => {
    if (error) {
      console.error(error);
      callback(null, {
        statusCode: error.statusCode || 501,
        headers: { "Content-Type": "text/plain" },
        body: "Couldnt add session.",
      });
      return;
    }
    //return item
    const response = {
      statusCode: 200,
      body: JSON.stringify(params.Item),
    };
    callback(null, response);
  });
};
