
module top_level(
    // Physical Pin Declarations
    // Inputs (from Helium Board)
    input clk_1hz,          // Pin 43: Onboard 1Hz Clock
    input reset_button,     // Pin 6 (SW3): Global Asynchronous Reset
    input mode_switch,      // Pin 4 (SW1): Run=0, Step=1
    input [1:0] fsm_input_x,  // Pin 5 (SW2), Pin 8 (SW4)
    input step_button,      // Pin 14 (SW8): Single-Step button
    
    // Outputs (to Helium Board & Breadboard)
    output [6:0] segments_out, // Pins 16,18,19,34,37,39,40 (To 7-Seg)
    output [3:0] fsm_output_z  // Pin 33 (LED8), Pin 31 (LED7)
  );

  // Internal Wires
  
  wire fsm_enable_wire;  
  wire [3:0] state_wire; 

  // FSM Core 
  fsm_core FSM_INSTANCE (
    .clk(clk_1hz),
    .clk_enable(fsm_enable_wire), // <-- connected to debugger's output
    .reset(reset_button),
    .x_in(fsm_input_x),         
    .z_out(fsm_output_z),       // --> connected to physical LEDs
    .current_state_debug(state_wire) // --> connected to decoder's input
  );

  // Debugger
  debugger DEBUGGER_INSTANCE (
    .clk_1hz(clk_1hz),
    .reset(reset_button),
    .mode_switch_raw(mode_switch),
    .step_button_raw(step_button),
    .fsm_clk_enable(fsm_enable_wire) // <-- connected to FSM's input
  );
  
  // 7-Segment Decoder
  decoder_7seg DECODER_INSTANCE (
    .bcd_in(state_wire),      // <-- connected to FSM's debug output
    .segments_out(segments_out) // --> connected to 7 Seg output
  );

endmodule