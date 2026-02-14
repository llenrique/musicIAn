# 🎼 Sistema de Tonalidades con Tooltips Interactivos

## Descripción General

El sistema de tonalidades en musicIAn proporciona una experiencia educativa completa con:

- ✅ **Nomenclatura Enarmónica Correcta**: Notas con el nombre adecuado según la tonalidad
- ✅ **Tooltips Interactivos**: Explicaciones al pasar mouse sobre notas
- ✅ **Todas las 12 Tonalidades**: Completo círculo de quintas
- ✅ **Todas las Escalas**: Mayor, Menor, Modos, Pentatónica, Blues

## Nomenclatura Enarmónica Correcta

### ¿Qué es Enarmónico Spelling?

Es la **manera correcta de nombrar las notas** dentro de una tonalidad específica, siguiendo reglas musicales estrictas.

### Ejemplos

#### Re Mayor (D Major)
**Correcto:**
```
D - E - F# - G - A - B - C#
```

**Incorrecto (evitar):**
```
D - E - Gb - G - A - B - Db
```

**Por qué?** En Re Mayor, cada nota debe tener un nombre diferente (D, E, F, G, A, B, C). El F se eleva con # para mantener la secuencia.

#### Fa Mayor (F Major)
**Correcto:**
```
F - G - A - Bb - C - D - E
```

**Por qué?** El B se baja a Bb para mantener cada grado de escala único.

### Ventajas

1. **Claridad Visual**: Fácil de leer en partitura
2. **Educación Correcta**: Enseña reglas musicales reales
3. **Transposición**: Facilita transportar a otras tonalidades
4. **Conducción de Voces**: Mejora la organización armónica

## Tooltips Educativos

### Estructura de un Tooltip

Cada tooltip muestra **4 elementos de información**:

```
┌──────────────────────────────────────┐
│ F# - 3ª                              │  ← Nota y Grado
│ Dos tonos (4 semitonos) -            │  ← Intervalo
│ Tercera mayor                        │
│ ⚠️ Alterada según la tonalidad        │  ← Razón (si aplica)
└──────────────────────────────────────┘
```

### 1. Nota y Grado

**Muestra:**
- **Nombre de la nota** con su alteración (C, D, E, F#, Bb, etc.)
- **Grado** en la escala (1ª, 2ª, 3ª, 4ª, 5ª, 6ª, 7ª)

**Ejemplo:** `F# - 3ª` significa que F# es la tercera nota de la escala

### 2. Intervalo

**Muestra:**
- **Distancia en semitonos** desde la raíz
- **Nombre del intervalo** en español

**Ejemplos:**
- `2 semitonos - Segundo mayor`
- `4 semitonos - Tercera mayor`
- `5 semitonos - Cuarta perfecta`
- `7 semitonos - Quinta perfecta`

### 3. Razón de Alteración (si aplica)

Solo aparece para notas que tienen sostenido o bemol.

**Ejemplos:**
- `Alterada según la tonalidad` (Mayor)
- `3ª menor: Característica de la escala menor`
- `7ª mayor: Elevada para crear el acorde dominante en menor`
- `4ª aumentada: Característica del modo Lidio`

## Todas las 12 Tonalidades

### Tonalidades con Sostenidos (#)

| Tonalidad | Sostenidos | Tooltips |
|-----------|-----------|----------|
| Do Mayor (C) | Ninguno | ✅ Nota natural |
| Sol Mayor (G) | F# | ✅ Alteración explicada |
| Re Mayor (D) | F#, C# | ✅ Ambas explicadas |
| La Mayor (A) | F#, C#, G# | ✅ Todas explicadas |
| Mi Mayor (E) | F#, C#, G#, D# | ✅ Contexto completo |
| Si Mayor (B) | F#, C#, G#, D#, A# | ✅ Información detallada |
| F# Mayor | 6 sostenidos | ✅ Sistema completo |

### Tonalidades con Bemoles (b)

| Tonalidad | Bemoles | Tooltips |
|-----------|---------|----------|
| Fa Mayor (F) | Bb | ✅ Alteración explicada |
| Sib Mayor (Bb) | Bb, Eb | ✅ Ambas explicadas |
| Mib Mayor (Eb) | Bb, Eb, Ab | ✅ Todas explicadas |
| Lab Mayor (Ab) | Bb, Eb, Ab, Db | ✅ Contexto completo |
| Reb Mayor (Db) | 5 bemoles | ✅ Información detallada |
| Solb Mayor (Gb) | 6 bemoles | ✅ Sistema completo |
| Dob Mayor (Cb) | 7 bemoles | ✅ Configuración completa |

### Tonalidades Menores

Las tonalidades menores relativas siguen el mismo patrón que sus mayores relativas:

- La Menor (Am) → Sin alteraciones (relativa de Do Mayor)
- Mi Menor (Em) → Un sostenido F# (relativa de Sol Mayor)
- Si Menor (Bm) → Dos sostenidos (relativa de Re Mayor)
- etc.

## Todas las Escalas

### Escalas Implementadas

#### 1. Mayor
```
Patrón: T-T-S-T-T-T-S
Tooltip: "Patrón: T-T-S-T-T-T-S. La referencia absoluta de la música occidental."
```

#### 2. Menor Natural
```
Patrón: T-S-T-T-S-T-T
Tooltip: "Patrón: T-S-T-T-S-T-T. Baja la 3ra, 6ta y 7ma respecto a la Mayor."
```

#### 3. Menor Armónica
```
Patrón: T-S-T-T-S-3S-S (3S = tres semitonos)
Tooltip: "Menor con 7ma elevada. Crea el sonido 'árabe' o 'clásico' característico."
```

#### 4. Menor Melódica
```
Patrón: T-S-T-T-T-T-S
Tooltip: "Sube 6ta y 7ma al subir. Suaviza la melodía para el jazz y clásica."
```

#### 5. Modos (7 modos griegos)

**Dorian:**
```
Patrón: T-S-T-T-T-S-T
Tooltip: "Menor con 6ta mayor. Menos triste, más 'funky' y medieval."
```

**Phrygian:**
```
Patrón: S-T-T-T-S-T-T
Tooltip: "Menor con 2da menor. El sonido del Flamenco y Metal."
```

**Lydian:**
```
Patrón: T-T-T-S-T-T-S
Tooltip: "Mayor con 4ta aumentada (#4). Sonido mágico, de película o sueño."
```

**Mixolydian:**
```
Patrón: T-T-S-T-T-S-T
Tooltip: "Mayor con 7ma menor (b7). El sonido del Rock y Blues clásico."
```

**Locrian:**
```
Patrón: S-T-T-S-T-T-T
Tooltip: "Disminuido. La escala más inestable y tensa de todas."
```

#### 6. Pentatónica Mayor
```
Patrón: T-T-3S-T-3S (solo 5 notas)
Tooltip: "Solo 5 notas. Sin semitonos. Imposible sonar mal."
```

#### 7. Pentatónica Menor
```
Patrón: 3S-T-T-3S-T
Tooltip: "Solo 5 notas. La base de la improvisación en Rock y Blues."
```

#### 8. Blues
```
Patrón: 3S-T-3S-S-3S-T (pentatónica menor + b5)
Tooltip: "Pentatónica menor + Blue Note (b5). El alma del Blues."
```

## Cómo Funcionan los Tooltips

### Flujo de Datos

```
Usuario Selecciona Tonalidad
    ↓
Scale.ex genera notas + explicaciones
    ↓
TheoryLive asigna a socket.assigns
    ↓
Staff.ex recibe como atributo
    ↓
JavaScript carga en data-explanations
    ↓
MusicStaff.js mapea a overlay
    ↓
Usuario pasa mouse
    ↓
Tooltip aparece con información
```

### Cambio de Tonalidad

Cuando cambias de tonalidad:

1. **Se ejecuta** `handle_event("select_root", ...)`
2. **Se genera nueva escala** con nuevas explicaciones
3. **Se actualiza el socket** con `note_explanations`
4. **JavaScript recibe los datos** y reinizia el overlay
5. **Los tooltips reflejan** la nueva tonalidad

### Ejemplo Completo

**Acción:** Cambiar de Do Mayor a Re Mayor

**Paso 1: Do Mayor**
```elixir
scale = Scale.new(60, :major)
# notes: [C, D, E, F, G, A, B]
# explanations: sin alteraciones
```

**Paso 2: Re Mayor**
```elixir
scale = Scale.new(62, :major)
# notes: [D, E, F#, G, A, B, C#]
# explanations:
#   - F#: "3ª - Dos tonos (4 semitonos) - Tercera mayor - ⚠️ Alterada"
#   - C#: "7ª - Cinco tonos y medio (11 semitonos) - Séptima mayor - ⚠️ Alterada"
```

**Paso 3: UI Actualizada**
```javascript
// MusicStaff.js recibe las nuevas explicaciones
this.explanations = {
  "D": {...},
  "E": {...},
  "F#": {degree: "3ª", interval: "...", reason: "..."},
  "G": {...},
  "A": {...},
  "B": {...},
  "C#": {degree: "7ª", interval: "...", reason: "..."}
}
```

## Casos de Uso

### Educación Musical

1. **Estudiante principiante aprende tonalidades**
   - Selecciona Sol Mayor
   - Pasa mouse sobre F#
   - Lee tooltip: "¿Por qué F# aquí?"
   - Aprende sobre alteraciones

2. **Músico transponiendo**
   - Explora diferentes tonalidades
   - Entiende patrones comunes
   - Práctica de lectura a primera vista

3. **Compositor buscando sonoridad**
   - Explora modos para inspiración
   - Lee explicaciones del "mood"
   - Entiende características musicales

### Práctica Instrumental

1. **Pianista practicando escalas**
   - Toca la escala en el teclado virtual
   - Lee tooltips para verificar comprensión
   - Valida que está tocando las notas correctas

2. **Guitarrista de improvización**
   - Explora pentatónicas en diferentes tonalidades
   - Entiende la relación con tonalidades mayores
   - Práctica de improvisación informada

## Especificaciones Técnicas

### Archivos Involucrados

- **Backend:**
  - `lib/music_ian/music_core/scale.ex` - Generación de escalas y explicaciones
  - `lib/music_ian/music_core/theory.ex` - Análisis teórico
  - `lib/music_ian_web/live/theory_live.ex` - Orquestación

- **Frontend:**
  - `lib/music_ian_web/components/music/staff.ex` - Componente de partitura
  - `assets/js/hooks/MusicStaff.js` - Tooltips interactivos

### Performance

- Las explicaciones se **generan una sola vez** por tonalidad
- El overlay es **reutilizable** para todas las tonalidades
- Cambio de tonalidad es **instantáneo** (<100ms)

## Futuras Mejoras

- [ ] Sonido al pasar mouse (reproducir nota)
- [ ] Comparación visual entre tonalidades
- [ ] Historial de tonalidades exploradas
- [ ] Preferencia de usuario (sharps vs flats)
- [ ] Análisis de dificultad (cuántas alteraciones)
- [ ] Ejercicios basados en tooltips

---

**¿Preguntas?** Consulta [Circle of Fifths Guide](./03-circle-of-fifths.md) para más detalles sobre tonalidades.
