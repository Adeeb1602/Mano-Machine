//For Common Anode (For Common Cathode everything would be complimented)
module decoder_7seg(
    input [3:0] bcd_in,
    output reg [6:0] segments_out
  );

  always @(*) begin
    case (bcd_in)
      //           abcdefg
      4'd0: segments_out = 7'b0000001; // 0
      4'd1: segments_out = 7'b1001111; // 1
      4'd2: segments_out = 7'b0010010; // 2
      4'd3: segments_out = 7'b0000110; // 3
      4'd4: segments_out = 7'b1001100; // 4
      4'd5: segments_out = 7'b0100100; // 5
      4'd6: segments_out = 7'b0100000; // 6
      4'd7: segments_out = 7'b0001111; // 7
      4'd8: segments_out = 7'b0000000; // 8
      4'd9: segments_out = 7'b0000100; // 9
      4'd10: segments_out = 7'b0001000; // A
      4'd11: segments_out = 7'b1100000; // b
      4'd12: segments_out = 7'b0110001; // C
      4'd13: segments_out = 7'b1000010; // d
      4'd14: segments_out = 7'b0110000; // E
      4'd15: segments_out = 7'b0111000; // F
      default: segments_out = 7'b1111111; // Off
    endcase
  end

endmodule