"use strict";
const AWS = require("aws-sdk");

AWS.config.update({ region: "ap-northeast-1" });

exports.handler = async (event, context, callback) => {
  const ddb = new AWS.DynamoDB.DocumentClient();

  const data = JSON.parse(event.body);
  console.log(data);
  const timestamp = new Date().getTime();

  const params = {
    TableName: "Trainers",
    Item: {
      id: data.id,
      username: data.username,
      email: data.email,
      dateCreated: timestamp,
      bio: data.bio,
      sessions_complete: data.sessions_complete,
      stats: data.stats,
      rating: data.rating,
      sessionPhoto: data.sessionPhoto,
      profilePhoto: data.profilePhoto,
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
