# 05. Armonía Avanzada: Cromatismo y Modulación

Más allá de la tonalidad básica, la música interesante rompe las reglas diatónicas.

## 1. Dominantes Secundarios (V/x)
Acordes dominantes que resuelven en un grado que NO es la tónica.
*   **Concepto**: "Tonicalizar" momentáneamente otro acorde.
*   **Ejemplo en C Mayor**:
    *   Queremos ir a Dm (ii).
    *   El dominante de D es A7.
    *   Progresión: C -> **A7** -> Dm -> G7 -> C.
    *   Análisis: I -> **V7/ii** -> ii -> V7 -> I.
*   **Detección**: Un acorde mayor con 7ma menor cuya raíz está una 5ta justa arriba del siguiente acorde diatónico.

## 2. Sustitución Tritonal (SubV7)
Reemplazar un acorde dominante por otro cuya raíz está a un tritono de distancia.
*   **Teoría**: Ambos acordes comparten el mismo tritono (3ra y 7ma).
    *   G7: G - **B** - D - **F**
    *   Db7: Db - **F** - Ab - **Cb (B)**
*   **Uso**: Crea una línea de bajo cromática descendente.
    *   Dm7 -> **Db7** -> Cmaj7 (en lugar de G7).

## 3. Intercambio Modal (Modal Interchange)
Tomar prestados acordes del modo paralelo (ej: C Menor) mientras estamos en C Mayor.
*   **Acordes Prestados Comunes**:
    *   **bVI (AbMaj7)**: De Eólico. Sonido épico/heroico.
    *   **bVII (Bb7)**: De Mixolidio o Eólico. "Backdoor dominant".
    *   **iv (Fm)**: De Eólico. La "cadencia plagal menor" (sentimental).
    *   **iiø (Dm7b5)**: De Eólico.

## 4. Acordes de Sexta Aumentada
Acordes cromáticos de predominante que expanden la octava hacia afuera para resolver en la dominante (V).
*   **Italiana**: b6 + 1 + #4 (Ab - C - F# en C mayor).
*   **Alemana**: b6 + 1 + b3 + #4 (Ab - C - Eb - F#). Suena como un Dominante 7.
*   **Francesa**: b6 + 1 + 2 + #4 (Ab - C - D - F#). Sonido de escala de tonos enteros.

## 5. Acordes Napolitanos (N6)
Un acorde mayor construido sobre el segundo grado rebajado (bII), generalmente en primera inversión.
*   En C menor: Db Mayor / F (Db - F - Ab).
*   Función: Predominante dramática.

## 6. Modulación (Cambio de Tono)
El sistema debe detectar si el centro tonal ha cambiado permanentemente.
*   **Pivote**: Un acorde común a ambas tonalidades.
*   **Directa**: Salto brusco a nueva tonalidad.
*   **Cromática**: Movimiento por semitonos.
*   **Algoritmo**: Si `MusicCore` detecta consistentemente notas fuera de la escala actual (accidentals) que forman una nueva escala diatónica durante X compases -> `change_key(new_key)`.
