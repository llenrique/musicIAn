const AudioEngine = {
  mounted() {
    // Visual-only engine now
    
    this.handleEvent("play_note", ({ midi, duration }) => {
      this.highlightKey(midi, true);
      setTimeout(() => this.highlightKey(midi, false), (duration || 0.5) * 1000);
    });

    // Listen for local MIDI events (Optimistic UI)
    window.addEventListener("local-midi-note", (e) => {
      const { midi, velocity, isOn } = e.detail;
      
      if (isOn === undefined) {
        // Fallback for legacy calls
        this.highlightKey(midi, true);
        setTimeout(() => this.highlightKey(midi, false), 200);
      } else if (isOn) {
        this.highlightKey(midi, true);
      } else {
        this.highlightKey(midi, false);
      }
    });
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
