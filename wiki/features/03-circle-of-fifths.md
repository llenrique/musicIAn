# 🔄 Círculo de Quintas

## ¿Qué es el Círculo de Quintas?

El **Círculo de Quintas** es una herramienta visual fundamental en música que organiza las 12 tonalidades de forma circular, mostrando las relaciones armónicas entre ellas.

### Propósito

- 📍 **Selector Visual de Tonalidades**: Haz clic para cambiar
- 🔍 **Entendimiento de Relaciones**: Ver cómo se conectan tonalidades
- 📊 **Patrón de Alteraciones**: Visualizar sostenidos/bemoles
- 🎯 **Navegación Intuitiva**: Moverse entre tonalidades relacionadas

## Estructura

### Disposición Circular

```
                    C
              F     ↑     G
            (Bb)   (0)   (F#)
        
     Bb                        D
   (Eb)                      (C#)
    
  
    Eb              Circulo          A
  (Ab)              Quintas        (G#)
           
   Ab                            E
 (Db)                          (B)
 
      Db            B
    (Gb)          (F#)
```

### Interpretación

**Posición:**
- **Top** (12 o'clock): Do Mayor (0 alteraciones)
- **Derecha (Horario)**: Aumentan sostenidos (F#, C#, G#, etc.)
- **Izquierda (Contra-horario)**: Aumentan bemoles (Bb, Eb, Ab, etc.)

**Número de Alteraciones:**

| Posición | Tonalidad Mayor | Sostenidos | Tonalidad Menor | Alteraciones |
|----------|----------------|-----------|-----------------|-------------|
| Top | C | — | Am | — |
| 1 (→) | G | F# | Em | — |
| 2 (→) | D | F#, C# | Bm | — |
| 3 (→) | A | F#, C#, G# | F#m | — |
| 4 (→) | E | 4 sostenidos | C#m | — |
| 5 (→) | B | 5 sostenidos | G#m | — |
| 6 (→) | F# | 6 sostenidos | D#m | — |
| 1 (←) | F | Bb | Dm | Bb |
| 2 (←) | Bb | Bb, Eb | Gm | Bb, Eb |
| 3 (←) | Eb | 3 bemoles | Cm | 3 bemoles |
| 4 (←) | Ab | 4 bemoles | Fm | 4 bemoles |
| 5 (←) | Db | 5 bemoles | Bbm | 5 bemoles |

## Interfaz en musicIAn

### Elementos Visuales

```
SELECTOR DE TONALIDAD (Círculo)
┌─────────────────────────────┐
│                             │
│         F       C       G   │
│      (Bb)   (C)    (F#)     │
│                             │
│   Bb                    D   │
│  (Eb)   TONALIDAD    (C#)   │
│      SELECCIONADA           │
│                             │
│   Eb                    A   │
│  (Ab)                 (G#)  │
│                             │
│      Db       B            │
│    (Gb)    (F#)            │
│                             │
└─────────────────────────────┘

Tonalidad Seleccionada (Púrpura): C
Relativa Menor (Gris): Am
```

### Información Mostrada

Debajo del círculo aparece:
- **Nombre de la tonalidad**: "Do Mayor" o "C"
- **Tipo de tonalidad**: Mayor o Menor
- **Descripción contextual**: Posición en el círculo

Ejemplo:
```
Do Mayor (C)

Centro tonal (Do). El punto de partida puro, 
sin alteraciones.

Son las tonalidades más comunes y fáciles de 
leer en partitura (pocas alteraciones).
```

### Interacción

```
1. Haz clic en cualquier tonalidad
2. Se resalta en púrpura
3. La partitura se actualiza
4. Los tooltips muestran info de la nueva tonalidad
5. El análisis teórico se actualiza
```

## Tonalidades por Posición

### Derecha del Top (Sostenidos)

**G Mayor (Sol):**
- 1 sostenido: F#
- Relativa: Em (Mi menor)
- Descripción: "Un paso a la derecha. Introduce el Fa#."

**D Mayor (Re):**
- 2 sostenidos: F#, C#
- Relativa: Bm (Si menor)
- Descripción: "Dos pasos a la derecha. Brillo creciente."

**A Mayor (La):**
- 3 sostenidos: F#, C#, G#
- Relativa: F#m (Fa# menor)
- Descripción: "Tres pasos a la derecha. Tonalidad brillante y enérgica."

**E Mayor (Mi):**
- 4 sostenidos: F#, C#, G#, D#
- Relativa: C#m (Do# menor)
- Descripción: "Cuatro pasos. Muy brillante, usada en guitarra."

**B Mayor (Si):**
- 5 sostenidos: F#, C#, G#, D#, A#
- Relativa: G#m (Sol# menor)
- Descripción: "Cinco pasos. Tensión armónica alta."

**F# Mayor (Fa#):**
- 6 sostenidos: F#, C#, G#, D#, A#, E#
- Relativa: D#m (Re# menor)
- Descripción: "El tritono. Máxima tensión con sostenidos."

### Izquierda del Top (Bemoles)

**F Mayor (Fa):**
- 1 bemol: Bb
- Relativa: Dm (Re menor)
- Descripción: "Un paso a la izquierda. Introduce el Sib."

**Bb Mayor (Sib):**
- 2 bemoles: Bb, Eb
- Relativa: Gm (Sol menor)
- Descripción: "Dos pasos a la izquierda. Suave, común en vientos."

**Eb Mayor (Mib):**
- 3 bemoles: Bb, Eb, Ab
- Relativa: Cm (Do menor)
- Descripción: "Tres pasos. Heroico y majestuoso."

**Ab Mayor (Lab):**
- 4 bemoles: Bb, Eb, Ab, Db
- Relativa: Fm (Fa menor)
- Descripción: "Cuatro pasos. Profundo y solemne."

**Db Mayor (Reb):**
- 5 bemoles: Bb, Eb, Ab, Db, Gb
- Relativa: Bbm (Sib menor)
- Descripción: "Cinco pasos. Oscuro, cálido y romántico."

**Gb Mayor (Solb):**
- 6 bemoles: Bb, Eb, Ab, Db, Gb, Cb
- Relativa: Ebm (Mib menor)
- Descripción: "El tritono. Máxima tensión con bemoles."

## Tonalidades Menores Relativas

Cada tonalidad mayor tiene una **relativa menor** que comparte la misma armadura.

**Relación:**
```
Do Mayor (C) ←→ La Menor (Am)  (0 alteraciones)
Sol Mayor (G) ←→ Mi Menor (Em)  (1 sostenido)
Re Mayor (D) ←→ Si Menor (Bm)   (2 sostenidos)
... etc
```

**Cómo Encontrar:**
- Tonalidad mayor → 3 semitonos abajo = relativa menor
- Tonalidad menor → 3 semitonos arriba = relativa mayor

## Patrón de Alteraciones

### Orden de Sostenidos

El orden en que aparecen los sostenidos es fijo:

```
F# - C# - G# - D# - A# - E# - B#
 1    2    3    4    5    6    7
```

**Ejemplo:**
- Do Mayor: ninguno
- Sol Mayor: F# (1 sostenido)
- Re Mayor: F#, C# (2 sostenidos)
- La Mayor: F#, C#, G# (3 sostenidos)

### Orden de Bemoles

El orden de bemoles es el reverso de los sostenidos:

```
B♭ - E♭ - A♭ - D♭ - G♭ - C♭ - F♭
 1    2    3    4    5    6    7
```

**Ejemplo:**
- Do Mayor: ninguno
- Fa Mayor: Bb (1 bemol)
- Sib Mayor: Bb, Eb (2 bemoles)
- Mib Mayor: Bb, Eb, Ab (3 bemoles)

## Navegación

### Por Pasos

- **1 paso a la derecha** (+7 semitonos / quinta ascendente): Añade 1 sostenido
- **1 paso a la izquierda** (-7 semitonos / cuarta ascendente): Añade 1 bemol

### Transposición

Para transponer a otra tonalidad:

```
Do Mayor → Sol Mayor (5 pasos → +7 semitonos)
Do Mayor → Fa Mayor (5 pasos ← -5 semitonos)
Do Mayor → Re Mayor (2 pasos →)
```

## Casos de Uso

### 1. Aprender Tonalidades

```
Estudiante:
1. Empieza en Do Mayor (centro, sin alteraciones)
2. Se mueve gradualmente a la derecha
3. Observa cómo aumentan los sostenidos
4. Entiende el patrón
5. Repite a la izquierda con bemoles
```

### 2. Transposición

```
Músico tiene canción en Sol Mayor:
1. Haz clic en Sol Mayor
2. Lee los sostenidos (F#)
3. Toca la canción sabiendo qué alterar
4. Puede transponer a otras tonalidades
```

### 3. Improvisación

```
Bajista quiere improvisar:
1. Selecciona La Menor
2. Explora la escala en el teclado
3. Entiende los tonos seguros
4. Improvisa con confianza
```

## Especificaciones Técnicas

### Archivos

- **Backend**: `lib/music_ian/music_core/theory.ex` (función `generate_circle_of_fifths`)
- **Frontend**: `lib/music_ian_web/components/music/circle_of_fifths.ex`

### Datos

```elixir
%{
  index: 0,                    # Posición (0-11)
  label: "C",                  # Do Mayor
  minor: "a",                  # La menor
  midi: 60,                    # MIDI number
  angle: 0                     # Ángulo en círculo (0-360)
}
```

### Performance

- Renderizado: <50ms
- Actualización de tonalidad: <100ms
- Repositorio completo en memoria

## Futuras Mejoras

- [ ] Modo relativo (Ver todas las relativas)
- [ ] Modo paralelo (Ver tonalidades paralelas)
- [ ] Animación al navegar
- [ ] Sonido al cambiar (acorde de la tonalidad)
- [ ] Historial de tonalidades visitadas
- [ ] Favoritos/tonalidades personales

---

**¿Preguntas?** Ver [Tonalidades y Tooltips](./01-tonalities-tooltips.md) para más detalles técnicos.
