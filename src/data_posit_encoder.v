/*
Based on paper: 
R. Murillo, A. A. Del Barrio and G. Botella, "Customized Posit Adders and Multipliers using the FloPoCo Core Generator," 2020 IEEE International Symposium on Circuits and Systems (ISCAS), 2020, pp. 1-5, 
doi: 10.1109/ISCAS45731.2020.9180771.
*/


module data_posit_encoder #( parameter N=16) (
  input wire i_s ,
  input wire [N-10:0]i_sf ,
  input wire [N-5:0]i_mant ,
  input wire i_guard ,
  input wire i_sticky ,
  input wire i_nzn ,
  output wire [N-1:0] o_r
);

  wire rc ;
  wire [$clog2(N):0]rcVect;
  wire [$clog2(N):0] k ;
  wire sgnVect ;
  wire exp ;
  wire ovf ;
  wire [$clog2(N)-1:0] regValue;
  wire regNeg ;
  wire padBit ;
  wire [N-2:0]inputShifter ;
  wire [N-2:0]shiftedPosit ;
  wire stkBit ;
  wire [N-2:0] unroundedPosit ;
  wire lsb ;
  wire rnd ;
  wire stk ;
  wire round;
  wire [N-2:0]roundedPosit ;
  wire [N-2:0]unsignedPosit ;


  assign rc      = i_sf[N-10];
  assign rcVect  = {5{rc}};
  assign k       =  i_sf[5:1] ^ rcVect;
  assign sgnVect = i_s;
  assign exp = i_sf[0] ^ sgnVect;

  assign ovf      = (k>13) ? 1 :0;
  assign regValue = (!ovf) ? k[3:0] : 4'b1110;

  assign regNeg       = i_s ^ rc;
  assign padBit       = ~(regNeg);
  assign inputShifter = {regNeg, exp , i_mant, i_guard};
  right_shifter_sticky_18 #(.N(N))  inst_right_shifter_sticky_18
    ( .i_s(regValue),
      .i_in(inputShifter),
      .i_padbit(padBit),
      .o_r     (shiftedPosit),
      .o_sticky(stkBit)
    );
  
  assign unroundedPosit = {padBit, shiftedPosit[N-2:1]};

  assign lsb = shiftedPosit[1];
  assign rnd = shiftedPosit[0];
  assign stk = stkBit | i_sticky;
  assign round = rnd & (lsb | stk | ovf);
  assign roundedPosit = unroundedPosit + {14'd0,round};
  
  assign unsignedPosit = (i_nzn) ? roundedPosit : 0;
  assign o_r = { i_s  ,unsignedPosit};



endmodule
