module FIFO#(parameter s=2,n=3)(
     input clk,
     input rst,
     input wr,
     input rd,
     input [n-1:0] in,
     output [n-1:0] out,
     output empty,
     output full,
     output button1,
     output button2,
     output button3
);
wire wrr,rdd;
reg wr1,wr2,rd1,rd2;
always @(posedge clk) wr1<=wr;
always @(posedge clk) wr2<=wr1;
assign wrr=~wr1 & wr2;
always @(posedge clk) rd1<=rd;
always @(posedge clk) rd2<=rd1;
assign rdd=~rd1 & rd2;

reg [n-1:0] out1;
reg [n-1:0] buffer[2**s-1:0];
reg [s-1:0] wrp, wrn, wrs, rdp,rdn,rds;
reg butt1, butt2, butt3, fullp, fulln, emptyp, emptyn;

always @(posedge clk)
 begin
   if(wrr & ~full)
     buffer[wrp]<=in;
 end
always @(posedge clk)
 begin
  if(rdd & ~empty)
    out1<= buffer[rdp];
 end


always @(posedge clk or posedge rst)
 begin
  if(rst)
   begin
   wrp <=0;
   rdp <=0;
   fullp <= 1'b0;
   emptyp <= 1'b1;
   butt1 <=1'b0;
   butt2 <= 1'b0;
   butt3 <= 1'b0;
   end
  
  else
   begin
   wrp <= wrn;
   rdp <=rdn;
   fullp <= fulln;
   emptyp <= emptyn;
   butt1 <=1'b0;
   butt2 <= 1'b0;
   butt3 <= 1'b0;
   end
  end
  
always @(*)
 begin
 wrs=wrp+1;
 wrn=wrp;
 rds=rdp+1;
 rdn=rdp;
 fulln=fullp;
 emptyn=emptyp;
 
 case({wrr,rdd})
  2'b10:
   begin
    if(~full)
     begin
      wrn=wrs;
      emptyn=1'b0;
      if(wrn==rdp)
       fulln=1'b1;
     end
    end
   2'b01:
    begin
    if(~empty)
     begin
      rdn=rds;
      fulln=1'b0;
      if(rdn==wrp)
       emptyn=1'b1;
     end
    end
   endcase
 end
 
assign full=fullp;
assign empty =emptyp;
assign out=out1;
endmodule


