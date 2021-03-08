#-------------- MCS Generation ----------------------
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1  [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES       [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8          [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE          [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone      [current_design]
set_property CFGBVS GND                               [current_design]
set_property CONFIG_VOLTAGE 1.8                       [current_design]
set_property CONFIG_MODE SPIx8                        [current_design]

# SDC part
set_property PACKAGE_PIN D12      [get_ports {sys_clock_n}] ;
set_property IOSTANDARD  DIFF_SSTL12 [get_ports {sys_clock_n}] ;
set_property PACKAGE_PIN E12      [get_ports {sys_clock_p}] ;
set_property IOSTANDARD  DIFF_SSTL12 [get_ports {sys_clock_p}] ;
create_clock -name sys_diff_clk -period 4.0 [get_ports {sys_clock_p}]
set_input_jitter sys_diff_clk 0.5
create_clock -name JTCK -period 100.0 [get_ports {jtag_jtag_TCK}]
set_input_jitter JTCK 0.5
create_clock -name pcie_ref_clk -period 10.0 [get_ports {pciePorts_REFCLK_rxp}]
set_input_jitter pcie_ref_clk 0.5

set_clock_groups -asynchronous \
  -group [list [get_clocks { \
      sys_diff_clk \
    }]] \
  -group [list [get_clocks -of_objects [get_pins { \
      pll/clk_out1 \
    }]]] \
  -group [list [get_clocks -of_objects [get_pins { \
      pll/clk_out2 \
    }]]] \
  -group [list [get_clocks -of_objects [get_pins { \
      pll/clk_out3 \
    }]]] \
  -group [list [get_clocks { \
      JTCK \
    }]]

# PINS

# Attached to PMOD1 (J53.2,4,6,8)
set_property PACKAGE_PIN {P29} [get_ports {jtag_jtag_TCK}]
set_property IOSTANDARD {LVCMOS12} [get_ports {jtag_jtag_TCK}]
set_property PULLUP {TRUE} [get_ports {jtag_jtag_TCK}]
set_property PACKAGE_PIN {L31} [get_ports {jtag_jtag_TMS}]
set_property IOSTANDARD {LVCMOS12} [get_ports {jtag_jtag_TMS}]
set_property PULLUP {TRUE} [get_ports {jtag_jtag_TMS}]
set_property PACKAGE_PIN {M31} [get_ports {jtag_jtag_TDI}]
set_property IOSTANDARD {LVCMOS12} [get_ports {jtag_jtag_TDI}]
set_property PULLUP {TRUE} [get_ports {jtag_jtag_TDI}]
set_property PACKAGE_PIN {R29} [get_ports {jtag_jtag_TDO}]
set_property IOSTANDARD {LVCMOS12} [get_ports {jtag_jtag_TDO}]
set_property PULLUP {TRUE} [get_ports {jtag_jtag_TDO}]

set_property CLOCK_DEDICATED_ROUTE {FALSE} [get_nets [get_ports {jtag_jtag_TCK}]]

# Attached to PMOD1 (J52.7,3,5,1 [2,4])
set_property PACKAGE_PIN {AV15} [get_ports {sdio_sdio_clk}]
set_property IOSTANDARD {LVCMOS18} [get_ports {sdio_sdio_clk}]
set_property IOB {TRUE} [get_ports {sdio_sdio_clk}]
# No pullup for SD clk
set_property PACKAGE_PIN {AY15} [get_ports {sdio_sdio_cmd}]
set_property IOSTANDARD {LVCMOS18} [get_ports {sdio_sdio_cmd}]
set_property IOB {TRUE} [get_ports {sdio_sdio_cmd}]
set_property PULLUP {TRUE} [get_ports {sdio_sdio_cmd}]
set_property PACKAGE_PIN {AW15} [get_ports {sdio_sdio_dat_0}]
set_property IOSTANDARD {LVCMOS18} [get_ports {sdio_sdio_dat_0}]
set_property IOB {TRUE} [get_ports {sdio_sdio_dat_0}]
set_property PULLUP {TRUE} [get_ports {sdio_sdio_dat_0}]
set_property PACKAGE_PIN {AY14} [get_ports {sdio_sdio_dat_3}]
set_property IOSTANDARD {LVCMOS18} [get_ports {sdio_sdio_dat_3}]
set_property IOB {TRUE} [get_ports {sdio_sdio_dat_3}]
set_property PULLUP {TRUE} [get_ports {sdio_sdio_dat_3}]

set_property PACKAGE_PIN {AV16} [get_ports {sdio_sdio_dat_1}]
set_property IOSTANDARD {LVCMOS18} [get_ports {sdio_sdio_dat_1}]
set_property IOB {TRUE} [get_ports {sdio_sdio_dat_1}]
set_property PULLUP {TRUE} [get_ports {sdio_sdio_dat_1}]
set_property PACKAGE_PIN {AU16} [get_ports {sdio_sdio_dat_2}]
set_property IOSTANDARD {LVCMOS18} [get_ports {sdio_sdio_dat_2}]
set_property IOB {TRUE} [get_ports {sdio_sdio_dat_2}]
set_property PULLUP {TRUE} [get_ports {sdio_sdio_dat_2}]

set_property PACKAGE_PIN {AY25} [get_ports {uart_ctsn}]
set_property IOSTANDARD {LVCMOS18} [get_ports {uart_ctsn}]
set_property IOB {TRUE} [get_ports {uart_ctsn}]
set_property PACKAGE_PIN {BB22} [get_ports {uart_rtsn}]
set_property IOSTANDARD {LVCMOS18} [get_ports {uart_rtsn}]
set_property IOB {TRUE} [ get_ports {uart_rtsn}]
set_property PACKAGE_PIN {AW25} [get_ports {uart_rxd}]
set_property IOSTANDARD {LVCMOS18} [get_ports {uart_rxd}]
set_property IOB {TRUE} [ get_ports {uart_rxd}]
set_property PACKAGE_PIN {BB21} [get_ports {uart_txd}]
set_property IOSTANDARD {LVCMOS18} [get_ports {uart_txd}]
set_property IOB {TRUE} [get_ports {uart_txd}]

set_property PACKAGE_PIN {AT32} [get_ports {gpio_out[0]}]
set_property PACKAGE_PIN {AV34} [get_ports {gpio_out[1]}]
set_property PACKAGE_PIN {AY30} [get_ports {gpio_out[2]}]
set_property PACKAGE_PIN {BB32} [get_ports {gpio_out[3]}]
set_property PACKAGE_PIN {BF32} [get_ports {gpio_out[4]}]
set_property PACKAGE_PIN {AU37} [get_ports {gpio_out[5]}]
set_property PACKAGE_PIN {AV36} [get_ports {gpio_out[6]}]
set_property PACKAGE_PIN {BA37} [get_ports {gpio_out[7]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_out[0]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_out[1]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_out[2]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_out[3]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_out[4]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_out[5]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_out[6]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_out[7]}]

set_property PACKAGE_PIN {B17} [get_ports {gpio_in[0]}]
set_property PACKAGE_PIN {G16} [get_ports {gpio_in[1]}]
set_property PACKAGE_PIN {J16} [get_ports {gpio_in[2]}]
set_property PACKAGE_PIN {D21} [get_ports {gpio_in[3]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_in[0]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_in[1]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_in[2]}]
set_property IOSTANDARD {LVCMOS12} [get_ports {gpio_in[3]}]

#TODO: Still missing the FPGA_INIT_B
set_property PACKAGE_PIN {AJ11} [get_ports {qspi_0_qspi_cs}]
set_property PACKAGE_PIN {AF13} [get_ports {qspi_0_qspi_sck}]
set_property PACKAGE_PIN {AP11} [get_ports {qspi_0_qspi_miso}]
set_property PACKAGE_PIN {AN11} [get_ports {qspi_0_qspi_mosi}]
set_property PACKAGE_PIN {AM11} [get_ports {qspi_0_qspi_wp}]
set_property PACKAGE_PIN {AL11} [get_ports {qspi_0_qspi_hold}]
set_property IOSTANDARD {LVCMOS18} [get_ports {qspi_0_qspi_cs}]
set_property IOSTANDARD {LVCMOS18} [get_ports {qspi_0_qspi_sck}]
set_property IOSTANDARD {LVCMOS18} [get_ports {qspi_0_qspi_miso}]
set_property IOSTANDARD {LVCMOS18} [get_ports {qspi_0_qspi_mosi}]
set_property IOSTANDARD {LVCMOS18} [get_ports {qspi_0_qspi_wp}]
set_property IOSTANDARD {LVCMOS18} [get_ports {qspi_0_qspi_hold}]

# North
set_property PACKAGE_PIN BB24     [get_ports {rst_0}]
set_property IOSTANDARD  LVCMOS18 [get_ports {rst_0}]
# East
set_property PACKAGE_PIN BE23     [get_ports {rst_3}]
set_property IOSTANDARD  LVCMOS18 [get_ports {rst_3}]
# West
set_property PACKAGE_PIN BF22     [get_ports {rst_1}]
set_property IOSTANDARD  LVCMOS18 [get_ports {rst_1}]
# South
set_property PACKAGE_PIN BE22     [get_ports {rst_2}]
set_property IOSTANDARD  LVCMOS18 [get_ports {rst_2}]

set_property PACKAGE_PIN {D14} [get_ports {ddr_c0_ddr4_adr[0]}]
set_property PACKAGE_PIN {B15} [get_ports {ddr_c0_ddr4_adr[1]}]
set_property PACKAGE_PIN {B16} [get_ports {ddr_c0_ddr4_adr[2]}]
set_property PACKAGE_PIN {C14} [get_ports {ddr_c0_ddr4_adr[3]}]
set_property PACKAGE_PIN {C15} [get_ports {ddr_c0_ddr4_adr[4]}]
set_property PACKAGE_PIN {A13} [get_ports {ddr_c0_ddr4_adr[5]}]
set_property PACKAGE_PIN {A14} [get_ports {ddr_c0_ddr4_adr[6]}]
set_property PACKAGE_PIN {A15} [get_ports {ddr_c0_ddr4_adr[7]}]
set_property PACKAGE_PIN {A16} [get_ports {ddr_c0_ddr4_adr[8]}]
set_property PACKAGE_PIN {B12} [get_ports {ddr_c0_ddr4_adr[9]}]
set_property PACKAGE_PIN {C12} [get_ports {ddr_c0_ddr4_adr[10]}]
set_property PACKAGE_PIN {B13} [get_ports {ddr_c0_ddr4_adr[11]}]
set_property PACKAGE_PIN {C13} [get_ports {ddr_c0_ddr4_adr[12]}]
set_property PACKAGE_PIN {D15} [get_ports {ddr_c0_ddr4_adr[13]}]
set_property PACKAGE_PIN {H14} [get_ports {ddr_c0_ddr4_adr[14]}]
set_property PACKAGE_PIN {H15} [get_ports {ddr_c0_ddr4_adr[15]}]
set_property PACKAGE_PIN {F15} [get_ports {ddr_c0_ddr4_adr[16]}]
set_property PACKAGE_PIN {H13} [get_ports {ddr_c0_ddr4_bg}]
set_property PACKAGE_PIN {G15} [get_ports {ddr_c0_ddr4_ba[0]}]
set_property PACKAGE_PIN {G13} [get_ports {ddr_c0_ddr4_ba[1]}]
set_property PACKAGE_PIN {N20} [get_ports {ddr_c0_ddr4_reset_n}]
set_property PACKAGE_PIN {E13} [get_ports {ddr_c0_ddr4_act_n}]
set_property PACKAGE_PIN {E14} [get_ports {ddr_c0_ddr4_ck_c}]
set_property PACKAGE_PIN {F14} [get_ports {ddr_c0_ddr4_ck_t}]
set_property PACKAGE_PIN {A10} [get_ports {ddr_c0_ddr4_cke}]
set_property PACKAGE_PIN {F13} [get_ports {ddr_c0_ddr4_cs_n}]
set_property PACKAGE_PIN {C8} [get_ports {ddr_c0_ddr4_odt}]
set_property PACKAGE_PIN {F11} [get_ports {ddr_c0_ddr4_dq[0]}]
set_property PACKAGE_PIN {E11} [get_ports {ddr_c0_ddr4_dq[1]}]
set_property PACKAGE_PIN {F10} [get_ports {ddr_c0_ddr4_dq[2]}]
set_property PACKAGE_PIN {F9} [get_ports {ddr_c0_ddr4_dq[3]}]
set_property PACKAGE_PIN {H12} [get_ports {ddr_c0_ddr4_dq[4]}]
set_property PACKAGE_PIN {G12} [get_ports {ddr_c0_ddr4_dq[5]}]
set_property PACKAGE_PIN {E9} [get_ports {ddr_c0_ddr4_dq[6]}]
set_property PACKAGE_PIN {D9} [get_ports {ddr_c0_ddr4_dq[7]}]
set_property PACKAGE_PIN {R19} [get_ports {ddr_c0_ddr4_dq[8]}]
set_property PACKAGE_PIN {P19} [get_ports {ddr_c0_ddr4_dq[9]}]
set_property PACKAGE_PIN {M18} [get_ports {ddr_c0_ddr4_dq[10]}]
set_property PACKAGE_PIN {M17} [get_ports {ddr_c0_ddr4_dq[11]}]
set_property PACKAGE_PIN {N19} [get_ports {ddr_c0_ddr4_dq[12]}]
set_property PACKAGE_PIN {N18} [get_ports {ddr_c0_ddr4_dq[13]}]
set_property PACKAGE_PIN {N17} [get_ports {ddr_c0_ddr4_dq[14]}]
set_property PACKAGE_PIN {M16} [get_ports {ddr_c0_ddr4_dq[15]}]
set_property PACKAGE_PIN {L16} [get_ports {ddr_c0_ddr4_dq[16]}]
set_property PACKAGE_PIN {K16} [get_ports {ddr_c0_ddr4_dq[17]}]
set_property PACKAGE_PIN {L18} [get_ports {ddr_c0_ddr4_dq[18]}]
set_property PACKAGE_PIN {K18} [get_ports {ddr_c0_ddr4_dq[19]}]
set_property PACKAGE_PIN {J17} [get_ports {ddr_c0_ddr4_dq[20]}]
set_property PACKAGE_PIN {H17} [get_ports {ddr_c0_ddr4_dq[21]}]
set_property PACKAGE_PIN {H19} [get_ports {ddr_c0_ddr4_dq[22]}]
set_property PACKAGE_PIN {H18} [get_ports {ddr_c0_ddr4_dq[23]}]
set_property PACKAGE_PIN {F19} [get_ports {ddr_c0_ddr4_dq[24]}]
set_property PACKAGE_PIN {F18} [get_ports {ddr_c0_ddr4_dq[25]}]
set_property PACKAGE_PIN {E19} [get_ports {ddr_c0_ddr4_dq[26]}]
set_property PACKAGE_PIN {E18} [get_ports {ddr_c0_ddr4_dq[27]}]
set_property PACKAGE_PIN {G20} [get_ports {ddr_c0_ddr4_dq[28]}]
set_property PACKAGE_PIN {F20} [get_ports {ddr_c0_ddr4_dq[29]}]
set_property PACKAGE_PIN {E17} [get_ports {ddr_c0_ddr4_dq[30]}]
set_property PACKAGE_PIN {D16} [get_ports {ddr_c0_ddr4_dq[31]}]
set_property PACKAGE_PIN {D17} [get_ports {ddr_c0_ddr4_dq[32]}]
set_property PACKAGE_PIN {C17} [get_ports {ddr_c0_ddr4_dq[33]}]
set_property PACKAGE_PIN {C19} [get_ports {ddr_c0_ddr4_dq[34]}]
set_property PACKAGE_PIN {C18} [get_ports {ddr_c0_ddr4_dq[35]}]
set_property PACKAGE_PIN {D20} [get_ports {ddr_c0_ddr4_dq[36]}]
set_property PACKAGE_PIN {D19} [get_ports {ddr_c0_ddr4_dq[37]}]
set_property PACKAGE_PIN {C20} [get_ports {ddr_c0_ddr4_dq[38]}]
set_property PACKAGE_PIN {B20} [get_ports {ddr_c0_ddr4_dq[39]}]
set_property PACKAGE_PIN {N23} [get_ports {ddr_c0_ddr4_dq[40]}]
set_property PACKAGE_PIN {M23} [get_ports {ddr_c0_ddr4_dq[41]}]
set_property PACKAGE_PIN {R21} [get_ports {ddr_c0_ddr4_dq[42]}]
set_property PACKAGE_PIN {P21} [get_ports {ddr_c0_ddr4_dq[43]}]
set_property PACKAGE_PIN {R22} [get_ports {ddr_c0_ddr4_dq[44]}]
set_property PACKAGE_PIN {P22} [get_ports {ddr_c0_ddr4_dq[45]}]
set_property PACKAGE_PIN {T23} [get_ports {ddr_c0_ddr4_dq[46]}]
set_property PACKAGE_PIN {R23} [get_ports {ddr_c0_ddr4_dq[47]}]
set_property PACKAGE_PIN {K24} [get_ports {ddr_c0_ddr4_dq[48]}]
set_property PACKAGE_PIN {J24} [get_ports {ddr_c0_ddr4_dq[49]}]
set_property PACKAGE_PIN {M21} [get_ports {ddr_c0_ddr4_dq[50]}]
set_property PACKAGE_PIN {L21} [get_ports {ddr_c0_ddr4_dq[51]}]
set_property PACKAGE_PIN {K21} [get_ports {ddr_c0_ddr4_dq[52]}]
set_property PACKAGE_PIN {J21} [get_ports {ddr_c0_ddr4_dq[53]}]
set_property PACKAGE_PIN {K22} [get_ports {ddr_c0_ddr4_dq[54]}]
set_property PACKAGE_PIN {J22} [get_ports {ddr_c0_ddr4_dq[55]}]
set_property PACKAGE_PIN {H23} [get_ports {ddr_c0_ddr4_dq[56]}]
set_property PACKAGE_PIN {H22} [get_ports {ddr_c0_ddr4_dq[57]}]
set_property PACKAGE_PIN {E23} [get_ports {ddr_c0_ddr4_dq[58]}]
set_property PACKAGE_PIN {E22} [get_ports {ddr_c0_ddr4_dq[59]}]
set_property PACKAGE_PIN {F21} [get_ports {ddr_c0_ddr4_dq[60]}]
set_property PACKAGE_PIN {E21} [get_ports {ddr_c0_ddr4_dq[61]}]
set_property PACKAGE_PIN {F24} [get_ports {ddr_c0_ddr4_dq[62]}]
set_property PACKAGE_PIN {F23} [get_ports {ddr_c0_ddr4_dq[63]}]
set_property PACKAGE_PIN {D10} [get_ports {ddr_c0_ddr4_dqs_c[0]}]
set_property PACKAGE_PIN {P16} [get_ports {ddr_c0_ddr4_dqs_c[1]}]
set_property PACKAGE_PIN {J19} [get_ports {ddr_c0_ddr4_dqs_c[2]}]
set_property PACKAGE_PIN {E16} [get_ports {ddr_c0_ddr4_dqs_c[3]}]
set_property PACKAGE_PIN {A18} [get_ports {ddr_c0_ddr4_dqs_c[4]}]
set_property PACKAGE_PIN {M22} [get_ports {ddr_c0_ddr4_dqs_c[5]}]
set_property PACKAGE_PIN {L20} [get_ports {ddr_c0_ddr4_dqs_c[6]}]
set_property PACKAGE_PIN {G23} [get_ports {ddr_c0_ddr4_dqs_c[7]}]
set_property PACKAGE_PIN {D11} [get_ports {ddr_c0_ddr4_dqs_t[0]}]
set_property PACKAGE_PIN {P17} [get_ports {ddr_c0_ddr4_dqs_t[1]}]
set_property PACKAGE_PIN {K19} [get_ports {ddr_c0_ddr4_dqs_t[2]}]
set_property PACKAGE_PIN {F16} [get_ports {ddr_c0_ddr4_dqs_t[3]}]
set_property PACKAGE_PIN {A19} [get_ports {ddr_c0_ddr4_dqs_t[4]}]
set_property PACKAGE_PIN {N22} [get_ports {ddr_c0_ddr4_dqs_t[5]}]
set_property PACKAGE_PIN {M20} [get_ports {ddr_c0_ddr4_dqs_t[6]}]
set_property PACKAGE_PIN {H24} [get_ports {ddr_c0_ddr4_dqs_t[7]}]
set_property PACKAGE_PIN {G11} [get_ports {ddr_c0_ddr4_dm_dbi_n[0]}]
set_property PACKAGE_PIN {R18} [get_ports {ddr_c0_ddr4_dm_dbi_n[1]}]
set_property PACKAGE_PIN {K17} [get_ports {ddr_c0_ddr4_dm_dbi_n[2]}]
set_property PACKAGE_PIN {G18} [get_ports {ddr_c0_ddr4_dm_dbi_n[3]}]
set_property PACKAGE_PIN {B18} [get_ports {ddr_c0_ddr4_dm_dbi_n[4]}]
set_property PACKAGE_PIN {P20} [get_ports {ddr_c0_ddr4_dm_dbi_n[5]}]
set_property PACKAGE_PIN {L23} [get_ports {ddr_c0_ddr4_dm_dbi_n[6]}]
set_property PACKAGE_PIN {G22} [get_ports {ddr_c0_ddr4_dm_dbi_n[7]}]

# TODO: Connected to the chiplink in a future
#set_property PACKAGE_PIN {AK39} [get_ports {USB_0_WireDataIn[0]}]
#set_property PACKAGE_PIN {AL39} [get_ports {USB_0_WireDataIn[1]}]
#set_property PACKAGE_PIN {AJ42} [get_ports {USB_0_WireDataOut[0]}]
#set_property PACKAGE_PIN {AK42} [get_ports {USB_0_WireDataOut[1]}]
#set_property PACKAGE_PIN {AF42} [get_ports {USB_0_WireCtrlOut}]
#set_property PACKAGE_PIN {AG42} [get_ports {USB_0_FullSpeed}]
#set_property IOSTANDARD {LVCMOS18} [get_ports {USB_0_WireDataIn[0]}]
#set_property IOSTANDARD {LVCMOS18} [get_ports {USB_0_WireDataIn[1]}]
#set_property IOSTANDARD {LVCMOS18} [get_ports {USB_0_WireDataOut[0]}]
#set_property IOSTANDARD {LVCMOS18} [get_ports {USB_0_WireDataOut[1]}]
#set_property IOSTANDARD {LVCMOS18} [get_ports {USB_0_WireCtrlOut}]
#set_property IOSTANDARD {LVCMOS18} [get_ports {USB_0_FullSpeed}]

# TODO: No idea about the REFCLK
set_property PACKAGE_PIN {W9} [get_ports {pciePorts_REFCLK_rxp}]
set_property PACKAGE_PIN {W8} [get_ports {pciePorts_REFCLK_rxn}]
set_property PACKAGE_PIN {V7} [get_ports {pciePorts_pci_exp_txp}]
set_property PACKAGE_PIN {V6} [get_ports {pciePorts_pci_exp_txn}]
set_property PACKAGE_PIN {Y2} [get_ports {pciePorts_pci_exp_rxp}]
set_property PACKAGE_PIN {Y1} [get_ports {pciePorts_pci_exp_rxn}]
