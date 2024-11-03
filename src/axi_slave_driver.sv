class axi_slave_driver extends uvm_driver#(axi_tx);
	`uvm_component_utils(axi_slave_driver)
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
//virtua interface 	from top module
virtual axi_interface svif;
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
uvm_config_db#(virtual axi_interface)::get(this,"","vif",svif);
endfunction
//declare assosiative array for id (store the siganls as packets)
 axi_tx wr_tx[int];
 axi_tx rd_tx[int];

  int count;
  bit [7:0] byte_count;
  bit [3:0] response_id;
  bit [3:0] temp_read_id;//mainly used to store read first id 
  int temp_size;
 

  //create memeory 
  reg [7:0] mem [1000];//mem[0]  mem[1]  mem[2]
 task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin 
			@(posedge  svif.aclk);//for every posedge of clock we chaeck reset if it is 0 then moves to unknown state
			// reset ==0
			//$display("after forevr aresetn =%d",svif.aresetn);
                  if(svif.aresetn==0)begin  //SLAVE DRIVER IS NOT WORKING 
			 // $display("aresetn=0");
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
	// else reset ==1

                   else begin // reset==1
			   //	$display("aresetn=1");		

			   //Here comes valid and ready handshake mechanism
			   //where slave gives response as  ready responsefor
			   //input valid
			  // write address channel
			  if(svif.awvalid==0)
	                          svif.awready<=0;
			  //write data channel
			  if(svif.wvalid==0)
				 svif.wready<=0;
			 //write response
			 if(svif.bready==0)
				 svif.bvalid<=0;
			 //read adrress
			if(svif.arready==0)
			        svif.arvalid<=0;
			//read data
			if(svif.rready==0)
				svif.rvalid<=0;

// when master send valid adress
//$display("before if");
if(svif.awvalid==1)begin
//	$display("after if");

	       svif.awready<=1;//slave also ready to recive reqest 
	      //slave need to recive all address & cintrol 
	      //
	       wr_tx[svif.awid]=new();// create mem for axi_tex wr_tx[5]=new(),wr_tx[10]=new()
	       wr_tx[svif.awid].awaddr=svif.awaddr; 
	       wr_tx[svif.awid].awlen=svif.awlen;
	       wr_tx[svif.awid].awsize=svif.awsize;
	       wr_tx[svif.awid].awcache=svif.awcache;
	       wr_tx[svif.awid].awprot=svif.awprot;
	       wr_tx[svif.awid].awlock=svif.awlock;
	       wr_tx[svif.awid].awburst=svif.awburst;
	       wr_tx[svif.awid].awid=svif.awid; 
       end

       //after recieving adresss channel we recive data signals
       if(svif.wvalid==1)begin //master sending valid data //2nd clock cyle 
	       svif.wready<=1;
	 //incriment transaction
//ready to recive data from master 
//wdata size by awsize and nof bytes per transaction by awlen and active bytes
//by wstrb send by master which bytes are active,awburst define incriment 

//awburst master intially decide which transaction now awburst =1 ie
//incrimenet

  if(wr_tx[svif.wid].awburst==1)begin  
	  temp_size=$size(svif.wdata);
         byte_count=temp_size/8 ;
	  // now how many beats or transfers
	   for(int i=0; i<=wr_tx[svif.wid].awlen; i++)begin 
		   @(posedge svif.aclk);
		   $display("num of beats =%d address=%h wdata = %h wstrb=%h time=%d",i,wr_tx[svif.wid].awaddr ,svif.wdata,svif.wstrb,$time);
 		   // foreach (svif.wdata[j])   if (j % 8 == 0) byte_count++;//bits to bytes
		   //now according to awsize what are active bytes w have
		   //7 cases of awsize
		  case(wr_tx[svif.wid].awsize)
		   	0:begin //1 byte is active in each beat 
                                count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin //i=0   i=1 i=2
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
			
            wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
                         //wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % (temp_variable/8);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        
			         end
				 1:begin //2 bytes are active i each beat --128 diffrent lines 
				  count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin //i=0   i=1 i=2
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
					if(svif.wstrb[i]==1)begin //i=0  i=1  i=2 i=3
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
                                       count=count+1;	//1,2,3,4
					end 
				end 
				
		       //step1: convert unaligned to aligned address
            wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr %byte_count);
					 
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        
	             end
 3:begin //8 bytes are active in each beat
				   count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin //i=0   i=1 i=2
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end
				       //svif.wdata[i%8]  -- convert bit to
				       //bytes	
				end 
				
          wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        

			          end
				  4:begin //16 bytes are active in each beat
				   count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin //i=0   i=1 i=2
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
				
            wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        

			          end
				  5:begin //32 bytes are active in each beat
				   count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin //i=0   i=1 i=2
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
				
				/*wdata[31:0]  --- in the form bytes-4
				* wdata[63:0]   ---- 8    
				* wdaa[1023:0]    ---  128bytes  */ 
          wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        

				   end
				  6:begin //64 bytes 
				   count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin //i=0   i=1 i=2
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
			
			
               wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        

				    end
				  7:begin //128 bytes are active
				  count=0;
				for(int i=0; i<128; i++)begin 
					if(svif.wstrb[i]==1)begin //i=0   i=1 i=2
					mem[wr_tx[svif.wid].awaddr + count] = svif.wdata[i*8 +: 8];
					count=count+1;	
					end 
				end 
		
             wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr - (wr_tx[svif.wid].awaddr % byte_count);
			 wr_tx[svif.wid].awaddr = wr_tx[svif.wid].awaddr + byte_count;        
 
				     end  

			endcase
	//awsize recieved from master address calucated aligned unaligned
	//@(posedge svif.aclk);// after awsize next clock  next data
end//for
end//awburst
end//wvalid
//recieved data
//walst 
	if(svif.wlast==1)begin //last beat of data 
		response_id=svif.wid;
		//next posedge of clock we are expecting response 

     //@(posedge svif.aclk);
       //3.write response channel
       if(svif.bready==1)begin //master is ready to recive response
	       svif.bvalid<=1;//slave also ready to send response 
	       //bid and bresp from slave 
	       svif.bresp<=2'b00;//ok response 
	       svif.bid<=response_id;
       end
       end
       //------------------------------------------------------READCHANNEL---------------------------------

 //4.read address channel
       if(svif.arvalid==1)begin //master sending valid read address & co ntrol information 
	       svif.arready<=1;//slave also ready to recive read request
	       rd_tx[svif.arid]=new();// create mem for axi_tex wr_tx[5]=new(),wr_tx[10]=new()
	       rd_tx[svif.arid].araddr=svif.araddr; 
	       rd_tx[svif.arid].arlen=svif.arlen;
	       rd_tx[svif.arid].arsize=svif.arsize;
	       rd_tx[svif.arid].arcache=svif.arcache;
	       rd_tx[svif.arid].arprot=svif.arprot;
	       rd_tx[svif.arid].arlock=svif.arlock;
	       rd_tx[svif.arid].arburst=svif.arburst;
	       rd_tx[svif.arid].arid=svif.arid; 

       end
       //5.read data channel
      
      if(svif.rready==1)begin //master is ready to recive read data or response    //st2
	       svif.rvalid<=1;//slave also ready to send rdata and response 
	       //$display("rd_tx=%0d",rd_tx.size);

	       if(rd_tx.size()>0)begin //if some read address is avilable then only need to send read data 
		       rd_tx.first(temp_read_id);
	       //incriment
	       if(rd_tx[temp_read_id].arburst==1)begin  //rd_tx[5].arburst
	       //how many beats of data need to send from memeory 
	       for(int i=0; i<=rd_tx[temp_read_id].arlen; i++)begin//4 times  
	       //what is the size of beat 
               case(rd_tx[temp_read_id].arsize)
		       0:begin end 
		       1:begin end
		       2:begin //rdata 128 bytes awize=2 only 4 bytes are active 

		           //convert unaligned address to aligned address 
	rd_tx[temp_read_id].araddr= rd_tx[temp_read_id].araddr - (rd_tx[temp_read_id].araddr % (2** rd_tx[temp_read_id].arsize)); 		   
                                 count=0;
				 for(int i=0; i<(2** rd_tx[temp_read_id].arsize) ; i++)begin //4times

					
				svif.rdata[i*8 +: 8] = mem[rd_tx[temp_read_id].araddr + count];
				$display("mem =%p,%d",mem[rd_tx[temp_read_id].araddr],count);
				count=count+1;	
				end 
				svif.rid<=temp_read_id;//
				svif.rresp<=2'b00;//ok response 
				if(i == rd_tx[temp_read_id].arlen) svif.rlast<=1;
		       end 
		       3:begin end 
		       4:begin end 
		       5:begin end 
		       6:begin end 
		       7:begin end
	       endcase 
				//next beat start address 
			rd_tx[temp_read_id].araddr = rd_tx[temp_read_id].araddr + (2** rd_tx[temp_read_id].arsize);	 // addr =0 +4=4   8

			@(posedge svif.aclk);//between one beat to anothe beat making one clock cycle dealy
		          svif.rlast<=0;	
                           //need to check every posedge of clock arvalid is
			   //high or not 
	      if(svif.arvalid==1)begin //master sending valid read address & co ntrol information 
	       svif.arready<=1;//slave also ready to recive read request
	       rd_tx[svif.arid]=new();//rd_tx[20] size is 3 
	       rd_tx[svif.arid].araddr=svif.araddr; 
	       rd_tx[svif.arid].arlen=svif.arlen;
	       rd_tx[svif.arid].arsize=svif.arsize;
	       rd_tx[svif.arid].arcache=svif.arcache;
	       rd_tx[svif.arid].arprot=svif.arprot;
	       rd_tx[svif.arid].arlock=svif.arlock;
	       rd_tx[svif.arid].arburst=svif.arburst;
	       rd_tx[svif.arid].arid=svif.arid;
               end//if
      

	       end//for loop
              end //burst
	      rd_tx.delete(temp_read_id);//delete id 5 information from array 
      end//rd_tx size end 


       end//rready 

			
      
	end//areset=1
		end
	endtask

 	


	
endclass
















