class axi_master_driver extends uvm_driver#(axi_tx);
	`uvm_component_utils(axi_master_driver)
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction

virtual axi_interface mvif;
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
uvm_config_db#(virtual axi_interface)::get(this,"","vif",mvif);
endfunction
int k;

task run_phase(uvm_phase phase);
         super.run_phase(phase);
	 forever begin 
		 @(posedge mvif.aclk);		 		
		 seq_item_port.get_next_item(req);	 
		 driver_to_interface(req);
		 seq_item_port.item_done();
	 end
	 endtask


  task driver_to_interface(axi_tx req);
	  if(req.rd==WRITE_ONLY)begin
		 write_address_channel(req);
		 write_data_channel(req);
		 write_response_channel(req);  
	  end
	  if(req.rd==READ_ONLY)begin 
		  read_address_channel(req);
		 read_data_channel(req);
	  end
	  if(req.rd==WRITE_THEN_READ)begin 
		  write_address_channel(req);
		  write_data_channel(req);
		  write_response_channel(req);
		  read_address_channel(req);
		  read_data_channel(req);
	  end
	  if(req.rd==WRITE_PARALLEL_READ)begin 
		  fork
			  begin
		 write_address_channel(req);
		 write_data_channel(req);
		 write_response_channel(req);  
			  end
		          begin 
		  read_address_channel(req);
		  read_data_channel(req);
		      end
	      join 
	  end
	  endtask



	  task write_address_channel(axi_tx req);
                     case(req.awsize)
			 0:begin end
			 1:begin end
			 2:begin 
			      req.wstrb=4'hf;
   			      if(req.awaddr % (2** req.awsize) !=0)begin    
		        	k = req.awaddr % (2**req.awsize);
	                 for(int i=0; i<k; i++)begin  
		           req.wstrb[i]=0;
		               end 		    		   
			   end 
		       end 
			 3:begin end
			 4:begin end
			 5:begin end
			 6:begin end
			 7:begin end
		 endcase
		   
	   mvif.awaddr<=req.awaddr;
	   mvif.awvalid<=1;
	   mvif.awid<=req.awid;
	   mvif.awlen<=req.awlen;
	   mvif.awsize<=req.awsize;
	   mvif.awburst<=req.awburst;
	   mvif.awcache<=req.awcache;
	   mvif.awprot<=req.awprot;
	   mvif.awlock<=req.awlock;
	   wait(mvif.awready==1); 
	   @(posedge mvif.aclk);
	   mvif.awaddr<=0;
	    mvif.awvalid<=0;
	    mvif.awid<=0;
	    mvif.awlen<=0;
	    mvif.awsize<=0;
	    mvif.awprot<=0;
	    mvif.awcache<=0;
	    mvif.awburst<=0;
	    mvif.awlock<=0;
	  endtask

	  task write_data_channel(axi_tx req);
		  mvif.bready<=1;
		  mvif.wlast<=0;
		   for(int i=0; i<=req.awlen; i++)begin
                 	  mvif.wdata<=req.wdata.pop_back();  
			  mvif.wvalid<=1;
			  mvif.wid<= req.awid;
			  mvif.wstrb<=req.wstrb;
 			   if(i==req.awlen) mvif.wlast<=1;
			  wait(mvif.wready==1);
		           @(posedge mvif.aclk);	              
		     mvif.wlast<=0;
		     mvif.wvalid<=0;
		    for(int i=0; i<(2**req.awsize); i++)begin 
				  req.wstrb[i]=1;
			  end

		  end

	  endtask
	  task write_response_channel(axi_tx req);
		  wait(mvif.bvalid==1);
		  @(posedge mvif.aclk);
		     mvif.bready<=0; 
	  endtask
          task read_address_channel(axi_tx req);		
           mvif.araddr<=req.araddr;
	   mvif.arvalid<=1;
	   mvif.arid<=req.arid;
	   mvif.arlen<=req.arlen;
	   mvif.arsize<=req.arsize;
	   mvif.arburst<=req.arburst;
	   mvif.arcache<=req.arcache;
	   mvif.arprot<=req.arprot;
	   mvif.arlock<=req.arlock;
	   wait(mvif.arready==1);
	   @(posedge mvif.aclk); 
	    mvif.araddr<=0;
	    mvif.arvalid<=0;
	    mvif.arid<=0;
	    mvif.arlen<=0;
	    mvif.arsize<=0;
	    mvif.arprot<=0;
	    mvif.arcache<=0;
	    mvif.arburst<=0;
	    mvif.arlock<=0;	  
	  endtask
	  task read_data_channel(axi_tx req);
		   for(int i=0; i<=req.arlen; i++)begin 
			 mvif.rready<=1;
			wait(mvif.rvalid==1);
			 @(posedge mvif.aclk);
			 mvif.rready<=0;
		 end 

	  endtask

endclass 




