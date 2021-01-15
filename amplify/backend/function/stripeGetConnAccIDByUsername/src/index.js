
/* Amplify Params - DO NOT EDIT
	ENV
	REGION
	STORAGE_SKILLTRAINAMPLIFYDB_ARN
	STORAGE_SKILLTRAINAMPLIFYDB_NAME
Amplify Params - DO NOT EDIT */

var AWS = require("aws-sdk");
var region = process.env.REGION;
var ddb_table_name = process.env.STORAGE_SKILLTRAINAMPLIFYDB_NAME;
AWS.config.update({ region: region });

exports.handler = async (event) => {

    const trainerUsername = event.queryStringParameters["username"];
    const ddb = new AWS.DynamoDB.DocumentClient();
    let statusCode = 200;

    const dbParams = {
        TableName: ddb_table_name,
        Key: {
          "username": trainerUsername,
        },
      };

    const record = await ddb.get(dbParams, function(err, data) {
        if (err) {
            statusCode = 400
            console.error("Unable to read item. Error JSON:", JSON.stringify(err, null, 2));
        } else {
            console.log(data);
            console.log(JSON.stringify(data));
            console.log("GetItem succeeded:", JSON.stringify(data, null, 2));
        }
    }).promise();

    // TODO implement
    const response = {
        statusCode: statusCode,
    //  Uncomment below to enable CORS requests
    //  headers: {
    //      "Access-Control-Allow-Origin": "*",
    //      "Access-Control-Allow-Headers": "*"
    //  }, 
        body: JSON.stringify(record.Item.connAccId),
    };
    return response;
};
