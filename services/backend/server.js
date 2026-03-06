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
  database: "event_platform",
  options: {
    encrypt: true
  }
}

app.get("/events", async (req,res)=>{

  try {

    await sql.connect(config)

    const result = await sql.query`SELECT * FROM events`

    res.json(result.recordset)

  } catch(err){

    res.status(500).send(err)

  }

})

app.post("/book", async (req,res)=>{

  const {event_id,user_name,tickets} = req.body

  try {

    await sql.connect(config)

    await sql.query`
      INSERT INTO bookings(event_id,user_name,tickets)
      VALUES (${event_id},${user_name},${tickets})
    `

    res.json({message:"Booking successful"})

  } catch(err){

    res.status(500).send(err)

  }

})

app.listen(5000,()=>{
  console.log("Backend running on port 5000")
})