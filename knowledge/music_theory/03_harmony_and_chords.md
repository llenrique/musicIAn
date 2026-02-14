# 03. Armonía y Acordes: La Estructura Vertical

La armonía define el "color" y la emoción del momento musical.

## 1. Construcción de Acordes (Triadas)
Un acorde básico se forma apilando terceras sobre una raíz.

| Tipo | Fórmula (Semitonos) | Intervalos | Sentimiento |
| :--- | :--- | :--- | :--- |
| **Mayor** | `[0, 4, 7]` | R + M3 + P5 | Feliz, Estable |
| **Menor** | `[0, 3, 7]` | R + m3 + P5 | Triste, Serio |
| **Disminuido** | `[0, 3, 6]` | R + m3 + TT | Tenso, Terror |
| **Aumentado** | `[0, 4, 8]` | R + M3 + m6 | Onírico, Flotante |
| **Sus4** | `[0, 5, 7]` | R + P4 + P5 | Suspensión |
| **Sus2** | `[0, 2, 7]` | R + M2 + P5 | Abierto |

## 2. Tétradas (Acordes de Séptima)
Esenciales para Jazz, Soul y música compleja.

| Tipo | Símbolo | Fórmula | Componentes |
| :--- | :--- | :--- | :--- |
| **Maj7** | Cmaj7 | `[0, 4, 7, 11]` | Triada Mayor + 7ma Mayor |
| **Dominante 7** | C7 | `[0, 4, 7, 10]` | Triada Mayor + 7ma Menor |
| **Menor 7** | Cm7 | `[0, 3, 7, 10]` | Triada Menor + 7ma Menor |
| **Menor 7b5** | Cm7b5 (ø) | `[0, 3, 6, 10]` | Triada Dism + 7ma Menor (Semidisminuido) |
| **Disminuido 7** | Cdim7 (°) | `[0, 3, 6, 9]` | Triada Dism + 7ma Dism (6ta Mayor enarmónica) |

## 3. Inversiones
Cambiar la nota más grave (el bajo) del acorde.
Para un acorde `[C, E, G]`:
*   **Estado Fundamental**: Bajo en C. `[0, 4, 7]`
*   **1ra Inversión**: Bajo en E. `[4, 7, 12]` (El C sube una octava).
*   **2da Inversión**: Bajo en G. `[7, 12, 16]` (El E sube una octava).

> **Detección Algorítmica**: Para identificar un acorde invertido, movemos las notas a una sola octava, las ordenamos, y probamos rotaciones hasta que encajen con una fórmula conocida de triada o tétrada.

## 4. Funciones Tonales (El Mapa de la Canción)
En una tonalidad mayor (ej: Do Mayor), cada grado cumple una función:

*   **I (Tónica)**: Casa, reposo. (C Maj)
*   **ii (Subdominante)**: Movimiento. (D min)
*   **iii (Mediante)**: Color, extensión de tónica. (E min)
*   **IV (Subdominante)**: Alejamiento, tensión suave. (F Maj)
*   **V (Dominante)**: Tensión máxima, pide volver a I. (G Maj / G7)
*   **vi (Submediante)**: Relativa menor, tristeza. (A min)
*   **vii° (Sensible)**: Inestable, quiere ir a I. (B dim)

> **Progresión II-V-I**: La secuencia más importante en Jazz y música occidental. `ii -> V -> I`.
