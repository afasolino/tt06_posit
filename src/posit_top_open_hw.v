module posit_top_open_hw #(parameter  N=16) (
  input wire [N-1:0] i_in_1,
  input wire [N-1:0] i_in_2,
  output wire [N-1:0] o_res
);





  wire [$clog2(N)+1:0]w_sf_1;
  wire [N-5:0] w_mant_1;

  wire [$clog2(N)+1:0]w_sf_2;
  wire [N-5:0] w_mant_2;

  wire [N-10:0]w_sf_res_add;
  wire [N-5:0]w_mant_res_add;
  wire w_guard_res_add;
  wire w_sticky_res_add;
  wire w_nzn_res_add;
  wire w_Q_1;
  wire w_sign_1;
  wire w_exponent_1;
  wire [3:0]w_regime_value_1;
  wire w_Q_2;
  wire w_sign_2;
  wire w_exponent_2;
  wire [3:0]w_regime_value_2;




Fixed16toPosit16 instFixed16toPosit16_1(
  .fixed_number_input(i_in_1),
  .Q                 (w_Q_1),
  .sign              (w_sign_1),
  .exponent          (w_exponent_1),
  .mantissa          (w_mant_1),
  .regime_value      (w_regime_value_1)
  );

Fixed16toPosit16 instFixed16toPosit16_2(
  .fixed_number_input(i_in_2),
  .Q                 (w_Q_2),
  .sign              (w_sign_2),
  .exponent          (w_exponent_2),
  .mantissa          (w_mant_2),
  .regime_value      (w_regime_value_2)
  );

assign w_sf_1 =(!w_sign_1) ? {1'b1, w_regime_value_1,w_exponent_1}: {1'b1, w_regime_value_1,~w_exponent_1} ;
assign w_sf_2 =(!w_sign_2) ? {1'b1, w_regime_value_2,w_exponent_2}:  {1'b1, w_regime_value_2,~w_exponent_2};

  add #(.N(N)) inst_add(
    .i_s_1   (w_sign_1),
    .i_sf_1  (w_sf_1),
    .i_mant_1(w_mant_1),
    .i_nzn_1 (~w_Q_1),
    .i_sf_2  (w_sf_2),
    .i_mant_2(w_mant_2),
    .i_nzn_2 (~w_Q_2),
    .i_s_2   (w_sign_2),
    .o_nzn   (w_nzn_res_add),
    .o_s     (w_s_res_add),
    .o_sticky(w_sticky_res_add),
    .o_guard (w_guard_res_add),
    .o_sf    (w_sf_res_add),
    .o_mant  (w_mant_res_add)


  );




  data_posit_encoder #(.N(N)) inst_data_posit_encoder
    (  .i_mant  (w_mant_res_add),
      .i_guard (w_guard_res_add),

      .i_nzn   (w_nzn_res_add),
      .i_sf(w_sf_res_add),
      .i_s     (w_s_res_add),
      .i_sticky(w_sticky_res_add),
      .o_r     (o_res)
    );













endmodule