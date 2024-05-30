/*
Based on paper: 
R. Murillo, A. A. Del Barrio and G. Botella, "Customized Posit Adders and Multipliers using the FloPoCo Core Generator," 2020 IEEE International Symposium on Circuits and Systems (ISCAS), 2020, pp. 1-5, 
doi: 10.1109/ISCAS45731.2020.9180771.
*/
module add #(parameter N=16) (
   input wire  i_s_1,
   input wire [N-11:0]  i_sf_1,
   input wire [N-5:0] i_mant_1,
   input wire  i_nzn_1,
   input wire  i_s_2,
   input wire [N-11:0]  i_sf_2,
   input wire [N-5:0] i_mant_2,
   input wire  i_nzn_2,
   output wire o_s,
   output wire [N-10:0]o_sf,
   output wire [N-5:0] o_mant,
   output wire o_guard,
   output wire o_sticky,
   output wire o_nzn
);

 
  wire X_not_zero ;
  wire X_nar ;
  wire Y_not_zero ;
  wire Y_nar ;
  wire check_larger ;
  wire [$clog2(N)+1:0] larger_number ;
  wire [$clog2(N)+1:0] smallest_number ;
  wire [N-3:0] larger_mant ;
  wire [N-3:0] smaller_mant ;
  wire [$clog2(N)+1:0] offset;
  wire shift_saturate;
  wire [$clog2(N):0]mant_offset ;
  wire [N-1:0]input_shifter ;
  wire pad_bit;
  wire [N-1:0] shifted_mant ;
  wire stk_tmp ;
  wire [N-3:0] smaller_mant_sh;
  wire grd_tmp ;
  wire rnd_tmp ;
  wire [N-2:0]add_mant;
  wire grd_bit;
  wire rnd_bit;
  wire stk_bit;
  wire count_type;
  wire [N:0]add_mant_shift ;
  wire [$clog2(N):0]count ;
  wire [(N):0]norm_mant_tmp;
  wire [N-10:0]add_sf ;
  wire is_not_zero ;
  wire is_nar;
  wire Xi_nzn_2;
  wire [N-5:0]norm_mant ;

  assign X_not_zero = i_s_1 | i_nzn_1;
  assign X_nar      = i_s_1 & ~(i_nzn_1);
  assign Y_not_zero = i_s_2 | i_nzn_2;
  assign Y_nar      = i_s_2 & ~(i_nzn_2);

  assign check_larger    = (($signed(i_sf_1))>($signed(i_sf_2))) ?  1 : 0;
  assign larger_number    = (check_larger) ? i_sf_1 : i_sf_2;
  assign smallest_number   = (check_larger) ? i_sf_2 : i_sf_1;
  assign larger_mant  = (check_larger) ? {i_s_1 , (~i_s_1 & X_not_zero) ,i_mant_1} : {i_s_2,(~i_s_2 & Y_not_zero),i_mant_2};
  assign smaller_mant = (check_larger) ? {i_s_2,(~i_s_2 & Y_not_zero),i_mant_2} :{i_s_1 , (~i_s_1 & X_not_zero) ,i_mant_1};

  assign offset         = larger_number - smallest_number;
  assign shift_saturate = (!offset[5]) ? 0 : 1;
  assign mant_offset    = (shift_saturate) ? 16 : offset[4:0];

  assign input_shifter = {smaller_mant, 2'b00};

  assign pad_bit = smaller_mant[N-3];
  right_shifter_sticky_16 #(.N(N)) inst_right_shifter_sticky_16_2
    (  .i_s     (mant_offset),
      .i_in    (input_shifter),
      .i_padbit(pad_bit),
      .o_r     (shifted_mant),
      .o_sticky(stk_tmp)
    );
  assign smaller_mant_sh = shifted_mant[15:2];
  assign grd_tmp         = shifted_mant[1];
  assign rnd_tmp         = shifted_mant[0];



  assign add_mant = {larger_mant[13], larger_mant} + {smaller_mant_sh[13], smaller_mant_sh};
  assign grd_bit  = grd_tmp;
  assign rnd_bit  = rnd_tmp;
  assign stk_bit  = stk_tmp;

  assign count_type     = add_mant[14];
  assign add_mant_shift = {add_mant[13:0], grd_bit , rnd_bit , stk_bit};

  normalizer_16 #(.N(N)) inst_normalizer_16
    ( .i_ozb  (count_type),
      .i_in   (add_mant_shift),
      .o_count(count),
      .o_r  (norm_mant_tmp)
    );

  assign add_sf = {larger_number[5] , larger_number} - ({2'b00 , count}) + 1;

  assign is_not_zero = (count==5'b11111) ? count_type : 1;
  assign is_nar      = X_nar | Y_nar;
  assign Xi_nzn_2      = is_not_zero & ~(is_nar);
  assign o_s        = is_nar | (is_not_zero & add_mant[14]);
  assign o_mant   = norm_mant_tmp[N-1:4];
  assign o_guard         = norm_mant_tmp[3];
  assign o_sticky         = norm_mant_tmp[2] | norm_mant_tmp[1] | norm_mant_tmp[0];
  assign o_sf =  add_sf;
  assign o_nzn = Xi_nzn_2;


endmodule
