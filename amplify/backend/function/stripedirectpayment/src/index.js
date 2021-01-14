const stripe = require("stripe")(
  "sk_test_51I8F0wCwmhFB6ae2JIv45lTRWveDwxUMMUG1k8yWvRINm0a3zJmvj0nybYPA4DBGaM3xIAIKfqndxzEJHpmfTJkk00TouBlgXv"
);

exports.handler = async (event) => {
  const stripeVendorAccount = event.queryStringParameters["connAccID"];
  const fee = (event.queryStringParameters["amount"] / 100) | 0;
  const response = {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: {},
  };

  await stripe.paymentMethods
    .create(
      {
        payment_method: event.queryStringParameters["paym"],
      },
      {
        stripeAccount: stripeVendorAccount,
      }
    )
    .then(async function (clonedPaymentMethod) {
      try {
        console.log("clonedPaymentMethod: ", clonedPaymentMethod);
        await stripe.paymentIntents
          .create(
            {
              amount: event.queryStringParameters["amount"],
              currency: event.queryStringParameters["currency"],
              payment_method: clonedPaymentMethod.id,
              confirmation_method: "automatic",
              confirm: true,
              application_fee_amount: fee,
            },
            {
              stripeAccount: stripeVendorAccount,
            }
          )
          .then(function (paymentIntent) {
            try {
              const paymentIntentReference = paymentIntent;
              console.log("Created paymentintent: ", paymentIntent);
              response.body.paymentIntent = paymentIntent;
              response.body.stripeAccount = stripeVendorAccount;
            } catch (err) {
              console.log(err);
            }
          });
      } catch (err) {
        console.log(err);
      }
    });
  response.body = JSON.stringify(response.body);
  return response;
};
