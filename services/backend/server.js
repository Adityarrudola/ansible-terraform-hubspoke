const express = require("express")
const sql = require("mssql")
const cors = require("cors")

const app = express()
app.use(cors())
app.use(express.json())

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_HOST,
  database: process.env.DB_NAME,
  options: {
    encrypt: true,
    trustServerCertificate: false
  },
  port: 1433
}

async function initDatabase() {
  try {

    const pool = await sql.connect(config)

    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM sys.tables WHERE name='events')
      CREATE TABLE events (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(150),
        location NVARCHAR(150),
        event_date DATETIME,
        price INT
      )
    `)

    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM sys.tables WHERE name='bookings')
      CREATE TABLE bookings (
        id INT IDENTITY(1,1) PRIMARY KEY,
        event_id INT,
        user_name NVARCHAR(150),
        tickets INT,
        created_at DATETIME DEFAULT GETDATE()
      )
    `)

    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM events)
      INSERT INTO events (name,location,event_date,price)
      VALUES
      ('Music Festival','Delhi','2026-05-10',500),
      ('Tech Conference','Bangalore','2026-06-15',1200),
      ('Startup Meetup','Gurgaon','2026-07-01',300)
    `)

    console.log("Database initialized")

  } catch (err) {
    console.error("Database init error:", err)
  }
}

app.get("/events", async (req, res) => {
  try {

    const pool = await sql.connect(config)

    const result = await pool.request().query(`SELECT * FROM events`)

    res.json(result.recordset)

  } catch (err) {

    res.status(500).send(err)

  }
})

app.post("/book", async (req, res) => {

  const { event_id, user_name, tickets } = req.body

  try {

    const pool = await sql.connect(config)

    await pool.request()
      .input("event_id", sql.Int, event_id)
      .input("user_name", sql.NVarChar, user_name)
      .input("tickets", sql.Int, tickets)
      .query(`
        INSERT INTO bookings(event_id,user_name,tickets)
        VALUES (@event_id,@user_name,@tickets)
      `)

    res.json({ message: "Booking successful" })

  } catch (err) {

    console.error(err)
    res.status(500).json(err)

  }
})

async function startServer() {

  await initDatabase()

  app.listen(5000, () => {
    console.log("Backend running on port 5000")
  })

}

startServer()