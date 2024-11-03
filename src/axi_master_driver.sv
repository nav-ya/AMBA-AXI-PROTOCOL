class axi_master_driver extends uvm_driver#(axi_tx);
	`uvm_component_utils(axi_master_driver)
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
//virtua interface 	from top module
virtual axi_interface mvif;
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
uvm_config_db#(virtual axi_interface)::get(this,"","vif",mvif);
endfunction
int k;

task run_phase(uvm_phase phase);
         super.run_phase(phase);
	 forever begin 
		 @(posedge mvif.aclk);//1st clock 
		 //we need to get all request from sequencer 
		 seq_item_port.get_next_item(req);//getting req
		 //put all inormation into interface  
		 driver_to_interface(req);
		 //send response to sequencer 
		 seq_item_port.item_done();
	 end
	 endtask


  task driver_to_interface(axi_tx req);
	  if(req.rd==WRITE_ONLY)begin
		 //write address channel
		 write_address_channel(req);
		 //write data channel 
		 write_data_channel(req);
		 //write response channel
		 write_response_channel(req);  
	  end
	  if(req.rd==READ_ONLY)begin 
		  //read address channel
		  read_address_channel(req);
		  //read data channel
		  read_data_channel(req);
	  end
	  if(req.rd==WRITE_THEN_READ)begin 
	 
		  //write address
		  write_address_channel(req);
		  //write data chann
		  write_data_channel(req);
		  //write response channel
		  write_response_channel(req);
		  //read address channel
		  read_address_channel(req);
		  //read data channel
		  read_data_channel(req);
	  end
	  if(req.rd==WRITE_PARALLEL_READ)begin 
		  fork
			  begin
		//write address channel
		 write_address_channel(req);
		 //write data channel 
		 write_data_channel(req);
		 //write response channel
		 write_response_channel(req);  
			  end
		          begin 
                 //read address channel
		  read_address_channel(req);
		  //read data channel
		  read_data_channel(req);
		      end
	      join 
	  end
	  endtask



	  task write_address_channel(axi_tx req);

//ALIGNED TO UNALIGNED WSTRB
                     case(req.awsize)
			 0:begin end
			 1:begin end
			 2:begin 
			      //if address is  aligned  then all bytes active 
			      req.wstrb=4'hf;// all bytes are active   
			      //if address is aunligned 1byte, 2nd or 3by byte not 0th byte //wstrb=4'b1111
		           if(req.awaddr % (2** req.awsize) !=0)begin //unaligned address case conditon true      
		        	k = req.awaddr % (2**req.awsize);//2%4=2
	                 for(int i=0; i<k; i++)begin // 2 times for loop 
		           req.wstrb[i]=0;//wstrb[0]=0  wstrb[1]=0   wstrb[2] & [3]
			   //wstrb=1100
			      
	                  end 		    		   
			   end 
			 			  
		          end //4 bytes are active 
			 3:begin end
			 4:begin end
			 5:begin end
			 6:begin end
			 7:begin end
		 endcase










		  //we are sending all write address channel signals to interface 
		   
	   mvif.awaddr<=req.awaddr;//2
	   mvif.awvalid<=1;//valid address & control information 
	   mvif.awid<=req.awid;
	   mvif.awlen<=req.awlen;
	   mvif.awsize<=req.awsize;
	   mvif.awburst<=req.awburst;
	   mvif.awcache<=req.awcache;
	   mvif.awprot<=req.awprot;
	   mvif.awlock<=req.awlock;
	   //we need to maintain same address & control untill ready come from slave 
	   wait(mvif.awready==1);//waiting untill ready come from slave 
	   @(posedge mvif.aclk);//2nd clock cycle 
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
		  
		  // sending all write data channel
		  
		  for(int i=0; i<=req.awlen; i++)begin

			  //2nd clock cycle wdata[3]=32'haabbccdd wdata[2]
			 
			  
			  mvif.wdata<=req.wdata.pop_back(); //get the data from wdata Q  array also delete the data from delete 
			  mvif.wvalid<=1;
			  mvif.wid<= req.awid;
			  // aligned unaligned ,narrow transfer 
			   mvif.wstrb<=req.wstrb;
 			   if(i==req.awlen) mvif.wlast<=1;
			  wait(mvif.wready==1);
		           @(posedge mvif.aclk);	              
		     mvif.wlast<=0;
		     mvif.wvalid<=0;
		    for(int i=0; i<(2**req.awsize); i++)begin // remining beats all bytes are active 
				  req.wstrb[i]=1;
			  end

		  end

	  endtask
	  task write_response_channel(axi_tx req);
		  // sensing all write response channel signals to interface 
		  wait(mvif.bvalid==1);
		  @(posedge mvif.aclk);
		     mvif.bready<=0; 
	  endtask



	  //----------------------read cahnnel---------------------------------
	  task read_address_channel(axi_tx req);
		  // sending all read address channel signas to interface
		  mvif.araddr<=req.araddr;//2
	   mvif.arvalid<=1;//valid address & control information 
	   mvif.arid<=req.arid;//5
	   mvif.arlen<=req.arlen;//3
	   mvif.arsize<=req.arsize;//2
	   mvif.arburst<=req.arburst;
	   mvif.arcache<=req.arcache;
	   mvif.arprot<=req.arprot;
	   mvif.arlock<=req.arlock;
	   //we need to maitaine same address & control untill ready come from
	   //slave 
	   wait(mvif.arready==1);//waiting untill ready come from slave 
	   @(posedge mvif.aclk);//2nd clock cycle 
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
		  //sending all read data signals to interface
		   for(int i=0; i<=req.arlen; i++)begin 
			 mvif.rready<=1;
			wait(mvif.rvalid==1);
			 @(posedge mvif.aclk);
			 mvif.rready<=0;
		 end 

	  endtask

endclass 




