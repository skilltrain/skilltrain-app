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
const Stripe = require("stripe");
const stripe = Stripe(
  "sk_test_51I8F0wCwmhFB6ae2JIv45lTRWveDwxUMMUG1k8yWvRINm0a3zJmvj0nybYPA4DBGaM3xIAIKfqndxzEJHpmfTJkk00TouBlgXv"
);

exports.handler = async (event) => {
  const accounts = await stripe.accounts.list();

  // TODO implement
  const response = {
    statusCode: null,
    //  Uncomment below to enable CORS requests
    //  headers: {
    //      "Access-Control-Allow-Origin": "*",
    //      "Access-Control-Allow-Headers": "*"
    //  },
    body: null,
  };

  for (const account of accounts.data) {
    try {
      const deleted = stripe.accounts.delete(account.id);
      console.log(deleted);
    } catch (e) {
      response.statusCode = 400;
      console.log(`Account could not be deleted: ${e}`);
      return response;
    }
  }

  response.statusCode = 200;
  return response;
};
