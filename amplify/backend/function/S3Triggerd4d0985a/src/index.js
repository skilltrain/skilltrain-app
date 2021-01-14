const AWS = require("aws-sdk");
const ddb = new AWS.DynamoDB.DocumentClient();

exports.handler = async event => {
  let statusCode = 0;
  let responseBody = "";
  const { name } = event.Records[0].s3.bucket;
  let { key } = event.Records[0].s3.object;

  //remove public/
  key = key.split("/").slice(1).join("/");

  const username = key.split("/")[2];
  let userType = key.split("/")[1];
  const picType = key.split("/")[3];
  userType = `${userType.charAt(0).toUpperCase()}${userType.slice(1)}`;

  try {
    const putParams = {
      TableName: userType,
      Key: {
        username: username,
      },
      UpdateExpression: `SET ${picType} = :img`,
      ExpressionAttributeValues: {
        ":img": key,
      },
      ReturnValues: "ALL_NEW",
    };

    await ddb
      .update(putParams)
      .promise()
      .then(data => console.log(data));
    responseBody = `Succesfully added ${key} to ${picType} attr of ${username} in ${userType} table`;
    statusCode = 201;
  } catch (err) {
    responseBody = "Error" + err;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
  };
  console.log(response);
  return response;
};
