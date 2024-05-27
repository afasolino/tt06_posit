/*
Based on paper: 
R. Murillo, A. A. Del Barrio and G. Botella, "Customized Posit Adders and Multipliers using the FloPoCo Core Generator," 2020 IEEE International Symposium on Circuits and Systems (ISCAS), 2020, pp. 1-5, 
doi: 10.1109/ISCAS45731.2020.9180771.
*/

module right_shifter_sticky_18 #(parameter N=16) (
  input wire [N-2:0] i_in,
  input wire [$clog2(N)-1:0] i_s,
  input wire i_padbit,
  output wire [N-2:0] o_r,
  output wire o_sticky
);


  wire [$clog2(N)-1:0] ps;
  wire [N-2:0] Xpadded;
  wire [N-2:0] level4 ;
  wire stk3 ;
  wire [N-2:0] level3 ;
  wire stk2 ;
  wire [N-2:0] level2 ;
  wire stk1 ;
  wire [N-2:0] level1 ;
  wire stk0 ;
  wire [N-2:0] level0 ;

  assign ps      = i_s;
  assign Xpadded = i_in;
  assign level4  = Xpadded ;
  assign stk3    = ((level4[7:0]!=0 && ps[3]==1)) ? 1 : 0;
  assign level3 =  ps[3]==0 ?  level4 : {{8{i_padbit}},level4[14 : 8]};
  assign stk2 = ((level3[3:0]!=0 && ps[2]==1)|| stk3==1) ? 1 : 0;
  assign level2 =  ps[2]==0 ?  level3 : {{4{i_padbit}},level3[14 : 4]};
  assign stk1 = ((level2[1:0]!=0 && ps[1]==1)|| stk2==1) ? 1 : 0;
  assign level1 =  ps[1]==0 ?  level2 : {{2{i_padbit}},level2[14 : 2]};
  assign stk0 = ((level1[0]!=0 && ps[0]==1)|| stk1==1) ? 1 : 0;
  assign level0 =   ps[0]==0 ?  level1 : {i_padbit,level1[14 : 1]};
  assign o_r = level0;
  assign o_sticky = stk0;




endmodule