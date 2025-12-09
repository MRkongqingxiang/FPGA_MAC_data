# FPGA_MAC_data

开发平台：基于紫光同创FPGA芯片，双网口开发板。

## 设计概述
仓库包含 `eth_udp_loop` 顶层模块的代码以及与之匹配的约束示例，用于在层二实现从一个网口接收报文并透传到另一个网口。顶层实例化了 ARP、ICMP、UDP 处理单元以及 GMII/RGMII 转换等模块，MAC 和 IP 参数均可通过参数修改。

## 目录说明
- `rtl/eth_udp_loop.v`：顶层端口和信号连接的 Verilog 源文件。
- `rtl/eth_udp_loop_stubs.v`：ARP、ICMP、UDP、GMII/RGMII 转换、异步 FIFO 和以太网控制模块的占位符，便于综合时通过黑盒替换为实际实现。
- `constraints/eth_udp_loop_constraints.tcl`：基于提供的管脚和时钟定义的约束示例。

## 使用提示
1. 将 `rtl/eth_udp_loop.v` 作为顶层加入工程，并替换/补充 `rtl/eth_udp_loop_stubs.v` 中的占位模块为真实实现。
2. 根据实际网口选择启用或调整 `constraints/eth_udp_loop_constraints.tcl` 中的 GE0/GE1 引脚约束。
3. 更新参数 `BOARD_MAC`、`BOARD_IP`、`DES_MAC`、`DES_IP` 以匹配目标网络环境。
