
class axi_base_sequence extends uvm_sequence#(axi_tx);
	`uvm_object_utils(axi_base_sequence)
	function new(string name="");
		super.new(name);
	endfunction 

endclass
class axi_single_wr_rd_sequence extends axi_base_sequence;
	`uvm_object_utils(axi_single_wr_rd_sequence)
	function new(string name="");
		super.new(name);
	endfunction 
	task body();
	
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==7; req.awlen==4; req.awsize==2; req.awburst==1; req.awid==5;});
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==7; req.arlen==4; req.arsize==2; req.arburst==1; req.arid==5;});
	        endtask
endclass

class axi_multiple_wr_rd_sequence extends axi_base_sequence;
	`uvm_object_utils(axi_multiple_wr_rd_sequence)
	function new(string name="");
		super.new(name);
	endfunction 

	task body();
		
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==7; req.awlen==4; req.awsize==2; req.awburst==1; req.awid==5;});
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==30; req.awlen==8; req.awsize==2; req.awburst==1; req.awid==10;});
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==100; req.awlen==15; req.awsize==2; req.awburst==1; req.awid==11;});
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==200; req.awlen==0; req.awsize==2; req.awburst==1; req.awid==12;});
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==300; req.awlen==1; req.awsize==2; req.awburst==1; req.awid==13;});
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==7; req.arlen==4; req.arsize==2; req.arburst==1; req.arid==5;});
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==30; req.arlen==8; req.arsize==2; req.arburst==1; req.arid==10;});
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==100; req.arlen==15; req.arsize==2; req.arburst==1; req.arid==11;});	
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==200; req.arlen==0; req.arsize==2; req.arburst==1; req.arid==12;});
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==300; req.arlen==1; req.arsize==2; req.arburst==1; req.arid==13;});
        endtask
endclass
class axi_multiple_wr_rd_sequence_write_then_read extends axi_base_sequence;
	`uvm_object_utils(axi_multiple_wr_rd_sequence_write_then_read )
	function new(string name="");
		super.new(name);
	endfunction 

	task body();
		
		`uvm_do_with(req,{req.rd==WRITE_THEN_READ; req.awaddr==7; req.awlen==4; req.awsize==2; req.awburst==1; req.awid==5; req.araddr==7; req.arlen==4; req.arsize==2; req.arburst==1; req.arid==5;});       
	
		`uvm_do_with(req,{req.rd==WRITE_THEN_READ; req.awaddr==100; req.awlen==10; req.awsize==2; req.awburst==1; req.awid==11; req.araddr==100; req.arlen==10; req.arsize==2; req.arburst==1; req.arid==11;});
	
		`uvm_do_with(req,{req.rd==WRITE_THEN_READ; req.awaddr==303; req.awlen==15; req.awsize==2; req.awburst==1; req.awid==12; req.araddr==303; req.arlen==15; req.arsize==2; req.arburst==1; req.arid==12;});
	        endtask
endclass
class out_of_order_seq extends axi_base_sequence;
	`uvm_object_utils(out_of_order_seq)
	function new(string name="");
		super.new(name);
	endfunction 
	task body();
		
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==4; req.awid==5; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==100; req.awid==10; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==200; req.awid==12; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==12; req.wvalid==1; req.awvalid==0;})	 
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==5; req.wvalid==1; req.awvalid==0;})
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==10; req.wvalid==1; req.awvalid==0;})
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==100; req.arid==10; req.arlen==3; req.arsize==2; req.arburst==1; }) 		
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==200; req.arid==12; req.arlen==3; req.arsize==2; req.arburst==1; })
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==4; req.arid==5; req.arlen==3; req.arsize==2; req.arburst==1; })

	endtask
endclass

class overlaping_seq extends axi_base_sequence;
	`uvm_object_utils(overlaping_seq)
	function new(string name="");
		super.new(name);
	endfunction 
	task body();		
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==4; req.awid==5; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==100; req.awid==10; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==0;})
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.awaddr==200; req.awid==12; req.awlen==3; req.awsize==2; req.awburst==1; req.awvalid==1; req.wvalid==1; req.wid==5; })
         	`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==12; req.wvalid==1; req.awvalid==1; req.awaddr==300; req.awid==15; req.awlen==3; req.awsize==2; req.awburst==1; })
            	`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==10; req.wvalid==1; req.awvalid==0;})
		`uvm_do_with(req,{req.rd==WRITE_ONLY; req.wid==15; req.wvalid==1; req.awvalid==0;})	
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==100; req.arid==7; req.arlen==3; req.arsize==2; req.arburst==1; }) 
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==200; req.arid==1; req.arlen==3; req.arsize==2; req.arburst==1; }) 
		`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==4; req.arid==2; req.arlen==3; req.arsize==2; req.arburst==1; }
              	`uvm_do_with(req,{req.rd==READ_ONLY; req.araddr==300; req.arid==8; req.arlen==3; req.arsize==2; req.arburst==1; })
	endtask
endclass




