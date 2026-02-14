# 04. Ritmo y Métrica: El Tiempo Estructurado

El ritmo es la organización del tiempo musical. Para `musicIAn`, esto implica matemáticas precisas sobre la duración y el acento.

## 1. Compases (Time Signatures)
El compás define la agrupación de pulsos. Se representa como una fracción `Numerador / Denominador`.

*   **Numerador**: Cuántos pulsos hay por compás.
*   **Denominador**: Qué figura musical representa un pulso (4 = Negra, 8 = Corchea, 2 = Blanca).

### Clasificación Computacional
1.  **Simple**: El pulso se divide en 2 (Ej: 2/4, 3/4, 4/4).
2.  **Compuesto**: El pulso se divide en 3 (Ej: 6/8, 9/8, 12/8).
    *   *Nota*: En 6/8, hay 2 pulsos principales (de negra con puntillo), no 6.
3.  **Amalgama/Irregular**: Combinación de simples y compuestos (Ej: 5/4 = 3+2 o 2+3; 7/8 = 2+2+3, etc.).

## 2. Acentuación (Groove y Feel)
No todos los pulsos son iguales. El sistema debe saber qué pulsos son "fuertes" para evaluar la interpretación.

*   **4/4**: Fuerte (1), Débil (2), Semifuerte (3), Débil (4).
*   **3/4**: Fuerte (1), Débil (2), Débil (3).
*   **6/8**: Fuerte (1), Débil (2), Débil (3), Semifuerte (4), Débil (5), Débil (6).

> **Implementación**: Un mapa de "peso" por posición en el compás `%{0 => 1.0, 1 => 0.5, 2 => 0.8, 3 => 0.5}` para calcular la precisión rítmica ponderada.

## 3. Polirritmia y Hemiolas
Cuando dos ritmos contrastantes suenan simultáneamente.
*   **3 contra 2**: Típico en música africana y jazz. (Tresillos de negra vs Negras).
*   **4 contra 3**: Polirritmia compleja.

## 4. Swing y Shuffle
Desplazamiento temporal de las notas a contratiempo (off-beats).
*   **Straight**: División exacta 50/50.
*   **Swing**: La primera corchea dura más que la segunda (aprox 66/33 o "atresillado").
*   **Cálculo**: `swing_ratio = duration_on_beat / duration_off_beat`.

## 5. Algoritmo de Cuantización (Quantization)
Para corregir o evaluar la entrada del usuario, necesitamos "ajustar" sus notas a la rejilla (grid) más cercana.
*   `grid_value`: 1/16 (semicorchea) es el estándar.
*   `closest_grid_point = round(note_timestamp / grid_duration) * grid_duration`
*   **Humanize**: Permitir un margen de error (ej: +/- 15ms) antes de penalizar.
