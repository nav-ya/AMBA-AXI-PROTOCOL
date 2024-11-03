class axi_master_agent extends uvm_agent;
	`uvm_component_utils(axi_master_agent)
	function new(string name="",uvm_component parent= null);
		super.new(name,parent);
	endfunction
	// include master_agent   coverage & scoreboard
	axi_sequencer  seqr;
	axi_master_driver  mdrv;
	axi_monitor   mon;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seqr= axi_sequencer::type_id::create("seqr",this);
		mdrv= axi_master_driver::type_id::create("mdrv",this);
                mon= axi_monitor::type_id::create("mon",this);

	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mdrv.seq_item_port.connect(seqr.seq_item_export);
	endfunction
endclass

