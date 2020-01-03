//
// Write pointer to read clock synchronizer
//
module sync_w2r
#(
  parameter ADDRSIZE = 4
)
(
  input  reg rclk, rrst_n,
  input  reg [ADDRSIZE:0] wptr,
  output reg [ADDRSIZE:0] rq2_wptr
);

  reg [ADDRSIZE:0] rq1_wptr;

  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      {rq2_wptr,rq1_wptr} <= {2*(ADDRSIZE + 1){1'b0}};
    else
      {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};

endmodule
