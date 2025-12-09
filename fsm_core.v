
module fsm_core(
    input clk,
    input clk_enable,
    input reset, 
    input [1:0] x_in,
    output [3:0] z_out, 
    output [3:0] current_state_debug
  );

  // State Definitions 
  parameter S0 = 4'd0;
  parameter S1 = 4'd1;
  parameter S2 = 4'd2;
  parameter S3 = 4'd3;
  parameter S4 = 4'd4;
  parameter S5 = 4'd5;
  parameter S6 = 4'd6;
  parameter S7 = 4'd7;
  parameter S8 = 4'd8;
  parameter S9 = 4'd9;
  parameter S10 = 4'd10;
  parameter S11 = 4'd11;
  parameter S12 = 4'd12;
  parameter S13 = 4'd13;
  parameter S14 = 4'd14;
  parameter S15 = 4'd15;

  // State Registers
  reg [3:0] present_state;
  reg [3:0] next_state;
  reg [3:0] z; 

  // State Updation when clock available(the clock signal[clk_enable] will be controlled by debugger)
  always @(posedge clk or negedge reset) begin
    if (reset == 1'b0) 
      present_state <= S0;
    else if (clk_enable) 
      present_state <= next_state;
  end
  
  // The whole FSM in form of case blocks and if-else
  always @(*) begin
    // Safe Defaults
    next_state = S0;
    z = 4'b0000; 

    case (present_state)
        
        //PYTHON-GEN-START
		S0: begin
			case (x_in)
				2'b00: begin next_state = S0; z = 4'b0000; end
				2'b01: begin next_state = S0; z = 4'b0000; end
				2'b10: begin next_state = S1; z = 4'b0000; end
				2'b11: begin next_state = S2; z = 4'b0000; end
				default: begin next_state = S0; z = 4'b0000; end
			endcase
		end

		S1: begin
			case (x_in)
				2'b00: begin next_state = S1; z = 4'b0000; end
				2'b01: begin next_state = S1; z = 4'b0000; end
				2'b10: begin next_state = S2; z = 4'b0000; end
				2'b11: begin next_state = S3; z = 4'b0000; end
				default: begin next_state = S0; z = 4'b0000; end
			endcase
		end

		S2: begin
			case (x_in)
				2'b00: begin next_state = S2; z = 4'b0000; end
				2'b01: begin next_state = S2; z = 4'b0000; end
				2'b10: begin next_state = S3; z = 4'b0000; end
				2'b11: begin next_state = S4; z = 4'b0000; end
				default: begin next_state = S0; z = 4'b0000; end
			endcase
		end

		S3: begin
			case (x_in)
				2'b00: begin next_state = S0; z = 4'b0001; end
				2'b01: begin next_state = S0; z = 4'b0001; end
				2'b10: begin next_state = S0; z = 4'b0001; end
				2'b11: begin next_state = S0; z = 4'b0001; end
				default: begin next_state = S0; z = 4'b0000; end
			endcase
		end

		S4: begin
			case (x_in)
				2'b00: begin next_state = S0; z = 4'b0011; end
				2'b01: begin next_state = S0; z = 4'b0011; end
				2'b10: begin next_state = S0; z = 4'b0011; end
				2'b11: begin next_state = S0; z = 4'b0011; end
				default: begin next_state = S0; z = 4'b0000; end
			endcase
		end

        //PYTHON-GEN-END

        
        // To prevent lock out for unused states
        default: begin 
            next_state = S0;
            z = 4'b0000; 
        end
    endcase
  end
  
  assign current_state_debug = present_state;
  assign z_out = z;

endmodule