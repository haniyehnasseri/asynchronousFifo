//
// Top level wrapper
//
module async_fifo
#(
  parameter DSIZE = 8,
  parameter ASIZE = 4
 )
(
  input  reg winc, wclk, wrst_n,
  input  reg rinc, rclk, rrst_n,
  input  reg [DSIZE-1:0] wdata,

  output reg [DSIZE-1:0] rdata,
  output reg wfull,
  output reg rempty
);

  reg [ASIZE-1:0] waddr, raddr;
  reg [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w sync_r2w (.*);
  sync_w2r sync_w2r (.*);
  fifomem #(DSIZE, ASIZE) fifomem (.*);
  rptr_empty #(ASIZE) rptr_empty (.*);
  wptr_full #(ASIZE) wptr_full (.*);

endmodule