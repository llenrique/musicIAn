# 🛠️ Instalación y Setup

## Requisitos Previos

### Sistema Operativo
- macOS (Apple Silicon o Intel)
- Linux (Ubuntu 20.04+)
- Windows (con WSL2)

### Software Requerido
- **Elixir 1.16.3** o superior
- **Erlang/OTP 26** o superior
- **PostgreSQL 14** o superior
- **Node.js 18** o superior (para JavaScript)

### Hardware (Opcional)
- Controlador MIDI compatible
- Auriculares o altavoces para audio

## Instalación Paso a Paso

### 1. Clonar el Repositorio

```bash
git clone https://github.com/llenrique/musicIAn.git
cd musicIAn
```

### 2. Instalar Dependencias de Elixir

```bash
mix deps.get
```

Este comando descargará todas las dependencias definidas en `mix.exs`.

### 3. Instalar Dependencias de JavaScript

Las dependencias de JavaScript se instalan automáticamente a través de esbuild.

### 4. Configurar Base de Datos

#### Opción A: Crear automáticamente
```bash
mix ecto.create
mix ecto.migrate
```

#### Opción B: PostgreSQL manual
```bash
# Crear base de datos
createdb music_ian_dev

# Ejecutar migraciones
mix ecto.migrate
```

### 5. Configurar Variables de Entorno

Crea un archivo `.env.local` en la raíz del proyecto:

```env
# Database
DATABASE_URL=ecto://postgres:password@localhost:5432/music_ian_dev

# Server
PHX_HOST=localhost
PHX_PORT=4000
SECRET_KEY_BASE=tu_clave_secreta_aqui
```

Para generar `SECRET_KEY_BASE`:
```bash
mix phx.gen.secret
```

## Iniciar el Servidor

### Con PostgreSQL automático (recomendado)

```bash
mix phx.server
```

Este comando:
1. Inicia PostgreSQL (si está disponible)
2. Compila el código Elixir
3. Compila assets (CSS, JavaScript)
4. Inicia el servidor Phoenix en `http://localhost:4000`

### Con PostgreSQL manual

**Terminal 1: Inicia PostgreSQL**
```bash
postgres -D /usr/local/var/postgres
# o con Homebrew
brew services start postgresql@14
```

**Terminal 2: Inicia Phoenix**
```bash
mix phx.server
```

## Verificar la Instalación

1. Abre http://localhost:4000 en tu navegador
2. Deberías ver la página de inicio con el círculo de quintas
3. Haz clic en una tonalidad para visualizar la escala

## Solución de Problemas

### Error: "Failed to connect to PostgreSQL"

**Solución:**
```bash
# Verificar si PostgreSQL está corriendo
pg_isready -h localhost -p 5432

# Si no está corriendo
brew services start postgresql@14
```

### Error: "node_modules not found"

**Solución:**
```bash
cd assets
npm install
cd ..
mix phx.server
```

### Puerto 4000 ya en uso

**Solución:**
```bash
# Usar diferente puerto
PORT=4001 mix phx.server
```

### Database migrations error

**Solución:**
```bash
# Resetear base de datos (CUIDADO: borra todos los datos)
mix ecto.reset

# O manualmente
mix ecto.drop
mix ecto.create
mix ecto.migrate
```

## Desarrollo

### Estructura de Carpetas

```
musicIAn/
├── lib/
│   ├── music_ian/              # Lógica de negocio
│   │   ├── music_core/         # Teoría musical pura
│   │   ├── practice/           # Motor de lecciones
│   │   └── curriculum.ex       # Definición de lecciones
│   └── music_ian_web/          # Phoenix LiveView
│       ├── live/               # LiveView components
│       └── components/         # UI components
├── assets/
│   ├── js/
│   │   └── hooks/              # JavaScript hooks
│   ├── css/                    # Estilos Tailwind
├── priv/
│   └── repo/migrations/        # Migraciones Ecto
├── test/                       # Tests
└── config/                     # Configuración
```

### Comando Útiles

```bash
# Compilar sin correr servidor
mix compile

# Ejecutar tests
mix test

# Analizar código
mix credo

# Generar documentación
mix docs

# Limpiar artifacts
mix clean
```

## Próximos Pasos

- [Primera ejecución](./03-first-run.md)
- [Explorar características](../features/)
- [Entender la arquitectura](../architecture/)

---

**¿Tienes problemas?** Revisa [CONTRIBUTING.md](../development/01-contributing.md) para reportar issues.
