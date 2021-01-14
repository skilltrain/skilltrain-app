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
var ddb = new AWS.DynamoDB({ apiVersion: "latest" });
const Stripe = require("stripe");
const stripe = Stripe(
  "sk_test_51I8F0wCwmhFB6ae2JIv45lTRWveDwxUMMUG1k8yWvRINm0a3zJmvj0nybYPA4DBGaM3xIAIKfqndxzEJHpmfTJkk00TouBlgXv"
);

exports.handler = async function (event, context) {
  const data = JSON.parse(event.body);

  var params = {
    TableName: ddb_table_name,
    Item: {
      username: { S: event.queryStringParameters["username"] },
    },
  };

  data.response;

  let statusCode;
  let responseBody;

  try {
    const res = await ddb.putItem(params).promise();
    responseBody = JSON.stringify(data);
    statusCode = 201;
  } catch (err) {
    responseBody = `Unable to put trainer: ${err}`;
    statusCode = 403;
  }

  const test = `${data.individual.last_name_kanji}${data.individual.first_name_kanji}`;
  console.log(test);
  console.log(typeof test);

  const account = await stripe.accounts.create({
    country: "JP",
    type: "custom",
    email: data.individual.email,
    capabilities: {
      card_payments: {
        requested: true,
      },
      transfers: {
        requested: true,
      },
    },
    business_type: "individual",
    individual: {
      address_kana: {
        city: data.individual.address_kana.city,
        country: "JP",
        line1: data.individual.address_kana.line1,
        line2: data.individual.address_kana.line2,
        postal_code: data.individual.address_kana.postal_code,
        state: data.individual.address_kana.state,
        town: data.individual.address_kana.town,
      },
      address_kanji: {
        city: data.individual.address_kanji.city,
        country: data.individual.address_kanji.country,
        country: "JP",
        line1: data.individual.address_kanji.line1,
        line2: data.individual.address_kanji.line2,
        postal_code: data.individual.address_kanji.postal_code,
        state: data.individual.address_kanji.state,
        town: data.individual.address_kanji.town,
      },
      dob: {
        day: data.individual.dob.day,
        month: data.individual.dob.month,
        year: data.individual.dob.year,
      },
      email: data.individual.email,
      first_name_kana: data.individual.first_name_kana,
      first_name_kanji: data.individual.first_name_kanji,
      gender: data.individual.gender,
      last_name_kana: data.individual.last_name_kana,
      last_name_kanji: data.individual.last_name_kanji,
      phone: data.individual.phone,
    },
    external_account: {
      object: "bank_account",
      country: "JP",
      currency: "jpy",
      account_holder_name:
        "`${data.individual.last_name_kanji}${data.individual.first_name_kanji}`",
      account_holder_type: "individual",
      account_number: data.external_account.account_number,
      routing_number: data.external_account.routing_number,
    },
  });

  // const createdAccountResponse = JSON.parse(account);
  console.log(account.id);

  const accountAccepted = await stripe.accounts.update(account.id, {
    tos_acceptance: {
      date: Math.floor(Date.now() / 1000),
      ip: "8.8.8.8", // Assumes you're not using a proxy
    },
  });

  console.log(accountAccepted);

  const response = {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(account),
  };

  return response;
};
