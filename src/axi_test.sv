class axi_base_test extends uvm_test;
	//factory registation 
	`uvm_component_utils(axi_base_test)
        //memeory allocation 
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 

	//we are including env 
	axi_top_env    top_env;//handel creation 
	    

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//object creation 
		top_env=axi_top_env::type_id::create("top_env",this);
		 //handel creation of sequence 
	    //object creation of sequece 

	endfunction

endclass 

//single wr and rd 
class axi_single_wr_rd_test extends axi_base_test;
	`uvm_component_utils(axi_single_wr_rd_test)
        //memeory allocation 
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 

	//1.handel creation o single_wr_Rd_sequence
	axi_single_wr_rd_sequence   single_seq;

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
	$display("single test");


		single_seq=axi_single_wr_rd_sequence::type_id::create("single_seq");
		phase.raise_objection(this);
		single_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass 



//multiple wr and rd 
class axi_multiple_wr_rd_test extends axi_base_test;
	`uvm_component_utils(axi_multiple_wr_rd_test)
        //memeory allocation 
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 

	//1.handel creation o single_wr_Rd_sequence
	axi_multiple_wr_rd_sequence   multiple_seq;

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
	$display("multiplr test");


		multiple_seq=axi_multiple_wr_rd_sequence::type_id::create("multiple_seq");
		phase.raise_objection(this);
		multiple_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass


//multiple wr and rd 
class axi_multiple_wr_rd_write_then_read_test extends axi_base_test;
	`uvm_component_utils(axi_multiple_wr_rd_write_then_read_test)
        //memeory allocation 
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 

	//1.handel creation o single_wr_Rd_sequence
	axi_multiple_wr_rd_sequence_write_then_read   multiple_seq;

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		multiple_seq=axi_multiple_wr_rd_sequence_write_then_read::type_id::create("multiple_seq");
		phase.raise_objection(this);
		multiple_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass


//when we run this test we need to pluasrags +OUT_OF_ORDER_EN=1 need to make
//then only this transaction possible 
class out_of_order_test extends axi_base_test;
	`uvm_component_utils(out_of_order_test)
        //memeory allocation 
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 

	//1.handel creation o single_wr_Rd_sequence
	out_of_order_seq   out_seq;

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		out_seq=out_of_order_seq::type_id::create("out_seq");
		phase.raise_objection(this);
		out_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass

//when we need to run this test, need to add +OVERLAPING_EN=1 then only
//overlping transaction possible 
class overlaping_test extends axi_base_test;
	`uvm_component_utils(overlaping_test)
        //memeory allocation 
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 

	//1.handel creation o single_wr_Rd_sequence
	overlaping_seq   over_seq;

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		over_seq=overlaping_seq::type_id::create("over_seq");
		phase.raise_objection(this);
		over_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass



