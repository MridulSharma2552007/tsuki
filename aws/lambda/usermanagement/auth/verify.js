const cognito = require("../utils/cognito");

const {
  ConfirmSignUpCommand,
} = require("@aws-sdk/client-cognito-identity-provider");

exports.verify = async (event) => {
  try {
    console.log("[VERIFY] ENV CLIENT_ID:", process.env.CLIENT_ID);
    console.log("[VERIFY] Raw body:", event.body);
    const body = JSON.parse(event.body);
    const { email, code } = body;
    console.log("[VERIFY] Parsed body:", JSON.stringify(body));
    console.log("[VERIFY] Email:", email);
    console.log("[VERIFY] Code:", code);

    if (!email || !code) {
      console.log("[VERIFY] Missing email or code — returning 400");
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "OTP required",
        }),
      };
    }

    console.log("[VERIFY] Constructing ConfirmSignUpCommand for email:", email);
    const command = new ConfirmSignUpCommand({
      ClientId: process.env.CLIENT_ID,
      Username: email,
      ConfirmationCode: code,
    });
    console.log("[VERIFY] Command:", JSON.stringify({
      ClientId: process.env.CLIENT_ID,
      Username: email,
      ConfirmationCode: code,
    }));

    console.log("[VERIFY] Sending ConfirmSignUp to Cognito...");
    await cognito.send(command);
    console.log("[VERIFY] Account verified successfully for email:", email);

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Account Verified",
      }),
    };
  } catch (error) {
    console.log("[VERIFY] ERROR:", error);
    console.log("[VERIFY] Error name:", error.name);
    console.log("[VERIFY] Error message:", error.message);
    console.log("[VERIFY] Error code:", error.code);
    console.log("[VERIFY] Error stack:", error.stack);
    if (error.$metadata) {
      console.log("[VERIFY] Error metadata:", JSON.stringify(error.$metadata));
    }
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: error.message,
      }),
    };
  }
};
