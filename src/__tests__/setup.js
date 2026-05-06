const pool = require('../config/db');

// Creamos las tablas si no existen, aunque ya hice la copia del schema de la BD original
beforeaAll (async ()=>{ 
    await pool.query(`
        CREATE TABLE IF NOT EXISTS usuarios (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(150) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        rol VARCHAR(20) NOT NULL DEFAULT 'usuario',
        activo BOOLEAN DEFAULT true,
        created_at TIMESTAMPTZ DEFAULT NOW()
        )
    `)

    await pool.query(`
    CREATE TABLE IF NOT EXISTS peliculas (
      id SERIAL PRIMARY KEY,
      titulo VARCHAR(255) NOT NULL,
      anio INTEGER,
      nota NUMERIC(3,1),
      director_id INTEGER,
      genero_id INTEGER,
      created_at TIMESTAMPTZ DEFAULT NOW()
    )
  `)

  await pool.query(`
    CREATE TABLE IF NOT EXISTS favoritos (
      id SERIAL PRIMARY KEY,
      usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
      pelicula_id INTEGER NOT NULL REFERENCES peliculas(id) ON DELETE CASCADE,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      UNIQUE(usuario_id, pelicula_id)
    )
  `)
});

// Limpiamos todos los datos de las tablas antes de cada test
beforeEach ( async ()=>{
    await pool.query('DELETE FROM favoritos')
    await pool.query('DELETE FROM peliculas')
    await pool.query('DELETE FROM usuarios')
})

// cerramos la conexión al finalizar todo
afterAll(async ()=>{
    await pool.end()
})