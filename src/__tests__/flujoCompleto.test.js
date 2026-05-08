const request = require("supertest");
const app = require("../../index");
const { crearPelicula } = require("./helpers");

describe("Flujo completo de usuario", () => {
  it("registro → login → buscar → favoritos → listar → eliminar", async () => {
    
    // 0. SEMBRAR DB
    await crearPelicula({ titulo: "Pelicula Flujo Test" });

    // 1. REGISTRO
    const email = `flujo_${Date.now()}@test.com`;

    const resRegistro = await request(app)
      .post("/api/auth/registro")
      .send({ nombre: "Usuario Flujo", email, password: "pass1234" });

    expect(resRegistro.status).toBe(201);

    // 2. LOGIN — usamos email dinámico del paso anterior
    const resLogin = await request(app)
      .post("/api/auth/login")
      .send({ email, password: "pass1234" });

    expect(resLogin.status).toBe(200);
    const token = resLogin.body.token;
    expect(token).toBeDefined();

    // 3. BUSCAR PELÍCULAS — cogemos la primera
    const resPeliculas = await request(app)
      .get("/api/peliculas")
      .set("Authorization", `Bearer ${token}`);

    expect(resPeliculas.status).toBe(200);
    expect(resPeliculas.body.length).toBeGreaterThan(0);
    const peliculaId = resPeliculas.body[0].id;

    // 4. AÑADIR A FAVORITOS
    const resAñadir = await request(app)
      .post(`/api/favoritos/${peliculaId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(resAñadir.status).toBe(201);
    expect(resAñadir.body).toHaveProperty("ok", true);
    expect(resAñadir.body.favorito).toHaveProperty("pelicula_id", peliculaId);

    // 5. LISTAR FAVORITOS — debe tener exactamente 1
    const resListar = await request(app)
      .get("/api/favoritos")
      .set("Authorization", `Bearer ${token}`);

    expect(resListar.status).toBe(200);
    expect(resListar.body).toHaveLength(1);
    expect(resListar.body[0]).toHaveProperty("id", peliculaId);

    // 6. ELIMINAR DE FAVORITOS
    const resEliminar = await request(app)
      .delete(`/api/favoritos/${peliculaId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(resEliminar.status).toBe(200);
    expect(resEliminar.body).toHaveProperty("ok", true);

    // 7. VERIFICAR QUE LA LISTA ESTÁ VACÍA
    const resListarVacia = await request(app)
      .get("/api/favoritos")
      .set("Authorization", `Bearer ${token}`);

    expect(resListarVacia.status).toBe(200);
    expect(resListarVacia.body).toHaveLength(0);
  });
});