/**
 * Hook for Web MIDI API device selection and MIDI message sending
 * Used in MetronomeExampleLive to test Yamaha YDP-105 metronome control
 */

export default {
  mounted() {
    window.midiDeviceSelector = this;
    this.midiOutput = null;
    this.logDiv = document.getElementById('midi-log');
    this.statusDiv = document.getElementById('midi-status');
    this.deviceSelect = document.getElementById('midi-devices');

    this.log('🎵 MidiDeviceSelector inicializado', 'info');
    this.listDevices();
  },

  destroyed() {
    if (this.midiOutput) {
      this.midiOutput.close();
    }
  },

  // List available MIDI output devices
  listDevices() {
    if (!navigator.requestMIDIAccess) {
      this.log('❌ Web MIDI API no disponible en este navegador', 'error');
      this.updateStatus('Web MIDI API no soportado');
      return;
    }

    navigator.requestMIDIAccess().then(
      (midiAccess) => {
        const outputs = midiAccess.outputs.values();
        const devices = Array.from(outputs);

        this.deviceSelect.innerHTML = '<option value="">-- Selecciona un dispositivo --</option>';

        if (devices.length === 0) {
          this.log('⚠️ No hay dispositivos MIDI disponibles', 'warn');
          this.updateStatus('Sin dispositivos MIDI');
          return;
        }

        devices.forEach((device, index) => {
          const option = document.createElement('option');
          option.value = device.id;
          option.textContent = device.name;
          this.deviceSelect.appendChild(option);
          this.log(`✓ Dispositivo MIDI encontrado: ${device.name}`, 'success');
        });

        this.updateStatus(`${devices.length} dispositivo(s) MIDI disponible(s)`);
      },
      (error) => {
        this.log(`❌ Error al acceder a MIDI: ${error.message}`, 'error');
        this.updateStatus('Error al acceder a MIDI');
      }
    );
  },

  // Connect to selected MIDI device
  connect() {
    const selectedId = this.deviceSelect.value;
    if (!selectedId) {
      this.log('⚠️ Selecciona un dispositivo primero', 'warn');
      return;
    }

    navigator.requestMIDIAccess().then((midiAccess) => {
      const device = midiAccess.outputs.get(selectedId);
      if (device) {
        this.midiOutput = device;
        this.log(`✓ Conectado a: ${device.name}`, 'success');
        this.updateStatus(`✓ Conectado a ${device.name}`);
        this.deviceSelect.disabled = true;
      }
    });
  },

  // Send a Note On message followed by Note Off
  sendNote(note, velocity, name) {
    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    try {
      // Note On: 0x90 = channel 1, note, velocity
      this.midiOutput.send([0x90, note, velocity]);
      this.log(`📤 Note On: ${name}`, 'success');

      // Auto Note Off after 100ms
      setTimeout(() => {
        this.midiOutput.send([0x80, note, 0]);
        this.log(`📥 Note Off: ${name}`, 'info');
      }, 100);
    } catch (error) {
      this.log(`❌ Error enviando Note On: ${error.message}`, 'error');
    }
  },

  // Send custom note
  sendCustomNote() {
    const noteInput = document.getElementById('test-note');
    const velocityInput = document.getElementById('test-velocity');
    const note = parseInt(noteInput.value);
    const velocity = parseInt(velocityInput.value);

    if (isNaN(note) || note < 0 || note > 127) {
      this.log('⚠️ Nota MIDI inválida (0-127)', 'warn');
      return;
    }

    if (isNaN(velocity) || velocity < 0 || velocity > 127) {
      this.log('⚠️ Velocidad inválida (0-127)', 'warn');
      return;
    }

    this.sendNote(note, velocity, `Custom (MIDI ${note})`);
  },

  // Toggle metronome (FUNCTION + C5)
  toggleMetronome() {
    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    this.log('🎵 Intentando activar metrónomo (FUNCTION + C5)...', 'info');
    this.sendNote(72, 127, 'C5 (Do5) - Metrónomo');
  },

  // Brute Force: Test all notes (0-127) with 50ms delay
  bruteForceAllNotes() {
    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    this.isBruteForcing = true;
    this.log('🔴 Iniciando Brute Force: Todas las notas...', 'warn');

    let noteIndex = 0;
    const interval = setInterval(() => {
      if (!this.isBruteForcing || noteIndex > 127) {
        clearInterval(interval);
        this.log('✓ Brute Force de notas completado', 'success');
        return;
      }

      const note = noteIndex;
      this.midiOutput.send([0x90, note, 127]); // Note On
      
      setTimeout(() => {
        this.midiOutput.send([0x80, note, 0]); // Note Off
      }, 30);

      if (noteIndex % 10 === 0) {
        this.log(`Probando notas ${noteIndex}-${Math.min(noteIndex + 10, 127)}...`, 'info');
      }

      noteIndex++;
    }, 50);
  },

  // Brute Force: Test all CC (0-127) with 50ms delay
  bruteForceAllCC() {
    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    this.isBruteForcing = true;
    this.log('🟠 Iniciando Brute Force: Todos los CC...', 'warn');

    let ccIndex = 0;
    const interval = setInterval(() => {
      if (!this.isBruteForcing || ccIndex > 127) {
        clearInterval(interval);
        this.log('✓ Brute Force de CC completado', 'success');
        return;
      }

      this.midiOutput.send([0xB0, ccIndex, 127]); // Control Change with value 127

      if (ccIndex % 10 === 0) {
        this.log(`Probando CC ${ccIndex}-${Math.min(ccIndex + 10, 127)}...`, 'info');
      }

      ccIndex++;
    }, 50);
  },

  // Brute Force: Test all Program Changes (0-127) with 50ms delay
  bruteForceAllPC() {
    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    this.isBruteForcing = true;
    this.log('🟡 Iniciando Brute Force: Todos los PC...', 'warn');

    let pcIndex = 0;
    const interval = setInterval(() => {
      if (!this.isBruteForcing || pcIndex > 127) {
        clearInterval(interval);
        this.log('✓ Brute Force de PC completado', 'success');
        return;
      }

      this.midiOutput.send([0xC0, pcIndex]); // Program Change

      if (pcIndex % 10 === 0) {
        this.log(`Probando PC ${pcIndex}-${Math.min(pcIndex + 10, 127)}...`, 'info');
      }

      pcIndex++;
    }, 50);
  },

  // Brute Force: Test System Exclusive (SysEx) messages
  bruteForceSystemExclusive() {
    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    this.isBruteForcing = true;
    this.log('🟣 Iniciando Brute Force: System Exclusive...', 'warn');

    // Yamaha SysEx format: F0 43 12 00 41 10 42 12 40 00 F7
    // Common SysEx messages to try
    const sysexMessages = [
      // Generic SysEx pattern
      [0xF0, 0x43, 0x12, 0x00, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0xF7],
      // Alternative Yamaha SysEx
      [0xF0, 0x43, 0x12, 0x00, 0x7F, 0xF7],
      // Simple SysEx
      [0xF0, 0x7E, 0x00, 0x01, 0xF7],
      // Another variant
      [0xF0, 0x43, 0x10, 0x00, 0xF7],
    ];

    sysexMessages.forEach((msg, index) => {
      setTimeout(() => {
        try {
          this.midiOutput.send(msg);
          this.log(`Probando SysEx ${index + 1}: ${msg.map(b => '0x' + b.toString(16).toUpperCase()).join(' ')}`, 'info');
        } catch (error) {
          this.log(`Error enviando SysEx ${index + 1}: ${error.message}`, 'warn');
        }
      }, index * 100);
    });

    setTimeout(() => {
      this.log('✓ Brute Force de SysEx completado', 'success');
      this.isBruteForcing = false;
    }, sysexMessages.length * 100 + 500);
  },

  // Stop brute force
  stopBruteForce() {
    this.isBruteForcing = false;
    this.log('⏹️ Brute Force detenido', 'warn');
  },

  // Helper: update status div
  updateStatus(message) {
    if (this.statusDiv) {
      this.statusDiv.textContent = message;
    }
  },

  // Send Program Change message
  sendPC(programNumber, name) {
    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    try {
      // Program Change: 0xC0 = channel 1, program number
      this.midiOutput.send([0xC0, programNumber]);
      this.log(`📤 Program Change: ${name} (PC ${programNumber})`, 'success');
    } catch (error) {
      this.log(`❌ Error enviando PC: ${error.message}`, 'error');
    }
  },

  // Send Program Change + C5 Note
  sendPCThenNote() {
    const pcInput = document.getElementById('pc-number');
    const pcNumber = parseInt(pcInput.value);

    if (isNaN(pcNumber) || pcNumber < 0 || pcNumber > 127) {
      this.log('⚠️ PC # inválido (0-127)', 'warn');
      return;
    }

    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    try {
      // Send PC
      this.midiOutput.send([0xC0, pcNumber]);
      this.log(`📤 Program Change: PC ${pcNumber}`, 'success');

      // Wait 100ms then send Note On C5
      setTimeout(() => {
        this.midiOutput.send([0x90, 72, 127]);
        this.log(`📤 Note On: C5 (Do5) - MIDI 72`, 'success');

        // Note Off after 100ms
        setTimeout(() => {
          this.midiOutput.send([0x80, 72, 0]);
          this.log(`📥 Note Off: C5`, 'info');
        }, 100);
      }, 100);
    } catch (error) {
      this.log(`❌ Error: ${error.message}`, 'error');
    }
  },

  // Send Control Change message
  sendCC(ccNumber, value, name) {
    if (!this.midiOutput) {
      this.log('❌ Dispositivo MIDI no conectado', 'error');
      return;
    }

    try {
      // Control Change: 0xB0 = channel 1, CC number, value
      this.midiOutput.send([0xB0, ccNumber, value]);
      this.log(`📤 Control Change: ${name} (CC ${ccNumber}, Value ${value})`, 'success');
    } catch (error) {
      this.log(`❌ Error enviando CC: ${error.message}`, 'error');
    }
  },

  // Send custom Control Change
  sendCustomCC() {
    const ccInput = document.getElementById('cc-number');
    const valueInput = document.getElementById('cc-value');
    const ccNumber = parseInt(ccInput.value);
    const value = parseInt(valueInput.value);

    if (isNaN(ccNumber) || ccNumber < 0 || ccNumber > 127) {
      this.log('⚠️ CC # inválido (0-127)', 'warn');
      return;
    }

    if (isNaN(value) || value < 0 || value > 127) {
      this.log('⚠️ Valor inválido (0-127)', 'warn');
      return;
    }

    this.sendCC(ccNumber, value, `Custom CC ${ccNumber}`);
  },

  // Helper: log message
  log(message, type = 'info') {
    const timestamp = new Date().toLocaleTimeString();
    const div = document.createElement('div');

    const colorClasses = {
      success: 'text-green-700',
      error: 'text-red-700',
      warn: 'text-yellow-700',
      info: 'text-blue-700'
    };

    div.className = colorClasses[type] || colorClasses.info;
    div.textContent = `[${timestamp}] ${message}`;

    if (this.logDiv) {
      this.logDiv.appendChild(div);
      this.logDiv.scrollTop = this.logDiv.scrollHeight;
    }

    console.log(`[${type.toUpperCase()}] ${message}`);
  }
};
