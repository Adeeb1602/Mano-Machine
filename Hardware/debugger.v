
module debugger(
    input clk_1hz,          
    input reset,            
    input mode_switch_raw, 
    input step_button_raw,  
    output reg fsm_clk_enable 
);

    wire button_pressed;
    assign button_pressed = ~step_button_raw; 

    // Edge Detector
    // This turns a long press into a single 1-cycle pulse.
    
    reg button_pressed_prev; 
    wire single_pulse;

    always @(posedge clk_1hz or negedge reset) begin
        if (reset == 1'b0) 
            button_pressed_prev <= 1'b0;
        else
            button_pressed_prev <= button_pressed;
    end
    
    //Edge Detection
    assign single_pulse = button_pressed & ~button_pressed_prev;

    //Decides whether in Run Mode or Step Mode
    always @(*) begin
        //In Run Mode
        if (mode_switch_raw == 1'b1) 
            fsm_clk_enable = 1'b1;     
        else // In Step Mode
            fsm_clk_enable = single_pulse; 
    end

endmodule