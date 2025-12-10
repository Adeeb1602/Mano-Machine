# **The Mano-Machine: A Re-usable CPLD FSM Debugger**

**The Mano-Machine** is a hardware/software "meta-machine" designed to synthesize, run, and debug *any* Finite State Machine (FSM) on a CPLD. It transforms the Helium CPLD board into a transparent debugging platform where logic can be validated physically, one clock cycle at a time.

## **🚀 Project Overview**

Standard FSM design often involves a disconnect between high-level logic (state tables) and low-level hardware verification. This project bridges that gap with a complete workflow:

1. **High-Level Synthesis (HLS):** A Python script parses an Excel state table and auto-generates synthesis-ready Verilog code.  
2. **Hardware Debugging:** A Verilog-based test harness runs the FSM on real hardware with two modes:  
   * **Run Mode (1Hz):** Real-time execution.  
   * **Step Mode:** A manual, single-step debugger using a custom edge-detector circuit.

This project was developed as a final submission for the Digital Electronics course.

**📄 Project Report:** The full technical details, including block diagrams, pin maps, and testbench waveforms, can be found in the [**Docs/**](https://github.com/Adeeb1602/Mano-Machine/tree/main/Docs) directory.

## **🛠️ Features**

* **Universal FSM Engine:** Supports any FSM with up to 16 states, 2 inputs, and 4 outputs.  
* **"Step Mode" Debugger:** Freezes the FSM clock and allows single-cycle advancement via a physical button.  
* **Visual State Feedback:** Displays the current state (0-F) on an external 7-segment display.  
* **Visual Output Feedback:** Displays the FSM outputs on onboard LEDs.  
* **Automated Workflow:** Python script (generate\_fsm\_robust.py) eliminates manual Verilog coding errors.

## **📂 Repository Structure**
```
Mano-Machine/  
├── Docs/                   \# Documentation & Report  
│   └── Mano_Machine.pdf  \# The complete technical report  
├── Hardware/               \# Verilog Source Code  
│   ├── top_level.v         \# System Integrator  
│   ├── fsm_core.v          \# The FSM Logic (Auto-Generated)  
│   ├── debugger.v          \# The Clock Gating & Step Logic  
│   └── decoder_7seg.v      \# 7-Segment Display Driver  
├── Tools/                  \# Python HLS Tools  
│   ├── fsm_generator.py     \# The Generator Script  
│   ├── fsm_core_template.v \# The Verilog Template  
│   └── fsm_full_template.xlsx      \# The Excel State Table Template
└── Simulation/             \# Testbenches  
    └── tb_top_level.v      \# Verilog Testbench
```
## **🔧 How to Use**

### **Phase 1: Define Your Logic (Software)**

1. Open Tools/fsm_full_template.xlsx, use it as a template to make another file fsm_logic.xlsx(example) and define your state table (Only Next State, Output required) in it.

Note: unused states and inputs will be handled, just keep them empty.

2. Run the generator script: (run python in directory Tools)
   ```
   python fsm_generator.py fsm_logic.xlsx
   ```

4. This will generate a new fsm_core.v file with your logic.

### **Phase 2: Implementation (Hardware)**

1. Open **Altera Quartus II**.  
2. Create a project and add all files from the Hardware directory.  
3. Assign pins according to the **Pin Map** (see Docs/Mano_Machine.pdf).  
4. Compile and upload the .svf file to the Helium CPLD board using **UrJTAG**.

### **Phase 3: Validation (Debug)**

1. **Reset:** Press SW5 to initialize the system.  
2. **Run:** Set SW1 UP for 1Hz execution.  
3. **Step:** Set SW1 DOWN to freeze. Press SW4 to advance one state.

## **👥 Author**

* **\[Adeeb Ali Islam\]** 


## **🙏 Acknowledgements**

I would like to thank our TAs for their support with the Helium board hardware. I also utilized AI assistance (Google Gemini) for Verilog syntax debugging and clarifying asynchronous reset logic.
