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

  let response = {
    headers: {
      "Content-Type": "application/json",
    },
    statusCode: null,
    body: null,
  };

  let dbParams = {
    TableName: ddb_table_name,
    Item: {
      username: data.username,
      connAccId: null,
    },
  };

  try {
    const accountCreated = await stripe.accounts.create({
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
    console.log(accountCreated.id);
    dbParams.Item.connAccId = accountCreated.id;
    response.body += accountCreated;

    try {
      const accountAccepted = await stripe.accounts.update(account.id, {
        tos_acceptance: {
          date: Math.floor(Date.now() / 1000),
          ip: "8.8.8.8", // Eliot - Hardcoded this as suggested code is returning an error
        },
      });
      response.body += accountAccepted;
      response.statusCode = 200;
      try {
        const databaseUpdated = await ddb.putItem(dbParams);
        response.body += databaseUpdated;
        response.statusCode = 200;
      } catch (e) {
        response.body = `Unable to put trainer in database: ${e}`;
        response.statusCode = 403;
      }
    } catch (e) {
      response.body = `Unable to accept terms of service: ${e}`;
      response.statusCode = 403;
    }
  } catch (e) {
    response.body = `Unable to create stripe account: ${e}`;
    response.statusCode = 403;
  } finally {
    response.body = JSON.stringify(response.body);
    return response;
  }
};
