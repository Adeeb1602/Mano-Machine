`timescale 1ns / 1ps

module tb_counter_fsm;

    // 1. Inputs
    reg clk_1hz;
    reg reset_button_raw;
    reg mode_switch_raw;
    reg [1:0] fsm_input_x_raw; 
    reg step_button_raw;

    // 2. Outputs
    wire [3:0] fsm_output_z;
    wire [6:0] segments_out;

    top_level DUT (
        .clk_1hz(clk_1hz),
        .reset_button(reset_button_raw),
        .mode_switch(mode_switch_raw),
        .fsm_input_x(fsm_input_x_raw),
        .step_button(step_button_raw),
        .fsm_output_z(fsm_output_z),
        .segments_out(segments_out)
    );

    always begin
        #5 clk_1hz = ~clk_1hz;
    end
    
    //  The Test Script
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_counter_fsm);
        
        
        clk_1hz = 0;
        reset_button_raw = 1'b1;
        mode_switch_raw  = 1'b1; 
        fsm_input_x_raw  = 2'b00; 
        step_button_raw  = 1'b1;
        
        $display("--- Counter FSM Test Start ---");
        
        //Test 1
        $display("T= %0t: Resetting System...", $time);
        reset_button_raw = 1'b0; 
        #100;
        reset_button_raw = 1'b1; 
        #100;

        //Test 2
        $display("T= %0t: Testing Count UP (Input 01)...", $time);
        fsm_input_x_raw = 2'b01; 
        #400; 
        
        //Test 3
        $display("T= %0t: Testing HOLD (Input 00)...", $time);
        fsm_input_x_raw = 2'b00;
        #200; 

        // Test 4
        $display("T= %0t: Testing Count DOWN (Input 10)...", $time);
        fsm_input_x_raw = 2'b10;
        #400; 

        // Test 5
        $display("T= %0t: Testing Soft Reset (Input 11)...", $time);
        fsm_input_x_raw = 2'b11;
        #100; 
        
        $display("--- Test Finished ---");
        $stop;
    end
    
endmodule