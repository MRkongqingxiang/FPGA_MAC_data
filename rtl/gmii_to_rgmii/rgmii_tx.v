module rgmii_tx(
    //GMII发送端口
    input              gmii_tx_clk , //GMII发送时钟    
    input              gmii_tx_en  , //GMII输出数据有效信号
    input       [7:0]  gmii_txd    , //GMII输出数据        
    
    //RGMII发送端口
    output             rgmii_txc   , //RGMII发送数据时钟    
    output             rgmii_tx_ctl, //RGMII输出数据有效信号
    output      [3:0]  rgmii_txd     //RGMII输出数据     
    );

//*****************************************************
//**                    main code
//*****************************************************

assign rgmii_txc = gmii_tx_clk;

//输出双沿采样寄存器 (rgmii_tx_ctl)

GTP_ODDR_E1 #(
    .GRS_EN("TRUE"),
    .ODDR_MODE("SAME_EDGE"),
    .RS_TYPE("SYNC_RESET") 
) u_ODDR_inst_tx_ctl (
    .Q(rgmii_tx_ctl),  // OUTPUT  
    .CE(1'b1), // INPUT  
    .CLK(gmii_tx_clk),// INPUT  
    .D0(gmii_tx_en), // INPUT  
    .D1(gmii_tx_en), // INPUT  
    .RS(1'b0)  // INPUT  
);

genvar i;
generate for (i=0; i<4; i=i+1)
    begin : txdata_bus
        //输出双沿采样寄存器 (rgmii_txd)

GTP_ODDR_E1 #(
    .GRS_EN("TRUE"),
    .ODDR_MODE("SAME_EDGE"),
    .RS_TYPE("SYNC_RESET") 
) u_ODDR_inst_txdata (
    .Q(rgmii_txd[i]),  // OUTPUT  
    .CE(1'b1), // INPUT  
    .CLK(gmii_tx_clk),// INPUT  
    .D0(gmii_txd[i]), // INPUT  
    .D1(gmii_txd[4+i]), // INPUT  
    .RS(1'b0)  // INPUT  
);       
    end
endgenerate

endmodule