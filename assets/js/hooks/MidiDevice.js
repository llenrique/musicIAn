const MidiDevice = {
  mounted() {
    // === TIMING SYSTEM INITIALIZATION ===
    this.metronomeStartTime = null;  // When metronome started (performance.now())
    this.metronomeStartServerTime = null; // Server timestamp when metronome started
    this.currentBPM = 60;             // Beats per minute
    this.beatDurationMs = 1000;       // Milliseconds per beat (1000 / BPM)
    this.timingTolerance = 150;       // ±150ms tolerance for "on time"
    this.timingLog = [];              // Log of all timing events for analysis
    
    // === NEW: Lesson steps for beat-based validation ===
    this.lessonSteps = null;          // Steps from current lesson
    this.currentStepIndex = 0;        // Which step we're expecting
    
    this.initMIDI();
    
    // === NEW: Receive lesson info when practice starts ===
    this.handleEvent("lesson_started", ({ steps, tempo, metronome_active }) => {
      console.log(`📚 Lesson started with ${steps.length} steps at ${tempo} BPM`);
      this.lessonSteps = steps;
      this.currentStepIndex = 0;
      
      // Pre-calculate expected beats for each step
      this.expectedBeatsPerStep = this.calculateExpectedBeatsForLesson(steps);
      console.log(`📍 Expected beats per step:`, this.expectedBeatsPerStep);
    });
    
    // Listen for play_note event from server (Virtual Keyboard clicks)
    this.handleEvent("play_note", ({ midi, duration }) => {
      this.sendMidiOut(midi, duration || 0.5);
    });

    // Allow manual reconnection trigger from server/UI
    this.handleEvent("reconnect_midi", () => {
      console.log("🔄 Manual MIDI Reconnection Requested");
      this.initMIDI();
    });

    // Metronome Events
    this.handleEvent("toggle_metronome", ({ active, bpm }) => {
      if (active) {
        this.startMetronome(bpm);
      } else {
        this.stopMetronome();
      }
    });

    this.handleEvent("update_metronome_tempo", ({ bpm }) => {
      if (this.metronomeInterval) {
        this.startMetronome(bpm); // Restart with new BPM
      }
    });

    // Demo Sequencer
    this.handleEvent("play_demo_sequence", ({ tempo, steps }) => {
      this.startDemoSequencer(tempo, steps);
    });

     this.handleEvent("stop_demo_sequence", () => {
       this.stopDemoSequencer();
     });

     // === Countdown beep sounds ===
     this.handleEvent("countdown_tick", ({ countdown, stage }) => {
       // Only play beep during final countdown (3, 2, 1)
       if (stage === "final") {
         this.playCountdownBeep(countdown);
       }
     });

     this.initKeyboard();
  },

  destroyed() {
    console.log("❌ MidiDevice Hook Destroyed");
    this.stopMetronome();
    if (this.pollingInterval) {
      clearInterval(this.pollingInterval);
    }
    if (this.midiAccess) {
      for (let input of this.midiAccess.inputs.values()) {
        input.onmidimessage = null;
      }
    }
    if (this.localNoteListener) {
      this.el.removeEventListener("local-midi-note", this.localNoteListener);
      window.removeEventListener("local-midi-note", this.localNoteListener);
      this.localNoteListener = null;
    }
  },

  reconnected() {
    console.log("♻️ MidiDevice Hook Reconnected");
    // Add a small delay to ensure LiveView is fully ready to receive events
    setTimeout(() => this.initMIDI(), 500);
  },

  initKeyboard() {
    // Standard DAW Layout (Ableton / Logic style)
    // A S D F G H J K L ; ' -> White Keys
    // W E T Y U O P -> Black Keys
    // Z / X -> Octave Down / Up (Future)
    
    // Mapping starting at C4 (MIDI 60)
    const keyMap = {
      'a': 60, // C4
      'w': 61, // C#4
      's': 62, // D4
      'e': 63, // D#4
      'd': 64, // E4
      'f': 65, // F4
      't': 66, // F#4
      'g': 67, // G4
      'y': 68, // G#4
      'h': 69, // A4
      'u': 70, // A#4
      'j': 71, // B4
      'k': 72, // C5
      'o': 73, // C#5
      'l': 74, // D5
      'p': 75, // D#5
      ';': 76, // E5
      "'": 77  // F5
    };

    this.pressedKeys = new Set();

    window.addEventListener('keydown', (e) => {
      // Ignore if typing in an input
      if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
      
      const key = e.key.toLowerCase();
      
      // Check if key is already pressed to prevent auto-repeat
      if (this.pressedKeys.has(key)) return;
      
      const midi = keyMap[key];
      if (midi) {
        this.pressedKeys.add(key);
        
        // === BEAT-BASED TIMING SYSTEM ===
        const notePlayedAtMs = performance.now();
        
        // Get expected beat for CURRENT STEP
        let expectedBeat = null;
        if (this.expectedBeatsPerStep && this.currentStepIndex < this.expectedBeatsPerStep.length) {
          expectedBeat = this.expectedBeatsPerStep[this.currentStepIndex].expectedBeat;
        }
        
        // Check timing against the EXPECTED BEAT for this step
        const timingInfo = this.checkTimingSynchronization(notePlayedAtMs, expectedBeat);
        
        console.log(
          `⌨️  Keyboard Note On: ${midi} | Step ${this.currentStepIndex} | ` +
          `Beat ${expectedBeat} | Timing: ${timingInfo.status}`
        );
        
        // Simulate MIDI Note On (Velocity 100)
        this.triggerLocalEffects(midi, 100, true, "computer-keyboard");
        this.safePushEvent("midi_note_on", { 
          midi: midi, 
          velocity: 100,
          // === Beat-based timing information ===
          timestamp: notePlayedAtMs,
          expectedBeat: expectedBeat,
          timingStatus: timingInfo.status,
          timingDeviation: timingInfo.deviation,
          timingSeverity: timingInfo.severity,
          beatWindowStart: timingInfo.beatWindowStart,
          beatWindowEnd: timingInfo.beatWindowEnd,
          noteRelativeTime: timingInfo.noteRelativeTime
        });
      }
    });

    window.addEventListener('keyup', (e) => {
      const key = e.key.toLowerCase();
      if (this.pressedKeys.has(key)) {
        this.pressedKeys.delete(key);
        const midi = keyMap[key];
        if (midi) {
          // Simulate MIDI Note Off
          this.triggerLocalEffects(midi, 0, false, "computer-keyboard");
          this.safePushEvent("midi_note_off", { midi: midi });
        }
      }
    });
  },

  initMIDI() {
    // Reset existing access if any
    this.midiAccess = null;

    // Listen for local-midi-note events to send MIDI OUT
    // We listen on the hook element (container) to catch bubbled events
    if (!this.localNoteListener) {
      this.localNoteListener = (e) => {
        const { midi, velocity, isOn, source } = e.detail;
        console.log("🎹 Local Note Event (MidiDevice):", midi, isOn ? "ON" : "OFF", source);
        
        // Only send MIDI OUT if the source is NOT "midi-in" (to avoid loops)
        if (source !== "midi-in") {
          if (isOn) {
            this.sendNoteOn(midi, velocity || 100);
          } else {
            this.sendNoteOff(midi);
          }
        }
      };
      // Listen on the element itself (bubbling) AND window (just in case)
      this.el.addEventListener("local-midi-note", this.localNoteListener);
      window.addEventListener("local-midi-note", this.localNoteListener);
    }

    if (!navigator.requestMIDIAccess) {
      console.warn("Web MIDI API not supported in this browser.");
      return;
    }

    // Request Sysex access to potentially see more devices/outputs and control metronome
    navigator.requestMIDIAccess({ sysex: true })
      .then(this.onMIDISuccess.bind(this), this.onMIDIFailure.bind(this));
      
    // Polling fallback: Check for new devices every 5 seconds if connection seems lost
    // This helps if the browser doesn't fire onstatechange reliably
    if (this.pollingInterval) clearInterval(this.pollingInterval);
    
    this.pollingInterval = setInterval(() => {
        if (this.midiAccess) {
            // Re-attach to any inputs that might have been dropped
            for (let input of this.midiAccess.inputs.values()) {
                if (!input.onmidimessage) {
                    console.log("♻️ Re-attaching dropped input:", input.name);
                    this.attachInput(input);
                }
            }
        }
    }, 5000);
  },

  onMIDISuccess(midiAccess) {
    // === DISABLED: Connection logs (too noisy) ===
    // console.log("✅ MIDI Access Granted");
    this.midiAccess = midiAccess; // Store for output access
    
    const inputs = Array.from(midiAccess.inputs.values()).map(i => i.name);
    const outputs = Array.from(midiAccess.outputs.values()).map(i => i.name);

    // console.log("Available Inputs:", inputs);
    // console.log("Available Outputs:", outputs);
    
    // Notify server of successful connection with retry mechanism
    this.sendConnectionStatus(inputs, outputs);
    
    // Attach to all existing inputs
    for (let input of midiAccess.inputs.values()) {
      this.attachInput(input);
    }

    // Listen for new devices connecting
    midiAccess.onstatechange = (e) => {
      // === DISABLED: Connection event logs (too noisy) ===
      // console.log("🔌 MIDI Connection Event:", e.port.name, e.port.state);
      
      // Re-scan inputs when any connection change happens
      // This handles both new connections and re-connections
      if (e.port.type === "input" && e.port.state === "connected") {
        this.attachInput(e.port);
      }
      
      // Update server with new list
      const newInputs = Array.from(this.midiAccess.inputs.values()).map(i => i.name);
      const newOutputs = Array.from(this.midiAccess.outputs.values()).map(i => i.name);
      this.sendConnectionStatus(newInputs, newOutputs);
    };
  },

  sendConnectionStatus(inputs, outputs, retries = 3) {
    try {
      this.pushEvent("midi_status_update", { connected: true, inputs: inputs, outputs: outputs })
        .catch(e => {
          if (retries > 0) {
             console.log(`⚠️ MIDI Status update failed, retrying in 1s... (${retries})`);
             setTimeout(() => this.sendConnectionStatus(inputs, outputs, retries - 1), 1000);
          }
        });
    } catch (e) {
      if (retries > 0) {
         console.log(`⚠️ MIDI Status update failed, retrying in 1s... (${retries})`);
         setTimeout(() => this.sendConnectionStatus(inputs, outputs, retries - 1), 1000);
      }
    }
  },

  sendMidiOut(midi, duration) {
    console.log(`📤 sendMidiOut: MIDI ${midi}, duration ${duration}s, access=${this.midiAccess ? 'YES' : 'NO'}`);
    
    if (!this.midiAccess) {
      console.warn("⚠️ MIDI Output: No MIDI Access available");
      return;
    }
    
    // Note On
    console.log(`   → Calling sendNoteOn(${midi}, 100)`);
    this.sendNoteOn(midi, 100);
    
    // Note Off after duration
    if (duration) {
      setTimeout(() => {
        console.log(`   → Calling sendNoteOff(${midi})`);
        this.sendNoteOff(midi);
      }, duration * 1000);
    }
  },

  sendNoteOn(midi, velocity) {
    console.log(`[sendNoteOn] midi=${midi}, vel=${velocity}, midiAccess=${this.midiAccess ? 'EXISTS' : 'NULL'}`);
    
    if (!this.midiAccess) {
      console.warn("⚠️ MIDI Output ignored: No MIDI Access. Attempting to initialize...");
      this.initMIDI();
      return;
    }
    
    const outputCount = this.midiAccess.outputs.size;
    console.log(`[sendNoteOn] Outputs available: ${outputCount}`);
    
    let outputsFound = 0;
    for (let output of this.midiAccess.outputs.values()) {
      outputsFound++;
      console.log(`[sendNoteOn] Sending to output ${outputsFound}/${outputCount}: "${output.name}"`);
      try {
        // Send to Channel 1 (0x90)
        const message = [0x90, midi, velocity];
        console.log(`[sendNoteOn] Message bytes: [${message.join(', ')}]`);
        output.send(message);
        console.log(`✅ Sent Note ON ${midi} (Vel ${velocity}) to ${output.name}`);
      } catch (e) {
        console.error("❌ Error sending MIDI Note On:", e);
      }
    }
    
    if (outputsFound === 0) {
      console.warn("⚠️ No MIDI Output devices found in loop.");
    }
  },

  sendNoteOff(midi) {
    if (!this.midiAccess) return;
    for (let output of this.midiAccess.outputs.values()) {
      try {
        // Send to Channel 1 (0x80)
        output.send([0x80, midi, 0]);
      } catch (e) {
        console.error("Error sending MIDI Note Off:", e);
      }
    }
  },

  attachInput(input) {
    console.log("🔗 Attaching listener to:", input.name);
    
    // Remove previous listener to avoid duplicates if re-attaching
    input.onmidimessage = null;
    
    // Use direct assignment for maximum compatibility
    input.onmidimessage = this.onMIDIMessage.bind(this);
  },

  onMIDIFailure(msg) {
    console.error("❌ Could not access MIDI devices.", msg);
  },

   onMIDIMessage(message) {
     // Debug: Log that we received *something*
     // console.log("Raw message received");

     if (!message.data) return;
     
     const data = message.data;
     const status = data[0];
     const note = data[1];
     const velocity = data.length > 2 ? data[2] : 0;
     
     const command = status >> 4;
     const channel = status & 0xF;
     
     // Filter out Active Sensing (0xFE)
     if (status === 0xFE) return;

     // Log Real-Time Messages
     if (status >= 0xF8) {
         const rtNames = {
             0xF8: "Timing Clock",
             0xFA: "Start",
             0xFB: "Continue",
             0xFC: "Stop",
             0xFF: "Reset"
         };
         
         // Handle Clock (0xF8) for BPM detection
         if (status === 0xF8) {
             this.handleIncomingClock();
             return;
         }

         // Log Start/Stop/Continue with detailed information
         if (status === 0xFA || status === 0xFC || status === 0xFB) {
             this.logDetailedMIDIMessage("MIDI TRANSPORT", status, data, null, null);
             // Optional: Sync App state to Piano state
             // if (status === 0xFA) this.pushEvent("metronome_started_externally", {});
             // if (status === 0xFC) this.pushEvent("metronome_stopped_externally", {});
         }
         
         return;
     }
    
    // === DISABLED: Log only relevant Note On/Off messages (too noisy) ===
    // if (command === 9 || command === 8) {
    //     console.log(`🎹 MIDI IN: Cmd=${command} Ch=${channel} Note=${note} Vel=${velocity}`);
    // }

    // Note On (144-159) -> 9
    if (command === 9) {
      if (velocity > 0) {
        // Optimistic UI: Trigger local effects immediately
        this.triggerLocalEffects(note, velocity, true, "midi-in");
        
        // === BEAT-BASED TIMING SYSTEM ===
        const notePlayedAtMs = performance.now();
        
        // Get expected beat for CURRENT STEP
        let expectedBeat = null;
        if (this.expectedBeatsPerStep && this.currentStepIndex < this.expectedBeatsPerStep.length) {
          expectedBeat = this.expectedBeatsPerStep[this.currentStepIndex].expectedBeat;
        }
        
        // Check timing against the EXPECTED BEAT for this step
        const timingInfo = this.checkTimingSynchronization(notePlayedAtMs, expectedBeat);
        
        // Log timing event for analysis
        this.timingLog.push({
          midi: note,
          timestamp: notePlayedAtMs,
          stepIndex: this.currentStepIndex,
          expectedBeat: expectedBeat,
          ...timingInfo
        });
        
        // === DISABLED: Too noisy during testing ===
        // console.log(
        //   `🎵 MIDI Note On: ${note} | Step ${this.currentStepIndex} | ` +
        //   `Beat ${expectedBeat} | Timing: ${timingInfo.status} (${timingInfo.deviation.toFixed(0)}ms) | ` +
        //   `Severity: ${timingInfo.severity}`
        // );
        
        // Still send to server for validation/tracking
        this.safePushEvent("midi_note_on", { 
          midi: note, 
          velocity: velocity,
          // === Beat-based timing information ===
          timestamp: notePlayedAtMs,
          expectedBeat: expectedBeat,
          timingStatus: timingInfo.status,
          timingDeviation: timingInfo.deviation,
          timingSeverity: timingInfo.severity,
          beatWindowStart: timingInfo.beatWindowStart,
          beatWindowEnd: timingInfo.beatWindowEnd,
          noteRelativeTime: timingInfo.noteRelativeTime
        });
      } else {
        this.triggerLocalEffects(note, 0, false, "midi-in");
        this.safePushEvent("midi_note_off", { midi: note });
      }
     } 
     // Note Off (128-143) -> 8
     else if (command === 8) {
       this.triggerLocalEffects(note, 0, false, "midi-in");
       this.safePushEvent("midi_note_off", { midi: note });
     }
     // Control Change (176-191) -> 11 (0xB)
     else if (command === 0xB) {
       const ccNumber = data[1];
       const ccValue = data[2];
       this.logDetailedMIDIMessage("CONTROL CHANGE", status, data, ccNumber, ccValue);
       // Can add server event if needed for special CCs
     }
     // Program Change (192-207) -> 12 (0xC)
     else if (command === 0xC) {
       const program = data[1];
       this.logDetailedMIDIMessage("PROGRAM CHANGE", status, data, program, null);
     }
     // Channel Pressure (208-223) -> 13 (0xD)
     else if (command === 0xD) {
       const pressure = data[1];
       this.logDetailedMIDIMessage("CHANNEL PRESSURE", status, data, null, pressure);
     }
     // Pitch Bend (224-239) -> 14 (0xE)
     else if (command === 0xE) {
       const lsb = data[1];
       const msb = data[2];
       const pitchValue = (msb << 7) | lsb;
       this.logDetailedMIDIMessage("PITCH BEND", status, data, pitchValue, null);
     }
     // Polyphonic Pressure/Aftertouch (160-175) -> 10 (0xA)
     else if (command === 0xA) {
       const polyNote = data[1];
       const pressure = data[2];
       this.logDetailedMIDIMessage("POLYPHONIC PRESSURE", status, data, polyNote, pressure);
     }
   },

  handleIncomingClock() {
    const now = performance.now();
    
    if (!this.lastClockTime) {
        this.lastClockTime = now;
        this.clockCount = 0;
        return;
    }

    const delta = now - this.lastClockTime;
    this.lastClockTime = now;
    
    // MIDI Clock sends 24 pulses per quarter note (PPQ)
    // BPM = 60000 / (24 * delta_ms)
    // We smooth it out by averaging over 24 pulses (1 beat)
    
    this.clockCount++;
    if (!this.clockSum) this.clockSum = 0;
    this.clockSum += delta;

    if (this.clockCount >= 24) {
        const avgDelta = this.clockSum / 24;
        const bpm = Math.round(60000 / (24 * avgDelta));
        
        // === DISABLED: Log BPM change if significant (too noisy) ===
        // console.log(`🎹 MIDI IN CLOCK DETECTED: ~${bpm} BPM`);
        if (!this.lastDetectedBPM || Math.abs(this.lastDetectedBPM - bpm) > 1) {
            this.lastDetectedBPM = bpm;
            this.pushEvent("bpm_detected", { bpm: bpm });
        }
        
        this.clockCount = 0;
        this.clockSum = 0;
    }
  },

  safePushEvent(event, payload) {
    try {
      const result = this.pushEvent(event, payload);
      // Handle promise rejection if it returns a promise
      if (result && typeof result.catch === 'function') {
        result.catch(e => console.debug(`⚠️ Skipped sending ${event}: LiveView not connected.`));
      }
    } catch (e) {
      console.debug(`⚠️ Skipped sending ${event}: LiveView not connected.`);
    }
  },

  triggerLocalEffects(midi, velocity, isOn, source) {
    // 1. Play Sound directly via AudioEngine hook
    // We need to find the AudioEngine hook instance. 
    // Since hooks don't share state easily, we can dispatch a custom DOM event
    // or access the hook if we stored it globally (which we haven't).
    // A robust way is dispatching a custom event on window that AudioEngine listens to.
    
    const event = new CustomEvent("local-midi-note", { 
      detail: { midi: midi, velocity: velocity, isOn: isOn, source: source } 
    });
    window.dispatchEvent(event);
  },

  // Metronome Implementation
  startMetronome(bpm) {
    this.stopMetronome();
    
    const beatIntervalMs = 60000 / bpm;
    // const clockIntervalMs = 60000 / (bpm * 24); // Removed unused clock interval
    
    // === TIMING SYSTEM: Capture metronome start time ===
    this.metronomeStartTime = performance.now();
    this.currentBPM = bpm;
    this.beatDurationMs = beatIntervalMs;
    this.timingLog = []; // Reset timing log
    
    console.log(`⏰ Starting Metronome at ${bpm} BPM (Beat: ${beatIntervalMs}ms)`);
    console.log(`⏰ Metronome Time Reference: ${this.metronomeStartTime.toFixed(0)}ms`);
    
    // YDP-105 does NOT support MIDI Start/Stop or Clock.
    // We rely purely on the simulated click track.
    
    this.playMetronomeClick(); // Play first click immediately
    this.blinkMetronomeIndicator(); // Visual feedback
    
    // 1. Audible Click Interval (Visual/Audio feedback)
    this.metronomeInterval = setInterval(() => {
      this.playMetronomeClick();
      this.blinkMetronomeIndicator();
    }, beatIntervalMs);
  },

  stopMetronome() {
    if (this.metronomeInterval) {
      clearInterval(this.metronomeInterval);
      this.metronomeInterval = null;
    }
    
    console.log("⏰ Metronome Stopped");
  },

  // === TIMING SYSTEM FUNCTIONS ===

  /**
   * Calculate current beat position relative to metronome start
   * Returns: { beat: number, positionMs: number, timingStatus: 'on-time'|'early'|'late' }
   */
  calculateBeatPosition() {
    if (!this.metronomeStartTime) {
      return { beat: 0, positionMs: 0, timingStatus: 'unknown' };
    }

    const now = performance.now();
    const elapsedMs = now - this.metronomeStartTime;
    const currentBeat = elapsedMs / this.beatDurationMs;

    return {
      beat: currentBeat,
      positionMs: elapsedMs,
      beatIndex: Math.floor(currentBeat),
      beatFraction: currentBeat % 1
    };
  },

  /**
   * Check if a note played at the given time is synchronized with the metronome
   * NOW: Validates against EXPECTED BEAT, not just any beat
   * Returns: {
   *   status: 'on-time'|'early'|'late'|'between-beats',
   *   deviation: number (ms),
   *   severity: 'ok'|'warning'|'error',
   *   expectedBeat: number,
   *   beatWindow: {start, end}
   * }
   */
  checkTimingSynchronization(notePlayedAtMs, expectedBeatIndex = null) {
    if (!this.metronomeStartTime) {
      return { status: 'unknown', deviation: 0, severity: 'unknown' };
    }

    const noteRelativeTime = notePlayedAtMs - this.metronomeStartTime;
    const currentBeatPosition = noteRelativeTime / this.beatDurationMs;

    // === NEW: Use provided expected beat or round to nearest beat ===
    let expectedBeat = expectedBeatIndex;
    if (expectedBeat === null) {
      expectedBeat = Math.round(currentBeatPosition);
    }

    const expectedTimeMs = expectedBeat * this.beatDurationMs;
    const deviationMs = noteRelativeTime - expectedTimeMs;

    // === NEW: Define beat window (±tolerance around expected beat) ===
    const beatWindowStart = expectedBeat * this.beatDurationMs - this.timingTolerance;
    const beatWindowEnd = expectedBeat * this.beatDurationMs + this.timingTolerance;

    // === NEW: Check if note is COMPLETELY outside beat window ===
    let status = 'on-time';
    let severity = 'ok';

    if (noteRelativeTime < beatWindowStart) {
      // Note played BEFORE the beat window (too early)
      const timeBefore = beatWindowStart - noteRelativeTime;
      status = 'early';
      
      // Check if it might be part of PREVIOUS beat
      const prevBeatEnd = (expectedBeat - 1) * this.beatDurationMs + this.timingTolerance;
      if (noteRelativeTime >= prevBeatEnd) {
        // Note is between beats (not assigned to any beat)
        status = 'between-beats';
        severity = 'error';
      } else {
        severity = timeBefore > 300 ? 'error' : 'warning';
      }
    } else if (noteRelativeTime > beatWindowEnd) {
      // Note played AFTER the beat window (too late)
      const timeAfter = noteRelativeTime - beatWindowEnd;
      status = 'late';
      
      // Check if it might be part of NEXT beat
      const nextBeatStart = (expectedBeat + 1) * this.beatDurationMs - this.timingTolerance;
      if (noteRelativeTime < nextBeatStart) {
        // Note is between beats (not assigned to any beat)
        status = 'between-beats';
        severity = 'error';
      } else {
        severity = timeAfter > 300 ? 'error' : 'warning';
      }
    }

    return {
      status,
      deviation: deviationMs,
      severity,
      expectedBeat,
      beatWindowStart,
      beatWindowEnd,
      noteRelativeTime,
      toleranceMs: this.timingTolerance
    };
  },

  /**
   * Calculate expected beat for a specific step
   * Based on cumulative step durations
   */
  calculateExpectedBeatForStep(stepIndex, lessonSteps) {
    if (!lessonSteps || stepIndex >= lessonSteps.length) {
      return null;
    }

    let totalDuration = 0;
    for (let i = 0; i < stepIndex; i++) {
      const step = lessonSteps[i];
      totalDuration += (step.duration || 1);
    }

    return totalDuration;
  },

  /**
   * Pre-calculate expected beats for ALL steps
   * Returns: array where expectedBeatsPerStep[i] = beat number for step i
   */
  calculateExpectedBeatsForLesson(steps) {
    const beatMap = [];
    let currentBeat = 0;

    for (let i = 0; i < steps.length; i++) {
      const step = steps[i];
      const duration = step.duration || 1; // Default 1 beat
      
      beatMap[i] = {
        stepIndex: i,
        expectedBeat: currentBeat,
        beatWindowStart: currentBeat - this.timingTolerance / this.beatDurationMs,
        beatWindowEnd: currentBeat + duration * this.beatDurationMs + this.timingTolerance / this.beatDurationMs,
        duration: duration,
        text: step.text
      };

      currentBeat += duration;
    }

    return beatMap;
  },

  sendSysEx(bytes) {
    if (!this.midiAccess) return;
    for (let output of this.midiAccess.outputs.values()) {
      try {
        output.send(bytes);
        console.log("📤 Sent SysEx:", bytes.map(b => b.toString(16).toUpperCase()).join(" "));
      } catch (e) {
        console.error("Error sending SysEx:", e);
      }
    }
  },

  sendRealTimeMessage(status) {
    if (!this.midiAccess) return;
    for (let output of this.midiAccess.outputs.values()) {
      try {
        output.send([status]);
      } catch (e) {
        // Ignore errors for devices that don't support it
      }
    }
  },

  blinkMetronomeIndicator() {
    const indicator = document.getElementById("metronome-indicator");
    if (indicator) {
      indicator.classList.add("bg-emerald-500", "scale-125");
      setTimeout(() => {
        indicator.classList.remove("bg-emerald-500", "scale-125");
      }, 100);
    }
  },

  // Demo Sequencer Implementation
  startDemoSequencer(tempo, steps) {
    this.stopDemoSequencer();
    this.stopMetronome(); // Ensure regular metronome is off

    console.log(`▶️ Starting Demo Sequencer at ${tempo} BPM`);
    console.log(`📋 Steps to play:`, steps.length);
    console.log(`🎹 MIDI Access available:`, this.midiAccess ? "YES" : "NO");
    if (this.midiAccess) {
      console.log(`   Outputs available:`, this.midiAccess.outputs.size);
    }
    
    const beatDurationMs = 60000 / tempo;
    let currentStepIndex = 0;
    
    // We need to schedule events. 
    // Since JS is single threaded, a recursive setTimeout loop is often better than setInterval for varying durations.
    
    const playNextStep = () => {
      if (currentStepIndex >= steps.length) {
        console.log("⏹️ Demo Finished");
        this.pushEvent("demo_finished", {});
        return;
      }

      const step = steps[currentStepIndex];
      const stepDurationMs = step.duration_beats * beatDurationMs;
      
      console.log(`📍 Demo Step ${currentStepIndex + 1}/${steps.length}: "${step.text}" - ${step.notes.length} notes`);
      
      // 1. Update UI (highlight notes on staff/keyboard)
      this.pushEvent("demo_step_update", { step_index: step.step_index });
      
      // 2. Play Notes
      step.notes.forEach(midi => {
        console.log(`   🎵 Playing MIDI ${midi} for ${((stepDurationMs / 1000) * 0.9).toFixed(2)}s`);
        // Play note with duration slightly shorter than full step to articulate
        this.sendMidiOut(midi, (stepDurationMs / 1000) * 0.9);
        // Trigger visual effect locally
        this.triggerLocalEffects(midi, 80, true, "demo-player");
        setTimeout(() => {
            this.triggerLocalEffects(midi, 0, false, "demo-player");
        }, (stepDurationMs * 0.9));
      });

      // 3. Play Metronome Clicks
      // We need to play a click at the start, and if duration > 1 beat, play subsequent clicks
      // Example: Duration 2 beats -> Click at 0ms, Click at beatDurationMs
      
      let beatsPlayed = 0;
      const clickLoop = setInterval(() => {
        if (beatsPlayed < step.duration_beats) {
             this.playMetronomeClick();
             this.blinkMetronomeIndicator();
             beatsPlayed++;
        } else {
            clearInterval(clickLoop);
        }
      }, beatDurationMs);
      
      // Play first click immediately (setInterval waits first)
      this.playMetronomeClick();
      this.blinkMetronomeIndicator();
      beatsPlayed++; // Count the first one

      // Schedule next step
      this.demoTimeout = setTimeout(() => {
        clearInterval(clickLoop); // Safety cleanup
        currentStepIndex++;
        playNextStep();
      }, stepDurationMs);
    };

    // Start the loop
    playNextStep();
  },

  stopDemoSequencer() {
    if (this.demoTimeout) {
      clearTimeout(this.demoTimeout);
      this.demoTimeout = null;
    }
    console.log("⏹️ Demo Sequencer Stopped");
  },

  playMetronomeClick() {
    if (!this.midiAccess) return;
    
    // YDP-105 doesn't support Start/Stop commands (Recognized: X).
    // It also likely doesn't have a Drum Kit on Ch 10.
    // Solution: Use Channel 16 with a sharp sound (Harpsichord - PC 6) to simulate a click.
    
    // Channel 16 (0xF)
    // Note On: 0x9F
    // Note Off: 0x8F
    // Program Change: 0xCF
    
    const channel = 0xF; // Channel 16 (0-indexed)
    const note = 84; // C6 (High pitch)
    const velocity = 100;
    
    for (let output of this.midiAccess.outputs.values()) {
      try {
        // 1. Ensure Harpsichord is selected on Ch 16 (Only need to do this once really, but safe to repeat)
        // PC 6 = Harpsichord 8' (according to manual Voice List)
        // Program Change is 0xC0 + channel
        output.send([0xC0 + channel, 6]); 
        
        // 2. Play the Note
        output.send([0x90 + channel, note, velocity]);
        
        // 3. Note Off after 50ms
        setTimeout(() => {
          try { output.send([0x80 + channel, note, 0]); } catch(e) {}
        }, 50);
      } catch (e) {
        console.error("Error sending Metronome click:", e);
      }
    }
  },

  playCountdownBeep(countdown) {
    // Play a distinct beep for countdown (3, 2, 1)
    // Higher pitch than metronome click
    if (!this.midiAccess) return;

    const channel = 0xF; // Channel 16 (0-indexed)
    const note = 96; // C7 (Very high pitch, distinct from metronome)
    const velocity = 120; // Slightly louder than metronome
    
    for (let output of this.midiAccess.outputs.values()) {
      try {
        // Send countdown beep
        output.send([0xC0 + channel, 6]); // Harpsichord
        output.send([0x90 + channel, note, velocity]); // Note On
        
        // Note Off after 100ms (slightly longer than metronome click)
        setTimeout(() => {
          try { output.send([0x80 + channel, note, 0]); } catch(e) {}
        }, 100);
      } catch (e) {
        console.error("Error sending Countdown beep:", e);
      }
    }
  },

  /**
   * === Detailed MIDI Message Logging ===
   * Logs comprehensive information about MIDI messages including:
   * - Message type (Note On/Off, CC, PC, SysEx, etc.)
   * - Channel number
   * - Data bytes
   * - Human-readable interpretation
   */
  logDetailedMIDIMessage(messageType, status, data, note, velocity) {
    const channel = (status & 0x0F) + 1; // Channels are 0-15, display as 1-16
    const command = status >> 4;
    
    // Command name mapping
    const commandNames = {
      0x8: "Note Off",
      0x9: "Note On",
      0xA: "Polyphonic Pressure",
      0xB: "Control Change (CC)",
      0xC: "Program Change (PC)",
      0xD: "Channel Pressure",
      0xE: "Pitch Bend",
      0xF: "System Message"
    };
    
    // System message names (0xF0-0xFF)
    const systemMessageNames = {
      0xF0: "System Exclusive (SysEx)",
      0xF1: "MIDI Time Code Quarter Frame",
      0xF2: "Song Position Pointer",
      0xF3: "Song Select",
      0xF4: "Undefined",
      0xF5: "Undefined",
      0xF6: "Tune Request",
      0xF7: "End of Exclusive",
      0xF8: "Timing Clock",
      0xF9: "Undefined",
      0xFA: "Start",
      0xFB: "Continue",
      0xFC: "Stop",
      0xFD: "Undefined",
      0xFE: "Active Sensing",
      0xFF: "System Reset"
    };

    let commandName = "";
    let isSystemMessage = status >= 0xF0;
    
    if (isSystemMessage) {
      commandName = systemMessageNames[status] || "Unknown System Message";
    } else {
      commandName = commandNames[command] || "Unknown Message";
    }

    // Format hex bytes
    const hexBytes = Array.from(data)
      .map(b => `0x${b.toString(16).toUpperCase().padStart(2, '0')}`)
      .join(" ");

    // Build detailed log message
    let logMessage = `🎹 MIDI MESSAGE RECEIVED\n`;
    logMessage += `   Type: ${messageType} | ${commandName}\n`;
    logMessage += `   Raw Bytes: ${hexBytes}\n`;
    logMessage += `   Status Byte: 0x${status.toString(16).toUpperCase().padStart(2, '0')}\n`;

    if (!isSystemMessage) {
      logMessage += `   Channel: ${channel}\n`;
      
      if (command === 0x9 || command === 0x8) { // Note On/Off
        logMessage += `   Note: ${note} (MIDI Note Number)\n`;
        logMessage += `   Velocity: ${velocity}\n`;
      } else if (command === 0xB) { // Control Change
        logMessage += `   CC Number: ${data[1]}\n`;
        logMessage += `   CC Value: ${data[2]}\n`;
      } else if (command === 0xC) { // Program Change
        logMessage += `   Program: ${data[1]}\n`;
      } else if (command === 0xE) { // Pitch Bend
        const lsb = data[1];
        const msb = data[2];
        const pitchValue = (msb << 7) | lsb;
        logMessage += `   Pitch Bend: ${pitchValue} (0x${pitchValue.toString(16).toUpperCase()})\n`;
      }
    }

    logMessage += `   Timestamp: ${new Date().toLocaleTimeString('es-ES', { 
      hour: '2-digit', 
      minute: '2-digit', 
      second: '2-digit',
      fractionalSecondDigits: 3
    })}`;

    console.log(logMessage);
  }
};

export default MidiDevice;
