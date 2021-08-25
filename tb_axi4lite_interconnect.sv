`timescale 1ns / 1ps

   module tb_axi4lite_interconnect(

    );
    
    integer i=0;
    reg [31:0] m;
    reg s_axi_aclk;
    reg s_axi_areset;
    
    //slave read channel
    reg [31:0]s_axi_araddr;
    reg s_axi_arvalid;
    reg s_axi_rready;
    wire [31:0] s_axi_rdata;
    wire s_axi_arready;
    wire [1:0] s_axi_rresp;
    wire s_axi_rvalid;
    
    //slave write channel
    reg [31:0] s_axi_awaddr;
    reg s_axi_awvalid;
    reg s_axi_bready;
    reg [31:0] s_axi_wdata;
    reg [3:0] s_axi_wstrb;
    reg s_axi_wvalid;
    wire s_axi_awready;
    wire [1:0] s_axi_bresp ;
    wire s_axi_bvalid;
    wire s_axi_wready;
    
    /////////////////////////////////////////////////////////////////
    
    //master read channel
    wire [31:0] m_axi_araddr [15:0];
    reg m_axi_arready  [15:0];
    wire m_axi_arvalid  [15:0];
    reg [31:0] m_axi_rdata  [15:0];
    wire m_axi_rready  [15:0];//bu neden output(anlamis olabilirim)
    // baslangicta her master icin 0 olmali
    
    reg [1:0] m_axi_rresp  [15:0];
    reg m_axi_rvalid  [15:0];
    
    //master write channel
    wire[31:0]m_axi_awaddr  [15:0];
    reg m_axi_awready  [15:0];
    wire m_axi_awvalid  [15:0];
    wire [31:0] m_axi_wdata  [15:0];
    reg m_axi_wready  [15:0];
    wire[3:0] m_axi_wstrb [15:0];
    wire m_axi_wvalid [15:0];
    
    reg [1:0] m_axi_bresp [15:0];
    reg m_axi_bvalid  [15:0]; 
    wire m_axi_bready [15:0];
    
    axi4lite_interconnect uut(s_axi_aclk,s_axi_areset,s_axi_araddr,s_axi_arvalid,s_axi_rready,s_axi_rdata,s_axi_arready,s_axi_rresp,s_axi_rvalid,s_axi_awaddr,
    s_axi_awvalid,s_axi_bready, s_axi_wdata,s_axi_wstrb,s_axi_wvalid,
    s_axi_awready,s_axi_bresp,s_axi_bvalid,s_axi_wready, m_axi_araddr,
    m_axi_arready,m_axi_arvalid,
    m_axi_rdata,m_axi_rready,m_axi_rresp,m_axi_rvalid,m_axi_awaddr,m_axi_awready,m_axi_awvalid,m_axi_wdata,m_axi_wready,m_axi_wstrb,m_axi_wvalid,
    m_axi_bresp,m_axi_bvalid,m_axi_bready);
    always begin
        s_axi_aclk = ~s_axi_aclk; #5;
    end
    
    
    initial begin
        s_axi_aclk=1;s_axi_areset=1;
        #10;
        /*
        s_axi_bready=1;
        s_axi_awvalid=1; s_axi_wvalid=1;
      
        m_axi_awready[0]=1;m_axi_awready[2]=1;m_axi_awready[3]=1;m_axi_awready[4]=1;m_axi_awready[5]=1; m_axi_awready[6]=1; 
       m_axi_awready[7]=1; m_axi_awready[8]=1; m_axi_awready[9]=1;m_axi_awready[10]=1;
        m_axi_awready[11]=1;m_axi_awready[12]=1;m_axi_awready[13]=1;m_axi_awready[14]=1;m_axi_awready[15]=1;
         m_axi_awready[1]=1; m_axi_wready[14]=1;m_axi_wready[15]=1;m_axi_wready[13]=1;m_axi_wready[12]=1;
         m_axi_wready[11]=1;m_axi_wready[10]=1;m_axi_wready[9]=1;m_axi_wready[8]=1;m_axi_wready[7]=1;m_axi_wready[6]=1;m_axi_wready[5]=1;m_axi_wready[4]=1;
         m_axi_wready[3]=1;m_axi_wready[2]=1;m_axi_wready[1]=1;m_axi_wready[0]=1;
        s_axi_awaddr=32'd300; s_axi_awvalid=1; s_axi_wdata=32'd22; s_axi_wstrb=4'd3;*/
        /*
        s_axi_araddr=32'd256; s_axi_arvalid=1;s_axi_rready=1;
        m_axi_arready[14]=1; 
        #50;
        m_axi_bresp[14]=2'b01;
        m_axi_bvalid[14]=1;
       */
       
       m_axi_arready[0]=1;m_axi_arready[2]=1;m_axi_arready[3]=1;m_axi_arready[4]=1;m_axi_arready[5]=1; m_axi_arready[6]=1; 
       m_axi_arready[7]=1; m_axi_arready[8]=1; m_axi_arready[9]=1;m_axi_arready[10]=1;
        m_axi_arready[11]=1;m_axi_arready[12]=1;m_axi_arready[13]=1;m_axi_arready[14]=1;m_axi_arready[15]=1;
         m_axi_arready[1]=1;
              while(i==0)begin
        
            m=$urandom%600;
        $display("%d",m);
       //   m_axi_awready[m]=1;
         //   m_axi_wready[m]=1;
         s_axi_araddr=m; s_axi_arvalid=1;s_axi_rready=1;
    //        s_axi_awaddr=m; s_axi_awvalid=1; s_axi_wdata=32'd22; s_axi_wstrb=4'd3;
    
            #10;
                 m_axi_rvalid[15]=1;
        m_axi_rresp[15]=2'b11;
      m_axi_rdata[15]=32'd89;
 //       m_axi_bresp[15]=2'b01;
  //      m_axi_bvalid[15]=1;
        end
  /*      
        m_axi_bvalid[0]=0;m_axi_bvalid[1]=0;m_axi_bvalid[3]=0;m_axi_bvalid[4]=0;m_axi_bvalid[5]=0; m_axi_bvalid[6]=0; m_axi_bvalid[7]=0; m_axi_bvalid[8]=0; m_axi_bvalid[9]=0;m_axi_bvalid[10]=0;
        m_axi_bvalid[11]=0;m_axi_bvalid[12]=0;m_axi_bvalid[13]=0;m_axi_bvalid[2]=0;m_axi_bvalid[15]=0;
        
        m_axi_rvalid[14]=1;
        m_axi_rresp[14]=2'b11;
      m_axi_rdata[14]=32'd89;

      m_axi_rvalid[7]=1;
        m_axi_rresp[7]=2'b11;
      m_axi_rdata[7]=32'd524;
        #10;
        s_axi_awvalid=0;
        s_axi_wvalid=0;
        s_axi_arvalid=0;
        #10;
*/
/*
        s_axi_bready=1;
        s_axi_awvalid=1; s_axi_wvalid=1;
        m_axi_awready[0]=0;m_axi_awready[1]=0;m_axi_awready[3]=1;m_axi_awready[4]=0;m_axi_awready[5]=0; m_axi_awready[6]=0; m_axi_awready[7]=0; m_axi_awready[8]=0; m_axi_awready[9]=0;m_axi_awready[10]=0;
        m_axi_awready[11]=0;m_axi_awready[12]=0;m_axi_awready[13]=0;m_axi_awready[14]=0;m_axi_awready[15]=0;
         m_axi_awready[2]=0; m_axi_wready[3]=1;
        s_axi_awaddr=32'd710; s_axi_awvalid=1; s_axi_wdata=32'd11; s_axi_wstrb=4'd0;
        
        #40;
        
        m_axi_bresp[3]=2'b11;
        m_axi_bvalid[3]=1;
        
        #10
        ;
        $finish;*/
    end
endmodule