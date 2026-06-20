const { register } = require("./auth/register");
const { login } = require("./auth/login");
const { verify } = require("./auth/verify");

exports.handler = async (event) => {
  const path = event.rawPath;
  const method = event.requestContext.http.method;

  if (path === "/health" && method === "GET") {
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Tsuki API Online" }),
    };
  }

  if (path === "/auth/register" && method === "POST") {
    return register(event);
  }

  if (path === "/auth/login" && method === "POST") {
    return login(event);
  }

  if (path === "/auth/verify" && method === "POST") {
    return verify(event);
  }

  return {
    statusCode: 404,
    body: JSON.stringify({ message: "Route not found" }),
  };
};
