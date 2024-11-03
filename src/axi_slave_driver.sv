class axi_slave_driver extends uvm_driver#(axi_tx);
	`uvm_component_utils(axi_slave_driver)
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
virtual axi_interface svif;
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
uvm_config_db#(virtual axi_interface)::get(this,"","vif",svif);
endfunction
 axi_tx wr_tx[int];
 axi_tx rd_tx[int];

  int count;
  bit [7:0] byte_count;
  bit [3:0] response_id;
  bit [3:0] temp_read_id;  int temp_size;
  reg [7:0] mem [1000]; task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin 
			@(posedge  svif.aclk);		
      			if(svif.aresetn==0)begin 
			        	svif.awready<=1'bx;
					svif.wready<=1'bx;
					svif.bresp<=2'bxx;
					svif.bid<=4'bxxxx;
					svif.bvalid<=1'bx;
					svif.arready<=1'bx;
					svif.rdata<=32'hxxxxxxxx;
					svif.rvalid<=1'bx;
					svif.rlast<=1'bx;
					svif.rid<=4'bxxxx;
					svif.rresp<=2'bxx;
					for(int i=0 ;i<1000;i++)begin
						mem[i]=0;
					end
				end
	
                   else begin			  
 			   if(svif.awvalid==0)
	                          svif.awready<=0;
			  if(svif.wvalid==0)
				 svif.wready<=0;
			 if(svif.bready==0)
				 svif.bvalid<=0;
			if(svif.arready==0)
			        svif.arvalid<=0;
			if(svif.rready==0)
				svif.rvalid<=0;
if(svif.awvalid==1)begin
	       svif.awready<=1;	      
	       wr_tx[svif.awid]=new();	       
	       wr_tx[svif.awid].awaddr=svif.awaddr; 
	       wr_tx[svif.awid].awlen=svif.awlen;
	       wr_tx[svif.awid].awsize=svif.awsize;
	       wr_tx[svif.awid].awcache=svif.awcache;
	       wr_tx[svif.awid].awprot=svif.awprot;
	       wr_tx[svif.awid].awlock=svif.awlock;
	       wr_tx[svif.awid].awburst=svif.awburst;
	       wr_tx[svif.awid].awid=svif.awid; 
       end
       if(svif.wvalid==1)begin 
	       svif.wready<=1;
  if(wr_tx[svif.wid].awburst==1)begin  
	  temp_size=$size(svif.wdata);
         byte_count=temp_size/8 ;
	   for(int i=0; i<=wr_tx[svif.wid].awlen; i++)begin 
		   @(posedge svif.aclk);
		   case(wr_tx[svif.wid].awsize)
		   	0:begin /                             
			     	count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin 
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
			
            wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
                    			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        
			         end
				 1:begin 
				  count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin
						mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
             wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;  
		 end
		 2:begin
			  count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin 
						mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
                                       count=count+1;					end 
				end 
				
		    		wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr %byte_count);
					 
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        
	             end
                  3:begin 				 
		              count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin 
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end
				      
			end 
				
          wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        

			          end
				  4:begin
       					  count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
				
            wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        

			          end
				  5:begin
       					  count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin 
						mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
				
			
		      		wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        

				   end
				  6:begin 
				  count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin
						mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
			
			
               wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        

				    end
				  7:begin
					  count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin
						mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
		
             wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        
 
				     end  

			endcase
	end
end
end
	if(svif.wlast==1)begin 
		response_id=svif.wid;
	       if(svif.bready==1)begin 
	       svif.bvalid<=1;
	       svif.bresp<=2'b00;
	       svif.bid<=response_id;
       end
       end
       if(svif.arvalid==1)begin 
	       svif.arready<=1;
	       rd_tx[svif.arid]=new();
	       rd_tx[svif.arid].araddr=svif.araddr; 
	       rd_tx[svif.arid].arlen=svif.arlen;
	       rd_tx[svif.arid].arsize=svif.arsize;
	       rd_tx[svif.arid].arcache=svif.arcache;
	       rd_tx[svif.arid].arprot=svif.arprot;
	       rd_tx[svif.arid].arlock=svif.arlock;
	       rd_tx[svif.arid].arburst=svif.arburst;
	       rd_tx[svif.arid].arid=svif.arid; 

       end
      
      if(svif.rready==1)begin 
	      svif.rvalid<=1;
	       if(rd_tx.size()>0)begin 
		       rd_tx.first(temp_read_id);
	       if(rd_tx[temp_read_id].arburst==1)begin  
		       for(int i=0; i<=rd_tx[temp_read_id].arlen; i++)begin
		       case(rd_tx[temp_read_id].arsize)
		       0:begin end 
		       1:begin end
		       2:begin 
	       	       rd_tx[temp_read_id].araddr= rd_tx[temp_read_id].araddr - (rd_tx[temp_read_id].araddr % (2** rd_tx[temp_read_id].arsize)); 		   
                                 count=0;
				 for(int i=0; i<(2** rd_tx[temp_read_id].arsize) ; i++)begin 
					
				svif.rdata[i*8 +: 8] = mem[rd_tx[temp_read_id].araddr + count];
				$display("mem =%p,%d",mem[rd_tx[temp_read_id].araddr],count);
				count=count+1;	
				end 
				svif.rid<=temp_read_id;
				svif.rresp<=2'b00;
				if(i == rd_tx[temp_read_id].arlen) svif.rlast<=1;
		       end 
		       3:begin end 
		       4:begin end 
		       5:begin end 
		       6:begin end 
		       7:begin end
	       endcase 
			rd_tx[temp_read_id].araddr = rd_tx[temp_read_id].araddr + (2** rd_tx[temp_read_id].arsize);	
			@(posedge svif.aclk);
			svif.rlast<=0;	
                      	      if(svif.arvalid==1)begin 
	       svif.arready<=1;
	       rd_tx[svif.arid]=new();
	       rd_tx[svif.arid].araddr=svif.araddr; 
	       rd_tx[svif.arid].arlen=svif.arlen;
	       rd_tx[svif.arid].arsize=svif.arsize;
	       rd_tx[svif.arid].arcache=svif.arcache;
	       rd_tx[svif.arid].arprot=svif.arprot;
	       rd_tx[svif.arid].arlock=svif.arlock;
	       rd_tx[svif.arid].arburst=svif.arburst;
	       rd_tx[svif.arid].arid=svif.arid;
               end
      

	       end
              end 
	      rd_tx.delete(temp_read_id);
      end
end

			
      
	end
		end
	endtask

 	


	
endclass
















