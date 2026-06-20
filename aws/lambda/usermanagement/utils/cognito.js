

const {
  CognitoIdentityProviderClient,
} = require("@aws-sdk/client-cognito-identity-provider");

const cognito = new CognitoIdentityProviderClient({
  region: "ap-south-1",
});

module.exports = cognito;
