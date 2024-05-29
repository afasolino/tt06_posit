
module LeadingZeroCounter_16b(
    input  wire [15:0] x,
    output wire [3:0] count,
    output wire Q
    );

wire [3:0] auxa;
wire [7:0] auxz;
wire [1:0] auxcount;

genvar k;
generate
  for (k=0; k < 4; k=k+1)
  begin: NLC_generation
     NLC_16b NLC (.x(x[15-4*k : 12-4*k]),
              .a(auxa[k]),
              .z(auxz[2*k+1 : 2*k])
              );
  end
endgenerate

BNE_16b BNEncoder (.a(auxa), 
               .Q(Q),
               .y(auxcount[1 : 0]));

assign count[3 : 2] = auxcount;

Mux_LZC_16b Mux (.i0(auxz[1:0]), 
             .i1(auxz[3:2]), 
             .i2(auxz[5:4]), 
             .i3(auxz[7:6]), 
             .s(auxcount),
             .o(count[1 : 0])
             );

endmodule


module BNE_16b(
    input  wire [3:0] a,    
    output  wire  Q,    
    output  wire [1:0] y    
    );


 assign Q = a[0] & a[1] & a[2] & a[3];
 assign y[1] = a[0] & a[1];
 assign y[0] = a[0] & (!a[1] | a[2] );
endmodule

module NLC_16b (
    input  wire [3:0] x,    // Dedicated inputs 
    output  wire  a,    // Dedicated inputs 
    output  wire [1:0] z    // Dedicated inputs 
    );

wire aprimo,z1,z0,aux1;
assign aprimo = x[3] | x[2] | x[1] | x[0];
assign a = ! aprimo;
assign z1 = x[3] | x[2];
assign z[1] = ! z1; 
assign z0 = aux1 | x[3];
assign aux1 = x[1] & ! (x[2]);
assign z[0] = ! z0;

endmodule 

module Mux_LZC_16b(
    input wire [1:0] i0 ,
    input wire [1:0] i1  ,
    input wire [1:0] i2  ,
    input wire [1:0] i3  ,
    input wire [1:0]  s  ,
    output reg [1:0] o  
    );

always @(*)
  case (s)
     3'b000: o = i0;
     3'b001: o = i1;
     3'b010: o = i2;
     3'b011: o = i3;

  endcase
      
endmodule
