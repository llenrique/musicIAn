# 07. Formas y Estructuras: La Arquitectura del Tiempo

Para ser mejor que Mozart y Bad Bunny, hay que entender cómo ambos construyen sus "edificios" sonoros. La forma es el plano arquitectónico.

## 1. Estructuras Clásicas (El Legado de Beethoven/Mozart)
El sistema debe reconocer patrones de repetición y contraste a gran escala.

*   **Forma Binaria (A-B)**: Dos secciones contrastantes. Común en el Barroco.
*   **Forma Ternaria (A-B-A)**: Exposición, Contraste, Re-exposición.
*   **Forma Sonata**: La estructura más sofisticada del Clasicismo.
    1.  **Exposición**: Tema A (Tónica) -> Puente -> Tema B (Dominante).
    2.  **Desarrollo**: Caos tonal, fragmentación de temas, tensión máxima.
    3.  **Reexposición**: Tema A (Tónica) -> Tema B (Tónica). Resolución del conflicto.

## 2. Estructuras Pop/Rock/Urbano (MJ, TOP, Bad Bunny)
La música moderna se basa en la energía y el "Hook".

*   **Verse-Chorus (Verso-Estribillo)**: La forma estándar.
    *   **Verso**: Cuenta la historia, baja energía.
    *   **Pre-Chorus**: Construye tensión (Build-up).
    *   **Chorus (Estribillo)**: El mensaje principal, melodía pegadiza, máxima energía.
    *   **Bridge (Puente)**: Ruptura armónica/rítmica antes del último estribillo.
*   **La Estructura "Trap/Reggaeton"**:
    *   **Intro**: Atmósfera, firma del productor ("Bad Bunny baby").
    *   **Hook**: El motivo principal instrumental o vocal.
    *   **Verso**: Flow rítmico.
    *   **Drop**: En EDM/Trap, sustituye al estribillo vocal con una explosión instrumental.
    *   **Outro**: Fade out o corte seco.

## 3. Análisis de Energía (Dinámica Macroscópica)
Para que `musicIAn` evalúe una composición, debe medir la curva de intensidad.
*   **Beethoven**: Contrastes súbitos (*Subito Piano*), crescendos largos.
*   **Twenty One Pilots**: Cambios drásticos de género/tempo en la misma canción (ej: "Ode to Sleep").
*   **Michael Jackson**: Capas acumulativas. Empieza con bajo+batería, añade guitarra, luego sintetizador, luego voz.

> **Algoritmo de Segmentación**: Detectar cambios en densidad de notas, volumen (velocidad MIDI) y rango de frecuencias para identificar automáticamente: "Aquí empieza el Estribillo".
