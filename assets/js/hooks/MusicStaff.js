import { Renderer, Stave, StaveNote, Accidental, Voice, Formatter, StaveConnector, BarNote } from "vexflow";

const MusicStaff = {
  mounted() {
    this.div = this.el;
    this.tooltipInitialized = false;
    
    // Store highlighted notes (Set of MIDI numbers)
    this.highlightedMidis = new Set();
    
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
    this.draw();
  },

  destroyed() {
    if (this.resizeObserver) this.resizeObserver.disconnect();
  },
  
  highlightNote(midi) {
    this.highlightedMidis.add(midi);
    this.draw();
    
    // Remove highlight after 500ms
    setTimeout(() => {
      this.highlightedMidis.delete(midi);
      this.draw();
    }, 500);
  },

  draw() {
    this.div.innerHTML = "";
    
    // Get parent dimensions or use clientWidth
    const width = this.div.clientWidth;
    const height = this.div.clientHeight || 280; 
    
    if (width === 0) return;

    const renderer = new Renderer(this.div, Renderer.Backends.SVG);
    renderer.resize(width, height);
    const context = renderer.getContext();
    
    // Scale context if needed to fit everything
    // Standard VexFlow height is usually around 100-120 per stave.
    // Grand staff needs ~200-250.
    // If container is smaller, we scale down.
    const requiredHeight = 260; // 30 (top) + 100 (treble) + 100 (bass) + 30 (bottom)
    if (height < requiredHeight) {
        const scale = height / requiredHeight;
        context.scale(scale, scale);
    }

    const notesData = JSON.parse(this.el.dataset.notes || "[]");
    const keySignature = this.el.dataset.key || "C";
    const currentStepIndex = parseInt(this.el.dataset.stepIndex || "0");
    const isLesson = this.el.dataset.isLesson === "true";

    // 1. Create Staves (Grand Staff)
    // Treble
    const staveTreble = new Stave(10, 30, width - 20);
    staveTreble.addClef("treble");
    staveTreble.addTimeSignature("4/4");
    if (keySignature) staveTreble.addKeySignature(keySignature);
    staveTreble.setContext(context).draw();

    // Bass
    const staveBass = new Stave(10, 130, width - 20);
    staveBass.addClef("bass");
    staveBass.addTimeSignature("4/4");
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
    
    // Track beats to insert bar lines
    let currentBeat = 0;
    const beatsPerBar = 4; // Assuming 4/4 for now

    notesData.forEach((step, index) => {
        const duration = step.duration || "q";
        
        // Calculate beat value of this note
        let noteBeats = 1;
        if (duration === "w") noteBeats = 4;
        if (duration === "h") noteBeats = 2;
        if (duration === "q") noteBeats = 1;
        if (duration === "8") noteBeats = 0.5;

        // Separate notes by clef
        const trebleNotes = step.notes.filter(n => n.clef === "treble");
        const bassNotes = step.notes.filter(n => n.clef === "bass");

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
            
            // Highlight
            const shouldHighlight = isLesson ? (index === currentStepIndex) : true;
            if (shouldHighlight && trebleNotes.some(n => this.highlightedMidis.has(n.midi))) {
                note.setStyle({fillStyle: "#9333ea", strokeStyle: "#9333ea"});
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
            
            // Highlight
            const shouldHighlight = isLesson ? (index === currentStepIndex) : true;
            if (shouldHighlight && bassNotes.some(n => this.highlightedMidis.has(n.midi))) {
                note.setStyle({fillStyle: "#9333ea", strokeStyle: "#9333ea"});
            }
            bassTickables.push(note);
        } else {
            // Invisible Rest
            const rest = new StaveNote({ keys: ["d/3"], duration: duration, type: "r" });
            rest.setStyle({fillStyle: "transparent", strokeStyle: "transparent"});
            bassTickables.push(rest);
        }
        
        // Update beat counter and add bar line if needed
        currentBeat += noteBeats;
        
        if (currentBeat >= beatsPerBar) {
            // Add Bar Line
            trebleTickables.push(new BarNote());
            bassTickables.push(new BarNote());
            currentBeat = 0; // Reset for next measure
        }
    });

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

    // 5. Draw Cursor (Bar over current note)
    if (notesData.length > 0 && currentStepIndex < notesData.length) {
        // We need to map currentStepIndex (index in notesData) to index in tickables
        // Since we added BarNotes, the indices shifted.
        // We need to re-calculate the index in tickables array.
        
        let tickableIndex = 0;
        
        // Re-simulate the loop to find the correct tickable index
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
            if (beatSum >= 4) {
                tickableIndex++; // The bar line
                beatSum = 0;
            }
        }
        
        // Now tickableIndex points to the note in tickables array
        // We can pick either treble or bass tickable since they are aligned
        const targetNote = trebleTickables[tickableIndex];

        if (targetNote && targetNote.getAbsoluteX) {
            const noteX = targetNote.getAbsoluteX();
            context.beginPath();
            context.moveTo(noteX, 30);
            context.lineTo(noteX, 230);
            context.lineWidth = 2;
            context.strokeStyle = "#ef4444"; // Red-500
            context.stroke();
            
            context.beginPath();
            context.moveTo(noteX - 5, 20);
            context.lineTo(noteX + 5, 20);
            context.lineTo(noteX, 30);
            context.fillStyle = "#ef4444";
            context.fill();
        }
        
        // Highlight played notes (Real-time feedback)
        // Check if any highlighted MIDI matches notes in this step
        const currentStep = notesData[currentStepIndex];
        if (currentStep && currentStep.notes) {
             const stepMidis = currentStep.notes.map(n => n.midi);
             // Check if user is playing any of these
             // This is handled by the draw loop above (setStyle purple)
             // But maybe we want to show *any* note played?
             // The current implementation highlights ANY note played if it exists in the score.
             // That satisfies "reflect what is being played".
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
        
        this.overlay.addEventListener("mousemove", (e) => this.handleOverlayMouseMove(e));
        this.overlay.addEventListener("mouseout", () => this.hideTooltip());
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
