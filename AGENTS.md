# Contexto y Memoria de Agentes - musicIAn

Este archivo sirve como memoria persistente para los agentes de IA que trabajan en el proyecto.

> **IMPORTANTE para agentes:** Antes de escribir cualquier código Elixir nuevo, leer
> [CREDO_TRACKER.md](CREDO_TRACKER.md). Contiene las reglas que Credo enforcea en este
> proyecto y la lista de issues activos. No introducir issues nuevos del mismo tipo.

## Descripción del Proyecto
**musicIAn**: Plataforma web para la enseñanza de instrumentos musicales (foco inicial: Piano/MIDI) y teoría musical en tiempo real.
Combina análisis de interpretación en vivo con teoría musical adaptativa.

## Stack Tecnológico
- **Lenguaje**: Elixir
- **Framework Web**: Phoenix Framework
- **Frontend/Real-time**: Phoenix LiveView
- **Estilos**: Tailwind CSS
- **Base de Datos**: PostgreSQL (Ecto)
- **Integración Hardware**: Web MIDI API (Cliente) -> LiveView Hooks (Servidor)
- **Audio**: Web Audio API (Cliente) para síntesis de sonido sin latencia.

## Arquitectura del Sistema (Contextos de Phoenix)

El sistema se divide en 3 dominios principales (Contextos):

1.  **`MusicCore` (Núcleo Musical)**
    *   Lógica pura de teoría musical.
    *   Validación de notas, escalas, acordes, ritmo.
    *   No depende de base de datos ni web.
    *   **Base de Conocimiento**: Ver carpeta `knowledge/music_theory/`.

2.  **`Practice` (Seguimiento y Progreso)**
    *   Registro de sesiones de práctica.
    *   Métricas: % notas correctas/incorrectas, desviación de tiempo (tempo/ritmo).
    *   Historial diario/semanal del usuario.

3.  **`Instructor` (Motor de Análisis y Feedback)**
    *   Análisis de interpretación (Mano izquierda vs Derecha).
    *   Detección de errores específicos (figuras musicales, notas falsas).
    *   Generación de ejercicios correctivos (Algoritmo de recomendación).

## Interfaces (LiveViews)
- **`TheoryLive` (`/theory`)**: Explorador interactivo de teoría musical.
    - Teclado virtual interactivo.
    - Visualización de escalas y modos.
    - Síntesis de audio vía Web Audio API (Hook `AudioEngine`).

## Flujo de Lecciones (SIMPLIFICADO)
Ver: [LESSON_FLOW_SIMPLIFIED.md](LESSON_FLOW_SIMPLIFIED.md)

**Estados (lesson_phase):**
- `:intro` → Lección cargada (mostrar modal)
- `:demo` → Reproduciendo ejemplo (metrónomo OFF)
- `:post_demo` → Después de demo (usuario elige: repetir o practicar)
- `:countdown` → Preparación 10 seg (metrónomo ON si aplica)
- `:active` → Práctica activa (validación de notas)
- `:summary` → Lección completada

**Reglas Importantes:**
1. Metrónomo se activa SOLO en `begin_practice` si `lesson.metronome == true`
2. NO se puede hacer toggle_metronome durante `:countdown` o `:demo`
3. Validación solo ocurre en `:active`
4. stop_demo → :post_demo (NO :active)

## Documentación Técnica Adicional
- [Viabilidad Técnica y Estrategia MIDI](TECHNICAL_FEASIBILITY.md)
- [Flujo Simplificado de Lecciones](LESSON_FLOW_SIMPLIFIED.md) ⭐ LEER PRIMERO
- **Teoría Musical (Base de Conocimiento)**:
    - [Fundamentos](knowledge/music_theory/01_fundamentals.md)
    - [Intervalos y Escalas](knowledge/music_theory/02_intervals_and_scales.md)
    - [Armonía y Acordes](knowledge/music_theory/03_harmony_and_chords.md)
    - [Ritmo y Métrica](knowledge/music_theory/04_rhythm_and_meter.md)
    - [Armonía Avanzada](knowledge/music_theory/05_advanced_harmony.md)
    - [Conducción de Voces](knowledge/music_theory/06_voice_leading.md)
    - [Formas y Estructuras](knowledge/music_theory/07_musical_forms.md)
    - [Timbre y Producción](knowledge/music_theory/08_timbre_and_production.md)
    - [Psicoacústica](knowledge/music_theory/09_psychoacoustics.md)
    - [Maestría Global](knowledge/music_theory/10_global_mastery.md)

## Estado Actual
- **Fecha**: 2026-02-16
- **Fase**: Círculo de quintas rediseñado + compilación limpia.
- **Logros**:
    - Estructura base Phoenix creada.
    - `MusicCore` implementado (Notas, Escalas, Acordes).
    - Interfaz `TheoryLive` funcional con audio y visualización.
    - Flujo de lecciones simplificado y documentado.
    - Tooltips corregidos (no se quedan pegados).
    - Metrónomo integrado en countdown.
    - Bugs críticos de lecciones corregidos.
    - `mix compile` limpio (cero warnings) — `warnings_as_errors: true` activo.
    - **Escalas correctas** — `scale.ex`: `get_natural_note_index/2` (con `use_flats`), `add_accidental_for_degree/3` reescrito, `generate_scale_notes/4` con `opts`. Las 13 escalas mayores del círculo son correctas según libros de teoría (ej. Gb mayor = Gb Ab Bb Cb Db Eb F).
    - **Bug teclado resuelto** — `keyboard.ex`: eliminado `held_notes` del servidor; highlight de teclas presionadas lo maneja `AudioEngine.js` con `!bg-yellow-400`. `keyboard_notes` (solo mano derecha) separado de `active_notes` (pentagrama, ambas manos). `active_set` MapSet precalculado para lookup O(1).
    - **Círculo de quintas rediseñado** — `circle_of_fifths.ex` reescrito con 3 anillos concéntricos SVG: anillo mayor exterior, anillo menor interior, centro con nota activa. Colores arcoíris por sector. Toggle Mayor/Menor como botones encima del SVG. Click en anillo mayor → escala mayor; click en anillo menor → escala menor relativa.
    - `theory_live.ex`: assign `:circle_mode` (`:major`|`:minor`), `handle_event("select_circle_mode", ...)`, `handle_event("select_root", %{"note", "mode"}, ...)` actualizados.
    - `theory.ex`: `generate_circle_of_fifths` retorna `minor_midi` y `minor` label en cada sector.

## Decisiones de Diseño Importantes
- **`@sector_colors`** en `circle_of_fifths.ex`: mapa de índice 0..11 → `{color_major, color_minor}`. Se asigna a assigns para evitar acceso directo al módulo desde la plantilla HEEx.
- **`circle_mode`** controla qué anillo está "activo" visualmente y qué tipo de escala se selecciona al hacer click.
- **`suggested_keys`** resalta sectores del anillo mayor con opacidad 0.9 (vs 0.75 normal).
- **`keyboard_base: 48`** en mount de `theory_live.ex` — octava inicial del teclado virtual.
- **`should_use_flats`** excluye pitch_class 6 (F#/Gb ambiguo): por defecto F# con sostenidos; Gb requiere `use_flats: true` explícito.

## Convenciones
- **Código**: Inglés (variables, funciones, módulos).
- **Documentación/Comentarios**: Español (para facilitar el entendimiento del equipo).
- **Testing**: ExUnit (Test Driven Development preferido para `MusicCore`).
