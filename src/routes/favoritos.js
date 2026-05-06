const { Router } = require("express");
const router = Router();
const verificarToken = require("../middleware/verificarToken");
const {
  añadirFavorito,
  quitarDeFavoritos,
  listarFavoritos,
} = require("../controllers/favoritosController");

router.use(verificarToken);

router.post("/:peliculaId", añadirFavorito);
router.delete("/:peliculaId", quitarDeFavoritos);
router.get("/", listarFavoritos);

module.exports = router;
