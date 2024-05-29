
module Fixed16toPosit16(
    input [15:0]    fixed_number_input,
    output [3:0]    regime_value,
    output          exponent,
    output wire [11:0]   mantissa,
    output          Q,
    output          sign
    );
wire [15:0] fixed_number,fixed_numberaux, fixed_number_neg;

// 2's complement to extract value and sign of the fixed point input
assign fixed_numberaux = {(16){fixed_number_input[15]}} ;
assign fixed_number_neg = fixed_number_input ^ fixed_numberaux ;
assign fixed_number = fixed_number_neg + {15'b000000000000000, fixed_number_input[15]};
assign sign =  fixed_number_input[15];
reg [11:0] mantissa_compl;
wire [3:0] xaux,x;
wire [2:0] xaux2;
wire first_regime_bit;
//
//  zlc value       regime value
//      1,2     ->      2
//      3,4     ->      3
//      5,6     ->      4
//      7,8     ->      5
//      9,10    ->      6
//      11,12   ->      7
//      13,14   ->      8
//      15      ->      9
//  
//  regime value -  2   =   {y2,y1,y0}
//
//  x3  x2  x1  x0  |   y2  y1  y0
//  0   0   0   0   |   0   0   0
//  0   0   0   1   |   0   0   0
//  0   0   1   0   |   0   0   1
//  0   0   1   1   |   0   0   1
//  0   1   0   0   |   0   1   0
//  0   1   0   1   |   0   1   0
//  0   1   1   0   |   0   1   1
//  0   1   1   1   |   0   1   1
//  1   0   0   0   |   1   0   0
//  1   0   0   1   |   1   0   0
//  1   0   1   0   |   1   0   1
//  1   0   1   1   |   1   0   1
//  1   1   0   0   |   1   1   0
//  1   1   0   1   |   1   1   0
//  1   1   1   0   |   1   1   1
//  1   1   1   1   |   1   1   1
//

LeadingZeroCounter_16b LeadingZeroCounter_16b(
    .x(fixed_number),
    .count(x),
    .Q(Q)
    );
    
assign xaux = (sign & first_regime_bit)? x : x-1;
assign xaux2 = ~(xaux[3:1]);
assign regime_value = {1'b1,xaux2};
assign exponent = (first_regime_bit ) ? ~x[0]:x[0];
assign first_regime_bit = (fixed_number_input[14]==0 && sign==1) ? 1 : 0;
assign mantissa = (first_regime_bit) ? -mantissa_compl : mantissa_compl;
always @(*)
case (x)
      4'b0001: begin
                  mantissa_compl <= fixed_number [13:2];  //
               end
      4'b0010: begin
                  mantissa_compl <= fixed_number [12:1];  //
               end
      4'b0011: begin
                  mantissa_compl <= fixed_number [11:0];  //
               end
      4'b0100: begin
                  mantissa_compl <= {fixed_number [10:0],1'b0};  //
               end
      4'b0101: begin
                  mantissa_compl <= {fixed_number [9:0],2'b00};  //
               end
      4'b0110: begin
                  mantissa_compl <= {fixed_number [8:0],3'b000};  //
               end
      4'b0111: begin
                  mantissa_compl <= {fixed_number [7:0],4'b0000};  //
               end
      4'b1000: begin
                  mantissa_compl <= {fixed_number [6:0],5'b00000};  //
               end
      4'b1001: begin
                  mantissa_compl <= {fixed_number [5:0],6'b000000};  //
               end
      4'b1010: begin
                  mantissa_compl <= {fixed_number [4:0],7'b0000000};  //
               end
      4'b1011: begin
                  mantissa_compl <= {fixed_number [3:0],8'b00000000};  //
               end
      4'b1100: begin
                  mantissa_compl <= {fixed_number [2:0],9'b000000000};  //
               end
      4'b1101: begin
                  mantissa_compl <= {fixed_number [1:0],10'b0000000000};  //
               end
      4'b1110: begin
                  mantissa_compl <= {fixed_number [0],11'b00000000000};  //
                end
      default: begin
                  mantissa_compl <= {12'b00000000000};  //
                end
   endcase
				
endmodule
