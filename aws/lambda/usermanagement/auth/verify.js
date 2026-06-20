exports.verify = async (event) => {
  const body = JSON.parse(event.body);
  const { code } = body;

  return {
    statusCode: 200,
    body: JSON.stringify({ verified: true }),
  };
};
