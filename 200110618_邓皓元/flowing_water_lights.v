module flowing_water_lights (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led
);

    reg flag;
    reg [31:0]  cnt;

always@(posedge clk or negedge rst) 
begin
    if(rst==1'b1)              
    begin                                 cnt<=32'd0;
                                          flag<=1'b0;
    end
    else if(button==1'b1)                 flag<=1'b1;
    else if (cnt==32'd9999_9999)          cnt<=32'd0;
    else if (flag==1'b1)              cnt<=cnt+32'd1;
    else                                    cnt<=cnt;
end

always@(posedge clk or negedge rst)
begin
    if(rst==1'b1)
        led<=8'b0000_0001;
    else if(cnt==32'd9999_9999)
        led<={led[6:0],led[7]};
end


initial
flag=1'b0;
endmodule