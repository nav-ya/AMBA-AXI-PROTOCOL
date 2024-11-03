typedef enum{WRITE_ONLY, READ_ONLY, WRITE_THEN_READ, WRITE_PARALLEL_READ} wr_tx;




class axi_tx  extends uvm_sequence_item;

	//object class
	`uvm_object_utils(axi_tx)
	function new(string name="");
		super.new();
	endfunction
// used to send data from sequncer to driver 
// driver to monitor monitor o coveragr,monitor to scoreboard
// to achieve randomization
        rand wr_tx rd;
	rand logic[31:0] awaddr;//32bit it is fixed here ???????????
	rand logic[7:0] awid;
	rand logic awvalid;
	rand logic[3:0] awlen;
         logic awready;
	rand logic[3:0]awcache;
	rand logic[3:0]awsize;
	rand logic[1:0]awburst;
	rand logic[1:0]awlock;
	rand logic[3:0]awprot;

	//write data-6
	rand logic wvalid;
	 logic wready;
        rand logic[7:0]wid;
        rand logic[31:0] wdata[$];//Q array//MAXIMUM SUPPORTDS 1024 bits for evry clock cycle we ned to randomize data
        rand logic[3:0] wstrb;//4bytes in wdata 4 bits in srtb
        logic wlast;


	// write response-4
        logic bvalid;
	rand logic bready;
        logic[7:0]bid;
        logic[1:0] bresp;




	//read adress channel-10
	rand logic[31:0] araddr;//32bit it is fixed here ???????????
	rand logic[7:0] arid;
	rand logic arvalid;
	rand logic[3:0] arlen;
         logic  arready;
	rand logic[3:0]arcache;
	rand logic[3:0]arsize;
	rand logic[1:0]arburst;
	rand logic[1:0]arlock;
	rand logic[3:0]arprot;

	
	//read data channel-6
	 logic rvalid;
	rand logic rready;
        logic[7:0]rid;
        logic[31:0] rdata;
         logic[3:0] rstrobe;
	 logic rlast;
	 logic rresp;

	 constraint c1{
		 wdata.size()==awlen+1;}

		  constraint c2{
		       wid==awid;
	          }


endclass
