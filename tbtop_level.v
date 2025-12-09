`timescale 1ns / 1ps

module tb_top_level;

    // 1. Inputs
    reg clk_1hz;
    reg reset_button_raw;
    reg mode_switch_raw;
    reg [1:0] fsm_input_x_raw;
    reg step_button_raw;

    // 2. Outputs
    wire [3:0] fsm_output_z;
    wire [6:0] segments_out;

    // 3. Instantiate the Device Under Test (DUT)
    //
    // *** THIS IS THE FIXED SECTION ***
    //
    top_level DUT (
        .clk_1hz(clk_1hz),
        .reset_button(reset_button_raw),   // Connect to "reset_button"
        .mode_switch(mode_switch_raw),     // Connect to "mode_switch"
        .fsm_input_x(fsm_input_x_raw),     // <-- FIX: Connect the 2-bit vector directly
        .step_button(step_button_raw),     // Connect to "step_button"
        
        .fsm_output_z(fsm_output_z),
        .segments_out(segments_out)
    );
    // *** END OF FIX ***

    // 4. Create the Clock
    always begin
        #5 clk_1hz = ~clk_1hz;
    end
    
    // 5. The Test Script
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_top_level);
        
        // Start with all switches UP (logic '1')
        clk_1hz = 0;
        reset_button_raw = 1'b1;
        mode_switch_raw  = 1'b1; // Start in RUN mode
        fsm_input_x_raw  = 2'b11; // Input = 11 (Hold)
        step_button_raw  = 1'b1;
        
        $display("--- Test Start ---");
        
        // --- Test 1: Reset the System ---
        $display("T= %0t: Pulsing Reset (SW5 DOWN)...", $time);
        reset_button_raw = 1'b0; // Press reset
        #100; // Hold for 100ns
        reset_button_raw = 1'b1; // Release reset
        #100;
        // At this point, the FSM state should be S0.

        // --- Test 2: Test RUN Mode (Gated Counter) ---
        $display("T= %0t: RUN Mode. Setting Input to '01' (Count Up)...", $time);
        fsm_input_x_raw = 2'b01; // Count Up
        #100; // Wait 10 clock cycles
        $display("T= %0t: State should be > S0 now.", $time);
        
        $display("T= %0t: RUN Mode. Setting Input to '00' (Hold)...", $time);
        fsm_input_x_raw = 2'b00; // Hold
        #100; // Wait 10 clock cycles
        $display("T= %0t: State should be frozen.", $time);

        // --- Test 3: Test STEP Mode ---
        $display("T= %0t: Entering STEP Mode (SW1 DOWN)...", $time);
        mode_switch_raw = 1'b0; // Set to STEP mode
        fsm_input_x_raw = 2'b01; // Set input to Count Up
        #100; // Wait... state should be frozen
        
        $display("T= %0t: Pressing STEP button (SW4 DOWN)...", $time);
        step_button_raw = 1'b0; // Press step button
        #100; // Hold button
        $display("T= %0t: Releasing STEP button. State should have advanced by ONE.", $time);
        step_button_raw = 1'b1; // Release
        #100;

        $display("T= %0t: Pressing STEP button again...", $time);
        step_button_raw = 1'b0; // Press step button
        #100;
        $display("T= %0t: Releasing STEP button. State should have advanced by ONE.", $time);
        step_button_raw = 1'b1; // Release
        #100;
        
        $display("--- Test Finished ---");
        $stop;
    end
    
endmodule