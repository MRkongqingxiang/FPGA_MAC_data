// Dual-port Ethernet layer-2 transparent bridge
// Forwards frames between eth0 and eth1 without processing higher-layer protocols.
module eth_udp_loop(
    input              sys_clk     , // system clock (unused placeholder)
    input              sys_rst_n   , // system reset, active low
    // eth0 RGMII interface
    input              eth0_rxc    ,
    input              eth0_rx_ctl ,
    input       [3:0]  eth0_rxd    ,
    output             eth0_txc    ,
    output             eth0_tx_ctl ,
    output      [3:0]  eth0_txd    ,
    output             eth0_rst_n  ,
    // eth1 RGMII interface
    input              eth1_rxc    ,
    input              eth1_rx_ctl ,
    input       [3:0]  eth1_rxd    ,
    output             eth1_txc    ,
    output             eth1_tx_ctl ,
    output      [3:0]  eth1_txd    ,
    output             eth1_rst_n
    );

//*********************************************************
//**                        wires
//*********************************************************
// eth0 GMII signals
wire          gmii0_rx_clk;
wire          gmii0_rx_dv;
wire  [7:0]   gmii0_rxd;
wire          gmii0_tx_clk;
reg           gmii0_tx_en;
reg   [7:0]   gmii0_txd;

// eth1 GMII signals
wire          gmii1_rx_clk;
wire          gmii1_rx_dv;
wire  [7:0]   gmii1_rxd;
wire          gmii1_tx_clk;
reg           gmii1_tx_en;
reg   [7:0]   gmii1_txd;

// fifo 0->1
wire  [7:0]   fifo01_rd_data;
wire          fifo01_empty;
wire          fifo01_rd_en;

// fifo 1->0
wire  [7:0]   fifo10_rd_data;
wire          fifo10_empty;
wire          fifo10_rd_en;

assign eth0_rst_n = sys_rst_n;
assign eth1_rst_n = sys_rst_n;

//*********************************************************
//**                  gmii/rgmii convert
//*********************************************************
// eth0
gmii_to_rgmii u_gmii_to_rgmii_0(
    .gmii_rx_clk   (gmii0_rx_clk ),
    .gmii_rx_dv    (gmii0_rx_dv  ),
    .gmii_rxd      (gmii0_rxd    ),
    .gmii_tx_clk   (gmii0_tx_clk ),
    .gmii_tx_en    (gmii0_tx_en  ),
    .gmii_txd      (gmii0_txd    ),

    .rgmii_rxc     (eth0_rxc     ),
    .rgmii_rx_ctl  (eth0_rx_ctl  ),
    .rgmii_rxd     (eth0_rxd     ),
    .rgmii_txc     (eth0_txc     ),
    .rgmii_tx_ctl  (eth0_tx_ctl  ),
    .rgmii_txd     (eth0_txd     )
    );

// eth1
gmii_to_rgmii u_gmii_to_rgmii_1(
    .gmii_rx_clk   (gmii1_rx_clk ),
    .gmii_rx_dv    (gmii1_rx_dv  ),
    .gmii_rxd      (gmii1_rxd    ),
    .gmii_tx_clk   (gmii1_tx_clk ),
    .gmii_tx_en    (gmii1_tx_en  ),
    .gmii_txd      (gmii1_txd    ),

    .rgmii_rxc     (eth1_rxc     ),
    .rgmii_rx_ctl  (eth1_rx_ctl  ),
    .rgmii_rxd     (eth1_rxd     ),
    .rgmii_txc     (eth1_txc     ),
    .rgmii_tx_ctl  (eth1_tx_ctl  ),
    .rgmii_txd     (eth1_txd     )
    );

//*********************************************************
//**                 async fifo eth0 -> eth1
//*********************************************************
assign fifo01_rd_en = ~fifo01_empty;

async_fifo_2048x8b u_async_fifo_0_to_1 (
  .wr_clk (gmii0_rx_clk),            // input
  .wr_rst (~sys_rst_n),              // input
  .wr_en  (gmii0_rx_dv),             // input
  .wr_data(gmii0_rxd),               // input [7:0]
  .wr_full(),                       // output
  .almost_full(),                   // output
  .rd_clk (gmii1_tx_clk),            // input
  .rd_rst (~sys_rst_n),              // input
  .rd_en  (fifo01_rd_en),            // input
  .rd_data(fifo01_rd_data),          // output [7:0]
  .rd_empty(fifo01_empty),           // output
  .almost_empty()                   // output
);

always @(posedge gmii1_tx_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        gmii1_tx_en <= 1'b0;
        gmii1_txd   <= 8'd0;
    end
    else if(!fifo01_empty) begin
        gmii1_tx_en <= 1'b1;
        gmii1_txd   <= fifo01_rd_data;
    end
    else begin
        gmii1_tx_en <= 1'b0;
        gmii1_txd   <= 8'd0;
    end
end

//*********************************************************
//**                 async fifo eth1 -> eth0
//*********************************************************
assign fifo10_rd_en = ~fifo10_empty;

async_fifo_2048x8b u_async_fifo_1_to_0 (
  .wr_clk (gmii1_rx_clk),            // input
  .wr_rst (~sys_rst_n),              // input
  .wr_en  (gmii1_rx_dv),             // input
  .wr_data(gmii1_rxd),               // input [7:0]
  .wr_full(),                       // output
  .almost_full(),                   // output
  .rd_clk (gmii0_tx_clk),            // input
  .rd_rst (~sys_rst_n),              // input
  .rd_en  (fifo10_rd_en),            // input
  .rd_data(fifo10_rd_data),          // output [7:0]
  .rd_empty(fifo10_empty),           // output
  .almost_empty()                   // output
);

always @(posedge gmii0_tx_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        gmii0_tx_en <= 1'b0;
        gmii0_txd   <= 8'd0;
    end
    else if(!fifo10_empty) begin
        gmii0_tx_en <= 1'b1;
        gmii0_txd   <= fifo10_rd_data;
    end
    else begin
        gmii0_tx_en <= 1'b0;
        gmii0_txd   <= 8'd0;
    end
end

endmodule
