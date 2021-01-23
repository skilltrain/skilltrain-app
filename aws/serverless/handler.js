'use strict';
const AWS = require("aws-sdk");
require("aws-sdk/clients/apigatewaymanagementapi");
AWS.config.update({ region: "ap-northeast-1" });

const success = {
  statusCode: 200
};
module.exports.connectionHandler = async (event, context) => { 
  
  if (event.requestContext.eventType === 'CONNECT') {
    console.log(`[ConnectionHandler] Connected: ${JSON.stringify(event, null, 2)}`);
    return success;
  }
  else if (event.requestContext.eventType === 'DISCONNECT') {
    console.log(`[ConnectionHandler] Disconnected: ${JSON.stringify(event, null, 2)}`);
    return success;
  }
};
module.exports.defaultHandler = async (event, context) => {
  let connectionId = event.requestContext.connectionId;
  const endpoint = event.requestContext.domainName + "/" + event.requestContext.stage;
  console.log('[defaultHandler] endpoint is: ' + endpoint);
  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
      apiVersion: "2018-11-29",
      endpoint: endpoint
  });
  const params = {
      ConnectionId: connectionId,
      Data: 'Seems like wrong endpoint'
  };
  return apigwManagementApi.postToConnection(params).promise();
};

module.exports.databaseStreamHandler = async (event, context) => {
  console.log(JSON.stringify(event, null, 2));
  const body = JSON.parse(event.body);
  const randNum = body.data.body.randNum;
  const msg = body.data.body.msg;
  
  let connectionId = event.requestContext.connectionId;
  const endpoint = event.requestContext.domainName + "/" + event.requestContext.stage;
  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
      apiVersion: "2018-11-29",
      endpoint: endpoint
    });
  console.log(randNum);
  console.log(msg);
  const params = {
      ConnectionId: connectionId,
      Data: JSON.stringify({connectionID: connectionId, randNum: randNum, msg:msg}),
    };
  console.log('Params', params);
  return apigwManagementApi.postToConnection(params).promise();
};

module.exports.writeMessageHandler = async(event, context) => {
  const body = JSON.parse(event.body);
  const msg = body.data.body.msg;

  let connectionId = event.requestContext.connectionId;
  const endpoint = event.requestContext.domainName + "/" + event.requestContext.stage;
  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
      apiVersion: "2018-11-29",
      endpoint: endpoint
    });

  const ddb = new AWS.DynamoDB.DocumentClient();

  const dbParams = {
    TableName: "eliot-test",
    Item: {
      msg: msg,
    },
  };

  try {
    const data = await ddb.put(dbParams).promise();
    // responseBody = JSON.stringify(data);
    // statusCode = 201;
  } catch (err) {
    console.log(err);
    // responseBody = `Unable to put trainer: ${err}`;
    // statusCode = 403;
  }

  const params = {
    ConnectionId: connectionId,
    Data: JSON.stringify({connectionID: connectionId, msg:msg}),
  };

  return apigwManagementApi.postToConnection(params).promise();

}

module.exports.getMessagesHandler = async(event, context) => {
  const ddb = new AWS.DynamoDB.DocumentClient();

  let connectionId = event.requestContext.connectionId;
  const endpoint = event.requestContext.domainName + "/" + event.requestContext.stage;
  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
      apiVersion: "2018-11-29",
      endpoint: endpoint
    });

  const ddbparams = {
    TableName: "eliot-test",
  };


  let data;

  try {
    data = await ddb.scan(ddbparams).promise();
  } catch (error) {
    console.log(error);
  }

  const params = {
    ConnectionId: connectionId,
    Data: JSON.stringify({connectionID: connectionId, msg:data}),
  };

  return apigwManagementApi.postToConnection(params).promise();

}


















// module.exports.createConnectedUser = async (event, context) => {
//   let response = {};
//   console.log('Received event: ', JSON.stringify(event, null, 2));
 
//   const {connectionId, ipAddress, connectedAt, userName} = event;
//   var params = {
//     TableName: process.env.TABLE_NAME,
//     Item: {
//       "collection": "CONNECTED",  
//       "subCollection": "CONNECTED#USER#" + ipAddress,
//       "data": {
//         "connectionId": connectionId,
//         "ipAddress": ipAddress,
//         "connectedAt": connectedAt,
//         "userName": userName
//       }
//     }
//   }
//   try {
//     const data = await docClient.put(params).promise();
//     response = {
//       statusCode: 200,
//       body: data,
//     };
//     console.log("Added item:", JSON.stringify(data, null, 2));
//   } catch(err) {
//     response = {
//       statusCode: 400,
//       body: err,
//     };
//     console.error("Unable to create item. Error JSON:",    JSON.stringify(err, null, 2));
//   }
//   return JSON.stringify(response);
// }
// module.exports.updateConnected = async (event, context, callback) => {
//   let response = {};
//   console.log('Received event: ', JSON.stringify(event, null, 2));
  
//   // destruct
//   const {connectionId, ipAddress, connectedAt, userName} = event;
//   let updateExpressionString = 
//     "set "+
//     "#data.#userName = :userName, " +
//     "#data.#connectionId = :connectionId, " +
//     "#data.#ipAddress = :ipAddress, " +
//     "#data.#connectedAt = :connectedAt";
//   var params = {
//     TableName: process.env.TABLE_NAME,
//     Key:{
//       "collection": "CONNECTED",
//       "subCollection": "CONNECTED#USER#" + ipAddress,
//     },
//     UpdateExpression: updateExpressionString,
//     ExpressionAttributeNames:{
//       "#data": "data",
//       "#userName": "userName",
//       "#connectionId": "connectionId",
//       "#ipAddress": "ipAddress",
//       "#connectedAt": "connectedAt"
//     },
//     ExpressionAttributeValues:{
//       ":userName": userName,
//       ":connectionId": connectionId,
//       ":ipAddress": ipAddress,
//       ":connectedAt": connectedAt ? connectedAt : 0
//     },
//     ReturnValues:"UPDATED_NEW"
//   };
//   try {
//     const data = await docClient.update(params).promise();
//     response = {
//       statusCode: 200,
//       message: "Update completed",
//       body: data,
//     };
//     console.log("UpdateItem succeeded:", JSON.stringify(data, null, 2));
//   } catch(err) {
//     response = {
//       statusCode: 400,
//       message: "Update error",
//       body: err,
//     };
//     console.error("Unable to update item. Error JSON:", JSON.stringify(err, null, 2));
//   }
//   //callback(null, response);
//   return JSON.stringify(response);
// };
// module.exports.getConnected = async (event, context, callback) => {
//   let response = {};
//   console.log('Received parameter in event: ', JSON.stringify(event,   null, 2));
//   var params = {
//     TableName: process.env.TABLE_NAME,
//     FilterExpression: "#collectionName = :cname AND (attribute_exists(#data.#ipAddress) AND NOT #data.#ipAddress = :null)",
//     ExpressionAttributeNames:{
//       "#collectionName": "collection",
//       "#data": "data",
//       "#ipAddress": "ipAddress"
//     },
//     ExpressionAttributeValues: {
//       ":cname": "CONNECTED",
//       ":null": null
//     }
//   }
//   try {
//     const data = await docClient.scan(params).promise();
   
//     response = {
//       statusCode: 200,
//       message: "Scan completed",
//       body: data.Items,
//     };
//     console.log('Printing all scanned items....');
//     data.Items.forEach((el) => {
//       JSON.stringify(el, null, 2)
//     });
//   } catch(err) {
//     response = {
//       statusCode: 400,
//       message: "Scan error",
//       body: err,
//     };
//     console.error("Unable to get item. Error JSON:", JSON.stringify(err, null, 2));
//   }
//   //callback(null, response);
//   return JSON.stringify(response);
// };
// module.exports.createMessageUser = async (event, context) => {
  
//   let response = {};
//   console.log('Received event: ', JSON.stringify(event, null, 2));
  
//   // destruct
//   const {ipAddress, content, userName} = event;
//   // create uuid
//   const uuid = uuidv4();
//   var params = {
//     TableName: process.env.TABLE_NAME,
//     Item: {
//       "collection": "MESSAGES",  
//       "subCollection": "MESSAGES#ID#" + uuid,
//       "data": {
//         "id": uuid,
//         "ipAddress": ipAddress,
//         "content": content,
//         "userName": userName,
//         "created": Date.now()
//       }
//     }
//   }
//   try {
//     const data = await docClient.put(params).promise();
//     response = {
//       statusCode: 200,
//       body: data,
//     };
//     console.log("Added item:", JSON.stringify(data, null, 2));
//   } catch(err) {
//     response = {
//       statusCode: 400,
//       body: err,
//     };
//     console.error("Unable to create item. Error JSON:", JSON.stringify(err, null, 2));
//   }
//   return JSON.stringify(response);  
// }
// // This is called only once when user logs in.
// module.exports.getMessage = async (event, context) => {
//   let response = {};
//   console.log('Received parameter in event: ', JSON.stringify(event, null, 2));
//   var params = {
//     TableName: process.env.TABLE_NAME,
//     FilterExpression: "#collectionName = :cname AND  (attribute_exists(#data.#ipAddress) AND NOT #data.#ipAddress = :null)",
//     Limit: 40,
//     ExpressionAttributeNames:{
//       "#collectionName": "collection",
//       "#data": "data",
//       "#ipAddress": "ipAddress"
//     },
//     ExpressionAttributeValues: {
//       ":cname": "MESSAGES",
//       ":null": null
//     }
//   }
//   try {
//     const data = await docClient.scan(params).promise();
    
//     response = {
//       statusCode: 200,
//       message: "Scan completed",
//       body: data.Items,
//     };
//     console.log('Printing all scanned items....');
//     data.Items.forEach((el) => {
//       JSON.stringify(el, null, 2)
//     });
//   } catch(err) {
//     response = {
//       statusCode: 400,
//       message: "Scan error",
//       body: err,
//     };
//     console.error("Unable to get item. Error JSON:", JSON.stringify(err, null, 2));
//   }
//   return JSON.stringify(response);
// };
// module.exports.chatTableStreamHandler = async (event, context, callback) => {
//   let allListenedData = {};
//   event.Records.forEach(function(record) {
//     console.log(record.eventID);
//     console.log(record.eventName);
//     console.log('DynamoDB Record: %j', record.dynamodb);
//     // Handle MESSAGES collection only
//     if(record.eventName === "INSERT" && record.dynamodb.StreamViewType === "NEW_IMAGE" && record.dynamodb.Keys['collection']['S'] === 'MESSAGES') {
      
//       // Collect data
//       allListenedData = {
//         "created": record.dynamodb.NewImage['data']['M']['created']['N'],
//         "ipAddress": record.dynamodb.NewImage['data']['M']['ipAddress']['S'],
//         "id": record.dynamodb.NewImage['data']['M']['id']['S'],
//         "userName": record.dynamodb.NewImage['data']['M']['userName']['S'],
//         "content": record.dynamodb.NewImage['data']['M']['content']['S'],
//       };
      
//     }
//   });
//   console.log('Picked Data: ', allListenedData);
//   // Get connected users
//   var lambda = new AWS.Lambda({
//     region: process.env.REGION_NAME
//   });
//   const lambdaParams = {
//     FunctionName: process.env.SERVICE_NAME + '-' + process.env.STAGE_NAME + '-getConnected'
//   };
//   try {
//     const res = await lambda.invoke(lambdaParams).promise();
   
//     console.log('Get all connected user Lambda called: ', JSON.stringify(res, null, 2));
//     console.log('Res type is ' + typeof res.Payload);
//   if (res.StatusCode === 200) {
//       let parsedData = JSON.parse(res.Payload);
//       let parsedAgainData = JSON.parse(parsedData);
//       let connectedUserList = parsedAgainData.body ? [...parsedAgainData.body] : [];
//       console.log('Connected List: ', connectedUserList);
//   // create task
//       let taskContainer = [];
//       function tempLambdaFunction(targetUserData) {
//         return new Promise(function async (resolve, reject){
 
//           let payload = {
//             "requestContext": {
//               "stage": "dev", 
//               "domainName": "us2q8s4g99.execute-api.us-east-1.amazonaws.com",  // Use Websocket URL
//               "connectionId": targetUserData['connectionId']
//             },
//             "body": {...allListenedData}
//           }
//   let lambda2Params = {
//             FunctionName: process.env.SERVICE_NAME + '-' + process.env.STAGE_NAME + '-webSocketMessageHandler',
//             Payload: JSON.stringify(payload, null, 2)
//           }
//           console.log('Executing for target: ', lambda2Params);
//           lambda.invoke(lambda2Params).promise().then(() => {
//             resolve();
//           }).catch((e) => {
//             reject(e);
//           });
//         });
//       }
//   for(let i = 0; i < connectedUserList.length; i++) {
//         const targetUserData = connectedUserList[i]['data'];
//         taskContainer.push(tempLambdaFunction(targetUserData));
//       }
//   Promise.all(taskContainer).then(() => {
//         callback(null, 'Done!');
//       }).catch(e => {
//         console.log('Error Promising ALL' + JSON.stringify(e));
//         callback(null, 'Error!');
//       })
//     }
//   } catch(e) {
//     console.log('Error Calling Lambda: ', JSON.stringify(e, null, 2));
//     callback(null, 'Error!');
//   }
// };
// module.exports.webSocketMessageHandler = async (event, context) => {
//   console.log(JSON.stringify(event, null, 2));
//   console.log('Type is ' + typeof event);
  
//   let parsedEvent = event; //JSON.parse(event);
//   let parsedBody = event.body;
  
//   let connectionId = parsedEvent.requestContext.connectionId;
//   const endpoint = parsedEvent.requestContext.domainName + "/" + parsedEvent.requestContext.stage;
  
//   console.log(`[WebSocket Message Handler] Connection Id: ${connectionId} and end point: ${endpoint}`);
//   const apigwManagementApi = new AWS.ApiGatewayManagementApi({
//       apiVersion: "2018-11-29",
//       endpoint: endpoint
//     });
//   const params = {
//       ConnectionId: connectionId,
//       Data: JSON.stringify({fromLogin: false, connectionID: connectionId, messageData: parsedBody}),
//     };
//   return apigwManagementApi.postToConnection(params).promise();
// };
