class axi_base_test extends uvm_test;
	`uvm_component_utils(axi_base_test)
 	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 
	axi_top_env    top_env;	    

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		top_env=axi_top_env::type_id::create("top_env",this);
	endfunction

endclass 
class axi_single_wr_rd_test extends axi_base_test;
	`uvm_component_utils(axi_single_wr_rd_test)
    	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 
	axi_single_wr_rd_sequence   single_seq;
	task run_phase(uvm_phase phase);
		super.run_phase(phase);	
	single_seq=axi_single_wr_rd_sequence::type_id::create("single_seq");
		phase.raise_objection(this);
		single_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass 
class axi_multiple_wr_rd_test extends axi_base_test;
	`uvm_component_utils(axi_multiple_wr_rd_test)
       	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 
	axi_multiple_wr_rd_sequence   multiple_seq;
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		multiple_seq=axi_multiple_wr_rd_sequence::type_id::create("multiple_seq");
		phase.raise_objection(this);
		multiple_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask
endclass
class axi_multiple_wr_rd_write_then_read_test extends axi_base_test;
	`uvm_component_utils(axi_multiple_wr_rd_write_then_read_test) 
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 
	axi_multiple_wr_rd_sequence_write_then_read   multiple_seq;
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		multiple_seq=axi_multiple_wr_rd_sequence_write_then_read::type_id::create("multiple_seq");
		phase.raise_objection(this);
		multiple_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass

class out_of_order_test extends axi_base_test;
	`uvm_component_utils(out_of_order_test)
        	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 
	out_of_order_seq   out_seq;
	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		out_seq=out_of_order_seq::type_id::create("out_seq");
		phase.raise_objection(this);
		out_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass

class overlaping_test extends axi_base_test;
	`uvm_component_utils(overlaping_test)
        	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 
	overlaping_seq   over_seq;
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		over_seq=overlaping_seq::type_id::create("over_seq");
		phase.raise_objection(this);
		over_seq.start(top_env.menv.agent.seqr);
		phase.drop_objection(this);
	endtask

endclass



