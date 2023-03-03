`timescale 1ns / 1ps

module calculator_display(
    input  wire        clk_g     ,
    input  wire        rst       ,
    input  wire            button,
    input  wire [31:0] cal_result,
    output reg  [7:0]      led_en,
	output reg             led_ca,
	output reg             led_cb,
    output reg             led_cc,
	output reg             led_cd,
	output reg             led_ce,
	output reg             led_cf,
	output reg             led_cg,
	output wire            led_dp
);

wire       rst_n=~rst;
reg [31:0] cnt       ;
reg [ 2:0] cnt_led   ;
reg [ 3:0] num_led   ;
reg [ 7:0] light     ;

assign led_dp=1'b1;

parameter  cnt_max=32'd1_9999;
parameter  cnt_led_max=3'd7;

//每个周期的内置计数器
always@(posedge clk_g or negedge rst_n)
begin
    if(~rst_n)  cnt<=32'd0;
    else if(cnt==cnt_max)  cnt<=32'd0;
    else  cnt<=cnt+32'd1;
end
//周期计数器
always@(posedge clk_g or negedge rst_n)
begin
    if(~rst_n)  cnt_led<=3'd0;
    else if(cnt_led==cnt_led_max&&cnt==cnt_max)  cnt_led<=3'd0;
    else if(cnt==cnt_max)  cnt_led<=cnt_led+3'd1;
end
//周期与每个灯之间的联系
always@(posedge clk_g or negedge rst_n)
begin
    if(~rst_n)
    begin
        num_led<=4'b0000;
        led_en<=8'b1111_1111;
    end
    else
    begin
        case(cnt_led)
            3'b000:
            begin
                led_en<=8'b1111_1110;
                num_led<=cal_result[3:0];
            end
            3'b001:
            begin
                led_en<=8'b1111_1101;
                num_led<=cal_result[7:4];
            end
            3'b010:
            begin
                led_en<=8'b1111_1011;
                num_led<=cal_result[11:8];
            end
            3'b011:
            begin
                led_en<=8'b1111_0111;
                num_led<=cal_result[15:12];
            end
            3'b100:
            begin
                led_en<=8'b1110_1111;
                num_led<=cal_result[19:16];
            end
            3'b101:
            begin
                led_en<=8'b1101_1111;
                num_led<=cal_result[23:20];
            end
            3'b110:
            begin
                led_en<=8'b1011_1111;
                num_led<=cal_result[27:24];
            end
            3'b111:
            begin
                led_en<=8'b0111_1111;
                num_led<=cal_result[31:28];
            end
            default:led_en<=8'b1111_1111;
        endcase
        case(num_led)
            4'b0000:light<=7'b100_0000;
            4'b0001:light<=7'b111_1001;
            4'b0010:light<=7'b010_0100;
            4'b0011:light<=7'b011_0000;
            4'b0100:light<=7'b001_1001;
            4'b0101:light<=7'b001_0010;
            4'b0110:light<=7'b000_0010;
            4'b0111:light<=7'b111_1000;
            4'b1000:light<=7'b000_0000;
            4'b1001:light<=7'b001_1000;
            4'b1010:light<=7'b000_1000;
            4'b1011:light<=7'b000_0011;
            4'b1100:light<=7'b010_0111;
            4'b1101:light<=7'b010_0001;
            4'b1110:light<=7'b000_0110;
            4'b1111:light<=7'b000_1110;
            default:;
        endcase
        led_ca<=light[0];
        led_cb<=light[1];
        led_cc<=light[2];
        led_cd<=light[3];
        led_ce<=light[4];
        led_cf<=light[5];
        led_cg<=light[6];
    end
end
endmodule
