const { ApolloServer, gql } = require('apollo-server');
const resolvers = require('./resolvers');
const typeDefs = gql(require('fs').readFileSync('schema.graphql', 'utf8'));

// Creating the Apollo Server instance
const server = new ApolloServer({ typeDefs, resolvers });

// Starting the server
server.listen({ port: process.env.PORT }).then(({ url }) => {
  console.log(`🚀  Server ready at ${url}`);
});
