const https = require("https");
const stripe = require("stripe")
(
  "sk_test_51HyVhmGoiP0exFcuyQvoKyIwfqY9dFAK8WkjRofSK6VjSvjjqtBefGpXr2OCKFNFH7mrJluLanSzoRA3KslKpw2I00kl5ypfAh",
  {httpAgent: new https.Agent({keepAlive: false})}
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
              response.body = JSON.stringify(response.body);
            } catch (err) {
              console.log(err);
            }
          });
      } catch (err) {
        // 406 = Not Acceptable - MDN
        response.statusCode = 406;
        // Frontend method requires error to show payment declined
        response.body = "error";
        console.log(err);
      }
    });
  return response;
};
