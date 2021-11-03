// @lang=sva @ts=2
module register_file_property_suite(clk, reset_n, wr_en, wr_addr, rd_addr_a, rd_addr_b, d_in, d_out_a, d_out_b, reg_file);
  input logic clk, reset_n, wr_en;
  input logic [2:0] wr_addr, rd_addr_a, rd_addr_b;
  input logic [7:0] d_in, d_out_a, d_out_b;
  input logic [0:7][7:0] reg_file;

  // property definitions
  property write_on_wr_en;
    @(posedge clk) disable iff(!reset_n) wr_en |=> reg_file[$past(wr_addr)] == $past(d_in);
  endproperty

  property no_en_no_write;
    @(posedge clk) disable iff(!reset_n) !wr_en |=> $stable(reg_file);
  endproperty

  property rd_a;
    d_out_a == reg_file[rd_addr_a];
  endproperty

  property rd_b;
    d_out_b == reg_file[rd_addr_b];
  endproperty

  // make assertion on properties to be checked
  a_write_on_wr_en: assert property ( write_on_wr_en );
  a_no_en_no_write: assert property ( no_en_no_write );
  a_rd_a: assert property (rd_a);
  a_rd_b: assert property (rd_b);
endmodule

// bind the verification IP to the design
bind register_file register_file_property_suite register_file_property_suite_inst(.*);
