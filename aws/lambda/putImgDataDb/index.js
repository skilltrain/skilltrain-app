
// const AWS = require("aws-sdk");
// const s3 = new AWS.S3();
// const ddb = new AWS.DynamoDB.DocumentClient();

// exports.handler = async event => {
//   let statusCode = 0;
//   let responseBody = "";
//   const { name } = event.Records[0].s3.bucket;
//   const { key } = event.Records[0].s3.object;

//   console.log("event.records[0].s3" + JSON.stringify(event.Records[0].s3));

//   const username = key.split("/")[3];
//   const userType = key.split("/")[2];
//   const picType = key.split("/")[4];
//   const params = {
//     Bucket: name,
//     Key: key,
//   };

//   try {
//     const s3HeadData = await s3.headObject(params).promise();

//     const type = s3HeadData.Metadata["type"];
//     console.log(type);
//     const putParams = {
//       TableName: userType,
//       Key: {
//         username: username,
//       },
//       UpdateExpression: `SET ${picType} = :img`,
//       ExpressionAttributeValues: {
//         ":img": key,
//       },
//       ReturnValues: "ALL_NEW",
//     };
//     await ddb.update(putParams).promise();
//     responseBody = `Succesfully added ${key} to ${picType} attr of ${username} in ${userType} table`;
//     statusCode = 201;
//   } catch (err) {
//     responseBody = "Error" + err;
//     statusCode = 403;
//   }

//   const response = {
//     statusCode: statusCode,
//     body: responseBody,
//   };

//   return response;
// };

// eslint-disable-next-line
// exports.handler = function(event, context) {
//   console.log('Received S3 event:', JSON.stringify(event, null, 2));
//   // Get the object from the event and show its content type
//   const bucket = event.Records[0].s3.bucket.name; //eslint-disable-line
//   const key = event.Records[0].s3.object.key; //eslint-disable-line
//   console.log(`Bucket: ${bucket}`, `Key: ${key}`);
//   context.done(null, 'Successfully processed S3 event'); // SUCCESS with message
// };




const AWS = require("aws-sdk");
const s3 = new AWS.S3();
const ddb = new AWS.DynamoDB.DocumentClient();

exports.handler = async event => {
  let statusCode = 0;
  let responseBody = "";
  const { name } = event.Records[0].s3.bucket;
  const { key } = event.Records[0].s3.object;
  
  const username = key.split("/")[3];
  const userType = key.split("/")[2];

  const params = {
    Bucket: name,
    Key: key,
  };
  console.log("params = ", params);
  try {
    const s3HeadData = await s3.headObject(params).promise();
    const type = s3HeadData.Metadata["type"];
    const putParams = {
      TableName: userType,
      Key: {
        username: username,
      },
      UpdateExpression: `SET ${type} = :img`,
      ExpressionAttributeValues: {
        ":img": key,
      },
      ReturnValues: "ALL_NEW",
    };
    console.log(putParams);
    await ddb.update(putParams).promise();
    responseBody = `Succesfully added ${key} to profileImg attr of ${username} in ${userType} table`;
    statusCode = 201;
  } catch (err) {
    responseBody = "Error" + err;
    statusCode = 403;
  }

  const response = {
    statusCode: statusCode,
    body: responseBody,
  };
  console.log(response)
  return response;
};
