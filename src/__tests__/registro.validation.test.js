const request = require("supertest");
const app = require("../../index");

describe("POST /api/auth/registro — validaciones", () => {
  test.each([
    [
      "email inválido",
      { nombre: "Test", email: "no-es-un-email", password: "pass1234" },
      /email/i,
    ],
    [
      "contraseña demasiado corta",
      { nombre: "Test", email: "test@test.com", password: "123" },
      /contraseña/i,
    ],
    [
      "nombre vacío",
      { nombre: "", email: "test@test.com", password: "pass1234" },
      /obligatorio/i,
    ],
    [
      "email vacío",
      { nombre: "Test", email: "", password: "pass1234" },
      /obligatorio/i,
    ],
    [
      "password vacío",
      { nombre: "Test", email: "test@test.com", password: "" },
      /obligatorio/i,
    ],
    [
      "todos los campos vacíos",
      { nombre: "", email: "", password: "" },
      /obligatorio/i,
    ],
  ])(
    "debe rechazar registro con %s (400)",
    async (descripcion, body, mensajeEsperado) => {
      const res = await request(app)
        .post("/api/auth/registro")
        .send(body);

      expect(res.status).toBe(400);
      const mensajeRecibido = res.body.error || res.body.message || "";
      expect(mensajeRecibido).toMatch(mensajeEsperado);
    }
  );
});