# Metrónomo Yamaha YDP-105: Limitaciones Técnicas

## Estado Actual

Hemos investigado exhaustivamente cómo Smart Pianist de Yamaha activa el metrónomo en el YDP-105 remotamente. Aquí están nuestros hallazgos:

## Descubrimientos

### 1. Smart Pianist NO usa MIDI Estándar
- Smart Pianist **usa comunicación USB propietaria** de Yamaha
- No es MIDI protocol (0xF0 SysEx), es un protocolo cerrado de Yamaha
- Por esto midimonitor.com **no captura nada** relacionado con el metrónomo

### 2. El Botón FUNCTION es Puramente Físico
- El botón FUNCTION en el piano **NO emite MIDI**
- Solo activa un estado interno en el piano
- Presionar FUNCTION + una tecla es una **combinación de input físico**

### 3. Yamaha USB Metadata
```
Vendor ID: 1177 (0x0499)
Product ID: 5918 (0x170e)
Interface Class: 1 (Audio)
Interface Subclass: 3 (MIDI Streaming)
```

El piano expone una interfaz de MIDI Streaming estándar, **pero el control del metrónomo está fuera de MIDI estándar**.

### 4. Limitaciones de Web MIDI API
- Web MIDI API **no soporta SysEx arbitrarios** en todos los navegadores
- No hay forma desde JavaScript de acceder a **USB HID directo**
- Los navegadores no tienen acceso a **CoreMIDI** (macOS) o **ALSA** (Linux)

## Soluciones Investigadas

| Solución | Estado | Razón |
|----------|--------|-------|
| MIDI Note On (C5) | ❌ No funciona | Solo genera nota de audio |
| MIDI Control Change | ❌ No funciona | No mapeado al metrónomo |
| MIDI Program Change | ❌ No funciona | No mapeado al metrónomo |
| SysEx Yamaha | ❌ No funciona | Protocolo incorrecto |
| PortMIDI + Elixir | ❌ No compila | Sin binarios para ARM64 macOS |
| HID directo + shell | ❌ No disponible | hidapitester no instala en macOS |
| Brute force exhaustivo | ❌ No funciona | Ninguna combinación de 0-255 activa |

## Opciones Viables

### Opción A: Aceptar la Limitación (Recomendada)
✅ **Ventajas:**
- No hay dependencias externas
- Funciona 100% desde la app web (Web MIDI API estándar)
- Compatible con cualquier navegador moderno

❌ **Desventajas:**
- El usuario debe presionar FUNCTION físicamente en el piano
- La app puede cambiar tempo/compás, pero no activar el metrónomo

**Implementación:**
```
Usuario: [Presiona FUNCTION en el piano]
App Web: [Envía Note On para controlar tempo/compás]
```

### Opción B: Metrónomo en Software (Recomendada para MVP)
✅ **Ventajas:**
- Funciona 100% desde la app web
- Control completo sin hardware
- Buena UX con UI interactiva

❌ **Desventajas:**
- Usa recursos de la computadora/navegador
- Latencia de audio depende del navegador

**Implementación:**
```javascript
// En assets/js/hooks/MetronomeAudio.js
const audioContext = new (window.AudioContext || window.webkitAudioContext)();
const oscillator = audioContext.createOscillator();
// Generar clicks/sonidos a tempo especificado
```

### Opción C: Solución con Daemon Nativo (Para producción)
❌ **Desventajas:**
- Requiere instalación de software adicional en el sistema
- Complejidad significativa
- Mantenimiento complicado

⚠️ **Requeriría:**
- Script Python con `python-rtmidi` 
- O aplicación Node.js con `node-midi`
- Que corra como daemon en background
- Comunicación app web → daemon via sockets

## Recomendación Final

**Implementar Opción B: Metrónomo en Software JavaScript**

✅ Razones:
1. No depende de hardware/SO
2. Funciona en cualquier navegador
3. UX completa y controlable
4. Integrable fácilmente en musicIAn
5. Mejor para MVP

## Código de Ejemplo: Metrónomo en JavaScript

```javascript
class MetronomeAudio {
  constructor() {
    this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
    this.isPlaying = false;
    this.tempo = 120;
    this.nextNoteTime = 0;
    this.scheduleAheadTime = 0.1;
  }

  start() {
    if (this.isPlaying) return;
    this.isPlaying = true;
    this.nextNoteTime = this.audioContext.currentTime;
    this.scheduler();
  }

  stop() {
    this.isPlaying = false;
  }

  playClick() {
    const now = this.audioContext.currentTime;
    const osc = this.audioContext.createOscillator();
    const env = this.audioContext.createGain();
    
    osc.frequency.setValueAtTime(1000, now);
    osc.frequency.setValueAtTime(100, now + 0.05);
    
    env.gain.setValueAtTime(0.3, now);
    env.gain.setValueAtTime(0, now + 0.05);
    
    osc.connect(env);
    env.connect(this.audioContext.destination);
    
    osc.start(now);
    osc.stop(now + 0.05);
  }

  scheduler() {
    const scheduleAheadTime = 0.1;
    const lookAhead = 25;

    while (this.nextNoteTime < this.audioContext.currentTime + this.scheduleAheadTime) {
      this.scheduleNote(this.nextNoteTime);
      this.nextNoteTime += (60.0 / this.tempo);
    }

    if (this.isPlaying) {
      setTimeout(() => this.scheduler(), lookAhead);
    }
  }

  scheduleNote(time) {
    setTimeout(() => this.playClick(), (time - this.audioContext.currentTime) * 1000);
  }

  setTempo(bpm) {
    this.tempo = bpm;
  }
}
```

## Próximos Pasos

1. ✅ Página de test metrónomo Web MIDI creada (`/metronome`)
2. ⏳ Implementar metrónomo software JavaScript
3. ⏳ Integrar controles de tempo en interfaz principal
4. ⏳ Documentar limitaciones en UI

## Conclusión

**Smart Pianist puede activar el metrónomo porque usa APIs privadas de Yamaha que no están documentadas públicamente.** Es improbable replicar esto completamente desde una app web sin acceso a esas APIs.

La mejor aproximación es:
- ✅ Usar metrónomo software para reproducir beats
- ✅ Permitir cambio de tempo via MIDI si es posible
- ✅ Aceptar que la activación del metrónomo del piano requiere presión física

---

**Fecha:** Febrero 2026  
**Estado:** Investigación Completada  
**Responsable:** Equipo musicIAn
