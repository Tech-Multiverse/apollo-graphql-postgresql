const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.POSTGRES_HOST,
  port: process.env.POSTGRES_PORT,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
});

const resolvers = {
  Query: {
    hello: async () => {
      const client = await pool.connect();
      try {
        const result = await client.query('SELECT NOW()');
        return `Hello, world! Current time is ${result.rows[0].now}`;
      } finally {
        client.release();
      }
    },
    getUsers: async () => {
      const client = await pool.connect();
      try {
        const res = await client.query('SELECT id, name, email FROM users');
        return res.rows;
      } finally {
        client.release();
      }
    },
  },
  Mutation: {
    addUser: async (_, { name, email }) => {
      const client = await pool.connect();
      try {
        const res = await client.query(
          'INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *',
          [name, email]
        );
        return res.rows[0];
      } finally {
        client.release();
      }
    },
  },
};

module.exports = resolvers;
