"use strict";
const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async (event, context) => {
  const ddb = new AWS.DynamoDB.DocumentClient();
    
   let responseBody;
   let statusCode;
  const { username } = event.pathParameters;
     
    var params = {
            TableName: "Reviews",
            KeyConditionExpression: "#trainer_username = :trainer_username",
            ExpressionAttributeNames:{
                "#trainer_username": "trainer_username"
            },
            ExpressionAttributeValues: {
                ":trainer_username":username
            }
        };


        try {
    const data = await ddb.query(params).promise();
    responseBody =JSON.stringify( data.Items)
    statusCode = 200;
    
  } catch (err) {
    responseBody = "Unable to get trainer's sessions";
    statusCode = 400;
  }
const response = { 
  body: responseBody,
  statusCode: statusCode,
    headers: {
      "Content-Type": "application/json",
    },
}  ;
  
return response;
};
