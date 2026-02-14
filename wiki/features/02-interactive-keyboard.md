# 🎹 Teclado Interactivo

## Descripción

El **teclado virtual interactivo** es una de las herramientas principales de musicIAn para la práctica musical.

Características:
- 3 octavas completas (36 teclas)
- Integración con MIDI hardware
- Síntesis de audio con Web Audio API
- Visualización en tiempo real
- Resaltado automático de notas de la escala

## Interfaz

### Diseño Visual

```
┌─────────────────────────────────────────────────┐
│  C    D    E  F    G    A    B  C               │  ← Teclas blancas
│   C#   D#    F#   G#   A#    C#                 │  ← Teclas negras
└─────────────────────────────────────────────────┘
│ C - C6 │  Rango de notas mostradas              │
│ ▼ ▲    │  Controles de octava                   │
└────────┘
```

### Elementos

1. **Teclas Blancas**: Notas naturales (C, D, E, F, G, A, B)
2. **Teclas Negras**: Notas alteradas (C#, D#, F#, G#, A#)
3. **Indicador de Octava**: Muestra la octava actual (C4 - C6)
4. **Controles**: Cambiar entre octavas

## Interacción

### Con Mouse

```bash
1. Haz clic en cualquier tecla
2. Se escucha el sonido de la nota
3. La tecla se resalta visualmente
4. La nota aparece en la partitura
5. Se valida contra la escala actual
```

### Con Teclado Físico (Futuro)

```
Mapeo:
A-Z → MIDI 60-77 (C4-D#5)
Space → Sostenido/Bemol de la nota anterior
Shift + Tecla → Octava anterior
Ctrl + Tecla → Octava siguiente
```

### Con MIDI Hardware

```bash
1. Conecta controlador MIDI
2. El sistema detecta automáticamente
3. Las notas se capturan en tiempo real
4. Se procesan igual que mouse/teclado
```

## Audio

### Web Audio API

El sonido se genera usando **síntesis de audio** en el navegador.

**Características:**
- Latencia ultra-baja (<50ms)
- Polififonía (múltiples notas simultáneamente)
- Envolvente ADSR personalizable
- Sostenido de notas

**Parámetros:**
```javascript
{
  frequency: 440,        // Hz (A4)
  duration: 2.0,         // segundos
  volume: 0.7,          // 0-1
  waveform: 'sine',     // sine, square, triangle, sawtooth
  attack: 0.01,         // milisegundos
  decay: 0.1,
  sustain: 0.8,
  release: 0.5
}
```

## Validación

### Durante la Práctica

Cuando toca en modo práctica:
- ✅ Nota correcta → Se resalta en verde
- ❌ Nota incorrecta → Se resalta en rojo
- ⏱️ Timing error → Feedback visual

### Feedback Visual

```
Nota Correcta:
┌─────────┐
│  C  ✓   │  Verde, checkmark
└─────────┘

Nota Incorrecta:
┌─────────┐
│  C# ✗   │  Rojo, X
└─────────┘

Timing Error:
┌─────────┐
│  D  ⚠️   │  Amarillo, warning
└─────────┘
```

## Configuración

### Preferencias de Usuario

*(A implementar)*

```javascript
{
  octaveRange: [3, 6],           // Octavas visibles
  waveform: 'sine',              // Tipo de onda
  volume: 0.7,                   // Volumen
  velocityMode: 'dynamic',       // Sensibilidad MIDI
  highlightMode: 'scale',        // scale, none
  feedbackMode: 'visual+audio'   // visual, audio, both, none
}
```

### Temas

- 🌞 **Light**: Fondo blanco, teclas grises
- 🌙 **Dark**: Fondo oscuro, teclas brillantes
- 🎨 **Custom**: Colores personalizados

## Casos de Uso

### 1. Exploración de Escalas

```
Usuario:
1. Selecciona Re Mayor en el círculo
2. Ve la partitura
3. Toca notas en el teclado
4. Escucha como suenan
5. Entiende visualmente la escala
```

### 2. Práctica de Lectura

```
Usuario:
1. Ve una nota en la partitura
2. Identifica cuál es en el teclado
3. La toca para verificar
4. Mejora la velocidad de lectura
```

### 3. Improvisación

```
Usuario:
1. Selecciona escala (ej: Pentatónica de Blues)
2. Toca libremente en el teclado
3. Todas las notas suenan bien
4. Experimenta sin miedo
```

### 4. Lecciones Guiadas

```
Usuario:
1. Sigue una lección paso a paso
2. El teclado muestra qué tocar
3. Valida en tiempo real
4. Recibe feedback instantáneo
```

## Especificaciones Técnicas

### Archivos

- **Backend**: `lib/music_ian_web/components/music/keyboard.ex`
- **Frontend**: `assets/js/hooks/AudioEngine.js`, `assets/js/hooks/MidiDevice.js`

### Archivos Relacionados

- **Audio Synthesis**: `assets/js/hooks/AudioEngine.js` (~300 líneas)
- **MIDI Input**: `assets/js/hooks/MidiDevice.js` (~850 líneas)
- **Validación**: `lib/music_ian/practice/lesson_engine.ex`

### Performance

- Renderizado: 60 FPS
- Latencia de audio: <50ms
- Polififonía máxima: 8 notas simultáneamente
- Carga inicial: <200ms

## Futuras Mejoras

- [ ] Piano Midi visualizado en 3D
- [ ] Registros de sonido (organ, strings, etc.)
- [ ] Grabación de sesiones
- [ ] Playback de grabaciones
- [ ] Análisis de dinámica (velocity)
- [ ] Pedal de sustain virtual
- [ ] Transposición automática
- [ ] Detección de acordes tocados

## Troubleshooting

**No hay sonido:**
- Verifica volumen del navegador y del sistema
- Revisa DevTools → Console para errores
- Intenta recargando la página
- Algunos navegadores requieren autorización

**MIDI no detecta controlador:**
- Asegúrate que el controlador esté conectado
- Verifica que el navegador soporta Web MIDI API
- Intenta conectar en otro puerto USB
- Reinicia el navegador

**Latencia Alta:**
- Cierra pestañas innecesarias
- Reduce complejidad de la página
- Usa navegador actualizado
- En MIDI: reduce número de tracks

---

**¿Preguntas?** Ver [Teclado en Primera Ejecución](../03-first-run.md#4-teclado-interactivo)
