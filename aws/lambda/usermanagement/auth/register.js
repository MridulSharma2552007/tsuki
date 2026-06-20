const cognito = require("../utils/cognito");

const { SignUpCommand } = require("@aws-sdk/client-cognito-identity-provider");

exports.register = async (event) => {
  try {
    console.log("[REGISTER] ENV CLIENT_ID:", process.env.CLIENT_ID);
    console.log("[REGISTER] ENV USER_POOL_ID:", process.env.USER_POOL_ID);
    const body = JSON.parse(event.body);
    const { email, password } = body;
    console.log("[REGISTER] Parsed body:", JSON.stringify(body));
    console.log("[REGISTER] Email:", email);
    console.log("[REGISTER] Password:", password ? "[REDACTED - LENGTH: " + password.length + "]" : "undefined");

    if (!email || !password) {
      console.log("[REGISTER] Missing email or password — returning 400");
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Email and Password is required",
        }),
      };
    }

    console.log("[REGISTER] Constructing SignUpCommand with username:", email);
    const command = new SignUpCommand({
      ClientId: process.env.CLIENT_ID,
      Username: email,
      Password: password,
      UserAttributes: [{ Name: "email", Value: email }],
    });
    console.log("[REGISTER] Command:", JSON.stringify({ ClientId: process.env.CLIENT_ID, Username: email, UserAttributes: [{ Name: "email", Value: email }] }));

    console.log("[REGISTER] Sending command to Cognito...");
    const results = await cognito.send(command);
    console.log("[REGISTER] Cognito response:", JSON.stringify(results, null, 2));
    console.log("[REGISTER] UserSub:", results.UserSub);
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Verfication Code Sent",
        userSub: results.UserSub,
      }),
    };
  } catch (error) {
    console.log("[REGISTER] ERROR:", error);
    console.log("[REGISTER] Error name:", error.name);
    console.log("[REGISTER] Error message:", error.message);
    console.log("[REGISTER] Error code:", error.code);
    console.log("[REGISTER] Error stack:", error.stack);
    if (error.$metadata) {
      console.log("[REGISTER] Error metadata:", JSON.stringify(error.$metadata));
    }
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: error.message,
      }),
    };
  }
};
