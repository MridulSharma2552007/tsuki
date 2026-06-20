const cognito = require("../utils/cognito");

const {
  InitiateAuthCommand,
} = require("@aws-sdk/client-cognito-identity-provider");

exports.login = async (event) => {
  try {
    const { email, password } = JSON.parse(event.body);

    const command = new InitiateAuthCommand({
      AuthFlow: "USER_PASSWORD_AUTH",
      ClientId: process.env.CLIENT_ID,
      AuthParameters: {
        USERNAME: email,
        PASSWORD: password,
      },
    });

    const result = await cognito.send(command);

    return {
      statusCode: 200,
      body: JSON.stringify({
        accessToken: result.AuthenticationResult.AccessToken,
        idToken: result.AuthenticationResult.IdToken,
        refreshToken: result.AuthenticationResult.RefreshToken,
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
