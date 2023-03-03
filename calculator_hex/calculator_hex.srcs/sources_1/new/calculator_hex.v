`timescale 1ns / 1ps

module calculator_hex(
    input  wire        clk_g     ,
    input  wire        rst       ,
    input  wire        button    ,
    input  wire [2:0]  func      ,
	input  wire [7:0]  num1      ,
	input  wire [7:0]  num2      , 
	output reg  [31:0] cal_result 
);

wire    rst_n=~rst;
reg          start;
//��������
reg another_button;
reg             t1;
reg             t2;
reg          judge;
reg [31:0]     cnt;
reg [31:0]     cal;
reg           flag;
parameter cnt_max=32'd14_9999;//�����ж�����ʱ��
parameter cal_max=32'd999_9999;
//������
always@(posedge clk_g or negedge rst_n)
begin
    if(~rst_n)  
    begin
        cal_result<=32'd0;
        start<=1'd1;
    end
    else if(button==1'd1 && start==1'd1)//����������֤���button==1'd1�ĳ�cal==32'd1
    begin
        case(func)
            3'b000:cal_result<=num1+num2;
            3'b001:cal_result<=num1-num2;
            3'b010:cal_result<=num1*num2;
            3'b011:cal_result<=num1/num2;
            3'b100:cal_result<=num1%num2;
            default:;
        endcase
        start<=1'd0;
    end
    else if(button==1'd1 && start==1'd0)//����������֤���button==1'd1�ĳ�cal==32'd1
    begin
        case(func)
            3'b000:cal_result<=cal_result+num2;
            3'b001:cal_result<=cal_result-num2;
            3'b010:cal_result<=cal_result*num2;
            3'b011:cal_result<=cal_result/num2;
            3'b100:cal_result<=cal_result%num2;
            3'b101:cal_result<=cal_result*cal_result;
            default:;
        endcase
    end
end
//����ģ��
always@(posedge clk_g or negedge rst_n)
begin
    if(~rst_n)
    begin
        another_button<=1'd0;
        t1<=1'd0;
        t2<=1'd0;
        judge<=1'd0;
        cnt<=32'd0;
    end
    else
    begin
        if(judge==1'd1)
        begin
            if(cnt==cnt_max)
            begin
                cnt<=32'd0;
                t2=button;
                judge<=1'd0;
                if(t2==t1)
                    another_button<=button;
                else;
            end
            else cnt<=cnt+32'd1;
        end
        else if(button!=t1)
        begin
            judge<=1'd1;
            t1=button;
        end
        else another_button=button;
    end
end
//cal������
always@(posedge clk_g or negedge rst_n)
begin
    if(~rst_n)
    begin
        cal<=32'd0;
        flag<=1'd0;
    end
    else if(another_button==1'd1)
    begin
        cal<=32'd0;
        flag<=1'd1;
    end
    else if(cal==cal_max)
    begin
        cal<=32'd0;
        flag<=1'd0;
    end
    else if(flag==1'd1)  cal<=cal+32'd1;
end
endmodule