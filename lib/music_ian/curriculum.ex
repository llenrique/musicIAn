defmodule MusicIan.Curriculum do
  @moduledoc """
  Defines the educational content: Lessons and Steps.
  Methodology: "C Position Mastery" (Based on Alfred's/Faber).
  Focus: Finger independence, separate hand mastery, and gradual coordination.
  """

  def list_lessons do
    [
      # --- FASE 1: MANO DERECHA (Right Hand - RH) ---
      %{
        id: "01_rh_five_fingers",
        title: "1. MD: Los 5 Dedos (Posición Do)",
        description: "Estableciendo la posición de mano derecha."
      },
      %{
        id: "02_rh_skips",
        title: "2. MD: Pasos y Saltos",
        description: "Diferencia entre segundas y terceras."
      },
      %{
        id: "03_rh_melody",
        title: "3. MD: Primera Melodía (Oda a la Alegría)",
        description: "Aplicando la técnica a música real."
      },
      %{
        id: "04_rh_rhythm",
        title: "4. MD: Ritmo y Repetición (Jingle Bells)",
        description: "Control de notas repetidas."
      },

      # --- NUEVA FASE INTERMEDIA: VALORES DE NOTA (Note Values) ---
      %{
        id: "4a_note_values_basics",
        title: "4A. Valores de Nota: Redonda y Blanca",
        description: "Aprendiendo notas largas (4 y 2 tiempos)."
      },
      %{
        id: "4b_note_values_quarter",
        title: "4B. Valores de Nota: Negra",
        description: "La negra (1 tiempo) es tu base."
      },
      %{
        id: "4c_note_values_eighths",
        title: "4C. Valores de Nota: Corcheas",
        description: "Notas rápidas (0.5 tiempos cada una)."
      },
      %{
        id: "4d_note_values_sixteenths",
        title: "4D. Valores de Nota: Semicorcheas",
        description: "Notas muy rápidas (0.25 tiempos)."
      },

      # --- FASE 2: MANO IZQUIERDA (Left Hand - LH) ---
      %{
        id: "05_lh_five_fingers",
        title: "5. MI: El Espejo (Posición Do)",
        description: "Despertando la mano izquierda."
      },
      %{
        id: "06_lh_skips",
        title: "6. MI: Pasos y Saltos",
        description: "Independencia de dedos en la izquierda."
      },
      %{
        id: "07_lh_bass",
        title: "7. MI: Líneas de Bajo (Tónica y Dominante)",
        description: "El papel de soporte de la izquierda."
      },
      %{
        id: "08_lh_melody",
        title: "8. MI: Melodía en el Bajo",
        description: "La izquierda también puede cantar."
      },

      # --- FASE 3: COORDINACIÓN (Hands Together - HT) ---
      %{
        id: "09_ht_alternating",
        title: "9. Coordinación: Pregunta y Respuesta",
        description: "Alternando manos sin superponerlas."
      },
      %{
        id: "10_ht_contrary",
        title: "10. Coordinación: Movimiento Contrario",
        description: "Espejo: Separarse y juntarse."
      },
      %{
        id: "11_ht_parallel",
        title: "11. Coordinación: Movimiento Paralelo",
        description: "El reto: Ambas manos en la misma dirección."
      },

      # --- FASE 4: ARMONÍA Y TÉCNICA ---
      %{
        id: "12_triad_c",
        title: "12. Acorde de Do Mayor (Arpegio)",
        description: "Construyendo armonía: Raíz, Tercera, Quinta."
      },
      %{
        id: "13_triad_g",
        title: "13. Acorde de Sol Mayor (Dominante)",
        description: "Estirando la mano para el cambio de acorde."
      },
      %{
        id: "14_broken_chords",
        title: "14. Acordes Quebrados (Alberti Bass)",
        description: "Patrones de acompañamiento clásico."
      },

      # --- NUEVA FASE INTERMEDIA: VERSIONES DE ODE TO JOY ---
      %{
        id: "14a_ode_to_joy_simple",
        title: "14A. Oda a la Alegría: Versión Simple",
        description: "Versión de 16 pasos con notas enteras, mitades y negras."
      },
      %{
        id: "14b_ode_to_joy_intermediate",
        title: "14B. Oda a la Alegría: Versión Intermedia",
        description: "Versión con corcheas incluidas (24 pasos)."
      },
      %{
        id: "14c_ode_to_joy_advanced",
        title: "14C. Oda a la Alegría: Versión Avanzada",
        description: "Versión completa con semicorcheas (36 pasos)."
      },

      # --- FASE 5: REPERTORIO FINAL ---
      %{
        id: "15_final_performance",
        title: "15. RECITAL: Oda a la Alegría Completa",
        description: "Tu primera pieza completa con acompañamiento."
      },

      # --- FASE 6: TÉCNICA DE ESCALA (El Cruce) ---
      %{
        id: "16_rh_thumb_under",
        title: "16. MD: El Cruce de Pulgar",
        description: "Técnica esencial para extender la mano más allá de 5 notas."
      },
      %{
        id: "17_rh_c_scale",
        title: "17. MD: Escala de Do Mayor (1 Octava)",
        description: "Tu primera escala completa de 8 notas."
      },
      %{
        id: "18_lh_finger_over",
        title: "18. MI: El Cruce de Dedo",
        description: "Técnica de mano izquierda para bajar en la escala."
      },
      %{
        id: "19_lh_c_scale",
        title: "19. MI: Escala de Do Mayor (1 Octava)",
        description: "Dominando la escala con la izquierda."
      },

      # --- FASE 7: NUEVA TONALIDAD (Sol Mayor) ---
      %{
        id: "20_g_position",
        title: "20. Posición de Sol (G Major)",
        description: "Nueva posición: Mueve tus manos a Sol."
      },
      %{
        id: "21_f_sharp",
        title: "21. La Tecla Negra: Fa Sostenido (F#)",
        description: "Introduciendo las alteraciones (teclas negras)."
      },
      %{
        id: "22_g_scale",
        title: "22. Escala de Sol Mayor",
        description: "Escala con una alteración fija."
      },
      %{
        id: "23_g_piece",
        title: "23. Pieza en Sol: Minueto (Tema)",
        description: "Aplicando la nueva tonalidad a música clásica."
      }
    ]
  end

  def get_next_lesson_id(current_id) do
    lessons = list_lessons()
    index = Enum.find_index(lessons, fn l -> l.id == current_id end)

    if index && index + 1 < length(lessons) do
      Enum.at(lessons, index + 1).id
    else
      nil
    end
  end

  def get_lesson(id) do
    case id do
      # ==================================================================================
      # FASE 1: MANO DERECHA (Right Hand)
      # ==================================================================================

      "01_rh_five_fingers" ->
        %{
          id: "01_rh_five_fingers",
          title: "1. MD: Los 5 Dedos",
          intro:
            "Coloca tu mano derecha en el Do Central (C4). Cada dedo tiene su tecla: Pulgar(1) en Do, hasta Meñique(5) en Sol. Mantén la mano curva como si sostuvieras una pelota.",
          steps: [
            %{text: "Do (C4)", note: 60, hint: "Pulgar (1)", finger: 1, duration: 1},
            %{text: "Re (D4)", note: 62, hint: "Índice (2)", finger: 2, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Medio (3)", finger: 3, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Anular (4)", finger: 4, duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "Meñique (5)", finger: 5, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Bajando...", finger: 4, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Bajando...", finger: 3, duration: 1},
            %{text: "Re (D4)", note: 62, hint: "Bajando...", finger: 2, duration: 1},
            %{text: "Do (C4)", note: 60, hint: "Final", finger: 1, duration: 2}
          ]
        }

      "02_rh_skips" ->
        %{
          id: "02_rh_skips",
          title: "2. MD: Pasos y Saltos",
          intro:
            "La música se mueve por pasos (nota vecina) o saltos (saltarse una nota). Practiquemos saltar del 1 al 3 y del 3 al 5.",
          steps: [
            %{text: "Do (C4)", note: 60, hint: "Dedo 1", finger: 1, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Salto al 3", finger: 3, duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "Salto al 5", finger: 5, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Salto al 3", finger: 3, duration: 1},
            %{text: "Do (C4)", note: 60, hint: "Salto al 1", finger: 1, duration: 1},
            # Steps filler
            %{text: "Re (D4)", note: 62, hint: "Paso", finger: 2, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Salto de tercera", finger: 4, duration: 1},
            %{text: "Re (D4)", note: 62, hint: "Regreso", finger: 2, duration: 2}
          ]
        }

      "03_rh_melody" ->
        %{
          id: "03_rh_melody",
          title: "3. MD: Oda a la Alegría (Tema)",
          metronome: true,
          intro:
            "Usando solo los 5 dedos de la mano derecha, podemos tocar melodías famosas. Intenta mantener un ritmo constante.",
          steps: [
            %{text: "Mi (E4)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Repite", finger: 3, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "Sube", finger: 5, duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "Repite", finger: 5, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 1},
            %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 1},
            %{text: "Do (C4)", note: 60, hint: "Llegada", finger: 1, duration: 2}
          ]
        }

      "04_rh_rhythm" ->
        %{
          id: "04_rh_rhythm",
          title: "4. MD: Ritmo (Jingle Bells)",
          metronome: true,
          intro: "El control de las notas repetidas es crucial. Usa un rebote suave de muñeca.",
          steps: [
            %{text: "Mi (E4)", note: 64, hint: "Jingle...", finger: 3, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "...Bells", finger: 3, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Jingle...", finger: 3, duration: 2},
            %{text: "Mi (E4)", note: 64, hint: "...Bells", finger: 3, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Jin-", finger: 3, duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "-gle", finger: 5, duration: 1},
            %{text: "Do (C4)", note: 60, hint: "All", finger: 1, duration: 1},
            %{text: "Re (D4)", note: 62, hint: "The", finger: 2, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Way!", finger: 3, duration: 2}
          ]
        }

      # ==================================================================================
      # NUEVA FASE INTERMEDIA: VALORES DE NOTA (Note Values)
      # ==================================================================================

      "4a_note_values_basics" ->
        %{
          id: "4a_note_values_basics",
          title: "4A. Valores de Nota: Redonda y Blanca",
          intro:
            "Cada nota tiene una duración. La redonda (⚫) dura 4 tiempos. La blanca (⚪) dura 2 tiempos. Practica sosteniendo las notas.",
          metronome: true,
          steps: [
            %{
              text: "Do (C4) - Redonda",
              note: 60,
              hint: "Sostén 4 tiempos",
              finger: 1,
              duration: 4
            },
            %{
              text: "Re (D4) - Blanca",
              note: 62,
              hint: "Sostén 2 tiempos",
              finger: 2,
              duration: 2
            },
            %{
              text: "Mi (E4) - Blanca",
              note: 64,
              hint: "Sostén 2 tiempos",
              finger: 3,
              duration: 2
            },
            %{
              text: "Fa (F4) - Redonda",
              note: 65,
              hint: "Sostén 4 tiempos",
              finger: 4,
              duration: 4
            },
            %{
              text: "Sol (G4) - Blanca",
              note: 67,
              hint: "Sostén 2 tiempos",
              finger: 5,
              duration: 2
            },
            %{
              text: "Fa (F4) - Redonda",
              note: 65,
              hint: "Sostén 4 tiempos",
              finger: 4,
              duration: 4
            },
            %{
              text: "Mi (E4) - Blanca",
              note: 64,
              hint: "Sostén 2 tiempos",
              finger: 3,
              duration: 2
            },
            %{
              text: "Re (D4) - Blanca",
              note: 62,
              hint: "Sostén 2 tiempos",
              finger: 2,
              duration: 2
            }
          ]
        }

      "4b_note_values_quarter" ->
        %{
          id: "4b_note_values_quarter",
          title: "4B. Valores de Nota: La Negra",
          intro:
            "La negra (♩) dura 1 tiempo. Es la nota más común en la música. La usamos como nuestro 'pulso base'.",
          metronome: true,
          steps: [
            %{text: "Do (C4) - Negra", note: 60, hint: "1 tiempo", finger: 1, duration: 1},
            %{text: "Re (D4) - Negra", note: 62, hint: "1 tiempo", finger: 2, duration: 1},
            %{text: "Mi (E4) - Negra", note: 64, hint: "1 tiempo", finger: 3, duration: 1},
            %{text: "Fa (F4) - Negra", note: 65, hint: "1 tiempo", finger: 4, duration: 1},
            %{text: "Sol (G4) - Negra", note: 67, hint: "1 tiempo", finger: 5, duration: 1},
            %{text: "Fa (F4) - Negra", note: 65, hint: "1 tiempo", finger: 4, duration: 1},
            %{text: "Mi (E4) - Negra", note: 64, hint: "1 tiempo", finger: 3, duration: 1},
            %{text: "Re (D4) - Negra", note: 62, hint: "1 tiempo", finger: 2, duration: 1},
            %{text: "Do (C4) - Negra", note: 60, hint: "1 tiempo", finger: 1, duration: 1},
            %{text: "Do (C4) - Blanca", note: 60, hint: "2 tiempos", finger: 1, duration: 2}
          ]
        }

      "4c_note_values_eighths" ->
        %{
          id: "4c_note_values_eighths",
          title: "4C. Valores de Nota: Corcheas",
          intro:
            "La corchea (♪) dura 0.5 tiempos. Dos corcheas = una negra. Suena más rápido. ♪♪ = ♩",
          metronome: true,
          steps: [
            %{
              text: "Do-Re (C4-D4)",
              notes: [60, 62],
              hint: "2 corcheas = 1 tiempo",
              fingers: [1, 2],
              duration: 1
            },
            %{
              text: "Mi-Fa (E4-F4)",
              notes: [64, 65],
              hint: "2 corcheas = 1 tiempo",
              fingers: [3, 4],
              duration: 1
            },
            %{text: "Sol (G4)", note: 67, hint: "1 negra = 1 tiempo", finger: 5, duration: 1},
            %{
              text: "Fa-Mi-Re-Do (F4-E4-D4-C4)",
              notes: [65, 64, 62, 60],
              hint: "4 corcheas = 2 tiempos",
              fingers: [4, 3, 2, 1],
              duration: 2
            },
            %{text: "Do (C4)", note: 60, hint: "1 blanca = 2 tiempos", finger: 1, duration: 2},
            %{
              text: "Re-Mi (D4-E4)",
              notes: [62, 64],
              hint: "2 corcheas",
              fingers: [2, 3],
              duration: 1
            },
            %{
              text: "Fa-Sol (F4-G4)",
              notes: [65, 67],
              hint: "2 corcheas",
              fingers: [4, 5],
              duration: 1
            },
            %{text: "Sol (G4)", note: 67, hint: "1 negra", finger: 5, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "1 negra", finger: 4, duration: 1}
          ]
        }

      "4d_note_values_sixteenths" ->
        %{
          id: "4d_note_values_sixteenths",
          title: "4D. Valores de Nota: Semicorcheas",
          intro:
            "La semicorchea (𝅘𝅥𝅯) dura 0.25 tiempos. Cuatro semicorcheas = una negra. Muy rápido: 𝅘𝅥𝅯𝅘𝅥𝅯𝅘𝅥𝅯𝅘𝅥𝅯 = ♩",
          metronome: true,
          steps: [
            %{
              text: "Do-Re-Mi-Fa (C4-D4-E4-F4)",
              notes: [60, 62, 64, 65],
              hint: "4 semicorcheas = 1 tiempo",
              fingers: [1, 2, 3, 4],
              duration: 1
            },
            %{text: "Sol (G4)", note: 67, hint: "1 negra", finger: 5, duration: 1},
            %{
              text: "Sol-Fa-Mi-Re (G4-F4-E4-D4)",
              notes: [67, 65, 64, 62],
              hint: "4 semicorcheas = 1 tiempo",
              fingers: [5, 4, 3, 2],
              duration: 1
            },
            %{text: "Do (C4)", note: 60, hint: "1 negra", finger: 1, duration: 1},
            %{
              text: "Do-Re-Mi-Fa-Sol-La-Si-Do (C4-D4-E4-F4-G4-A4-B4-C5)",
              notes: [60, 62, 64, 65, 67, 69, 71, 72],
              hint: "Escala rápida en semicorcheas",
              fingers: [1, 2, 3, 4, 5, 5, 5, 5],
              duration: 2
            },
            %{
              text: "Do (C4) - Final",
              note: 60,
              hint: "1 blanca para descansar",
              finger: 1,
              duration: 2
            }
          ]
        }

      # ==================================================================================
      # FASE 2: MANO IZQUIERDA (Left Hand)
      # ==================================================================================

      "05_lh_five_fingers" ->
        %{
          id: "05_lh_five_fingers",
          title: "5. MI: El Espejo",
          intro:
            "Ahora la mano izquierda. Coloca el Meñique (5) en el Do grave (C3) y el Pulgar (1) en el Sol (G3).",
          steps: [
            %{text: "Do (C3)", note: 48, hint: "Meñique (5)", finger: 5, duration: 1},
            %{text: "Re (D3)", note: 50, hint: "Anular (4)", finger: 4, duration: 1},
            %{text: "Mi (E3)", note: 52, hint: "Medio (3)", finger: 3, duration: 1},
            %{text: "Fa (F3)", note: 53, hint: "Índice (2)", finger: 2, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Pulgar (1)", finger: 1, duration: 1},
            %{text: "Fa (F3)", note: 53, hint: "Bajando...", finger: 2, duration: 1},
            %{text: "Mi (E3)", note: 52, hint: "Bajando...", finger: 3, duration: 1},
            %{text: "Re (D3)", note: 50, hint: "Bajando...", finger: 4, duration: 1},
            %{text: "Do (C3)", note: 48, hint: "Final", finger: 5, duration: 2}
          ]
        }

      "06_lh_skips" ->
        %{
          id: "06_lh_skips",
          title: "6. MI: Pasos y Saltos",
          intro:
            "Igual que con la derecha, practicamos saltar notas. Esto fortalece los dedos débiles (4 y 5) de la izquierda.",
          steps: [
            %{text: "Do (C3)", note: 48, hint: "Dedo 5", finger: 5, duration: 1},
            %{text: "Mi (E3)", note: 52, hint: "Salto al 3", finger: 3, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Salto al 1", finger: 1, duration: 1},
            %{text: "Mi (E3)", note: 52, hint: "Salto al 3", finger: 3, duration: 1},
            %{text: "Do (C3)", note: 48, hint: "Salto al 5", finger: 5, duration: 1},
            # Variation
            %{text: "Re (D3)", note: 50, hint: "Dedo 4", finger: 4, duration: 1},
            %{text: "Fa (F3)", note: 53, hint: "Dedo 2", finger: 2, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Dedo 1", finger: 1, duration: 2}
          ]
        }

      "07_lh_bass" ->
        %{
          id: "07_lh_bass",
          title: "7. MI: Líneas de Bajo",
          intro:
            "La mano izquierda suele tocar las notas fundamentales (Bajos). Practica moverte entre Do (Tónica) y Sol (Dominante).",
          steps: [
            %{text: "Do (C3)", note: 48, hint: "Tónica (5)", finger: 5, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Dominante (1)", finger: 1, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Repite", finger: 1, duration: 1},
            %{text: "Do (C3)", note: 48, hint: "Tónica (5)", finger: 5, duration: 1},
            %{text: "Fa (F3)", note: 53, hint: "Subdominante (2)", finger: 2, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Dominante (1)", finger: 1, duration: 1},
            %{text: "Do (C3)", note: 48, hint: "Final", finger: 5, duration: 2}
          ]
        }

      "08_lh_melody" ->
        %{
          id: "08_lh_melody",
          title: "8. MI: Melodía en el Bajo",
          metronome: true,
          intro:
            "A veces la izquierda lleva la melodía (como en el violonchelo). Toca 'Oda a la Alegría' con la izquierda.",
          steps: [
            %{text: "Mi (E3)", note: 52, hint: "Dedo 3", finger: 3, duration: 1},
            %{text: "Mi (E3)", note: 52, hint: "Dedo 3", finger: 3, duration: 1},
            %{text: "Fa (F3)", note: 53, hint: "Dedo 2", finger: 2, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Dedo 1", finger: 1, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Dedo 1", finger: 1, duration: 1},
            %{text: "Fa (F3)", note: 53, hint: "Dedo 2", finger: 2, duration: 1},
            %{text: "Mi (E3)", note: 52, hint: "Dedo 3", finger: 3, duration: 1},
            %{text: "Re (D3)", note: 50, hint: "Dedo 4", finger: 4, duration: 2}
          ]
        }

      # ==================================================================================
      # FASE 3: COORDINACIÓN (Hands Together)
      # ==================================================================================

      "09_ht_alternating" ->
        %{
          id: "09_ht_alternating",
          title: "9. Coordinación: Pregunta/Respuesta",
          intro:
            "Antes de tocar juntos, aprendamos a pasarnos la pelota. Mano Izquierda pregunta, Mano Derecha responde.",
          steps: [
            %{text: "Do (C3) - Izq", note: 48, hint: "Pregunta (5)", finger: 5, duration: 1},
            %{text: "Mi (E3) - Izq", note: 52, hint: "Pregunta (3)", finger: 3, duration: 1},
            %{text: "Sol (G3) - Izq", note: 55, hint: "Pregunta (1)", finger: 1, duration: 1},
            %{text: "Do (C4) - Der", note: 60, hint: "Respuesta (1)", finger: 1, duration: 1},
            %{text: "Mi (E4) - Der", note: 64, hint: "Respuesta (3)", finger: 3, duration: 1},
            %{text: "Sol (G4) - Der", note: 67, hint: "Respuesta (5)", finger: 5, duration: 2}
          ]
        }

      "10_ht_contrary" ->
        %{
          id: "10_ht_contrary",
          title: "10. Movimiento Contrario",
          intro:
            "Tocar con dos manos es más fácil si se mueven en espejo (alejándose del centro). Ambos pulgares empiezan en Do.",
          steps: [
            %{
              text: "Centro: Do (C4)",
              notes: [60],
              hint: "Pulgares Juntos",
              finger: 1,
              duration: 1
            },
            %{
              text: "Re (D4) / Si (B3)",
              notes: [62, 59],
              hint: "Índices (2)",
              finger: 2,
              duration: 1
            },
            %{
              text: "Mi (E4) / La (A3)",
              notes: [64, 57],
              hint: "Medios (3)",
              finger: 3,
              duration: 1
            },
            %{
              text: "Fa (F4) / Sol (G3)",
              notes: [65, 55],
              hint: "Anulares (4)",
              finger: 4,
              duration: 1
            },
            %{
              text: "Sol (G4) / Fa (F3)",
              notes: [67, 53],
              hint: "Meñiques (5)",
              finger: 5,
              duration: 2
            }
          ]
        }

      "11_ht_parallel" ->
        %{
          id: "11_ht_parallel",
          title: "11. Movimiento Paralelo",
          intro:
            "El gran desafío: Ambas manos suben. La derecha usa dedos 1-2-3-4-5, pero la izquierda usa 5-4-3-2-1. ¡Concéntrate!",
          steps: [
            %{
              text: "Do (C3 + C4)",
              notes: [60, 48],
              hint: "Der: 1 / Izq: 5",
              finger: 1,
              duration: 1
            },
            %{
              text: "Re (D3 + D4)",
              notes: [62, 50],
              hint: "Der: 2 / Izq: 4",
              finger: 2,
              duration: 1
            },
            %{
              text: "Mi (E3 + E4)",
              notes: [64, 52],
              hint: "Der: 3 / Izq: 3",
              finger: 3,
              duration: 1
            },
            %{
              text: "Fa (F3 + F4)",
              notes: [65, 53],
              hint: "Der: 4 / Izq: 2",
              finger: 4,
              duration: 1
            },
            %{
              text: "Sol (G3 + G4)",
              notes: [67, 55],
              hint: "Der: 5 / Izq: 1",
              finger: 5,
              duration: 2
            }
          ]
        }

      # ==================================================================================
      # FASE 4: ARMONÍA Y TÉCNICA
      # ==================================================================================

      "12_triad_c" ->
        %{
          id: "12_triad_c",
          title: "12. Acorde de Do Mayor",
          intro:
            "Un acorde son 3 o más notas. Vamos a tocar las notas del acorde de Do (C Major) una por una (arpegio).",
          steps: [
            %{text: "Raíz: Do (C4)", note: 60, hint: "Dedo 1", finger: 1, duration: 1},
            %{text: "Tercera: Mi (E4)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
            %{text: "Quinta: Sol (G4)", note: 67, hint: "Dedo 5", finger: 5, duration: 1},
            %{text: "Octava: Do (C5)", note: 72, hint: "Estira el 5", finger: 5, duration: 2}
          ]
        }

      "13_triad_g" ->
        %{
          id: "13_triad_g",
          title: "13. Acorde de Sol Mayor",
          intro:
            "Para cambiar de acorde, mantenemos la forma de la mano pero la movemos de posición. Mueve el pulgar al Sol.",
          steps: [
            %{text: "Raíz: Sol (G4)", note: 67, hint: "Dedo 1", finger: 1, duration: 1},
            %{text: "Tercera: Si (B4)", note: 71, hint: "Dedo 3", finger: 3, duration: 1},
            %{text: "Quinta: Re (D5)", note: 74, hint: "Dedo 5", finger: 5, duration: 1},
            %{text: "Raíz: Sol (G4)", note: 67, hint: "Vuelve al 1", finger: 1, duration: 2}
          ]
        }

      "14_broken_chords" ->
        %{
          id: "14_broken_chords",
          title: "14. Acordes Quebrados",
          intro:
            "El 'Bajo Alberti' es un patrón clásico (Do-Sol-Mi-Sol). Practiquémoslo con la mano izquierda.",
          steps: [
            %{text: "Do (C3)", note: 48, hint: "Bajo (5)", finger: 5, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Alto (1)", finger: 1, duration: 1},
            %{text: "Mi (E3)", note: 52, hint: "Medio (3)", finger: 3, duration: 1},
            %{text: "Sol (G3)", note: 55, hint: "Alto (1)", finger: 1, duration: 1},
            %{text: "Do (C3)", note: 48, hint: "Repite patrón", finger: 5, duration: 2}
          ]
        }

      # ==================================================================================
      # NUEVA FASE INTERMEDIA: ODE TO JOY EN PROGRESIÓN
      # ==================================================================================

      "14a_ode_to_joy_simple" ->
        %{
          id: "14a_ode_to_joy_simple",
          title: "14A. Oda a la Alegría: Versión Simple",
          metronome: true,
          intro:
            "La versión simplificada de Ode to Joy usando solo valores largos (redonda, blanca, negra). 16 pasos.",
          steps: [
            # Frase A - Con redonda/blanca/negra
            %{text: "Mi (E4)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Repite", finger: 3, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "Sube", finger: 5, duration: 2},

            # Frase B
            %{text: "Sol (G4)", note: 67, hint: "Repite", finger: 5, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 1},
            %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 2},

            # Frase C
            %{text: "Do (C4)", note: 60, hint: "Bajada", finger: 1, duration: 1},
            %{text: "Re (D4)", note: 62, hint: "Sube", finger: 2, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Sube", finger: 3, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 2},

            # Cadencia
            %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 1.5},
            %{text: "Re (D4)", note: 62, hint: "Más", finger: 2, duration: 0.5},
            %{text: "Re (D4)", note: 62, hint: "Repite", finger: 2, duration: 2},
            %{text: "Do (C4)", note: 60, hint: "Final", finger: 1, duration: 4}
          ]
        }

      "14b_ode_to_joy_intermediate" ->
        %{
          id: "14b_ode_to_joy_intermediate",
          title: "14B. Oda a la Alegría: Versión Intermedia",
          metronome: true,
          intro:
            "Con corcheas incluidas. Ahora la melodía suena más naturalmente con subdivisiones. 24 pasos.",
          steps: [
            # Frase A - Original con algunas corcheas
            %{text: "Mi (E4)", notes: [64], hint: "Dedo 3", fingers: [3], duration: 1},
            %{text: "Mi (E4)", notes: [64], hint: "Repite", fingers: [3], duration: 1},
            %{text: "Fa-Sol", notes: [65, 67], hint: "2 corcheas", fingers: [4, 5], duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "Negra", finger: 5, duration: 1},

            # Frase B
            %{text: "Sol (G4)", note: 67, hint: "Negra", finger: 5, duration: 1},
            %{text: "Fa-Mi", notes: [65, 64], hint: "2 corcheas", fingers: [4, 3], duration: 1},
            %{text: "Re (D4)", note: 62, hint: "Negra", finger: 2, duration: 1},
            %{text: "Do (C4)", note: 60, hint: "Negra", finger: 1, duration: 1},

            # Frase C
            %{
              text: "Do-Re-Mi",
              notes: [60, 62, 64],
              hint: "3 notas rápidas",
              fingers: [1, 2, 3],
              duration: 1
            },
            %{text: "Fa (F4)", note: 65, hint: "Negra", finger: 4, duration: 1},
            %{text: "Mi-Fa", notes: [64, 65], hint: "2 corcheas", fingers: [3, 4], duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "Negra", finger: 5, duration: 1},

            # Más detalles
            %{
              text: "Fa-Mi-Re",
              notes: [65, 64, 62],
              hint: "3 notas",
              fingers: [4, 3, 2],
              duration: 1
            },
            %{text: "Do (C4)", note: 60, hint: "Negra", finger: 1, duration: 1},

            # Variación
            %{
              text: "Re-Mi-Fa-Sol",
              notes: [62, 64, 65, 67],
              hint: "4 semicorcheas",
              fingers: [2, 3, 4, 5],
              duration: 1
            },
            %{text: "Sol (G4)", note: 67, hint: "Negra", finger: 5, duration: 1},

            # Cadencia más larga
            %{text: "Fa (F4)", note: 65, hint: "Negra", finger: 4, duration: 1},
            %{text: "Mi-Re", notes: [64, 62], hint: "2 corcheas", fingers: [3, 2], duration: 1},
            %{text: "Do (C4)", note: 60, hint: "Negra", finger: 1, duration: 1},
            %{text: "Do (C4)", note: 60, hint: "Blanca", finger: 1, duration: 2},
            %{text: "Do (C4)", note: 60, hint: "Blanca", finger: 1, duration: 2},
            %{text: "Do (C4)", note: 60, hint: "Final largo", finger: 1, duration: 4}
          ]
        }

      "14c_ode_to_joy_advanced" ->
        %{
          id: "14c_ode_to_joy_advanced",
          title: "14C. Oda a la Alegría: Versión Avanzada",
          metronome: true,
          intro:
            "Versión completa con semicorcheas y variaciones. La versión más cercana a la partitura original. 36 pasos.",
          steps: [
            # Frase A - Versión decorada
            %{text: "Mi (E4)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
            %{text: "Mi (E4)", note: 64, hint: "Repite", finger: 3, duration: 1},
            %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 0.5},
            %{text: "Sol (G4)", note: 67, hint: "Sube", finger: 5, duration: 0.5},
            %{text: "Sol (G4)", note: 67, hint: "Largo", finger: 5, duration: 1},

            # Más detalles Frase A
            %{text: "Sol (G4)", note: 67, hint: "Repite", finger: 5, duration: 0.5},
            %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 0.5},
            %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 0.5},
            %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 0.5},
            %{text: "Do (C4)", note: 60, hint: "Llegada", finger: 1, duration: 1},

            # Frase B expandida
            %{text: "Do (C4)", note: 60, hint: "Base", finger: 1, duration: 0.5},
            %{text: "Re (D4)", note: 62, hint: "Paso", finger: 2, duration: 0.5},
            %{text: "Mi (E4)", note: 64, hint: "Sube", finger: 3, duration: 0.5},
            %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 0.5},
            %{text: "Sol (G4)", note: 67, hint: "Pico", finger: 5, duration: 1},

            # Retorno
            %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 0.5},
            %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 0.5},
            %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 0.5},
            %{text: "Do (C4)", note: 60, hint: "Tónica", finger: 1, duration: 0.5},
            %{text: "Do (C4)", note: 60, hint: "Repite", finger: 1, duration: 1},

            # Variación - Con saltos
            %{text: "Mi (E4)", note: 64, hint: "Salto", finger: 3, duration: 0.5},
            %{text: "Fa (F4)", note: 65, hint: "Paso", finger: 4, duration: 0.5},
            %{text: "Sol (G4)", note: 67, hint: "Salto", finger: 5, duration: 1},

            # Retorno a tónica
            %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 0.5},
            %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 0.5},
            %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 0.5},
            %{text: "Do (C4)", note: 60, hint: "Casa", finger: 1, duration: 0.5},

            # Cadencia final larga
            %{
              text: "Do-Re-Mi-Fa",
              notes: [60, 62, 64, 65],
              hint: "Escala rápida (4 semicor)",
              fingers: [1, 2, 3, 4],
              duration: 1
            },
            %{text: "Sol (G4)", note: 67, hint: "Pico", finger: 5, duration: 1},
            %{text: "Sol (G4)", note: 67, hint: "Sostenido", finger: 5, duration: 1},
            %{text: "Fa-Mi", notes: [65, 64], hint: "2 corcheas", fingers: [4, 3], duration: 1},
            %{text: "Re (D4)", note: 62, hint: "Nota larga", finger: 2, duration: 2},
            %{text: "Do (C4)", note: 60, hint: "Resolución", finger: 1, duration: 2},
            %{text: "Do (C4)", note: 60, hint: "Final", finger: 1, duration: 4}
          ]
        }

      # ==================================================================================
      # FASE 5: REPERTORIO FINAL
      # ==================================================================================

      "15_final_performance" ->
        %{
          id: "15_final_performance",
          title: "15. RECITAL: Oda a la Alegría Completa",
          metronome: true,
          intro:
            "¡EL GRAN FINAL! La versión COMPLETA de Ode to Joy con ambas manos y todo el acompañamiento. 38 pasos de música clásica. ¡Lo lograste!",
          steps: [
            # ==================== FRASE A ====================
            # A1: Presentación (Melodía + Bajo)
            %{
              text: "Mi (E4) + Do (C3)",
              notes: [64, 48],
              hint: "Dedo 3 + Bajo",
              fingers: [3, 5],
              duration: 1
            },
            %{text: "Mi (E4)", notes: [64], hint: "Repite", fingers: [3], duration: 0.5},
            %{
              text: "Fa-Sol",
              notes: [65, 67],
              hint: "Corcheas subiendo",
              fingers: [4, 5],
              duration: 1
            },
            %{text: "Sol (G4)", notes: [67], hint: "Pico", fingers: [5], duration: 1},

            # A2: Dominante (Sol Mayor)
            %{
              text: "Sol (G4) + Sol (G3)",
              notes: [67, 55],
              hint: "Bajo distinto",
              fingers: [5, 1],
              duration: 1
            },
            %{text: "Fa (F4)", notes: [65], hint: "Baja", fingers: [4], duration: 0.5},
            %{
              text: "Mi-Re",
              notes: [64, 62],
              hint: "Corcheas bajando",
              fingers: [3, 2],
              duration: 1
            },
            %{text: "Do (C4)", notes: [60], hint: "Resolución", fingers: [1], duration: 1},

            # ==================== FRASE B ====================
            # B1: Repetición en Do
            %{
              text: "Do (C4) + Do (C3)",
              notes: [60, 48],
              hint: "Vuelve a Do",
              fingers: [1, 5],
              duration: 1
            },
            %{text: "Do (C4)", notes: [60], hint: "Repite", fingers: [1], duration: 0.5},
            %{text: "Re-Mi", notes: [62, 64], hint: "Corcheas", fingers: [2, 3], duration: 1},
            %{text: "Mi (E4)", notes: [64], hint: "Mantén", fingers: [3], duration: 1},

            # B2: Variación ascendente
            %{text: "Fa (F4)", notes: [65], hint: "Sube", fingers: [4], duration: 0.5},
            %{text: "Sol-La", notes: [67, 69], hint: "Corcheas", fingers: [5, 5], duration: 1},
            %{text: "Sol (G4)", notes: [67], hint: "Vuelve", fingers: [5], duration: 1},
            %{text: "Fa (F4)", notes: [65], hint: "Baja", fingers: [4], duration: 0.5},

            # ==================== FRASE C (Repetición) ====================
            # C1: Regresa a la presentación
            %{
              text: "Mi (E4) + Do (C3)",
              notes: [64, 48],
              hint: "De nuevo la melodía",
              fingers: [3, 5],
              duration: 1
            },
            %{text: "Mi-Fa", notes: [64, 65], hint: "Corcheas", fingers: [3, 4], duration: 1},
            %{text: "Sol (G4)", notes: [67], hint: "Sube", fingers: [5], duration: 1},
            %{text: "Sol (G4)", notes: [67], hint: "Mantén", fingers: [5], duration: 0.5},

            # C2: Verso en Dominante
            %{
              text: "Fa-Mi-Re-Do",
              notes: [65, 64, 62, 60],
              hint: "Escala bajando",
              fingers: [4, 3, 2, 1],
              duration: 2
            },

            # ==================== CADENCIA FINAL ====================
            # Largo con anticipación
            %{
              text: "Do-Re-Mi-Fa",
              notes: [60, 62, 64, 65],
              hint: "Cuatro semicorcheas",
              fingers: [1, 2, 3, 4],
              duration: 1
            },
            %{text: "Sol (G4)", notes: [67], hint: "Pico final", fingers: [5], duration: 1},

            # Dominante + Bajo (V7 chord implication)
            %{
              text: "Sol (G4) + Sol (G3)",
              notes: [67, 55],
              hint: "Largo con tensión",
              fingers: [5, 1],
              duration: 1.5
            },

            # Retardo y resolución
            %{text: "Fa (F4)", notes: [65], hint: "Baja brevemente", fingers: [4], duration: 0.5},
            %{
              text: "Mi (E4) + Sol (G3)",
              notes: [64, 55],
              hint: "Penúltima nota",
              fingers: [3, 1],
              duration: 1
            },

            # ==================== RESOLUCIÓN FINAL ====================
            %{
              text: "Re (D4)",
              notes: [62],
              hint: "Última nota antes del final",
              fingers: [2],
              duration: 0.5
            },
            %{
              text: "Do (C4) + Do (C3)",
              notes: [60, 48],
              hint: "¡RESOLUCIÓN! Tónica",
              fingers: [1, 5],
              duration: 2
            },

            # Reafirmación de la tónica
            %{
              text: "Do (C4)",
              notes: [60],
              hint: "Eco final en mano derecha",
              fingers: [1],
              duration: 1
            },
            %{text: "Do (C4)", notes: [60], hint: "Nota final", fingers: [1], duration: 4}
          ]
        }

      # ==================================================================================
      # FASE 6: TÉCNICA DE ESCALA (El Cruce)
      # ==================================================================================

      "16_rh_thumb_under" ->
        %{
          id: "16_rh_thumb_under",
          title: "16. MD: El Cruce de Pulgar",
          intro:
            "Para tocar más de 5 notas, necesitamos 'cruzar'. Toca Do-Re-Mi (1-2-3) y luego pasa el Pulgar (1) POR DEBAJO del dedo 3 para llegar a Fa.",
          steps: [
            %{text: "Do (C4)", notes: [60], hint: "Dedo 1", fingers: [1], duration: 1},
            %{text: "Re (D4)", notes: [62], hint: "Dedo 2", fingers: [2], duration: 1},
            %{
              text: "Mi (E4)",
              notes: [64],
              hint: "Dedo 3 (¡Prepara el cruce!)",
              fingers: [3],
              duration: 1
            },
            %{
              text: "Fa (F4)",
              notes: [65],
              hint: "¡PULGAR (1) por debajo!",
              fingers: [1],
              duration: 1
            },
            %{text: "Sol (G4)", notes: [67], hint: "Dedo 2", fingers: [2], duration: 1},
            %{text: "Fa (F4)", notes: [65], hint: "Dedo 1", fingers: [1], duration: 1},
            %{text: "Mi (E4)", notes: [64], hint: "Dedo 3 por encima", fingers: [3], duration: 1},
            %{text: "Re (D4)", notes: [62], hint: "Dedo 2", fingers: [2], duration: 1},
            %{text: "Do (C4)", notes: [60], hint: "Dedo 1", fingers: [1], duration: 2}
          ]
        }

      "17_rh_c_scale" ->
        %{
          id: "17_rh_c_scale",
          title: "17. MD: Escala de Do Mayor",
          metronome: true,
          intro:
            "Completemos la octava. Mantén un pulso constante, como un reloj: Tic, Tac, Tic, Tac. ¡Intenta que suene fluido!",
          steps: [
            %{text: "Do (C4)", notes: [60], hint: "1 (Un tiempo)", fingers: [1], duration: 1},
            %{text: "Re (D4)", notes: [62], hint: "2 (Un tiempo)", fingers: [2], duration: 1},
            %{text: "Mi (E4)", notes: [64], hint: "3 (Cruce)", fingers: [3], duration: 1},
            %{text: "Fa (F4)", notes: [65], hint: "1 (Un tiempo)", fingers: [1], duration: 1},
            %{text: "Sol (G4)", notes: [67], hint: "2 (Un tiempo)", fingers: [2], duration: 1},
            %{text: "La (A4)", notes: [69], hint: "3 (Un tiempo)", fingers: [3], duration: 1},
            %{text: "Si (B4)", notes: [71], hint: "4 (Un tiempo)", fingers: [4], duration: 1},
            %{text: "Do (C5)", notes: [72], hint: "5 (Un tiempo)", fingers: [5], duration: 1}
          ]
        }

      "18_lh_finger_over" ->
        %{
          id: "18_lh_finger_over",
          title: "18. MI: El Cruce de Dedo",
          intro:
            "En la mano izquierda, el cruce ocurre al bajar. Toca Do-Si-La (1-2-3) y pasa el Pulgar (1) por debajo para Sol? ¡NO! La izquierda cruza el 3 POR ENCIMA del 1.",
          steps: [
            %{
              text: "Do (C4) - Central",
              notes: [60],
              hint: "Pulgar (1)",
              fingers: [1],
              duration: 1
            },
            %{text: "Si (B3)", notes: [59], hint: "Índice (2)", fingers: [2], duration: 1},
            %{text: "La (A3)", notes: [57], hint: "Medio (3)", fingers: [3], duration: 1},
            %{
              text: "Sol (G3)",
              notes: [55],
              hint: "¡PULGAR (1) por debajo!",
              fingers: [1],
              duration: 1
            },
            %{text: "Fa (F3)", notes: [53], hint: "Dedo 2", fingers: [2], duration: 1},
            %{text: "Mi (E3)", notes: [52], hint: "Dedo 3", fingers: [3], duration: 1},
            %{text: "Re (D3)", notes: [50], hint: "Dedo 4", fingers: [4], duration: 1},
            %{text: "Do (C3)", notes: [48], hint: "Dedo 5", fingers: [5], duration: 1}
          ]
        }

      "19_lh_c_scale" ->
        %{
          id: "19_lh_c_scale",
          title: "19. MI: Escala de Do Mayor",
          metronome: true,
          intro:
            "Escala completa izquierda. Sigue el ritmo constante. Subiendo: 5-4-3-2-1 (cruce 3) 3-2-1.",
          steps: [
            %{text: "Do (C3)", notes: [48], hint: "5 (Un tiempo)", fingers: [5], duration: 1},
            %{text: "Re (D3)", notes: [50], hint: "4 (Un tiempo)", fingers: [4], duration: 1},
            %{text: "Mi (E3)", notes: [52], hint: "3 (Un tiempo)", fingers: [3], duration: 1},
            %{text: "Fa (F3)", notes: [53], hint: "2 (Un tiempo)", fingers: [2], duration: 1},
            %{text: "Sol (G3)", notes: [55], hint: "1 (Cruce 3)", fingers: [1], duration: 1},
            %{text: "La (A3)", notes: [57], hint: "3 (Un tiempo)", fingers: [3], duration: 1},
            %{text: "Si (B3)", notes: [59], hint: "2 (Un tiempo)", fingers: [2], duration: 1},
            %{text: "Do (C4)", notes: [60], hint: "1 (Un tiempo)", fingers: [1], duration: 1}
          ]
        }

      # ==================================================================================
      # FASE 7: NUEVA TONALIDAD (Sol Mayor)
      # ==================================================================================

      "20_g_position" ->
        %{
          id: "20_g_position",
          title: "20. Posición de Sol (G Major)",
          intro:
            "Mueve tu mano derecha. Ahora el Pulgar (1) va en Sol (G4). Tus 5 dedos cubrirán: Sol, La, Si, Do, Re.",
          steps: [
            %{text: "Sol (G4)", notes: [67], hint: "Pulgar (1)", fingers: [1], duration: 1},
            %{text: "La (A4)", notes: [69], hint: "Índice (2)", fingers: [2], duration: 1},
            %{text: "Si (B4)", notes: [71], hint: "Medio (3)", fingers: [3], duration: 1},
            %{text: "Do (C5)", notes: [72], hint: "Anular (4)", fingers: [4], duration: 1},
            %{text: "Re (D5)", notes: [74], hint: "Meñique (5)", fingers: [5], duration: 1},
            %{text: "Sol (G4)", notes: [67], hint: "Vuelve a casa", fingers: [1], duration: 1}
          ]
        }

      "21_f_sharp" ->
        %{
          id: "21_f_sharp",
          title: "21. Fa Sostenido (F#)",
          intro:
            "En Sol Mayor, todos los Fa son Sostenidos (Tecla Negra). Está justo a la derecha del Fa natural. Tócalo con el anular (4) si estás en posición Re, o ajusta.",
          steps: [
            %{text: "Sol (G4)", notes: [67], hint: "1", fingers: [1], duration: 1},
            %{text: "La (A4)", notes: [69], hint: "2", fingers: [2], duration: 1},
            %{text: "Si (B4)", notes: [71], hint: "3", fingers: [3], duration: 1},
            %{text: "Do (C5)", notes: [72], hint: "1 (Cruce)", fingers: [1], duration: 1},
            %{text: "Re (D5)", notes: [74], hint: "2", fingers: [2], duration: 1},
            %{text: "Mi (E5)", notes: [76], hint: "3", fingers: [3], duration: 1},
            %{text: "Fa# (F#5)", notes: [78], hint: "4 (TECLA NEGRA)", fingers: [4], duration: 1},
            %{text: "Sol (G5)", notes: [79], hint: "5", fingers: [5], duration: 1}
          ]
        }

      "22_g_scale" ->
        %{
          id: "22_g_scale",
          title: "22. Escala de Sol Mayor",
          metronome: true,
          intro: "La escala completa de Sol tiene un Fa#. Recuerda: G A B C D E F# G.",
          steps: [
            %{text: "Sol (G4)", notes: [67], hint: "1", fingers: [1], duration: 1},
            %{text: "La (A4)", notes: [69], hint: "2", fingers: [2], duration: 1},
            %{text: "Si (B4)", notes: [71], hint: "3 (Cruce)", fingers: [3], duration: 1},
            %{text: "Do (C5)", notes: [72], hint: "1", fingers: [1], duration: 1},
            %{text: "Re (D5)", notes: [74], hint: "2", fingers: [2], duration: 1},
            %{text: "Mi (E5)", notes: [76], hint: "3", fingers: [3], duration: 1},
            %{text: "Fa# (F#5)", notes: [78], hint: "4 (Negra)", fingers: [4], duration: 1},
            %{text: "Sol (G5)", notes: [79], hint: "5", fingers: [5], duration: 1}
          ]
        }

      "23_g_piece" ->
        %{
          id: "23_g_piece",
          title: "23. Pieza en Sol: Minueto",
          metronome: true,
          intro:
            "Un fragmento del famoso Minueto en Sol de Bach. Fíjate en el ritmo: TA, TA, TA, TA-AA (Negra, Negra, Negra, Blanca).",
          steps: [
            %{text: "Re (D5)", notes: [74], hint: "Negra (TA)", fingers: [5], duration: 1},
            %{text: "Sol (G4)", notes: [67], hint: "Negra (TA)", fingers: [1], duration: 1},
            %{text: "La (A4)", notes: [69], hint: "Negra (TA)", fingers: [2], duration: 1},
            %{text: "Si (B4)", notes: [71], hint: "Negra (TA)", fingers: [3], duration: 1},
            %{text: "Do (C5)", notes: [72], hint: "Negra (TA)", fingers: [4], duration: 1},
            %{text: "Re (D5)", notes: [74], hint: "Blanca (TA-AA)", fingers: [5], duration: 2},
            %{text: "Sol (G4)", notes: [67], hint: "Blanca (TA-AA)", fingers: [1], duration: 2},
            %{text: "Sol (G4)", notes: [67], hint: "Blanca (TA-AA)", fingers: [1], duration: 2}
          ]
        }

      _ ->
        nil
    end
  end
end
