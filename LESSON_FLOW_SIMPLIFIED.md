# Flujo Simplificado de Lecciones

## 🎯 Flujo Principal

```
┌─────────────────────────────────────────┐
│ 1. START_LESSON                         │
│    - Cargar lección                     │
│    - Mostrar introducción               │
│    - Fase: :intro                       │
│    - Metrónomo: OFF                     │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ 2. START_DEMO (opcional)                │
│    - Usuario hace clic "Ver Demo"       │
│    - Reproduce ejemplo de cómo tocar    │
│    - Fase: :demo                        │
│    - Metrónomo: OFF                     │
│    - Toggle metronome: DESHABILITADO    │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ 3. STOP_DEMO                            │
│    - Demo termina                       │
│    - Mostrar modal post-demo            │
│    - Fase: :post_demo                   │
│    - Opciones: Repetir demo o practicar │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ 4. BEGIN_PRACTICE                       │
│    - Usuario hace clic "Comenzar"       │
│    - Iniciar countdown 10 segundos      │
│    - Activar metrónomo si la lección lo │
│      tiene (metronome: true)            │
│    - Fase: :countdown                   │
│    - Toggle metronome: DESHABILITADO    │
│    - Countdown: 10,9,8,7,6,5,4          │
│             luego: Listo, Set, ¡Vamos! │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ 5. COUNTDOWN TERMINA                    │
│    - Countdown llega a 0                │
│    - Fase: :active                      │
│    - Metrónomo: SIGUE ACTIVO            │
│    - Toggle metronome: HABILITADO       │
│    - Validación: ACTIVA                 │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ 6. USUARIO TOCA NOTAS                   │
│    - midi_note_on event                 │
│    - Validar contra paso actual         │
│    - Actualizar estadísticas            │
│    - Si correcto: pasar al siguiente    │
│    - Si error: contar como error        │
└─────────────────────────────────────────┘
              ↓
         Paso siguiente?
              ├─ SÍ → Volver al paso 6
              └─ NO ↓
┌─────────────────────────────────────────┐
│ 7. LECCIÓN COMPLETADA                   │
│    - Todos los pasos correctos          │
│    - Fase: :summary                     │
│    - Mostrar: Resultado final           │
│    - Guardar en DB                      │
│    - Metrónomo: OFF                     │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ 8. STOP_LESSON                          │
│    - Usuario hace clic X o "Volver"     │
│    - Limpiar todo estado                │
│    - Fase: nil                          │
│    - Volver al menú de lecciones        │
└─────────────────────────────────────────┘
```

---

## 📋 Estados de Fase (lesson_phase)

| Fase | Significado | Metrónomo | Validación | User Actions |
|------|-----------|-----------|-----------|--------------|
| `:intro` | Lección cargada | OFF | NO | Ver demo, comenzar |
| `:demo` | Reproduciendo ejemplo | OFF | NO | Detener demo |
| `:post_demo` | Después de demo | OFF | NO | Repetir demo o practicar |
| `:countdown` | Preparación (10 seg) | ON/OFF* | NO | Esperar |
| `:active` | En práctica | ON/OFF | SÍ | Tocar notas |
| `:summary` | Lección completada | OFF | NO | Siguiente lección o repetir |

*ON si lección tiene `metronome: true`, OFF si no

---

## 🎛️ Control del Metrónomo

### Cuándo se ACTIVA:
1. **En `begin_practice`**: Si `lesson.metronome == true`
   ```elixir
   metronome_enabled = Map.get(lesson, :metronome, false)
   if metronome_enabled do
     push_event("toggle_metronome", %{active: true, bpm: tempo})
   end
   ```

2. **Permanece ON** durante:
   - Countdown (10 segundos)
   - Práctica activa (:active)

### Cuándo se DESACTIVA:
1. **En `assign_lesson_state(socket, nil)`**: Cuando la lección termina
   ```elixir
   push_event("toggle_metronome", %{active: false, ...})
   ```

2. **En `demo_finished`**: Cuando termina la demostración
3. **En `stop_lesson`**: Cuando usuario cierra la lección

### GUARD - Qué NO puede hacer el usuario:
- **No puede** toggle metrónomo durante `:countdown`
- **No puede** toggle metrónomo durante `:demo`
- **Sí puede** toggle metrónomo durante `:active` (práctica)
- **Sí puede** toggle metrónomo fuera de lección (modo exploración)

---

## 🐛 Bugs Corregidos en Esta Refactorización

### Bug #1: stop_demo saltaba a :active
**Antes:**
```
:demo → stop_demo → :active (INCORRECTO)
```
**Ahora:**
```
:demo → stop_demo → :post_demo → begin_practice → :countdown → :active ✓
```

### Bug #2: Metrónomo se apagaba durante countdown
**Antes:**
```
User podía hacer toggle durante countdown → metrónomo se apagaba ❌
```
**Ahora:**
```
Guard bloquea toggle durante countdown ✓
```

### Bug #3: Flujo confuso después de demo
**Antes:**
```
show_demo → stop → ya estaba practicando (confusión)
```
**Ahora:**
```
show_demo → stop → modal:post_demo → usuario elige → practica clara ✓
```

---

## 🔄 Transiciones Permitidas

```
:intro
  ├→ :demo (start_demo)
  └→ :countdown (begin_practice directo, sin demo)

:demo
  └→ :post_demo (stop_demo)

:post_demo
  ├→ :demo (play_demo - repetir)
  └→ :countdown (begin_practice)

:countdown
  └→ :active (countdown_tick cuando llega a 0)

:active
  ├→ :continue (validate_step success)
  └→ :summary (validate_step completed)

:summary
  └→ nil (stop_lesson)
```

---

## ✅ Checklist de Validación

Cuando trabajes con lecciones, verifica:

- [ ] `start_lesson` → fase `:intro` ✓
- [ ] `start_demo` → fase `:demo`, metrónomo OFF ✓
- [ ] `stop_demo` → fase `:post_demo`, no :active ✓
- [ ] `begin_practice` → fase `:countdown`, metrónomo ON si aplica ✓
- [ ] Durante countdown → no puedes hacer toggle_metronome ✓
- [ ] Countdown termina → fase `:active`, metrónomo sigue ON ✓
- [ ] Usuario toca nota correcta → avanza al siguiente paso ✓
- [ ] Último paso completado → fase `:summary` ✓
- [ ] `stop_lesson` → metrónomo OFF, fase nil ✓

---

## 📝 Notas Importantes

1. **Metrónomo es responsabilidad del servidor**
   - El cliente NO decide cuándo activarlo/desactivarlo
   - Solo el servidor puede hacer push_event para cambiar estado
   - Guard en toggle_metronome protege la integridad del estado

2. **Countdown es sincrónico con metrónomo**
   - Si lección tiene metrónomo, está activo durante los 10 segundos
   - Usuario escucha cómo sonaría la práctica
   - Prepara mente y ritmo

3. **Validación solo ocurre en :active**
   - midi_note_on solo valida si `lesson_phase == :active`
   - Esto evita problemas con validación accidental durante demo/countdown

4. **Estados limpios**
   - Cada transición de fase es clara y unidireccional
   - No hay ciclos o estados ambiguos
   - Fácil de debuggear

---

## 🚀 Próximas Mejoras (Futura)

- [ ] Agregar fase `:error` para manejar errores críticos
- [ ] Agregar estadísticas en tiempo real
- [ ] Agregar opción de saltar pasos
- [ ] Agregar replay de lección
