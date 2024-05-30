/*
Based on paper: 
R. Murillo, A. A. Del Barrio and G. Botella, "Customized Posit Adders and Multipliers using the FloPoCo Core Generator," 2020 IEEE International Symposium on Circuits and Systems (ISCAS), 2020, pp. 1-5, 
doi: 10.1109/ISCAS45731.2020.9180771.
*/

module normalizer_16 #(parameter N=16) (
	input wire [N:0] i_in,
	input wire i_ozb,
	output wire [$clog2(N):0]o_count,
	output wire [N:0] o_r
);

	wire [N:0] level5 ;
	wire [N:0] level4 ;
	wire count4;
	wire sozb ;
	wire count3 ;
	wire [N:0] level3 ;
	wire count2 ;
	wire [N:0]level2 ;
	wire count1;
	wire [N:0]level1 ;
	wire count0;
	wire [N:0]level0;
	wire [$clog2(N):0]sCount ;

	assign level5 = i_in;
	assign sozb = i_ozb;

	assign count4 = (level5[N:1] == {16{sozb}}) ? 1: 0;
	assign level4 =(!count4) ? level5 : {level5[0],{16{1'b0}}};

	assign count3 = (level4[N:N-7] == {8{sozb}}) ? 1: 0;
	assign level3 = (!count3) ? level4 : {level4[8:0],{8{1'b0}}};

	assign count2 = (level3[N : N-3] == {4{sozb}})? 1 : 0;

	assign level2 = (!count2) ? level3  : {level3[12:0],{4{1'b0}}};
	assign count1 = level2[N:N-1]=={sozb,sozb} ?  1 : 0;

	assign level1 = (!count1) ? level2 : {level2[14:0], 2'b00};

	assign count0 = (level1[N]==sozb) ? 1 : 0;
	assign level0 = (!count0) ? level1 : {level1[15:0],1'b0};

	assign o_r    = level0;
	assign sCount = {count4,count3,count2,count1,count0};
	assign o_count  = sCount;

endmodule 
