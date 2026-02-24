import { Renderer, Stave, StaveNote, Accidental, Voice, Formatter, StaveConnector, BarNote } from "vexflow";

const MusicStaff = {
  mounted() {
    this.div = this.el;
    this.tooltipInitialized = false;
    
    // Store highlighted notes (Set of MIDI numbers — transient, playback)
    this.highlightedMidis = new Set();
    // Store held notes from piano (Set of MIDI numbers — sustained until note_off)
    this.heldMidis = new Set();
    
    // Store explanations data
    this.explanations = {};
    try {
      const explanationsJSON = this.el.dataset.explanations;
      if (explanationsJSON) {
        const expl = JSON.parse(explanationsJSON);
        expl.forEach(e => {
          this.explanations[e.name] = e;
        });
        console.log("✓ Loaded explanations:", Object.keys(this.explanations));
      }
    } catch (e) {
      console.warn("Could not parse explanations:", e);
    }
    
    // Listen for play_note event from server
    this.handleEvent("play_note", ({ midi }) => {
      this.highlightNote(midi);
    });

    // Listen for held notes from piano (sustained until note_off)
    this.handleEvent("highlight_held_notes", ({ midi_list }) => {
      this.heldMidis = new Set(midi_list);
      this.draw();
    });

    // Listen for local MIDI events (Optimistic UI)
    window.addEventListener("local-midi-note", (e) => {
      const { midi } = e.detail;
      this.highlightNote(midi);
    });

    this.resizeObserver = new ResizeObserver(() => this.draw());
    this.resizeObserver.observe(this.div);

    this.draw();
  },

  updated() {
    // Reset tooltip state when updated (e.g., tonality change)
    // IMPORTANT: Hide tooltip FIRST before resetting state
    this.hideTooltip();
    
    this.tooltipInitialized = false;
    this.overlay = null;
    
    // Reload explanations from dataset
    this.explanations = {};
    try {
      const explanationsJSON = this.el.dataset.explanations;
      if (explanationsJSON) {
        const expl = JSON.parse(explanationsJSON);
        expl.forEach(e => {
          this.explanations[e.name] = e;
        });
        console.log("✓ Reloaded explanations for tonality change:", Object.keys(this.explanations).length);
      }
    } catch (e) {
      console.warn("Could not parse explanations on update:", e);
    }
    
    this.draw();
  },

  destroyed() {
    if (this.resizeObserver) this.resizeObserver.disconnect();
    this.cleanupOverlay();
  },
  
  cleanupOverlay() {
    // Remove old event listeners before removing overlay
    if (this.overlay && this.overlayMouseMoveHandler) {
      this.overlay.removeEventListener("mousemove", this.overlayMouseMoveHandler);
      this.overlay.removeEventListener("mouseout", this.overlayMouseOutHandler);
      this.overlay.removeEventListener("mouseleave", this.overlayMouseLeaveHandler);
    }
    
    // Hide tooltip
    this.hideTooltip();
    
    // Clear overlay reference
    this.overlay = null;
    this.overlayMouseMoveHandler = null;
    this.overlayMouseOutHandler = null;
    this.overlayMouseLeaveHandler = null;
  },
  
  highlightNote(midi) {
    // Cancelar el timer anterior para evitar que notas viejas queden iluminadas
    if (this.highlightTimeout) clearTimeout(this.highlightTimeout);

    // Solo iluminar la nota actual
    this.highlightedMidis.clear();
    this.highlightedMidis.add(midi);
    this.draw();

    this.highlightTimeout = setTimeout(() => {
      this.highlightedMidis.delete(midi);
      this.draw();
    }, 500);
  },

  draw() {
    // Clean up old overlay listeners before clearing HTML
    this.cleanupOverlay();
    
    this.div.innerHTML = "";
    
    // Get parent dimensions or use clientWidth
    const width = this.div.clientWidth;
    // Grand staff: treble + bass + margins
    const GRAND_STAFF_HEIGHT = 280;
    const containerHeight = this.div.clientHeight || 0;
    const height = Math.max(containerHeight, GRAND_STAFF_HEIGHT);

    if (width === 0) return;

    const renderer = new Renderer(this.div, Renderer.Backends.SVG);
    renderer.resize(width, height);
    const context = renderer.getContext();

    // Allow SVG to overflow if container is smaller than needed
    const svg = this.div.querySelector("svg");
    if (svg) {
      svg.style.overflow = "visible";
      svg.style.minHeight = GRAND_STAFF_HEIGHT + "px";
    }

    const notesData = JSON.parse(this.el.dataset.notes || "[]");
    const keySignature = this.el.dataset.key || "C";
    const currentStepIndex = parseInt(this.el.dataset.stepIndex || "0");
    const isLesson = this.el.dataset.isLesson === "true";
    const timeSignature = this.el.dataset.timeSignature || "4/4";
    const [timeSigNum, timeSigDen] = timeSignature.split("/").map(Number);
    // beatsPerBar expresado en negras (quarter notes), que es la unidad interna de duración
    const beatsPerBar = timeSigNum * (4 / timeSigDen);

    // Layout constants
    const TREBLE_Y = 40;
    const BASS_Y = 150;
    const STAFF_LEFT = 10;
    const STAFF_WIDTH = width - 20;

    // 1. Create Staves (Grand Staff)
    // Treble
    const staveTreble = new Stave(STAFF_LEFT, TREBLE_Y, STAFF_WIDTH);
    staveTreble.addClef("treble");
    staveTreble.addTimeSignature(timeSignature);
    if (keySignature) staveTreble.addKeySignature(keySignature);
    staveTreble.setContext(context).draw();

    // Bass
    const staveBass = new Stave(STAFF_LEFT, BASS_Y, STAFF_WIDTH);
    staveBass.addClef("bass");
    staveBass.addTimeSignature(timeSignature);
    if (keySignature) staveBass.addKeySignature(keySignature);
    staveBass.setContext(context).draw();

    // Connector (Brace + Lines)
    new StaveConnector(staveTreble, staveBass).setType(StaveConnector.type.BRACE).setContext(context).draw();
    new StaveConnector(staveTreble, staveBass).setType(StaveConnector.type.SINGLE_LEFT).setContext(context).draw();
    new StaveConnector(staveTreble, staveBass).setType(StaveConnector.type.SINGLE_RIGHT).setContext(context).draw();

    if (notesData.length === 0) return;

    // 2. Create Notes and Rests for both voices to ensure alignment
    const trebleTickables = [];
    const bassTickables = [];

    // Track beats to insert bar lines (beatsPerBar ya calculado arriba desde timeSignature)
    let currentBeat = 0;

    // Helper: duración en beats
    const durationBeats = { "w": 4, "h": 2, "q": 1, "8": 0.5 };

    // Helper: rellena beats restantes con silencios invisibles para completar el compás
    const fillWithRests = (beats) => {
        const map = [[4, "w"], [2, "h"], [1, "q"], [0.5, "8"]];
        let remaining = beats;
        for (const [b, d] of map) {
            while (remaining >= b) {
                const tr = new StaveNote({ keys: ["b/4"], duration: d, type: "r" });
                tr.setStyle({ fillStyle: "transparent", strokeStyle: "transparent" });
                trebleTickables.push(tr);
                const br = new StaveNote({ keys: ["d/3"], duration: d, type: "r" });
                br.setStyle({ fillStyle: "transparent", strokeStyle: "transparent" });
                bassTickables.push(br);
                remaining -= b;
            }
        }
    };

    // Colores por grado (Do=0, Re=1, Mi=2, Fa=3, Sol=4, La=5, Si=6, Do=7)
    // Coinciden con los colores de la barra de solfeo en SolfegeBar
    const DEGREE_COLORS = [
      '#f43f5e', // Do  - rose
      '#f97316', // Re  - orange
      '#f59e0b', // Mi  - amber
      '#84cc16', // Fa  - lime
      '#14b8a6', // Sol - teal
      '#3b82f6', // La  - blue
      '#8b5cf6', // Si  - violet
      '#f43f5e', // Do  - rose (octava)
    ];

    notesData.forEach((step, index) => {
        const duration = step.duration || "q";
        const noteBeats = durationBeats[duration] || 1;

        // Si la nota no cabe en el compás actual, rellenar y cerrar compás antes de añadirla
        const beatsRemaining = beatsPerBar - currentBeat;
        if (noteBeats > beatsRemaining && currentBeat > 0) {
            fillWithRests(beatsRemaining);
            trebleTickables.push(new BarNote());
            bassTickables.push(new BarNote());
            currentBeat = 0;
        }

        // Separate notes by clef
        const trebleNotes = step.notes.filter(n => n.clef === "treble");
        const bassNotes = step.notes.filter(n => n.clef === "bass");

        // Color por grado en modo explorador (mismo color que la barra de solfeo)
        const degreeColor = DEGREE_COLORS[index % DEGREE_COLORS.length];

        // --- TREBLE VOICE ---
        if (trebleNotes.length > 0) {
            const keys = trebleNotes.map(n => n.key);
            const note = new StaveNote({
                clef: "treble",
                keys: keys,
                duration: duration,
                auto_stem: true
            });

            // Add accidentals
            trebleNotes.forEach((n, i) => {
                if (n.accidental) note.addModifier(new Accidental(n.accidental), i);
            });

            const isCurrentStep = isLesson && (index === currentStepIndex);
            const isPlaying = trebleNotes.some(n => this.highlightedMidis.has(n.midi));
            const isHeld = !isLesson && trebleNotes.some(n => this.heldMidis.has(n.midi));

            if (isCurrentStep && isPlaying) {
                // Nota correcta durante lección - verde
                note.setStyle({fillStyle: "#16a34a", strokeStyle: "#16a34a"});
            } else if (isCurrentStep) {
                // Nota objetivo durante lección - azul
                note.setStyle({fillStyle: "#2563eb", strokeStyle: "#2563eb"});
            } else if (isHeld) {
                // Nota mantenida en explorador - ámbar
                note.setStyle({fillStyle: "#f59e0b", strokeStyle: "#f59e0b"});
            } else if (isPlaying) {
                // Nota tocada (lección o explorador) - púrpura
                note.setStyle({fillStyle: "#9333ea", strokeStyle: "#9333ea"});
            } else if (!isLesson) {
                // Explorador: colorear por grado (Do-Re-Mi)
                note.setStyle({fillStyle: degreeColor, strokeStyle: degreeColor});
            }
            trebleTickables.push(note);
        } else {
            // Invisible Rest
            const rest = new StaveNote({ keys: ["b/4"], duration: duration, type: "r" });
            rest.setStyle({fillStyle: "transparent", strokeStyle: "transparent"});
            trebleTickables.push(rest);
        }

        // --- BASS VOICE ---
        if (bassNotes.length > 0) {
            const keys = bassNotes.map(n => n.key);
            const note = new StaveNote({
                clef: "bass",
                keys: keys,
                duration: duration,
                auto_stem: true
            });

            // Add accidentals
            bassNotes.forEach((n, i) => {
                if (n.accidental) note.addModifier(new Accidental(n.accidental), i);
            });

            const isCurrentStep = isLesson && (index === currentStepIndex);
            const isPlaying = bassNotes.some(n => this.highlightedMidis.has(n.midi));
            const isHeld = !isLesson && bassNotes.some(n => this.heldMidis.has(n.midi));

            if (isCurrentStep && isPlaying) {
                note.setStyle({fillStyle: "#16a34a", strokeStyle: "#16a34a"});
            } else if (isCurrentStep) {
                note.setStyle({fillStyle: "#2563eb", strokeStyle: "#2563eb"});
            } else if (isHeld) {
                // Nota mantenida en explorador - ámbar
                note.setStyle({fillStyle: "#f59e0b", strokeStyle: "#f59e0b"});
            } else if (isPlaying) {
                note.setStyle({fillStyle: "#9333ea", strokeStyle: "#9333ea"});
            } else if (!isLesson) {
                // Explorador: colorear por grado (Do-Re-Mi)
                note.setStyle({fillStyle: degreeColor, strokeStyle: degreeColor});
            }
            bassTickables.push(note);
        } else {
            // Invisible Rest
            const rest = new StaveNote({ keys: ["d/3"], duration: duration, type: "r" });
            rest.setStyle({fillStyle: "transparent", strokeStyle: "transparent"});
            bassTickables.push(rest);
        }
        
        // Actualizar contador y cerrar compás si está completo
        currentBeat += noteBeats;

        if (currentBeat >= beatsPerBar) {
            trebleTickables.push(new BarNote());
            bassTickables.push(new BarNote());
            currentBeat = 0;
        }
    });

    // Rellenar el último compás incompleto con silencios invisibles
    if (currentBeat > 0 && currentBeat < beatsPerBar) {
        fillWithRests(beatsPerBar - currentBeat);
    }

    // 3. Create Voices
    // Calculate total beats for the voice based on tickables
    // VexFlow auto-calculates if we don't specify num_beats, or we can set it high.
    // Actually, creating a voice with explicit num_beats might be restrictive if we have bar lines.
    // Let's try flexible voice.
    
    const voiceTreble = new Voice({ num_beats: 400, beat_value: 4 }); // Arbitrary high number
    voiceTreble.setStrict(false);
    voiceTreble.addTickables(trebleTickables);

    const voiceBass = new Voice({ num_beats: 400, beat_value: 4 });
    voiceBass.setStrict(false);
    voiceBass.addTickables(bassTickables);

    // 4. Format and Draw
    // Calculate available width for the music
    const availableWidth = width - 50;
    
    new Formatter()
        .joinVoices([voiceTreble, voiceBass])
        .format([voiceTreble, voiceBass], availableWidth);

    voiceTreble.draw(context, staveTreble);
    voiceBass.draw(context, staveBass);

    // 5. Draw Cursor (indicator at current note) - only during lessons
    if (isLesson && notesData.length > 0 && currentStepIndex < notesData.length) {
        // Map currentStepIndex to tickables index (accounting for BarNotes)
        let tickableIndex = 0;
        let beatSum = 0;
        
        for (let i = 0; i < notesData.length; i++) {
            if (i === currentStepIndex) break;
            
            const step = notesData[i];
            const dur = step.duration || "q";
            let beats = 1;
            if (dur === "w") beats = 4;
            if (dur === "h") beats = 2;
            if (dur === "q") beats = 1;
            if (dur === "8") beats = 0.5;
            
            tickableIndex++; // The note itself
            
            beatSum += beats;
            if (beatSum >= beatsPerBar) {
                tickableIndex++; // The bar line
                beatSum = 0;
            }
        }
        
        const targetNote = trebleTickables[tickableIndex];

        if (targetNote && targetNote.getAbsoluteX) {
            const noteX = targetNote.getAbsoluteX();
            
            // Draw subtle vertical line
            context.beginPath();
            context.moveTo(noteX, TREBLE_Y);
            context.lineTo(noteX, BASS_Y + 80);
            context.lineWidth = 2;
            context.strokeStyle = "rgba(37, 99, 235, 0.5)"; // Blue with 50% opacity
            context.stroke();
            
            // Draw small triangle at top pointing down
            context.beginPath();
            context.moveTo(noteX - 6, TREBLE_Y - 12);
            context.lineTo(noteX + 6, TREBLE_Y - 12);
            context.lineTo(noteX, TREBLE_Y - 2);
            context.closePath();
            context.fillStyle = "#2563eb"; // Blue-600
            context.fill();
        }
     }
     
     // Initialize tooltip AFTER SVG is rendered
     setTimeout(() => {
       if (!this.tooltipInitialized) {
         console.log("Initializing tooltip now");
         this.initTooltip();
         this.tooltipInitialized = true;
       }
     }, 100);
   },

   initTooltip() {
     // Create tooltip element
     if (!this.tooltip) {
       this.tooltip = document.createElement("div");
       this.tooltip.className = "staff-tooltip";
       this.tooltip.style.cssText = `
         position: fixed;
         background: rgba(15, 23, 42, 0.95);
         color: #f1f5f9;
         padding: 12px 16px;
         border-radius: 8px;
         font-size: 12px;
         line-height: 1.5;
         max-width: 320px;
         z-index: 9999;
         pointer-events: none;
         opacity: 0;
         transition: opacity 0.2s ease;
         border-left: 3px solid #8b5cf6;
         box-shadow: 0 10px 25px rgba(0,0,0,0.2);
       `;
       document.body.appendChild(this.tooltip);
     }
     
     // Create invisible overlay over staff for mouse tracking
     if (!this.overlay) {
       this.overlay = document.createElement("div");
       this.overlay.style.cssText = `
         position: absolute;
         top: 0;
         left: 0;
         right: 0;
         bottom: 0;
         z-index: 1000;
         pointer-events: auto;
         cursor: pointer;
       `;
       
       const svg = this.div.querySelector("svg");
       if (svg && svg.parentElement) {
         // Insert overlay after SVG
         svg.parentElement.style.position = "relative";
         svg.parentElement.appendChild(this.overlay);
         
         // Store bound handlers so we can remove them later
         this.overlayMouseMoveHandler = (e) => this.handleOverlayMouseMove(e);
         this.overlayMouseOutHandler = () => this.hideTooltip();
         this.overlayMouseLeaveHandler = () => this.hideTooltip();
         
         this.overlay.addEventListener("mousemove", this.overlayMouseMoveHandler);
         this.overlay.addEventListener("mouseout", this.overlayMouseOutHandler);
         this.overlay.addEventListener("mouseleave", this.overlayMouseLeaveHandler);
       }
     }
   },

  handleOverlayMouseMove(e) {
    const explanationsArray = Object.values(this.explanations);
    const notesData = JSON.parse(this.el.dataset.notes || "[]");
    
    // Simple approach: divide the overlay width into sections for each note
    const overlay = this.overlay;
    if (!overlay) return;
    
    const overlayRect = overlay.getBoundingClientRect();
    
    // Relative position within overlay
    const relativeX = e.clientX - overlayRect.left;
    
    // Approximate note width
    const noteWidth = overlayRect.width / notesData.length;
    const estimatedNoteIndex = Math.floor(relativeX / noteWidth);
    
    if (estimatedNoteIndex >= 0 && estimatedNoteIndex < explanationsArray.length) {
      const explanation = explanationsArray[estimatedNoteIndex];
      this.showTooltip(e.clientX, e.clientY, explanation);
    } else {
      this.hideTooltip();
    }
  },

  showTooltip(x, y, explanation) {
    if (!explanation) return;
    
    const content = `
      <strong style="display: block; margin-bottom: 4px;">${explanation.name} - ${explanation.degree}</strong>
      <span style="color: #cbd5e1; font-size: 11px; display: block; margin-bottom: 6px;">
        ${explanation.interval}
      </span>
      ${explanation.has_accidental ? `
        <span style="color: #fbbf24; font-size: 11px; display: block;">
          ⚠️ ${explanation.accidental_reason}
        </span>
      ` : ""}
    `;
    
    this.tooltip.innerHTML = content;
    
    // Position tooltip near cursor
    let top = y + 15;
    let left = x + 15;
    
    // Adjust if goes off screen horizontally
    const tooltipWidth = 320;
    if (left + tooltipWidth > window.innerWidth) {
      left = window.innerWidth - tooltipWidth - 10;
    }
    
    // Adjust if goes off screen vertically
    const tooltipHeight = this.tooltip.offsetHeight || 100;
    if (top + tooltipHeight > window.innerHeight) {
      top = y - tooltipHeight - 10;
    }
    
    this.tooltip.style.left = left + "px";
    this.tooltip.style.top = top + "px";
    this.tooltip.style.opacity = "1";
    this.tooltip.style.pointerEvents = "none";
  },

  hideTooltip() {
    if (this.tooltip) {
      this.tooltip.style.opacity = "0";
    }
  }
}

export default MusicStaff;
