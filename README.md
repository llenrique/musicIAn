# 🎵 musicIAn - Plataforma de Educación Musical Interactiva

[![Elixir](https://img.shields.io/badge/elixir-%231C1C1C?style=for-the-badge&logo=elixir&logoColor=white)](https://elixir-lang.org/)
[![Phoenix](https://img.shields.io/badge/phoenix-%23FD4F00?style=for-the-badge&logo=phoenix&logoColor=white)](https://www.phoenixframework.org/)
[![PostgreSQL](https://img.shields.io/badge/postgres-%23316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![JavaScript](https://img.shields.io/badge/javascript-%23323330?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

## 📌 Descripción

**musicIAn** es una plataforma web interactiva para la educación musical que combina:

- 🎹 **Teclado Virtual Interactivo** con integración MIDI
- 🎼 **Partitura Interactiva** con visualización de escalas y acordes
- 🔄 **Círculo de Quintas** como selector de tonalidades
- 💡 **Tooltips Educativos** con explicaciones contextuales
- 📊 **Lecciones Prácticas** con validación en tiempo real
- 🎯 **Análisis de Interpretación** automático y feedback instantáneo

Desarrollada con **Elixir + Phoenix** en el backend y **Vanilla JavaScript** en el frontend, musicIAn proporciona una experiencia educativa completa para músicos de todos los niveles.

## ✨ Características Principales

### 🎼 Tonalidades y Escalas

- ✅ **12 Tonalidades Completas** del círculo de quintas (Mayor y Menor)
- ✅ **Nomenclatura Enarmónica Correcta** (F# en lugar de Gb en Re Mayor)
- ✅ **8 Tipos de Escalas**: Mayor, Menor Natural, Armónica, Melódica, 5 Modos
- ✅ **Escalas Especiales**: Pentatónica Mayor/Menor, Blues

### 💡 Sistema de Tooltips

Pasa el mouse sobre cualquier nota en la partitura para ver:
- **Nombre de la nota** y grado en la escala
- **Intervalo** desde la raíz (en semitonos y nombre)
- **Explicación** de por qué tiene esa alteración
- **Contexto musical** según el tipo de escala

```
Ejemplo: F# en Re Mayor
F# - 3ª
Dos tonos (4 semitonos) - Tercera mayor
⚠️ Alterada según la tonalidad
```

### 🎹 Teclado Interactivo

- 3 octavas completas
- Integración con controladores MIDI
- Síntesis de audio con Web Audio API
- Visualización en tiempo real de notas tocadas

### 📊 Lecciones Prácticas

- Ejercicios estructurados por dificultad
- Validación instantánea de notas y ritmo
- Feedback contextual y personalizado
- Seguimiento de progreso

## 🚀 Inicio Rápido

### Requisitos

- **Elixir 1.16.3+** y **Erlang/OTP 26+**
- **PostgreSQL 14+**
- **Node.js 18+**

### Instalación

```bash
# Clonar repositorio
git clone https://github.com/llenrique/musicIAn.git
cd musicIAn

# Instalar dependencias
mix deps.get

# Crear y migrar base de datos
mix ecto.create
mix ecto.migrate

# Iniciar servidor
mix phx.server
```

Abre http://localhost:4000 en tu navegador.

## 📚 Documentación

- **[Wiki Completa](./WIKI.md)** - Documentación detallada del proyecto
- **[Introducción](./wiki/01-introduction.md)** - ¿Qué es musicIAn?
- **[Setup y Instalación](./wiki/02-setup.md)** - Guía de instalación paso a paso
- **[Primera Ejecución](./wiki/03-first-run.md)** - Primeros pasos en la app
- **[Tonalidades y Tooltips](./wiki/features/01-tonalities-tooltips.md)** - Explicación técnica completa
- **[Stack Técnico](./TECHNICAL_FEASIBILITY.md)** - Arquitectura y decisiones

## 🏗️ Arquitectura

### Stack Tecnológico

```
Backend:
  ├── Elixir 1.16.3
  ├── Phoenix 1.8.3
  ├── Phoenix LiveView (real-time updates)
  ├── PostgreSQL 14+ (Ecto)
  └── Postgrex (driver)

Frontend:
  ├── Vanilla JavaScript (sin frameworks)
  ├── TailwindCSS
  ├── VexFlow (partitura)
  ├── Web MIDI API
  └── Web Audio API

DevOps:
  ├── Mix (build tool)
  ├── esbuild (JavaScript bundler)
  ├── Tailwind CLI
  └── Docker (opcional)
```

### Estructura del Proyecto

```
musicIAn/
├── lib/
│   ├── music_ian/              # Lógica de negocio pura
│   │   ├── music_core/         # Teoría musical (Note, Scale, Chord)
│   │   ├── practice/           # Motor de lecciones
│   │   └── curriculum.ex       # Definición de lecciones
│   └── music_ian_web/          # Phoenix LiveView
│       ├── live/               # LiveView pages
│       ├── components/         # UI components
│       └── channels/           # WebSocket channels
├── assets/
│   ├── js/
│   │   ├── app.js              # Entrada principal
│   │   └── hooks/              # Phoenix hooks
│   ├── css/                    # TailwindCSS
│   └── vendor/                 # Librerías externas
├── priv/
│   ├── repo/
│   │   ├── migrations/         # Migraciones Ecto
│   │   └── seeds.exs           # Datos iniciales
│   └── static/                 # Assets estáticos
├── test/                       # Tests
├── config/                     # Configuración
├── wiki/                       # Documentación
├── WIKI.md                     # Índice de wiki
├── mix.exs                     # Dependencias
└── README.md                   # Este archivo
```

## 🧪 Desarrollo

### Instalar Dependencias

```bash
mix deps.get
```

### Ejecutar Tests

```bash
mix test
```

### Compilar sin Servidor

```bash
mix compile
```

### Analizar Código

```bash
mix credo
```

### Generar Documentación

```bash
mix docs
```

## 🌟 Características Implementadas

### v0.1.0 (Actual)

- ✅ Tonalidades con nomenclatura correcta
- ✅ Sistema de tooltips interactivos
- ✅ Teclado virtual interactivo
- ✅ Partitura con VexFlow
- ✅ Círculo de quintas
- ✅ Web Audio API (síntesis)
- ✅ Web MIDI API (controllers)

### Roadmap

#### v0.2.0

- [ ] Selector de escalas (Menor, Modos, etc.)
- [ ] Más tipos de lecciones
- [ ] Dashboard de progreso
- [ ] Sistema de notas personales

#### v0.3.0

- [ ] Análisis avanzado de interpretación
- [ ] Acordes diatónicos
- [ ] Retroalimentación con IA
- [ ] Exportación de progreso

#### v0.4.0+

- [ ] Soporte para otros instrumentos (guitarra, violin, etc.)
- [ ] Reconocimiento de ritmo
- [ ] Generación adaptativa de ejercicios
- [ ] Modo multijugador/colaborativo

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Para contribuir:

1. **Fork** el repositorio
2. **Crea una rama** para tu feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** tus cambios (`git commit -m 'Add AmazingFeature'`)
4. **Push** a la rama (`git push origin feature/AmazingFeature`)
5. **Abre un Pull Request**

Por favor revisa [CONTRIBUTING.md](./wiki/development/01-contributing.md) para más detalles.

## 📖 Guías de Teoría Musical

La carpeta [knowledge/music_theory/](./knowledge/music_theory/) contiene guías detalladas:

- [01_fundamentals.md](./knowledge/music_theory/01_fundamentals.md) - Fundamentos
- [02_intervals_and_scales.md](./knowledge/music_theory/02_intervals_and_scales.md) - Intervalos y escalas
- [03_harmony_and_chords.md](./knowledge/music_theory/03_harmony_and_chords.md) - Armonía
- [04_rhythm_and_meter.md](./knowledge/music_theory/04_rhythm_and_meter.md) - Ritmo
- [05_advanced_harmony.md](./knowledge/music_theory/05_advanced_harmony.md) - Armonía avanzada
- Y más...

## 🐛 Reportar Bugs

Si encuentras un bug:

1. Verifica que no esté ya reportado en [Issues](https://github.com/llenrique/musicIAn/issues)
2. Abre un nuevo issue con:
   - Descripción clara del problema
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Screenshots (si aplica)

## 💬 Preguntas y Soporte

- 📚 Lee la [Wiki](./WIKI.md)
- 📧 Abre un issue con etiqueta `question`
- 💬 Participa en [GitHub Discussions](https://github.com/llenrique/musicIAn/discussions)

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

## 🎯 Inspiración y Inspiradores

musicIAn fue creado para hacer la educación musical más accesible, interactiva y divertida.

Inspirado en:
- Métodos tradicionales de educación musical
- Tecnologías web modernas
- Comunidad de músicos y educadores

## 🙏 Agradecimientos

- [Phoenix Framework](https://www.phoenixframework.org/)
- [VexFlow](https://www.vexflow.com/) - Notación musical
- [Elixir](https://elixir-lang.org/) - Lenguaje
- [PostgreSQL](https://www.postgresql.org/) - Base de datos

## 📞 Contacto

- **GitHub**: [@llenrique](https://github.com/llenrique)
- **Issues**: [GitHub Issues](https://github.com/llenrique/musicIAn/issues)
- **Discussions**: [GitHub Discussions](https://github.com/llenrique/musicIAn/discussions)

---

**Última actualización**: Febrero 2026

**Estado**: ✅ En desarrollo activo

**¿Listo para empezar?** → [Instalación](./wiki/02-setup.md) | [Primera Ejecución](./wiki/03-first-run.md)
