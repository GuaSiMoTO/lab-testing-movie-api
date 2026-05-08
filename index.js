require('dotenv').config()
const express = require('express')

require('./src/config/db')

const peliculasRouter = require('./src/routes/peliculas')
const estadisticasRouter = require('./src/routes/estadisticas')

// Añade en index.js junto a los demás routers:
const authRouter = require('./src/routes/auth')

// Favoritos sobretodo para TDD
const favoritosRouter = require('./src/routes/favoritos')



const app = express()
const PORT = Number(process.env.PORT) || 3000

app.use(express.json())

app.use('/api/favoritos', favoritosRouter)
app.use('/api/peliculas', peliculasRouter)
app.use('/api', estadisticasRouter)
app.use('/api/auth', authRouter)

app.use((err, req, res, next) => {
  res.status(err.statusCode || 500).json({ error: err.message })
})

// sin llamar a listen. Para testear. IMPORTANTE! para no tocar la BD original
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`Servidor en http://localhost:${PORT}`)
  })
}

module.exports = app


