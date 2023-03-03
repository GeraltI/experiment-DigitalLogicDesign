module memory_top (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
	output wire [15:0] led   
);

wire  clk_g;
wire locked;

wire          mem_ena;
wire [ 0:0]   mem_wea;
wire [ 3:0] mem_addra;
wire [15:0]  mem_dina;
wire [15:0] mem_douta;

clk_div u_clk_div (
    .clk_in1   (clk   ),
    .clk_out1  (clk_g ),
    .locked    (locked)
);

memory_w_r u_memory_w_r (
     .clk_g     (clk_g    ),
     .rst       (rst      ),
     .button    (button   ),
     .mem_douta (mem_douta),
     .mem_ena   (mem_ena  ),
     .mem_wea   (mem_wea  ),
     .mem_addra (mem_addra),
     .mem_dina  (mem_dina ),
     .led       (led      )
);

led_mem u_led_mem (
  .clka  (clk_g    ),
  .ena   (mem_ena  ),   
  .wea   (mem_wea  ),     
  .addra (mem_addra),  
  .dina  (mem_dina ),   
  .douta (mem_douta)  
);

endmodule