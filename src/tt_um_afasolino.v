/*
* Copyright (c) 2024 Your Name
* SPDX-License-Identifier: Apache-2.0
*/
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Salerno, Fisciano (SA), Italy
// Engineer: Andrea Fasolino, Gian Domenico Licciardo
// 
// Module Name: tt_um_afasolino
// 
// 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`default_nettype none

module tt_um_afasolino (
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
//  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
//  assign uio_out = 0;
//  assign uio_oe  = 0;
  localparam  data_buffer_size_bit=8;
  localparam  data_posit_size_bit=16;
  localparam  buffer_size = 4;
  localparam  buffer_size_read = 6;
  reg alu_ready;
  reg [clog2(buffer_size+1)-1:0] wr_data_pointer;
  reg [clog2(buffer_size_read+1)-1:0] rd_data_pointer;
  wire data_input_valid;
  wire [data_posit_size_bit-1:0]data_input_1;
  wire [data_posit_size_bit-1:0]data_input_2;
  wire [data_posit_size_bit-1:0]o_result;
  reg [data_buffer_size_bit-1:0] input_buffer_data_1;
  reg [data_buffer_size_bit-1:0] input_buffer_data_2;
  reg [data_buffer_size_bit-1:0] input_buffer_data_3;
  reg [data_buffer_size_bit-1:0] input_buffer_data_4;
  reg data_valid_sync1;
  reg data_valid_sync2;
  reg read_data_valid_sync1;
  reg read_data_valid_sync2;
  reg read_data;
  wire read_data_valid;
  reg read_data_ready;
  reg [7:0]out_reg;
  assign data_input_valid = uio_in[0]; //Data valid on IO in 0
  assign uio_oe[0]        = 0;
  assign uio_oe[1]        = 1;
  assign data_input_1     = {input_buffer_data_2,input_buffer_data_1};
  assign data_input_2     = {input_buffer_data_4,input_buffer_data_3};
  assign uio_out[1]       = alu_ready;//alu ready on Output 1

  assign read_data_valid = uio_in[2];// Read Data valid on IO in 0
  assign uio_oe[2]       = 0;
  assign uio_out[3]      = read_data_ready;
  assign uio_oe[3]       = 1;
  assign uo_out     = out_reg;
  assign uio_oe[7:4] = 0; 
  assign uio_out[7:4]=0;
  assign uio_out[0]=0;
  assign uio_out[2]=0;
  always@(posedge clk, negedge rst_n)begin
    if(rst_n==0)begin
      data_valid_sync1<=0;
      data_valid_sync2<=0;
      read_data_valid_sync1<=0;
      read_data_valid_sync2<=0;
    end
    else begin
      data_valid_sync1<=data_input_valid;
      data_valid_sync2<=data_valid_sync1;
      read_data_valid_sync1<=read_data_valid;
      read_data_valid_sync2<=read_data_valid_sync1;
    end

  end

  always@(posedge clk, negedge rst_n)begin
    if(rst_n==0)begin
      input_buffer_data_1<=0;
      input_buffer_data_2<=0;
      input_buffer_data_3<=0;
      input_buffer_data_4<=0;
      wr_data_pointer<=0;
      rd_data_pointer<=0;
      alu_ready<=1;
      read_data<=0;
      out_reg<=0;
      read_data_ready<=0;
    end
    else begin
      if(data_valid_sync2==1 && alu_ready==1) begin
        case(wr_data_pointer)
          'd0: begin
            input_buffer_data_1<=ui_in;
            wr_data_pointer<=wr_data_pointer+1;
            alu_ready<=0;
          end
          'd1: begin
            input_buffer_data_2<=ui_in;
            wr_data_pointer<=wr_data_pointer+1;
            alu_ready<=0;
          end
          'd2: begin
            input_buffer_data_3<=ui_in;
            wr_data_pointer<=wr_data_pointer+1;
            alu_ready<=0;
          end
          'd3: begin
            input_buffer_data_4<=ui_in;
            alu_ready<=0;
            read_data<=1;
            read_data_ready<=1;
            rd_data_pointer<=0;
          end

          default:begin
            input_buffer_data_1<=0;
            input_buffer_data_2<=0;
            input_buffer_data_3<=0;
            input_buffer_data_4<=0;
            wr_data_pointer<=0;
            alu_ready<=1;
            read_data_ready<=0;
          end
        endcase
      end
      if(read_data==0)begin
        if(data_valid_sync2==0)begin
          alu_ready<=1;
        end
      end
      else begin
        if(read_data_ready)begin
          case(rd_data_pointer)
            'd0: begin
              out_reg<=data_input_1[7:0];
              if(read_data_valid_sync2==1) begin
                rd_data_pointer<=rd_data_pointer+1;
                read_data_ready<=0;
              end
            end
            'd1: begin
              out_reg<=data_input_1[15:8];
              if(read_data_valid_sync2==1) begin
                rd_data_pointer<=rd_data_pointer+1;
                read_data_ready<=0;
              end
            end
            'd2: begin
              out_reg<=data_input_2[7:0];
              if(read_data_valid_sync2==1) begin
                rd_data_pointer<=rd_data_pointer+1;
                read_data_ready<=0;
              end
            end
            'd3: begin
              out_reg<=data_input_2[15:8];
              if(read_data_valid_sync2==1) begin
                rd_data_pointer<=rd_data_pointer+1;
                read_data_ready<=0;
              end
            end

            'd4: begin
              out_reg<=o_result[7:0];
              if(read_data_valid_sync2==1) begin
                rd_data_pointer<=rd_data_pointer+1;
                read_data_ready<=0;
              end
            end
            'd5: begin
             out_reg<=o_result[15:8];
              if(read_data_valid_sync2==1) begin
                read_data_ready<=0;
                read_data<=0;
                alu_ready<=1;
                wr_data_pointer<=0;
              end
            end
            default:begin
              out_reg<=0;
              alu_ready<=1;
              rd_data_pointer<=0;
              read_data_ready<=0;
            end
          endcase
        end
        else if(read_data_valid_sync2==0)begin
          read_data_ready<=1;
        end
      end
    end
  end


  posit_top_open_hw inst_posit_top(
    .i_in_1(data_input_1),
    .i_in_2(data_input_2),
    .o_res(o_result)
  );








  function integer clog2;
    input integer value;
    begin
      value = value-1;
      for (clog2=0; value>0; clog2=clog2+1)
        value = value>>1;
    end
  endfunction


endmodule
