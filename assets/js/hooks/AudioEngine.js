const AudioEngine = {
  mounted() {
    // === NEW: Track held notes client-side to prevent stuck notes ===
    this.heldNotes = new Set();
    
    this.handleEvent("play_note", ({ midi, duration }) => {
      this.setKeyPressed(midi, true);
      setTimeout(() => this.setKeyPressed(midi, false), (duration || 0.5) * 1000);
    });

    // Listen for local MIDI events (Optimistic UI)
    window.addEventListener("local-midi-note", (e) => {
      const { midi, velocity, isOn } = e.detail;
      
      if (isOn === undefined) {
        // Fallback for legacy calls
        this.setKeyPressed(midi, true);
        setTimeout(() => this.setKeyPressed(midi, false), 200);
      } else {
        // === NEW: Use the new tracking method ===
        this.setKeyPressed(midi, isOn);
      }
    });
  },
  
  destroyed() {
    // Clean up when hook is destroyed
    this.heldNotes = new Set();
  },
  
  /**
   * === NEW: Set key pressed state with proper tracking ===
   * Mirrors the server-side MapSet behavior
   */
  setKeyPressed(midi, isOn) {
    if (isOn) {
      this.heldNotes.add(midi);
      this.highlightKey(midi, true);
    } else {
      this.heldNotes.delete(midi);
      // Only highlight off if this note is no longer in our held set
      if (!this.heldNotes.has(midi)) {
        this.highlightKey(midi, false);
      }
    }
  },
  
  highlightKey(midi, isOn) {
    const key = document.getElementById(`key-${midi}`);
    if (key) {
      if (isOn) {
        // Add a high-priority class for visual feedback
        key.classList.add("!bg-yellow-400", "!shadow-[0_0_20px_rgba(250,204,21,0.8)]", "scale-95");
      } else {
        key.classList.remove("!bg-yellow-400", "!shadow-[0_0_20px_rgba(250,204,21,0.8)]", "scale-95");
      }
    }
  }
}

export default AudioEngine;
