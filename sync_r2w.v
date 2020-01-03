//
// Read pointer to write clock synchronizer
//
module sync_r2w
#(
  parameter ADDRSIZE = 4
)
(
  input  reg wclk, wrst_n,
  input  reg [ADDRSIZE:0] rptr,
  output reg [ADDRSIZE:0] wq2_rptr
);

  reg [ADDRSIZE:0] wq1_rptr;

  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wq2_rptr,wq1_rptr} <= {2*(ADDRSIZE + 1){1'b0}};
    else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};

endmodule