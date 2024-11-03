
//basse sequece 
class axi_base_sequence extends uvm_sequence#(axi_tx);
	`uvm_object_utils(axi_base_sequence)
	function new(string name="");
		super.new(name);
	endfunction 

endclass



//TESTCASE1: SINGLE WR_RD SEQUENCE INCR
class axi_single_wr_rd_sequence extends axi_base_sequence;
	`uvm_object_utils(axi_single_wr_rd_sequence)
	function new(string name="");
		super.new(name);
	endfunction 

	task body();
		//first write
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==7; req.awlen==4; req.awsize==2; req.awburst==1; req.awid==5;});
		//first read
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==7; req.arlen==4; req.arsize==2; req.arburst==1; req.arid==5;});
	        endtask
endclass




//TESTCASE2:Multiple write & read transaction  INCR 
class axi_multiple_wr_rd_sequence extends axi_base_sequence;
	`uvm_object_utils(axi_multiple_wr_rd_sequence)
	function new(string name="");
		super.new(name);
	endfunction 

	task body();
		//first write
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==7; req.awlen==4; req.awsize==2; req.awburst==1; req.awid==5;});
		//second write
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==30; req.awlen==8; req.awsize==2; req.awburst==1; req.awid==10;});
		//3rd write
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==100; req.awlen==15; req.awsize==2; req.awburst==1; req.awid==11;});
		//4th write
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==200; req.awlen==0; req.awsize==2; req.awburst==1; req.awid==12;});
		//5th write
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==300; req.awlen==1; req.awsize==2; req.awburst==1; req.awid==13;});
		//first read
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==7; req.arlen==4; req.arsize==2; req.arburst==1; req.arid==5;});
		//second  read
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==30; req.arlen==8; req.arsize==2; req.arburst==1; req.arid==10;});
		//3rd  read
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==100; req.arlen==15; req.arsize==2; req.arburst==1; req.arid==11;});
		//4th  read
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==200; req.arlen==0; req.arsize==2; req.arburst==1; req.arid==12;});
		//5th   read
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==300; req.arlen==1; req.arsize==2; req.arburst==1; req.arid==13;});
        endtask
endclass
class axi_multiple_wr_rd_sequence_write_then_read extends axi_base_sequence;
	`uvm_object_utils(axi_multiple_wr_rd_sequence_write_then_read )
	function new(string name="");
		super.new(name);
	endfunction 

	task body();
		//first write then read
		`uvm_do_with(req,{req.rd==WRITE_THEN_READ; req.awaddr==7; req.awlen==4; req.awsize==2; req.awburst==1; req.awid==5; req.araddr==7; req.arlen==4; req.arsize==2; req.arburst==1; req.arid==5;});       
		//second write then read 
		`uvm_do_with(req,{req.rd==WRITE_THEN_READ; req.awaddr==100; req.awlen==10; req.awsize==2; req.awburst==1; req.awid==11; req.araddr==100; req.arlen==10; req.arsize==2; req.arburst==1; req.arid==11;});
		//3rd write the read 
		`uvm_do_with(req,{req.rd==WRITE_THEN_READ; req.awaddr==303; req.awlen==15; req.awsize==2; req.awburst==1; req.awid==12; req.araddr==303; req.arlen==15; req.arsize==2; req.arburst==1; req.arid==12;});
	        endtask
endclass
class out_of_order_seq extends axi_base_sequence;
	`uvm_object_utils(out_of_order_seq)
	function new(string name="");
		super.new(name);
	endfunction 
	task body();
		//first write address 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==4; req.awid==5; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		//second write address 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==100; req.awid==10; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		//3rd write address 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==200; req.awid==12; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
                //3 data we will genrate diffrent order w.r.t addresss 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==12; req.wvalid==1; req.awvalid==0;})//data is random
		 //2nd datav
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==5; req.wvalid==1; req.awvalid==0;})//data is random
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==10; req.wvalid==1; req.awvalid==0;})//data is random

		//read transaction 

		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==100; req.arid==10; req.arlen==3; req.arsize==2; req.arburst==1; }) //  100 th address write data  
		//second write address 
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==200; req.arid==12; req.arlen==3; req.arsize==2; req.arburst==1; })//   200th address write data 
		//3rd write address 
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==4; req.arid==5; req.arlen==3; req.arsize==2; req.arburst==1; })//5th address write data expecting
                //3 data we will genrate diffrent order w.r.t addresss 




	endtask
endclass




//overlaping transaction 
class overlaping_seq extends axi_base_sequence;
	`uvm_object_utils(overlaping_seq)
	function new(string name="");
		super.new(name);
	endfunction 
	task body();
		//first write address 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==4; req.awid==5; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		//second write address 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==100; req.awid==10; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		//3rd write address 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==200; req.awid==12; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==1; req.wid==5; })

                //first write data related also sending 4th write address  
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==12; req.wvalid==1; req.awvalid==1; req.awaddr==300; req.awid==15; req.awlen==3; req.awsize==2; req.awburst==1; })//data is random
                //2nd write data related to awid=5 or awaddr=4 becuse
		//wid=5, first write address data moving second time to slave
		//driver  
		 
	//	`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==5; req.wvalid==1; req.awvalid==0;})//data is random //awlen=0 
		
                //3rd write data related to awid=10 or awaddr=100 becuse
		//wid=10   , second write address data will send to slave
		//driver 3rd time.
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==10; req.wvalid==1; req.awvalid==0;})//data is random
//4th write data 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==15; req.wvalid==1; req.awvalid==0;})//data is random
		//read transaction 

		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==100; req.arid==7; req.arlen==3; req.arsize==2; req.arburst==1; }) //  100 th address write data  
		//second write address 
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==200; req.arid==1; req.arlen==3; req.arsize==2; req.arburst==1; })//   200th address write data 
		//3rd write address 
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==4; req.arid==2; req.arlen==3; req.arsize==2; req.arburst==1; })//5th address write data expecting
                //3 data we will genrate diffrent order w.r.t addresss 
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==300; req.arid==8; req.arlen==3; req.arsize==2; req.arburst==1; })//5th address write data expecting




	endtask
endclass




