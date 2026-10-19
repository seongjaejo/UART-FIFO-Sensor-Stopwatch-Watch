`timescale 1ns/1ps
module audit_sr04;
reg clk=0,rst=1,sr04_start=0,tick_us=0,echo=0;always #5 clk=~clk;
wire trig;wire[8:0]distance;
sr04_controller #(.F_COUNT(8)) dut(.*);
integer errors=0,k;
task tick;begin @(negedge clk);tick_us=1;@(negedge clk);tick_us=0;end endtask
task measure(input integer ticks,input integer cm);
begin
 sr04_start=1; repeat(10)@(negedge clk);sr04_start=0;
 repeat(14)tick(); repeat(3)@(negedge clk);
 echo=1;repeat(3)@(negedge clk);repeat(ticks)tick();echo=0;
 repeat(5)@(negedge clk);
 if(distance!==cm)begin errors=errors+1;$display("AUDIT SR04 FAIL ticks=%0d cm=%0d expected=%0d",ticks,distance,cm);end
end endtask
initial begin
 repeat(3)@(negedge clk);rst=0;
 measure(580,10);measure(1160,20);measure(5800,100);
 $display("AUDIT SR04 distances=3 errors=%0d",errors);if(errors==0)$display("AUDIT SR04 PASS");$finish;
end
initial begin #1000000;$display("AUDIT SR04 TIMEOUT FAIL");$finish;end
endmodule
