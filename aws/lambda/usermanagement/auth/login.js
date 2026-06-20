const cognito = require("../utils/cognito");

const {
  InitiateAuthCommand,
} = require("@aws-sdk/client-cognito-identity-provider");

exports.login = async (event) => {
  try {
    console.log("[LOGIN] ENV CLIENT_ID:", process.env.CLIENT_ID);
    console.log("[LOGIN] Raw body:", event.body);
    const body = JSON.parse(event.body);
    const { email, password } = body;
    console.log("[LOGIN] Parsed body:", JSON.stringify(body));
    console.log("[LOGIN] Email:", email);
    console.log("[LOGIN] Password present:", !!password);
    console.log("[LOGIN] Password length:", password ? password.length : 0);

    console.log("[LOGIN] Constructing InitiateAuthCommand for email:", email);
    const command = new InitiateAuthCommand({
      AuthFlow: "USER_PASSWORD_AUTH",
      ClientId: process.env.CLIENT_ID,
      AuthParameters: {
        USERNAME: email,
        PASSWORD: password,
      },
    });
    console.log("[LOGIN] Command:", JSON.stringify({
      AuthFlow: "USER_PASSWORD_AUTH",
      ClientId: process.env.CLIENT_ID,
      AuthParameters: { USERNAME: email, PASSWORD: "[REDACTED]" },
    }));

    console.log("[LOGIN] Sending InitiateAuth to Cognito...");
    const result = await cognito.send(command);
    console.log("[LOGIN] Cognito response:", JSON.stringify(result, null, 2));
    console.log("[LOGIN] AccessToken present:", !!result.AuthenticationResult?.AccessToken);
    console.log("[LOGIN] IdToken present:", !!result.AuthenticationResult?.IdToken);
    console.log("[LOGIN] RefreshToken present:", !!result.AuthenticationResult?.RefreshToken);
    console.log("[LOGIN] Token type:", result.AuthenticationResult?.TokenType);
    console.log("[LOGIN] Expires in:", result.AuthenticationResult?.ExpiresIn);

    return {
      statusCode: 200,
      body: JSON.stringify({
        accessToken: result.AuthenticationResult.AccessToken,
        idToken: result.AuthenticationResult.IdToken,
        refreshToken: result.AuthenticationResult.RefreshToken,
      }),
    };
  } catch (error) {
    console.log("[LOGIN] ERROR:", error);
    console.log("[LOGIN] Error name:", error.name);
    console.log("[LOGIN] Error message:", error.message);
    console.log("[LOGIN] Error code:", error.code);
    console.log("[LOGIN] Error stack:", error.stack);
    if (error.$metadata) {
      console.log("[LOGIN] Error metadata:", JSON.stringify(error.$metadata));
    }
    console.log("[LOGIN] Returning 500 with error message");
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: error.message,
      }),
    };
  }
};
