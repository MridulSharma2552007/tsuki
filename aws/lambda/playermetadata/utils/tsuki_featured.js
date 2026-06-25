const featuredData = require("../data/tsuki_home.json");

module.exports = async () => {
  return {
    statusCode: 200,
    body: JSON.stringify(featuredData),
  };
};
