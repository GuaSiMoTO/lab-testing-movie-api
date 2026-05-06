### Para crear la base de datos de test y copiar el mismo esquema:
```sql
CREATE DATABASE peliculas_test;
\c peliculas_test
```
Usa pg_dump con la opción --schema-only:

"pg_dump -U postgres -d peliculas_db --schema-only > esquema.sql"

Luego lo importas en tu nueva base:

"psql -U postgres -d peliculas_test -f esquema.sql"

### ❌ setupFilesAfterFramework no existe

Ese warning:

"Unknown option "setupFilesAfterFramework""

👉 Es porque esa opción está mal escrita o es antigua.

✅ La correcta es:

"setupFilesAfterEnv: ["./src/__tests__/setup.js"]"

## PRoblema en package.json

Estás usando setup.js como globalSetup, y eso está MAL para lo que quieres hacer.

En config package.json:

"globalSetup: "./src/__tests__/setup.js" ❌"


beforeAll NO funciona en globalSetup

Porque:

    . globalSetup = se ejecuta fuera del entorno de Jest
    . beforeAll = solo funciona dentro de tests

Corrección:

"setupFilesAfterEnv: ["./src/__tests__/setup.js"]"
