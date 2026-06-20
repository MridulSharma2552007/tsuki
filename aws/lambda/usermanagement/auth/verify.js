const cognito = require("../utils/cognito");

const {
  ConfirmSignUpCommand,
} = require("@aws-sdk/client-cognito-identity-provider");

exports.verify = async (event) => {
  try {
    const body = JSON.parse(event.body);

    const { email, code } = body;

    if (!email || !code) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "OTP required",
        }),
      };
    }

    const command = new ConfirmSignUpCommand({
      ClientId: process.env.CLIENT_ID,
      Username: email,
      ConfirmationCode: code,
    });

    await cognito.send(command);
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Account Verified",
      }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: error.message,
      }),
    };
  }
};
