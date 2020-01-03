//
// FIFO memory
//
module fifomem
#(
  parameter DATASIZE = 8, // Memory data word width
  parameter ADDRSIZE = 4  // Number of mem address bits
)
(
  input  reg winc, wfull, wclk,
  input  reg [ADDRSIZE-1:0] waddr, raddr,
  input  reg [DATASIZE-1:0] wdata,
  output [DATASIZE-1:0] rdata
);

  // RTL Verilog memory model
  localparam DEPTH = 1<<ADDRSIZE;

  reg [DATASIZE-1:0] mem [0:DEPTH-1];

  assign rdata = mem[raddr];

  always @(posedge wclk)
    if (winc && !wfull)
      mem[waddr] <= wdata;
    else
      mem[waddr] <= {DATASIZE{1'b0}};

endmodule