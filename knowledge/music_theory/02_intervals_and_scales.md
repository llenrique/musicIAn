# 02. Intervalos y Escalas: La Distancia y el Camino

La música no son notas aisladas, son las **relaciones** entre ellas.

## 1. Intervalos (La Distancia Matemática)
Un intervalo es la diferencia absoluta entre dos notas MIDI.
`Intervalo = abs(Nota2 - Nota1)`

| Semitonos | Nombre Corto | Nombre Completo | Calidad | Inversión |
| :--- | :--- | :--- | :--- | :--- |
| 0 | P1 | Unísono Perfecto | Consonante | P1 |
| 1 | m2 | Segunda Menor | Disonante | M7 |
| 2 | M2 | Segunda Mayor | Disonante (suave) | m7 |
| 3 | m3 | Tercera Menor | Consonante | M6 |
| 4 | M3 | Tercera Mayor | Consonante | m6 |
| 5 | P4 | Cuarta Justa | Consonante/Disonante | P5 |
| 6 | TT | Tritono (4a Aum / 5a Dism) | Muy Disonante | TT |
| 7 | P5 | Quinta Justa | Consonante (Estable) | P4 |
| 8 | m6 | Sexta Menor | Consonante | M3 |
| 9 | M6 | Sexta Mayor | Consonante | m3 |
| 10 | m7 | Séptima Menor | Disonante (Tensión) | M2 |
| 11 | M7 | Séptima Mayor | Disonante (Brillante) | m2 |
| 12 | P8 | Octava Justa | Consonante | P1 |

## 2. Escalas (Algoritmos de Generación)
Una escala es una secuencia ordenada de intervalos desde una nota raíz.

### Fórmula Maestra (Semitonos desde la Raíz)
Para generar cualquier escala en cualquier tono, sumamos estos valores a la nota MIDI raíz.

*   **Mayor (Jónica)**: `[0, 2, 4, 5, 7, 9, 11]`
    *   Ej: C Mayor -> C, D, E, F, G, A, B
*   **Menor Natural (Eólica)**: `[0, 2, 3, 5, 7, 8, 10]`
*   **Menor Armónica**: `[0, 2, 3, 5, 7, 8, 11]` (Nótese el salto de 3 semitonos al final).
*   **Pentatónica Mayor**: `[0, 2, 4, 7, 9]`
*   **Pentatónica Menor**: `[0, 3, 5, 7, 10]`
*   **Blues**: `[0, 3, 5, 6, 7, 10]` (Incluye la "Blue Note" - Tritono).

## 3. Modos Griegos (Desplazamiento de la Escala Mayor)
Si rotamos la escala mayor, obtenemos los modos.
Base: C Mayor (C D E F G A B)

1.  **Jónico (I)**: C a C (Mayor natural).
2.  **Dórico (II)**: D a D (Menor con 6ta mayor). `[0, 2, 3, 5, 7, 9, 10]`
3.  **Frigio (III)**: E a E (Menor con 2da menor - sonido español). `[0, 1, 3, 5, 7, 8, 10]`
4.  **Lidio (IV)**: F a F (Mayor con 4ta aumentada - sonido espacial). `[0, 2, 4, 6, 7, 9, 11]`
5.  **Mixolidio (V)**: G a G (Mayor con 7ma menor - sonido rock/blues). `[0, 2, 4, 5, 7, 9, 10]`
6.  **Eólico (VI)**: A a A (Menor natural).
7.  **Locrio (VII)**: B a B (Disminuido - inestable). `[0, 1, 3, 5, 6, 8, 10]`

> **Lógica de Implementación**:
> `get_scale(root, :dorian)` es equivalente a `get_scale(note_at_interval(root, -2), :major)` pero empezando en `root`.
