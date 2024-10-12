const { Pool } = require('pg');
require('dotenv').config();

console.log('Connecting to database with user:', process.env.DB_USER);

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.BILLING_DB_NAME,
    password: process.env.DB_PASS,
    port: process.env.DB_PORT,
});

// Test de connexion pour vérifier que la base de données est bien connectée
pool.connect((err, client, release) => {
    if (err) {
        return console.error('Error acquiring client', err.stack);
    }
    console.log('Database connected successfully');
    release(); // Libérer le client après la connexion
});

module.exports = pool;
