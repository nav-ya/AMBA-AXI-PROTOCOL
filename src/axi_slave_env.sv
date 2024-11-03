class axi_slave_env extends uvm_env;
	`uvm_component_utils(axi_slave_env)
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
	
	axi_slave_agent agent;
		function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent= axi_slave_agent::type_id::create("agent",this);
		endfunction
endclass


