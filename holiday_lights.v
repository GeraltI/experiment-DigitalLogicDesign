module holiday_lights (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
    input  wire [2:0]  switch,
	output reg  [15:0] led
);
    reg flag;
    reg [31:0]  cnt;
    reg [2:0] last_switch;

always@(posedge clk or negedge rst) 
begin
    if(rst==1'b1)                        
    begin                       
                                          cnt<=32'd0;
                                          flag<=1'b0;
    end
    else if(button==1'b1)                 flag<=1'b1;
    else if(cnt==32'd9999_9999)           cnt<=32'd0;
    else if(flag==1'b1)               cnt<=cnt+32'd1;
    else                                    cnt<=cnt;
end

always@(posedge clk or negedge rst)
begin
    last_switch<=switch;
    if(rst==1'b1) 
        case(switch)
        3'b000:led<=16'b0000_0000_0000_0001;
        3'b001:led<=16'b0000_0000_0000_0011;
        3'b010:led<=16'b0000_0000_0000_0111;
        3'b011:led<=16'b0000_0000_0000_1111;
        3'b100:led<=16'b0000_0000_0001_1111;
        3'b101:led<=16'b0000_0000_0011_1111;
        3'b110:led<=16'b0000_0000_0111_1111;
        3'b111:led<=16'b0000_0000_1111_1111;
        default:;
        endcase
    else if(last_switch!=switch)
        case(switch)
        3'b000:led<=16'b0000_0000_0000_0001;
        3'b001:led<=16'b0000_0000_0000_0011;
        3'b010:led<=16'b0000_0000_0000_0111;
        3'b011:led<=16'b0000_0000_0000_1111;
        3'b100:led<=16'b0000_0000_0001_1111;
        3'b101:led<=16'b0000_0000_0011_1111;
        3'b110:led<=16'b0000_0000_0111_1111;
        3'b111:led<=16'b0000_0000_1111_1111;
        default:;
        endcase
    else if(cnt==32'd9999_9999)
        led<={led[14:0],led[15]};
end

initial
flag=1'b0;
endmodule