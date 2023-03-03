module led_display_ctrl (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led_en,
	output reg        led_ca,
	output reg        led_cb,
    output reg        led_cc,
	output reg        led_cd,
	output reg        led_ce,
	output reg        led_cf,
	output reg        led_cg,
	output wire       led_dp 
);

wire       rst_n=~rst;
reg [31:0] cnt       ;
reg [31:0] cnt_time  ;
reg [ 2:0] cnt_led   ;
reg [ 3:0] num_time  ;
reg [ 3:0] num_led   ;
reg [ 7:0] light     ;
reg        flag      ;

assign led_dp=1'b1;

parameter  cnt_max=32'd9999_9999;
parameter  cnt_time_max=32'd19_9999;
parameter  cnt_led_max=3'd7;
//原始计数器
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin         
        cnt<=32'd0;
        flag<=1'b0;
    end
    else if(button==1'b1)  flag<=1'b1;
    else if(cnt==cnt_max)  cnt<=32'd0;
    else if(flag==1'b1)  cnt<=cnt+32'b1;
end
//倒数灯计数器
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)  num_time<=4'b1010;
    else if(num_time==4'b0000&&cnt==cnt_max)  num_time<=4'b1010;
    else if(cnt==cnt_max)  num_time<=num_time-4'b0001;
end
//每个周期的内置计数器
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)  cnt_time<=32'd0;
    else if(cnt_time==cnt_time_max)  cnt_time<=32'd0;
    else if(flag==1'b1)  cnt_time<=cnt_time+32'd1;
end
//周期计数器
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)  cnt_led<=3'd0;
    else if(cnt_led==cnt_led_max&&cnt_time==cnt_time_max)  cnt_led<=3'd0;
    else if(cnt_time==cnt_time_max)  cnt_led<=cnt_led+3'd1;
end
//周期与每个灯之间的联系
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        num_led<=4'b1111;
        led_en<=8'b1111_1111;
    end
    else if(flag==1'b1)
    begin
        case(cnt_led)
            3'b000:
            begin
                led_en<=8'b1111_1110;
                num_led<=4'b1000;
            end
            3'b001:
            begin
                led_en<=8'b1111_1101;
                num_led<=4'b0001;
            end
            3'b010:
            begin
                led_en<=8'b1111_1011;
                num_led<=4'b0110;
            end
            3'b011:
            begin
                led_en<=8'b1111_0111;
                num_led<=4'b0000;
            end
            3'b100:
            begin
                led_en<=8'b1110_1111;
                num_led<=4'b0000;
            end
            3'b101:
            begin
                led_en<=8'b1101_1111;
                num_led<=4'b0010;
            end
            3'b110:
            begin
                led_en<=8'b1011_1111;
                if(num_time==4'b1010)  num_led<=4'b0000;
                else  num_led<=num_time;
            end
            3'b111:
            begin
                led_en<=8'b0111_1111;
                if(num_time==4'b1010)  num_led<=4'b0001;
                else  num_led<=4'b0000;
            end
            default:led_en<=8'b1111_1111;
        endcase
        case(num_led)
        4'b0000:light<=8'b1100_0000;
        4'b0001:light<=8'b1111_1001;
        4'b0010:light<=8'b1010_0100;
        4'b0011:light<=8'b1011_0000;
        4'b0100:light<=8'b1001_1001;
        4'b0101:light<=8'b1001_0010;
        4'b0110:light<=8'b1000_0010;
        4'b0111:light<=8'b1111_1000;
        4'b1000:light<=8'b1000_0000;
        4'b1001:light<=8'b1001_1000;
        default:light<=8'b1111_1111;
        endcase
        led_ca<=light[0];
        led_cb<=light[1];
        led_cc<=light[2];
        led_cd<=light[3];
        led_ce<=light[4];
        led_cf<=light[5];
        led_cg<=light[6];
    end
    else  num_led<=4'b1111;
end

endmodule