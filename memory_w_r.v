module memory_w_r(
    input              clk_g    ,
    input              rst      ,
    input              button   ,
    input       [15:0] mem_douta,
    output reg         mem_ena  ,
    output reg  [ 0:0] mem_wea  ,
    output reg  [ 3:0] mem_addra,
    output reg  [15:0] mem_dina ,
    output reg  [15:0] led
    );

wire       rst_n=~rst;
reg [31:0] cnt       ;
reg        flag      ;
parameter t=32'd9999_999;

always@(posedge clk_g or negedge rst_n)
begin
    case(mem_addra)
        4'b0000:mem_dina<=16'b0000_0000_0000_0001;
        4'b0001:mem_dina<=16'b0000_0000_0000_0011;
        4'b0010:mem_dina<=16'b0000_0000_0000_0111;
        4'b0011:mem_dina<=16'b0000_0000_0000_1111;
        4'b0100:mem_dina<=16'b0000_0000_0001_1111;
        4'b0101:mem_dina<=16'b0000_0000_0011_1111;
        4'b0110:mem_dina<=16'b0000_0000_0111_1111;
        4'b0111:mem_dina<=16'b0000_0000_1111_1111;
        4'b1000:mem_dina<=16'b0000_0001_1111_1111;
        4'b1001:mem_dina<=16'b0000_0011_1111_1111;
        4'b1010:mem_dina<=16'b0000_0111_1111_1111; 
        4'b1011:mem_dina<=16'b0000_1111_1111_1111;
        4'b1100:mem_dina<=16'b0001_1111_1111_1111;
        4'b1101:mem_dina<=16'b0011_1111_1111_1111;
        4'b1110:mem_dina<=16'b0111_1111_1111_1111;
        4'b1111:mem_dina<=16'b1111_1111_1111_1111;
        default:;
    endcase
    if(~rst_n)
    begin     
                                             cnt<=32'd0;
                                             flag<=1'b0;
                                        mem_addra<=4'b0;
                           led<=16'b0000_0000_0000_0000;
    end
    else if(button==1'b1)                    flag<=1'b1;
    else if(cnt==t) 
    begin
        if(mem_addra<4'b1111)
        begin
            mem_addra<=mem_addra+4'b1;
        end
        led<=mem_douta;
        cnt<=32'd0;
    end
    else if(flag==1'b1)                   cnt<=cnt+32'd1;
end

always@(posedge clk_g or negedge rst_n)
begin
    if(rst_n)
    begin
        if(cnt==32'd1)
        begin
           mem_ena<=1'b1;
           mem_wea<=1'b1;
        end
        if(cnt==32'd2)  mem_ena<=1'b0;
        if(cnt==32'd3)
        begin
           mem_ena<=1'b1;
           mem_wea<=1'b0;
        end
        if(cnt==32'd4) mem_ena<=1'b0;
    end
end

endmodule