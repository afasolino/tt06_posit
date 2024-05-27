/*
Based on paper: 
R. Murillo, A. A. Del Barrio and G. Botella, "Customized Posit Adders and Multipliers using the FloPoCo Core Generator," 2020 IEEE International Symposium on Circuits and Systems (ISCAS), 2020, pp. 1-5, 
doi: 10.1109/ISCAS45731.2020.9180771.
*/

module right_shifter_sticky_16 #(parameter N=16) (
  input wire [N-1:0] i_in,
  input wire [$clog2(N):0] i_s,
  input wire i_padbit,
  output wire [N-1:0] o_r,
  output wire o_sticky
);


  wire [$clog2(N):0] ps;
  wire [N-1:0] Xpadded;
  wire [N-1:0] level5;
  wire stk4 ;
  wire [N-1:0] level4 ;
  wire stk3 ;
  wire [N-1:0] level3 ;
  wire stk2 ;
  wire [N-1:0] level2 ;
  wire stk1 ;
  wire [N-1:0] level1 ;
  wire stk0 ;
  wire [N-1:0] level0 ;

  assign ps      = i_s;
  assign Xpadded = i_in;
  assign level5  = Xpadded;
  assign stk4    = (level5!=0 && ps[4]==1) ?  1 : 0;
  assign level4  = (ps[4]==0) ?  level5 : {16{i_padbit}} ;
  assign stk3    = ((level4[7:0]!=0 && ps[3]==1)|| stk4==1) ? 1 : 0;
  assign level3 =  ps[3]==0 ?  level4 : {{8{i_padbit}},level4[15 : 8]};
  assign stk2 = ((level3[3:0]!=0 && ps[2]==1)|| stk3==1) ? 1 : 0;
  assign level2 =  ps[2]==0 ?  level3 : {{4{i_padbit}},level3[15 : 4]};
  assign stk1 = ((level2[1:0]!=0 && ps[1]==1)|| stk2==1) ? 1 : 0;
  assign level1 =  ps[1]==0 ?  level2 : {{2{i_padbit}},level2[15 : 2]};
  assign stk0 = ((level1[0]!=0 && ps[0]==1)|| stk1==1) ? 1 : 0;
  assign level0 =   ps[0]==0 ?  level1 : {i_padbit,level1[15 : 1]};
  assign o_r = level0;
  assign o_sticky = stk0;




endmodule