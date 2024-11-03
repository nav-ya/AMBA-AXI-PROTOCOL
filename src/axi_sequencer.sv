class axi_sequencer extends uvm_sequencer#(axi_tx);
	`uvm_component_utils(axi_sequencer);
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
endclass
