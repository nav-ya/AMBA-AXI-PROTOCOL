class axi_coverage extends uvm_subscriber#(axi_tx);
	`uvm_component_utils(axi_coverage);
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
	function void write(axi_tx t);
	endfunction
endclass
