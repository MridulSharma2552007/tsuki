exports.register = async (event) => {
  const body = JSON.parse(event.body);

  const { email, password } = body;

  return {
    statusCode: 200,
    body: JSON.stringify({
      email,
      password,
    }),
  };
};
