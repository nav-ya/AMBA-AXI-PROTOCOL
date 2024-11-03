class axi_slave_agent extends uvm_agent;
	`uvm_component_utils(axi_slave_agent)
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
        axi_slave_driver sdrv;
		function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sdrv= axi_slave_driver::type_id::create("sdrv",this);
		endfunction
endclass
