-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/vivado/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/vivado/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../memory_top.srcs/sources_1/ip/clk_div/clk_div_clk_wiz.v" \
  "../../../../memory_top.srcs/sources_1/ip/clk_div/clk_div.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

