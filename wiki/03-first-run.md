# 🚀 Primera Ejecución

Después de instalar musicIAn, aquí está tu guía para empezar a explorar la plataforma.

## Iniciando la Aplicación

```bash
cd musicIAn
mix phx.server
```

Deberías ver algo como:
```
[info] Running MusicIanWeb.Endpoint with Bandit 1.10.2 at 127.0.0.1:4000 (http)
[info] Access MusicIanWeb.Endpoint at http://localhost:4000
```

Abre tu navegador en: **http://localhost:4000**

## Interfaz Principal

### 1. Círculo de Quintas (Izquierda)

El **Círculo de Quintas** es tu principal selector de tonalidades.

**¿Qué ver?**
- 12 tonalidades mayores (en el perímetro exterior)
- 12 tonalidades menores relativas (en el perímetro interior)
- Tonalidad seleccionada resaltada en púrpura

**¿Cómo usarlo?**
1. Haz clic en cualquier tonalidad (ej: Do Mayor "C")
2. Observa cómo cambia la información teórica
3. La partitura se actualiza automáticamente

### 2. Partitura (Centro)

Muestra la **escala seleccionada** en grand staff (pentagrama treble y bass).

**Elementos:**
- **Armadura**: Muestra sostenidos/bemoles (ej: 2♯ para Re Mayor)
- **Notas**: Cabezas de nota en las líneas y espacios
- **Información**: Explicación teórica debajo

**Interactividad:**
- **Pasa el mouse sobre las notas** → Ver tooltips con explicaciones
- Los tooltips muestran:
  - Nombre de la nota (ej: F#)
  - Grado de la escala (ej: 3ª)
  - Intervalo desde la raíz (ej: Dos tonos - Tercera mayor)
  - Por qué tiene esa alteración

### 3. Análisis Teórico (Derecha)

Panel de información con 3 secciones:

#### Estructura Interválica
Muestra el patrón de la escala (ej: T-T-S-T-T-T-S para Mayor)

#### Carácter
Describe el "mood" de la escala:
- **Mayor**: "Alegre, Brillante, Estable"
- **Menor**: "Triste, Serio, Melancólico"
- **Modos**: Descripciones únicas para cada uno

#### Descripción
Explicación musical de la escala seleccionada.

### 4. Teclado Interactivo (Abajo)

Teclado virtual de 3 octavas.

**Características:**
- Haz clic en teclas para tocar notas
- Las teclas relevantes para la escala están resaltadas
- Las notas se sintetizan con Web Audio API

## Explorando Tonalidades

### Ejercicio 1: Entender Alteraciones

1. **Haz clic en Do Mayor (C)**
   - No hay alteraciones (teclas blancas)
   - Tooltip muestra notas naturales

2. **Haz clic en Sol Mayor (G)**
   - Aparece 1 sostenido: F#
   - Pasa mouse sobre F# para ver explicación

3. **Haz clic en Fa Mayor (F)**
   - Aparece 1 bemol: Bb
   - Pasa mouse sobre Bb para ver explicación

4. **Haz clic en Re Mayor (D)**
   - Aparecen 2 sostenidos: F# y C#
   - Cada uno tiene su propia explicación

### Ejercicio 2: Comparar Mayor vs Menor

1. **Haz clic en La Mayor (A)**
   - Nota las 3 sostenidos
   - Observa la estructura: "Alegre, Brillante"

2. **Haz clic en La Menor (Am)**
   - La tonalidad relativa (sin alteraciones adicionales)
   - Observa el "Carácter": "Triste, Serio"

3. **Compara la partitura**: Las notas son las mismas, pero el contexto cambia

## Usando los Tooltips

Los **tooltips educativos** son el corazón de musicIAn.

### Cómo Usar

1. Selecciona una tonalidad en el círculo
2. **Pasa lentamente el mouse** sobre cada nota en la partitura
3. Espera a que aparezca el tooltip
4. Lee la explicación:
   - **Nombre y Grado**: ¿Cuál nota es y qué posición ocupa?
   - **Intervalo**: ¿Cuántos semitonos desde la raíz?
   - **Alteración**: ¿Por qué tiene sostenido/bemol?

### Ejemplo: Do Mayor

```
Pasa mouse sobre "E" (la 3ª nota)

Tooltip:
E - 3ª
Dos tonos (4 semitonos) - Tercera mayor
```

### Ejemplo: Re Mayor

```
Pasa mouse sobre "F#" (la 3ª nota)

Tooltip:
F# - 3ª
Dos tonos (4 semitonos) - Tercera mayor
⚠️ Alterada según la tonalidad
```

## Cambiar de Escala (Futuro)

*(Cuando el selector de escala esté disponible, aquí habrá instrucciones para cambiar entre Mayor, Menor Natural, Armónica, Melódica, Modos, Pentatónica, Blues)*

## Shortcuts de Teclado

*(A implementar)*

| Tecla | Acción |
|-------|--------|
| `←` `→` | Navegar círculo de quintas |
| `↑` `↓` | Cambiar escala (futuro) |
| `?` | Mostrar ayuda |

## Próximos Pasos

1. **Explorar todas las 12 tonalidades** - Nota cómo cambia el patrón de alteraciones
2. **Entender el Círculo de Quintas** - Lee [Circle of Fifths Guide](../features/03-circle-of-fifths.md)
3. **Iniciar una Lección** - Cuando esté disponible
4. **Explorar Modos** - Cuando esté disponible

## Troubleshooting

**Los tooltips no aparecen:**
- Asegúrate de pasar el mouse **lentamente**
- Intenta acercar más el puntero a la nota
- Recarga la página (F5)

**El sonido no funciona:**
- Verifica que tus auriculares/altavoces estén conectados
- Abre las DevTools (F12) y revisa la consola
- Algunos navegadores requieren autorización de audio

**La partitura se ve mal:**
- Intenta hacer zoom (Ctrl + o Cmd +)
- Recarga la página
- Intenta otro navegador

## ¿Necesitas Ayuda?

- Lee la [documentación completa](../../WIKI.md)
- Revisa los [tutoriales de teoría musical](../guides/)
- Reporta issues en [GitHub](https://github.com/llenrique/musicIAn/issues)

---

**¡Felicidades! Ya estás usando musicIAn.** 🎵

Continúa explorando y aprendiendo. ¿Listo para más? Mira [Características Avanzadas](../features/).
