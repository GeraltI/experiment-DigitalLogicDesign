module sequence_detection (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	input  wire [7:0] switch,
	output reg        led
);

parameter IDLE=6'b0000_01;
parameter   S0=6'b0000_10;
parameter   S1=6'b0001_00;
parameter   S2=6'b0010_00;
parameter   S3=6'b0100_00;
parameter   S4=6'b1000_00;

wire rst_n=~rst;
reg [5:0]current_state;
reg [5:0]next_state;
reg [3:0]cnt;
reg flag;
reg switch_solo;
reg [7:0]lastswitch;
always@(cnt)
begin
    case(cnt)
        0:switch_solo<=switch[7];
        1:switch_solo<=switch[6];
        2:switch_solo<=switch[5];
        3:switch_solo<=switch[4];
        4:switch_solo<=switch[3];
        5:switch_solo<=switch[2];
        6:switch_solo<=switch[1];
        7:switch_solo<=switch[0];
    endcase
end
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n || lastswitch!=switch)
    begin
        cnt<=4'd0;
        flag<=1'b0;
    end
    else if(button) flag<=1'b1;
    else if(cnt==4'd8) flag<=1'b0;
    else if(flag==1'b1) cnt<=cnt+4'd1;
    lastswitch<=switch;
end

//第一个always模块，描述次态寄存器迁移到现态寄存器
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n) current_state<=IDLE;
    else  current_state<=next_state;
end
//第二个always模块，描述状态转移条件判断
always@(*)
begin
    case(current_state)
        IDLE:if(~button || rst || lastswitch!=switch) next_state=IDLE;
             else next_state=S0;
        S0:if(cnt==4'd8) next_state=IDLE;
           else if(switch_solo) next_state=S1;
           else if(~switch_solo) next_state=S0;
        S1:if(cnt==4'd8) next_state=IDLE;
           else if(~switch_solo) next_state=S2;
           else if(switch_solo) next_state=S1;
        S2:if(cnt==4'd8) next_state=IDLE;
           else if(~switch_solo) next_state=S3;
           else if(switch_solo)next_state=S1;
        S3:if(cnt==4'd8) next_state=IDLE;
           else if(switch_solo) next_state=S4;
           else if(~switch_solo)next_state=S0;
        S4:if(cnt==4'd8) next_state=IDLE;
           else if(~switch_solo) next_state=IDLE;
           else if(switch_solo) next_state=S0;
    endcase
end
//第三个always模块，描述次态寄存器输出
always@(posedge clk or negedge rst_n)
begin
    if(~rst_n || button) led<=1'b0;
    else if(current_state==S4 && ~switch_solo) led<=1'b1;
end
endmodule