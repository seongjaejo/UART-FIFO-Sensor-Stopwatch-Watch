`timescale 1ns/1ps
module audit_sensor;
reg clk=0,rst=1,rx=1,btnR=0,btnL=0,btnU=0,btnD=0,echo=0;
always #5 clk=~clk;
reg[3:0] sw=0; wire tx,trig;wire[3:0]fnd_com;wire[7:0]fnd_data;wire[2:0]led;tri1 dht11_io;
top_final dut(.*);
defparam dut.U_TOP_UART.U_UART.U_BAUD_TICK_GEN.F_COUNT=2;
integer errors=0,k; reg seenR=0,seenL=0,seenU=0,seenD=0,seenM=0; integer pushcount=0;
always @(posedge clk) begin
 if(dut.w_uart_R) seenR=1;if(dut.w_uart_L) seenL=1;if(dut.w_uart_U) seenU=1;if(dut.w_uart_D) seenD=1;if(dut.w_uart_M) seenM=1;
 if(dut.U_TOP_UART.w_push)pushcount=pushcount+1;
end
task send(input[7:0]b);
integer j;
begin
 @(negedge clk);rx=0;#320;
 for(j=0;j<8;j=j+1)begin rx=b[j];#320;end
 rx=1;#640;
end endtask
initial begin
 repeat(20) @(negedge clk);rst=0;
 for(k=0;k<4;k=k+1) begin
 sw=((k&2)?8:0)|((k&1)?2:0);repeat(10)@(negedge clk);
 if(dut.w_sel!==k[1:0]) begin errors=errors+1;$display("AUDIT SENSOR MODE FAIL %0d",k);end
 end
 sw=0;repeat(10)@(negedge clk);
 send("R");send("L");send("U");send("D");send("M");send("S");
 if(!seenR||!seenL||!seenU||!seenD||!seenM)begin errors=errors+1;$display("AUDIT UART COMMAND FAIL %b%b%b%b%b",seenR,seenL,seenU,seenD,seenM);end
 if(pushcount!=21)begin errors=errors+1;$display("AUDIT UART STATUS FAIL pushcount=%0d",pushcount);end
 $display("AUDIT SENSOR integration modes=4 UART commands=6 statusBytes=%0d errors=%0d",pushcount,errors);
 if(errors==0)$display("AUDIT SENSOR INTEGRATION PASS");$finish;
end
initial begin #10000000;$display("AUDIT SENSOR TIMEOUT FAIL");$finish;end
endmodule
