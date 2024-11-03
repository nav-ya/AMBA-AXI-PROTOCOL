class axi_master_env extends uvm_env;
	`uvm_component_utils(axi_master_env)
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
	axi_master_agent agent;
	axi_coverage    cov;
	axi_scoreboard   sco;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent= axi_master_agent::type_id::create("agent",this);
		cov= axi_coverage::type_id::create("cov",this);
                sco= axi_scoreboard::type_id::create("sco",this);
	endfunction
endclass





