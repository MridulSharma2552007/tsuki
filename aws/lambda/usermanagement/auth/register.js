const cognito = require("../utils/cognito");

const { SignUpCommand } = require("@aws-sdk/client-cognito-identity-provider");

exports.register = async (event) => {
  try {
    console.log("CLIENT_ID:", process.env.CLIENT_ID);
    console.log("USER_POOL_ID:", process.env.USER_POOL_ID);
    const body = JSON.parse(event.body);
    const { email, password } = body;
    if (!email || !password) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Email and Password is required",
        }),
      };
    }

    const command = new SignUpCommand({
      ClientId: process.env.CLIENT_ID,
      Username: email,
      Password: password,
      UserAttributes: [{ Name: "email", Value: email }],
    });

    const results = await cognito.send(command);
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Verfication Code Sent",
        userSub: results.UserSub,
      }),
    };
  } catch (error) {
    console.log(error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: error.message,
      }),
    };
  }
};
