`timescale 1ns / 1ps


module axilite_interconnect  
#(  
parameter numOfMasters                    = 16, //maximum 16 olabilir
parameter [32*numOfMasters-1:0] base_address_of_masters = 0, //master 15'ten 0'a
    parameter [32*numOfMasters-1:0] ranges_of_masters       = 0 //master 15'ten 0'a     
  
 )
(

    input              s_axi_aclk                       ,
    input              s_axi_aresetn                    ,
    
    //slave read channel
    input      [31:0]  s_axi_araddr                     ,
    input              s_axi_arvalid                    ,
    input              s_axi_rready                     ,
    input      [2:0]   s_axi_arprot                     ,
    output reg [31:0]  s_axi_rdata                      ,   
    output reg         s_axi_arready,
    output reg [1:0]   s_axi_rresp,
    output reg         s_axi_rvalid, // veri okunduktan sonra sadece 1 cevrim high
    
    //slave write channel
    input      [31:0]  s_axi_awaddr                     ,
    input              s_axi_awvalid                    ,
    input              s_axi_bready                     ,
    input      [31:0]  s_axi_wdata                      ,
    input      [3:0]   s_axi_wstrb                      ,
    input              s_axi_wvalid                     ,
    input      [2:0]   s_axi_awprot                     ,
    output reg         s_axi_awready                    ,
    output reg [1:0]   s_axi_bresp                      ,
    output reg         s_axi_bvalid                     ,
    output reg         s_axi_wready                     ,
    
    /////////////////////////////////////////////////////////////////
    
    //master read channel
    output reg [32*numOfMasters-1:0]  m_axi_araddr  ,
    input      [numOfMasters-1:0]   m_axi_arready ,
    output reg [numOfMasters-1:0]   m_axi_arvalid ,
    input      [32*numOfMasters-1:0]  m_axi_rdata   ,
    output reg  [2*numOfMasters-1:0]  m_axi_rready  , //bu neden output(anlamis olabilirim)
    
    output reg [3*numOfMasters-1:0]   m_axi_arprot  , //3 bit
    input      [2*numOfMasters-1:0]   m_axi_rresp   , //2 bit
    input      [numOfMasters-1:0]   m_axi_rvalid  ,

    //m
    output reg [32*numOfMasters-1:0]  m_axi_awaddr  ,
    input      [numOfMasters-1:0]  m_axi_awready ,
    output reg  [numOfMasters-1:0]       m_axi_awvalid ,
    output reg [32*numOfMasters-1:0]  m_axi_wdata   ,
    input      [numOfMasters-1:0]        m_axi_wready  ,
    output reg [4*numOfMasters-1:0]   m_axi_wstrb   , //4 bit
    output reg   [numOfMasters-1:0]      m_axi_wvalid  ,
    output reg [3*numOfMasters-1:0]   m_axi_awprot  , //3 bit

    input      [2*numOfMasters-1:0]   m_axi_bresp   ,
    input       [numOfMasters-1:0]       m_axi_bvalid  ,   
    output reg  [numOfMasters-1:0]       m_axi_bready  
 );
 
    reg [32*numOfMasters-1:0] base_address_of_masters_r;
    reg [32*numOfMasters-1:0] ranges_of_masters_r      ;
    
    integer i,m,n;
    initial begin
        for(i=0;i<numOfMasters;i++)begin
            m_axi_arvalid[i]=1'b0;
            m_axi_awvalid[i]=1'b0;
            m_axi_wvalid[i] =1'b0;
            m_axi_bready[i] =1'b0; //????
            m_axi_rready[i] =1'b0;
           
        end
        s_axi_arready =1;
        s_axi_awready =1;
        s_axi_bvalid  =0;
        s_axi_rvalid  =0;
        s_axi_wready  =1;
        
        for(m=0;m<numOfMasters;m++)begin
            base_address_of_masters_r[m*32+:32] = base_address_of_masters[m+:32];
            ranges_of_masters_r[m*32+:32] = ranges_of_masters[m+:32];
           
        end
        
    end
 

    reg [3:0]  master_no_read       ; //16 master icin 4 bit yeterli
    reg [3:0]  master_no_write      ;
    
    reg [3:0]  master_no_read_e     ;
    reg [3:0]  master_no_write_e    ;
    

    reg [31:0] master_addr_read     ;
    reg [31:0] master_addr_write    ;

    
    reg        reading=0            ;
    reg        writing=0            ;
    
    always @(s_axi_araddr or s_axi_awaddr) begin
        if(s_axi_arvalid==1)begin
            for(n=0;n<numOfMasters;n++)begin
               if($signed(s_axi_araddr)<=$signed(ranges_of_masters[n*32+:32]+base_address_of_masters_r[n*32+:32]-1) && s_axi_araddr>=base_address_of_masters_r[n*32+:32]) begin
                   master_no_read=n;
                   master_addr_read=s_axi_araddr-base_address_of_masters_r[n*32+:32];
               end         
            end       
        end
        
        if(s_axi_awvalid==1)begin
            for(n=0;n<numOfMasters;n++)begin
               if($signed(s_axi_awaddr)<=$signed(ranges_of_masters[n*32+:32]+base_address_of_masters_r[n*32+:32]-1) && s_axi_awaddr>=base_address_of_masters_r[n*32+:32]) begin       
                   master_no_write=n;
                   master_addr_write=s_axi_awaddr-base_address_of_masters_r[n*32+:32];
               end
            end
        end
    end
    always @(posedge s_axi_aclk)begin
    
        if(s_axi_aresetn)begin
         //   $display("%d",master_no_write);
            if(s_axi_arvalid && s_axi_rready && m_axi_arready[master_no_read] && reading==0)begin
                m_axi_araddr[master_no_read*32+:32]<=master_addr_read;
                m_axi_arvalid[master_no_read]<=1;
                master_no_read_e<=master_no_read;
                s_axi_arready<=0;
                m_axi_rready[master_no_read]<=1;
                reading<=1;
                m_axi_arprot[master_no_read*3+:3]<=s_axi_arprot;

            end
            if(s_axi_awvalid && s_axi_wvalid && m_axi_awready[master_no_write] && writing==0 && m_axi_wready[master_no_write])begin
                m_axi_awaddr[master_no_write*32+:32]<=master_addr_write;
                m_axi_awvalid[master_no_write]<=1;
                master_no_write_e<=master_no_write;
                s_axi_awready<=0;
                m_axi_wstrb[master_no_write*4+:4]<=s_axi_wstrb;
                m_axi_bready[master_no_write]<=1;
                s_axi_wready<=0;
                m_axi_wdata[master_no_write*32+:32]<=s_axi_wdata;
                m_axi_wvalid[master_no_write]<=1;
                writing<=1;
                m_axi_awprot[master_no_write*3+:3]<=s_axi_awprot;

            end
        end
       
        else begin //reset begin
            for(i=0;i<numOfMasters;i++)begin
                m_axi_arvalid[i]<=1'b0;
                m_axi_awvalid[i]<=1'b0;
                m_axi_wvalid[i] <=1'b0;
                m_axi_bready[i] <=1'b0; //????
                m_axi_rready[i] <=1'b0;
            end
            s_axi_arready <=1;
            s_axi_awready <=1;
            s_axi_bvalid  <=0;
            s_axi_rvalid  <=0;
            s_axi_wready  <=1;
            reading       <=0;
            writing       <=0;

        end  //reset end
    end
    
     always @(posedge s_axi_aclk)begin
        if(s_axi_aresetn)begin
        //&& s_axi_arvalid==0
            if(reading==0 )begin
                s_axi_arready<=1;
                s_axi_rvalid<=0;
                m_axi_arvalid[master_no_read_e]<=0;
                m_axi_rready[master_no_read_e]<=0;
                s_axi_arready<=1;
            end
            if(reading==1 && m_axi_rvalid[master_no_read_e] )begin
                s_axi_rdata<=m_axi_rdata[master_no_read_e*32+:32];
                s_axi_rvalid<=1;
                s_axi_rresp<=m_axi_rresp[master_no_read_e*2+:2];
                reading<=0;
                
            end
            if(writing==1 && m_axi_bvalid[master_no_write_e])begin
                m_axi_bready[master_no_write_e]<=0;
                writing<=0;
                s_axi_bresp<=m_axi_bresp[master_no_write_e*2+:2];
                s_axi_bvalid<=1;
   //             s_axi_awready<=1;
    //            s_axi_wready<=1;
            end
            //&& (  s_axi_awvalid==0 || s_axi_wvalid==0)
            if(writing==0 )begin
                s_axi_awready<=1;
                s_axi_wready<=1;
                m_axi_wvalid[master_no_write_e]<=0;
                m_axi_awvalid[master_no_write_e]<=0;
                s_axi_bvalid<=0;
                
            end
        end
     end
    
    
endmodule