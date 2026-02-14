import { Renderer, Stave, StaveNote, Accidental, Voice, Formatter, StaveConnector, BarNote } from "vexflow";

const MusicStaff = {
  mounted() {
    this.div = this.el;
    
    // Store highlighted notes (Set of MIDI numbers)
    this.highlightedMidis = new Set();
    
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
  }
}

export default MusicStaff;
