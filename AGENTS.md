# Contexto y Memoria de Agentes - musicIAn

Este archivo sirve como memoria persistente para los agentes de IA que trabajan en el proyecto.

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

## Documentación Técnica Adicional
- [Viabilidad Técnica y Estrategia MIDI](TECHNICAL_FEASIBILITY.md)
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
- **Fecha**: 2026-02-13
- **Fase**: Implementación del MVP.
- **Logros**:
    - Estructura base Phoenix creada.
    - `MusicCore` implementado (Notas, Escalas, Acordes).
    - Interfaz `TheoryLive` funcional con audio y visualización.

## Convenciones
- **Código**: Inglés (variables, funciones, módulos).
- **Documentación/Comentarios**: Español (para facilitar el entendimiento del equipo).
- **Testing**: ExUnit (Test Driven Development preferido para `MusicCore`).
