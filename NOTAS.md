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

## BONUS:

### Mock de bcrypt: En el helper de tests, en lugar de llamar a bcrypt.hash (lento), usa jest.mock para que siempre devuelva un hash fijo. Mide cuánto más rápido es la suite de tests.

```js
    jest.mock('bcrypt', () => ({
    hash: jest.fn().mockResolvedValue('hash_falso'),
    compare: jest.fn().mockResolvedValue(true),
    }))
```

- Tiempo sin mock:
    Test Suites: 1 passed, 1 total
    Tests:       8 passed, 8 total
    Snapshots:   0 total
    Time:        1.943 s
    Ran all test suites matching favoritos.

    real    0m3.643s
    user    0m0.106s
    sys     0m0.139s

- Tiempo con mock:
    Test Suites: 1 passed, 1 total
    Tests:       8 passed, 8 total
    Snapshots:   0 total
    Time:        1.066 s, estimated 2 s
    Ran all test suites matching favoritos.

    real    0m2.993s
    user    0m0.186s
    sys     0m0.197s

### Test parametrizado: Usa test.each para testear múltiples casos de validación del registro (email inválido, contraseña corta, campos vacíos) sin repetir código.
Los test.each está en el archivo: en __ test __/registro.validation.test.js