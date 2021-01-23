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
    TableName: "Sessions",
    ExpressionAttributeNames: {
      '#Y': 'messages'
    },
    ExpressionAttributeValues: {
      ':y': ['hey']
    },
    Key: {
      id: "2023-03-0512:00ath-trainer"
    },
    UpdateExpression: "SET #Y = list_append(#Y,:y)"
  };

  try {
    const data = await ddb.update(dbParams).promise();
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
