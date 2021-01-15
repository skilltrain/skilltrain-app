"use strict";
const AWS = require("aws-sdk");

AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async (event, context, callback) => {
  const ddb = new AWS.DynamoDB.DocumentClient();

  const data = JSON.parse(event.body);

  const params = {
    TableName: "Trainers",
    Item: {
      id: data.id,
      username: data.username,
      email: data.email,
      dateCreated: data.dateCreated,
      bio: data.bio,
      sessions_complete: data.sessions_complete,
      stats: data.stats,
      rating: data.rating,
      classPhoto: data.classPhoto,
      portrait: data.portrait,
      instructor: data.instructor,
      price: data.price,
      genre: data.genre,
      availability: data.availability,
      stripe: data.stripe,
      
    },
  };
  let responseBody;
  let statusCode;

  try {
    const data = await ddb.put(params).promise();
    responseBody = JSON.stringify(data);
    statusCode = 201;
  } catch (err) {
    responseBody = `Unable to put trainer: ${err}`;
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
