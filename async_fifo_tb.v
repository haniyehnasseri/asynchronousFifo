`timescale 1ns/1ns
//
// Testbench
//
module async_fifo_tb;

  parameter DSIZE = 8;
  parameter ASIZE = 4;

  reg [DSIZE-1:0] rdata;
  reg wfull;
  reg rempty;
  reg [DSIZE-1:0] wdata;
  reg winc, wclk, wrst_n;
  reg rinc, rclk, rrst_n;

  // Model a queue for checking data
  reg [DSIZE-1:0] verif_data_q[0:64];
  reg [DSIZE-1:0] verif_wdata;


  // Instantiate the FIFO
  async_fifo #(DSIZE, ASIZE) dut (.*);

  initial begin
    wclk = 1'b0;
    rclk = 1'b0;

    fork
      forever #10 wclk = ~wclk;
      forever #35 rclk = ~rclk;
    join
  end
  
  integer iter=0, i=0;
  integer idx=0;
  initial begin
    winc = 1'b0;
    wdata = '0;
    wrst_n = 1'b0;
    repeat(5) @(posedge wclk);
    wrst_n = 1'b1;

    for (iter=0; iter<2; iter=iter+1) begin
      for (i=0; i<32; i=i+1) begin
        if(wfull == 0)
        begin
          @(posedge wclk);
          winc = (i%2 == 0)? 1'b1 : 1'b0;
          if (winc) begin
            wdata = $urandom % 200;
            $display("wdata=%d", wdata);
            verif_data_q[idx]=(wdata);
            idx=idx+1;
          end
        end
      end
      winc = 1'b0;
      #1000;
    end
  end
  integer iter2=0, i2=0;
  integer idx2 = 0;
  initial begin
    rinc = 1'b0;

    rrst_n = 1'b0;
    repeat(8) @(posedge rclk);
    rrst_n = 1'b1;

    for (iter2=0; iter2<2; iter2=iter2+1) begin
      for (i2=0; i2<32; i2=i2+1) begin
        if (rempty == 0)
        begin
          rinc = (i%2 == 0)? 1'b1 : 1'b0;
          @(posedge rclk)
          if (rinc) begin
            verif_wdata = verif_data_q[idx2];
            // Check the rdata against modeled wdata
            $display("Checking rdata: expected wdata = %d, rdata = %d", verif_wdata, rdata);
            if(rdata === verif_wdata)
              $display("verif_wdata and rdata are equal");
            else 
              $error("Checking failed: expected wdata = %d, rdata = %d, idx2 = %d", verif_wdata, rdata, idx2);
            idx2=idx2+1;
          end
        end
      end
      rinc = 1'b0;
      #1000;
    end

    $stop;
  end

endmodule
