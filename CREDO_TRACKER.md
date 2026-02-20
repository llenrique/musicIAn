# Credo Tracker — musicIAn

**Última actualización:** 2026-02-16  
**Comando:** `mix credo --strict`  
**Estado:** 0 `[F]` · 0 `[R]` · 3 `[D]` (todos en código generado — aceptados)

---

## Reglas que los agentes DEBEN respetar al escribir código nuevo

Antes de escribir cualquier función nueva, consulta esta lista. Si introduces una violación nueva,
el PR debe corregirla antes de mergear.

### [R] Alias deben estar en orden alfabético

```elixir
# MAL
alias MusicIan.MusicCore
alias MusicIan.Curriculum        # 'C' < 'M' → debe ir antes

# BIEN
alias MusicIan.Curriculum
alias MusicIan.MusicCore
```

Aplica también dentro de grupos `alias Modulo.{A, B, C}` — las letras deben ir en orden.

### [R] @moduledoc obligatorio en todos los módulos

```elixir
# MAL
defmodule MusicIan.MiModulo do
  use Ecto.Schema

# BIEN
defmodule MusicIan.MiModulo do
  @moduledoc "Descripción breve del módulo."
  use Ecto.Schema
```

### [R] Sin trailing whitespace

Nunca dejes espacios al final de una línea. Al pegar bloques de código, revisar visualmente.
`sed -i '' 's/[[:space:]]*$//' ruta/al/archivo.ex` sirve para limpiar en bloque.

### [R] Líneas no deben superar 120 caracteres

```elixir
# MAL (121+ chars)
def foo, do: "cadena muy larga que supera el límite de ciento veinte caracteres establecido por Credo en este proyecto"

# BIEN — partir en varias líneas
def foo do
  "cadena..."
end
```

### [R] No usar `with` con una sola cláusula `<-` + `else` → usar `case`

```elixir
# MAL
with {:ok, val} <- do_thing() do
  val
else
  _ -> :error
end

# BIEN
case do_thing() do
  {:ok, val} -> val
  _ -> :error
end
```

### [F] No usar `Enum.map/2 |> Enum.join/2` → usar `Enum.map_join/3`

```elixir
# MAL
Enum.map(list, &transform/1) |> Enum.join(", ")

# BIEN
Enum.map_join(list, ", ", &transform/1)
```

### [F] No usar condiciones negadas en if-else

```elixir
# MAL
if !condition do
  a
else
  b
end

# BIEN
if condition do
  b
else
  a
end
```

### [F] `cond` debe tener al menos 2 condiciones reales además de `true`

```elixir
# MAL — solo 1 condición real + true → usar if
cond do
  x > 0 -> :positive
  true  -> :non_positive
end

# BIEN
if x > 0, do: :positive, else: :non_positive
```

### [F] Complejidad ciclomática máxima: 9

Si una función tiene más de 9 ramas (`case`, `if`, `cond`, `||`, `&&`), extraer funciones privadas.
Patrón habitual: separar en cláusulas de función (`def foo(:a)`), o extraer helpers privados.

### [F] Nesting máximo: 2 niveles

```elixir
# MAL — 3 niveles
def foo(socket) do
  if a do
    case b do
      :x ->
        if c do   # nivel 3 → CREDO falla
```

Solución: extraer la lógica interna en funciones privadas.

### [D] No dejar módulos anidados sin alias en el cuerpo

```elixir
# MAL (dentro de una función)
MusicIan.Practice.Manager.LessonManager.get_lesson(id)

# BIEN — poner alias al inicio del módulo
alias MusicIan.Practice.Manager.LessonManager
LessonManager.get_lesson(id)
```

### [D] No dejar comentarios `# TODO:` sin ticket

Si hay un TODO real, crear una entrada en este tracker o en el issue tracker. No dejar TODOs
sin resolver flotando en el código de producción.

---

## Issues activos

No hay issues `[F]` ni `[R]`. Los únicos issues activos son `[D]` en código generado/legacy,
aceptados como no-accionables:

### `[D]` — Design (aceptados)

| Archivo | Issue | Motivo |
|---|---|---|
| `core_components.ex:204` | Módulo anidado sin alias | Código generado por Phoenix — no modificar |
| `data_case.ex:39-40` | Módulos anidados sin alias | Test support generado — no modificar |

---

## Archivos limpios (0 issues Credo)

Todo el código de producción está limpio. Al modificar cualquier archivo, verificar
que siga sin introducir issues nuevos con `mix credo --strict`.

Nuevo componente añadido limpio:
- `lib/music_ian_web/components/music/lesson_modals.ex` ✅ (nuevo)
