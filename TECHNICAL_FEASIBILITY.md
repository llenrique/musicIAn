# Análisis de Viabilidad Técnica - musicIAn

Este documento detalla la factibilidad técnica, los desafíos y las estrategias de implementación para el proyecto `musicIAn` utilizando el stack Elixir/Phoenix LiveView.

## 1. Arquitectura de Comunicación MIDI (El Desafío Principal)

### El Problema

Los instrumentos MIDI se conectan al cliente (Navegador del usuario) a través de la **Web MIDI API**. Phoenix LiveView se ejecuta en el servidor. Existe una latencia inherente en la comunicación Cliente <-> Servidor.

### La Solución: Arquitectura Híbrida

No podemos enviar cada señal MIDI al servidor para generar el sonido (latencia inaceptable). Debemos separar responsabilidades:

1.  **Cliente (JavaScript/Hooks)**:
    - **Responsabilidad**: Captura de eventos MIDI (Web MIDI API) y Generación de Audio (Web Audio API / Tone.js).
    - **Acción**: El sonido debe ser inmediato en el navegador del usuario para evitar retraso al tocar.
    - **Envío**: Envía los eventos `note_on` y `note_off` con _timestamps_ al servidor vía LiveView Socket para análisis.

2.  **Servidor (Elixir/LiveView)**:
    - **Responsabilidad**: Lógica de negocio, Validación de Teoría, Puntuación y Persistencia.
    - **Acción**: Recibe el evento, lo compara con la "partitura esperada" o la regla teórica activa, y devuelve el feedback visual (ej: color verde/rojo en la UI).

### Viabilidad: ALTA

Elixir maneja procesos ligeros por usuario (`GenServer` detrás de cada LiveView), lo que permite procesar flujos de notas MIDI de miles de usuarios concurrentes sin bloquear el sistema.

## 2. Motor de Teoría Musical (`MusicCore`)

### Ventaja de Elixir

Elixir es excepcionalmente bueno para este dominio debido al **Pattern Matching**.

- **Ejemplo**: Identificar un acorde no requiere complejos `if/else`. Se pueden definir funciones que "encajen" con la estructura de las notas recibidas (ej: intervalos de 3ra mayor + 3ra menor = Acorde Mayor).
- **Estructura**: Las notas pueden representarse como átomos o enteros (MIDI numbers), facilitando la transposición y cálculos matemáticos simples.

## 3. Análisis de Interpretación y "Mano Izquierda/Derecha"

### El Desafío Técnico

El protocolo MIDI estándar **no envía información sobre qué mano tocó la nota**. Solo envía: Nota, Velocidad (fuerza) y Canal.

### Estrategia de Solución

Para identificar fallos de mano izquierda vs derecha, necesitamos **Inferencia Lógica**:

1.  **Split Point Fijo**: Definir un punto de corte (ej: Do central) donde notas inferiores son Izquierda y superiores Derecha (común en pianos digitales).
2.  **Análisis de Contexto**: Si el ejercicio es una escala, el sistema sabe qué mano _debería_ estar tocando.
3.  **Polifonía**: Elixir debe ser capaz de procesar acordes (múltiples eventos simultáneos) y compararlos con el "estado objetivo".

## 4. Latencia y Ritmo (Timing)

### Riesgo: Jitter de Red

Si evaluamos el ritmo basándonos en "cuándo llega el paquete al servidor", el lag de internet falseará la puntuación del alumno.

### Mitigación

- **Timestamp Relativo**: El cliente JS debe enviar el `performance.now()` o el timestamp del evento MIDI junto con la nota.
- **Ventana de Tolerancia**: El servidor compara la diferencia de tiempo relativa entre notas, no el tiempo absoluto de llegada.
- **Buffer**: Para ejercicios rápidos, se puede enviar un paquete de notas cada X milisegundos en lugar de una por una, aunque esto reduce el feedback visual instantáneo. Para `musicIAn`, el envío 1 a 1 suele ser aceptable si la conexión es estable (< 100ms ping).

## 5. Requisitos del Cliente

- **Navegador**: Debe soportar Web MIDI API (Chrome, Edge, Opera nativos; Firefox/Safari pueden requerir configuración o polyfills).
- **Hardware**: Dispositivo MIDI compatible o Teclado de PC emulando MIDI.

## Conclusión

El proyecto es **Técnicamente Viable**. La clave del éxito reside en delegar la generación de sonido al cliente (JS) y usar Elixir puramente como el "cerebro" que analiza la teoría y gestiona el estado de la lección en tiempo real.
