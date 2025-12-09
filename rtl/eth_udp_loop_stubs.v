`timescale 1ns/1ps
// Stub declarations for external modules referenced by eth_udp_loop.
// Replace with real implementations for full functionality.

module gmii_to_rgmii(
    input        gmii_rx_clk,
    input        gmii_rx_dv,
    input  [7:0] gmii_rxd,
    input        gmii_tx_clk,
    output       gmii_tx_en,
    output [7:0] gmii_txd,
    input        rgmii_rxc,
    input        rgmii_rx_ctl,
    input  [3:0] rgmii_rxd,
    output       rgmii_txc,
    output       rgmii_tx_ctl,
    output [3:0] rgmii_txd
);
    assign gmii_tx_en  = 1'b0;
    assign gmii_txd    = 8'h00;
    assign rgmii_txc   = gmii_tx_clk;
    assign rgmii_tx_ctl= 1'b0;
    assign rgmii_txd   = 4'h0;
endmodule

module arp #(
    parameter BOARD_MAC = 48'h0,
    parameter BOARD_IP  = 32'h0,
    parameter DES_MAC   = 48'h0,
    parameter DES_IP    = 32'h0
)(
    input         rst_n,
    input         gmii_rx_clk,
    input         gmii_rx_dv,
    input  [7:0]  gmii_rxd,
    input         gmii_tx_clk,
    output        gmii_tx_en,
    output [7:0]  gmii_txd,
    output        arp_rx_done,
    output        arp_rx_type,
    output [47:0] src_mac,
    output [31:0] src_ip,
    output        arp_tx_en,
    output        arp_tx_type,
    input  [47:0] des_mac,
    input  [31:0] des_ip,
    output        tx_done
);
    assign gmii_tx_en  = 1'b0;
    assign gmii_txd    = 8'h00;
    assign arp_rx_done = 1'b0;
    assign arp_rx_type = 1'b0;
    assign src_mac     = 48'h0;
    assign src_ip      = 32'h0;
    assign arp_tx_en   = 1'b0;
    assign arp_tx_type = 1'b0;
    assign tx_done     = 1'b0;
endmodule

module icmp #(
    parameter BOARD_MAC = 48'h0,
    parameter BOARD_IP  = 32'h0,
    parameter DES_MAC   = 48'h0,
    parameter DES_IP    = 32'h0
)(
    input         rst_n,
    input         gmii_rx_clk,
    input         gmii_rx_dv,
    input  [7:0]  gmii_rxd,
    input         gmii_tx_clk,
    output        gmii_tx_en,
    output [7:0]  gmii_txd,
    output        rec_pkt_done,
    output        rec_en,
    output [7:0]  rec_data,
    output [15:0] rec_byte_num,
    input         tx_start_en,
    input  [7:0]  tx_data,
    input  [15:0] tx_byte_num,
    input  [47:0] des_mac,
    input  [31:0] des_ip,
    output        tx_done,
    output        tx_req
);
    assign gmii_tx_en   = 1'b0;
    assign gmii_txd     = 8'h00;
    assign rec_pkt_done = 1'b0;
    assign rec_en       = 1'b0;
    assign rec_data     = 8'h00;
    assign rec_byte_num = 16'h0;
    assign tx_done      = 1'b0;
    assign tx_req       = 1'b0;
endmodule

module udp #(
    parameter BOARD_MAC = 48'h0,
    parameter BOARD_IP  = 32'h0,
    parameter DES_MAC   = 48'h0,
    parameter DES_IP    = 32'h0
)(
    input         rst_n,
    input         gmii_rx_clk,
    input         gmii_rx_dv,
    input  [7:0]  gmii_rxd,
    input         gmii_tx_clk,
    output        gmii_tx_en,
    output [7:0]  gmii_txd,
    output        rec_pkt_done,
    output        rec_en,
    output [7:0]  rec_data,
    output [15:0] rec_byte_num,
    input         tx_start_en,
    input  [7:0]  tx_data,
    input  [15:0] tx_byte_num,
    input  [47:0] des_mac,
    input  [31:0] des_ip,
    output        tx_done,
    output        tx_req
);
    assign gmii_tx_en   = 1'b0;
    assign gmii_txd     = 8'h00;
    assign rec_pkt_done = 1'b0;
    assign rec_en       = 1'b0;
    assign rec_data     = 8'h00;
    assign rec_byte_num = 16'h0;
    assign tx_done      = 1'b0;
    assign tx_req       = 1'b0;
endmodule

module async_fifo_2048x8b(
    input         wr_clk,
    input         wr_rst,
    input         wr_en,
    input  [7:0]  wr_data,
    output        wr_full,
    output        almost_full,
    input         rd_clk,
    input         rd_rst,
    input         rd_en,
    output [7:0]  rd_data,
    output        rd_empty,
    output        almost_empty
);
    assign wr_full      = 1'b0;
    assign almost_full  = 1'b0;
    assign rd_data      = 8'h00;
    assign rd_empty     = 1'b1;
    assign almost_empty = 1'b1;
endmodule

module eth_ctrl(
    input         clk,
    input         rst_n,
    input         arp_rx_done,
    input         arp_rx_type,
    output        arp_tx_en,
    output        arp_tx_type,
    input         arp_tx_done,
    input         arp_gmii_tx_en,
    input  [7:0]  arp_gmii_txd,
    input         icmp_tx_start_en,
    input         icmp_tx_done,
    input         icmp_gmii_tx_en,
    input  [7:0]  icmp_gmii_txd,
    input         icmp_rec_en,
    input  [7:0]  icmp_rec_data,
    output        icmp_tx_req,
    output [7:0]  icmp_tx_data,
    input         udp_tx_start_en,
    input         udp_tx_done,
    input         udp_gmii_tx_en,
    input  [7:0]  udp_gmii_txd,
    input  [7:0]  udp_rec_data,
    input         udp_rec_en,
    output        udp_tx_req,
    output [7:0]  udp_tx_data,
    output [7:0]  rec_data,
    output        rec_en,
    input         tx_req,
    input  [7:0]  tx_data,
    output        gmii_tx_en,
    output [7:0]  gmii_txd
);
    assign arp_tx_en   = 1'b0;
    assign arp_tx_type = 1'b0;
    assign icmp_tx_req = 1'b0;
    assign icmp_tx_data= 8'h00;
    assign udp_tx_req  = 1'b0;
    assign udp_tx_data = 8'h00;
    assign rec_data    = 8'h00;
    assign rec_en      = 1'b0;
    assign gmii_tx_en  = 1'b0;
    assign gmii_txd    = 8'h00;
endmodule

