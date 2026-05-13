const express = require('express');
const cors    = require('cors');
const path    = require('path');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '../frontend')));

const authRoutes     = require('./routes/auth');
const tripsRoutes    = require('./routes/trips');
const bookingsRoutes = require('./routes/bookings');
const hotelsRoutes   = require('./routes/hotels');

app.use('/api/auth',     authRoutes);
app.use('/api/trips',    tripsRoutes);
app.use('/api/bookings', bookingsRoutes);
app.use('/api/hotels',   hotelsRoutes);

app.get('/api/health', (req, res) => res.json({ success:true, message:'Safar backend running ✅' }));

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`\n🚀 Safar backend running at: http://localhost:${PORT}`);
    console.log(`\nAPI Endpoints:`);
    console.log(`  POST   /api/auth/register | login`);
    console.log(`  GET    /api/trips  |  POST /api/trips/add  |  DELETE /api/trips/:id`);
    console.log(`  GET    /api/hotels?city=X  |  POST /api/hotels/add  |  DELETE /api/hotels/:id`);
    console.log(`  GET    /api/hotels/owner/:owner_id`);
    console.log(`  POST   /api/bookings/hotel  |  POST /api/bookings/activity`);
    console.log(`  GET    /api/bookings/user/:id  |  GET /api/bookings/owner/:email`);
    console.log(`  PATCH  /api/bookings/hotel/:id/status`);
    console.log(`  PATCH  /api/bookings/hotel/:id/pay`);
    console.log(`  PATCH  /api/bookings/hotel/:id/counter-response\n`);
});
