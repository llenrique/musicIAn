# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Idioma

Responder siempre en **español**. Documentación (`@moduledoc`, `@doc`) también en español.

## Comandos esenciales

```bash
mix setup                  # Instalación completa (deps + DB + assets)
mix phx.server             # Servidor de desarrollo (localhost:4000)
iex -S mix phx.server      # Servidor con shell interactivo

mix test                   # Tests (auto-crea DB de test)
mix test path/to/test.exs  # Un solo archivo de test
mix test path/to/test.exs:42  # Un solo test por línea

mix compile --warnings-as-errors  # Compilar (warnings = error)
mix credo --strict         # Linter — debe pasar antes de commit
mix format                 # Formatear código
mix precommit              # compile + deps.unlock + format + test

mix ecto.reset             # Drop + create + migrate + seed
mix ecto.migrate           # Migraciones pendientes
```

## Reglas de código críticas

- **`warnings_as_errors: true`** en mix.exs — cero warnings permitidos
- **`mix credo --strict`** debe pasar limpio. Leer **CREDO_TRACKER.md** antes de escribir código
- Aliases en orden alfabético
- `@moduledoc` obligatorio en todos los módulos
- Líneas max 120 caracteres, sin trailing whitespace
- Usar `case` en vez de `with` con cláusula única
- Usar `Enum.map_join/3` en vez de `map |> join`
- Max complejidad ciclomática: 9, max nesting: 2 niveles

## Arquitectura

**Stack**: Elixir 1.16.3 / Phoenix 1.8.3 / LiveView 1.1.0 / PostgreSQL / TailwindCSS

### Contextos de dominio (`lib/music_ian/`)

| Contexto | Responsabilidad |
|---|---|
| **MusicCore** (`music_core/`) | Teoría musical pura: notas, escalas, acordes, circle of fifths. Sin dependencia de DB. |
| **Curriculum** (`curriculum/`) | Schemas Ecto de módulos y lecciones. Datos pedagógicos. |
| **Practice** (`practice/`) | Motor de lecciones: FSM, validación, resultados. Subdirs: `fsm/`, `manager/`, `helper/`, `schema/`. |
| **MIDI** (`midi/`) | Control de metrónomo Yamaha vía MIDI SysEx. |
| **MCPClientHelper** | Integración Model Context Protocol para análisis musical con IA. |

### Capa web (`lib/music_ian_web/`)

**LiveViews**: `TheoryLive` (`/`), `ModulesLive` (`/modules`), `DashboardLive` (`/dashboard`)

**Componentes**: `Components.Music.*` (Keyboard, Staff, CircleOfFifths, Controls, Footer, TheoryPanel, LessonModals)

**Canal WebSocket**: `MusicApiChannel` — API en tiempo real para operaciones musicales.

### Frontend (`assets/js/hooks/`)

| Hook | API del navegador |
|---|---|
| `AudioEngine` | Web Audio API — síntesis polifónica |
| `MusicStaff` | VexFlow 5.0 — notación musical SVG |
| `MidiDevice` | Web MIDI API — captura de notas MIDI en tiempo real |
| `MidiDeviceSelector` | Selector de dispositivos MIDI |

### Flujo de lecciones (FSM)

`:intro` → `:demo` → `:post_demo` → `:countdown` → `:active` → `:summary`

- Metrónomo se activa SOLO en `begin_practice` si `lesson.metronome == true`
- En `:demo` el metrónomo está siempre OFF
- Validación de notas ocurre server-side en `LessonFSM`
- Detalle completo en **LESSON_FLOW_SIMPLIFIED.md**

### Base de datos

- Lecciones usan IDs tipo string (`"1.1"`, `"1.2"`)
- Campo `steps` es JSONB con datos de nota/timing por paso
- Seeds en `priv/repo/seed_module_*.exs`

## Convenciones de código

- Pattern matching en argumentos > `if/else` dentro del cuerpo
- Pipe operator `|>` para transformaciones de datos
- Lógica de negocio en Contextos, NO en LiveViews ni Controllers
- `@spec` en funciones públicas críticas, especialmente en MusicCore
- Tests unitarios para MusicCore con `async: true`

## Archivos de referencia clave

- **AGENTS.md** — Memoria del proyecto, arquitectura, decisiones
- **CREDO_TRACKER.md** — Reglas de Credo y issues activos (leer antes de codificar)
- **LESSON_FLOW_SIMPLIFIED.md** — FSM de lecciones y reglas del metrónomo
- **knowledge/music_theory/** — Referencia de teoría musical (10 archivos)
