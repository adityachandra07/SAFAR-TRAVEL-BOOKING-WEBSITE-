const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '1234',       // Change to your MySQL password
    database: 'safarv'
});

db.connect((err) => {
    if (err) {
        console.error('❌ Database connection failed:', err.message);
        process.exit(1);
    }
    console.log('✅ Connected to MySQL database: safar');
});

module.exports = db;
