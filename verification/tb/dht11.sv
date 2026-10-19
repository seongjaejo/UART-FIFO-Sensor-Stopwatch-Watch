`timescale 1ns/1ps
module audit_dht;tb_dht11 t();initial begin #30000000;$display("AUDIT DHT TIMEOUT FAIL");$finish;end endmodule
