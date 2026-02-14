# 01. Fundamentos: El Átomo Musical (Notas y MIDI)

Para que el sistema entienda música, debe entender la unidad mínima: la Nota y su representación digital.

## 1. El Estándar MIDI (La verdad absoluta del sistema)
En `musicIAn`, la verdad fundamental es el **MIDI Note Number** (Entero 0-127).
- **C4 (Do Central)** = 60
- **A4 (La de referencia 440Hz)** = 69
- Cada semitono es +1 o -1.

## 2. Cromatismo y Enarmonía
El sistema debe manejar **12 clases de notas** (Pitch Classes) que se repiten en octavas.

| Pitch Class (Int) | Nombres Comunes | Enarmonía (Contextual) |
| :--- | :--- | :--- |
| 0 | C | B# (raro), Dbb |
| 1 | C# / Db | - |
| 2 | D | C##, Ebb |
| 3 | D# / Eb | - |
| 4 | E | Fb, D## |
| 5 | F | E#, Gbb |
| 6 | F# / Gb | - |
| 7 | G | F##, Abb |
| 8 | G# / Ab | - |
| 9 | A | G##, Bbb |
| 10 | A# / Bb | - |
| 11 | B | Cb, A## |

> **Regla de Oro para el Core**: Internamente calculamos con enteros (0-11). Solo al presentar al usuario (UI) decidimos si mostramos "Do#" o "Reb" basándonos en la tonalidad (Key Signature).

## 3. Octavas y Frecuencia
Fórmula para convertir MIDI a Frecuencia (para el motor de audio en JS):
`f = 440 * 2^((d - 69) / 12)`
Donde `d` es el número de nota MIDI.

## 4. Duración (Figuras Rítmicas)
El tiempo es relativo al **Tempo (BPM)**.
El sistema usará una unidad base de "Ticks" o "Pulsos".
En MIDI estándar, se usa PPQ (Pulses Per Quarter note).
Para `musicIAn`, normalizaremos a valores flotantes relativos a la redonda (1.0) o a la negra (0.25).

| Figura | Valor Relativo | Nombre |
| :--- | :--- | :--- |
| Redonda | 1.0 | Whole Note |
| Blanca | 0.5 | Half Note |
| Negra | 0.25 | Quarter Note |
| Corchea | 0.125 | Eighth Note |
| Semicorchea | 0.0625 | Sixteenth Note |
| Fusa | 0.03125 | Thirty-second Note |

> **Tresillos (Triplets)**: Valor * (2/3).
> **Puntillo (Dotted)**: Valor * 1.5.
