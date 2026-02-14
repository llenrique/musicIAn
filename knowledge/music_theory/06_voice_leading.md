# 06. Conducción de Voces y Contrapunto

Cómo se mueven las notas individuales de un acorde al siguiente. Es vital para generar ejercicios que suenen "musicales" y no robóticos.

## 1. Principios de Parsimonia (Voice Leading)
Las voces deben moverse lo menos posible.
*   **Notas Comunes**: Si una nota se repite en el siguiente acorde, mantenla en la misma voz.
*   **Movimiento Conjunto**: Preferir moverse por grados conjuntos (2das) que por saltos.
*   **Ley del Camino Más Corto**: La suma de los movimientos de todas las voces debe ser mínima.

## 2. Reglas Prohibitivas (Estilo Clásico/Coral)
Para ejercicios de estilo estricto (Bach, Coral):
*   **Quintas y Octavas Paralelas**: Dos voces no pueden moverse de una 5ta a otra 5ta, ni de una 8va a otra 8va. Destruye la independencia de las voces.
*   **Cruces de Voces (Voice Crossing)**: La voz de soprano no debe bajar más que la contralto, etc.

## 3. Voicings de Jazz (Piano)
Para el estilo moderno, las reglas cambian.
*   **Shell Voicings**: Tocar solo Raíz + 3ra + 7ma (Mano izquierda).
*   **Rootless Voicings**: Omitir la raíz (asumiendo que la toca el bajista). Tocar 3ra, 5ta, 7ma, 9na.
    *   **Guía Tones**: La 3ra y la 7ma son las notas que definen la cualidad del acorde. Deben estar presentes.
*   **Drop-2**: Tomar la segunda voz más aguda de un acorde cerrado y bajarla una octava. Abre el sonido.
*   **Cluster**: Notas adyacentes (2das) tocadas simultáneamente para color percusivo.

## 4. Tensiones Disponibles (Extensions)
Notas que se pueden añadir a un acorde sin chocar con la melodía o la función.
*   **9na**: Disponible si está a un tono de la raíz (b9 para dominantes menores).
*   **11na**: Disponible en acordes menores y dominantes (como sus4). En acordes mayores choca con la 3ra (evitar, o usar #11 Lidia).
*   **13na**: Disponible en dominantes y mayores.

> **Algoritmo de Generación de Ejercicios**:
> Al generar una progresión para el alumno, `MusicCore` no debe elegir inversiones al azar. Debe calcular el *Voice Leading* óptimo para que la mano del alumno no tenga que saltar incómodamente por el teclado.
