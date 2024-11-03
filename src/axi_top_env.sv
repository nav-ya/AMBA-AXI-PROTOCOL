class axi_top_env extends uvm_env;
	`uvm_component_utils(axi_top_env)
	function new (string name  ="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
	axi_master_env menv;
	axi_slave_env senv;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	        menv= axi_master_env::type_id::create("menv",this);
		senv= axi_slave_env::type_id::create("senv",this);
	endfunction
endclass


