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
  const sessionID = body.data.body.sessionID;
  const msg = body.data.body.msg;
  const isTrainer = body.data.body.isTrainer;
  const time = new Date().toLocaleString();
  const messageObject = {
    isTrainer: isTrainer,
    time: time,
    msg: msg
  };

  let connectionId = event.requestContext.connectionId;
  const endpoint = event.requestContext.domainName + "/" + event.requestContext.stage;
  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
      apiVersion: "2018-11-29",
      endpoint: endpoint
  });
    
  const ddb = new AWS.DynamoDB.DocumentClient();
  
  
  //Update current connection ID of relevant user
  // If there is no msg, assume initiating state on frontend
  if (msg === ' ') {
    try {
      const dbParams = {
        TableName: "Sessions",
        ExpressionAttributeNames: {
          '#Y': isTrainer ? 'trainer_connectionID' : 'user_connectionID'
        },
        ExpressionAttributeValues: {
          ':y': connectionId
        },
        Key: {
          id: sessionID
        },
          UpdateExpression: "SET #Y = :y"    
        
      };
      
      await ddb.update(dbParams).promise();
      
    } catch (err) {
      console.log(err);
    }
    return;
  }
  
  // Now, if both users are connected at the same time, we need to return a response
  // to both connectionIDs
  // Get the partner ID
  
  let partnerConnectionID;

  const ddbparams = {
    TableName: "Sessions",
    Key: {
      id: sessionID,
    },
    ProjectionExpression: isTrainer ? 'user_connectionID' : 'trainer_connectionID'
  };
  
  try {
    const data = await ddb.get(ddbparams).promise();
    console.log('partner connection ID', data);
    partnerConnectionID = isTrainer ? data.Item.user_connectionID : data.Item.trainer_connectionID;
  } catch (error) {
    console.log(error);
  }
  
  if (partnerConnectionID != null) {
    //If there is a partner ID, retrieve it and send a response to them (they may not be connected though)
    const params = {
      ConnectionId: partnerConnectionID,
      Data: JSON.stringify({connectionID: partnerConnectionID}),
    };
    apigwManagementApi.postToConnection(params).promise();
  }


  // Send it to the original person
  const params = {
    ConnectionId: connectionId,
    Data: JSON.stringify({connectionID: connectionId}),
  };

  apigwManagementApi.postToConnection(params).promise();
  
  
  

  //Add the message to the log, failsafe for if no current messages below
  try {
    const dbParams = {
      TableName: "Sessions",
      ExpressionAttributeNames: {
        '#Y': 'messages'
      },
      ExpressionAttributeValues: {
        ':y': [messageObject]
      },
      Key: {
        id: sessionID
      },
      UpdateExpression: "SET #Y = list_append(#Y,:y)"
    };
    
    await ddb.update(dbParams).promise();
    
  } catch (err) {
    console.log(err);
    // Failed, so it doesn't exist, or other error
    // Try creating the item
    console.log('next block');
    try {
      const dbParams = {
        TableName: "Sessions",
        ExpressionAttributeNames: {
        '#Y': 'messages'
        },
        ExpressionAttributeValues: {
          ':y': [messageObject]
        },
        Key: {
          id: sessionID
        },
        ConditionExpression: "attribute_not_exists(messages)",
        UpdateExpression: "SET #Y = :y"
      };
      
      await ddb.update(dbParams).promise();

    } catch (err) {
      console.log(err);
    }
  }
  
  return;


};
