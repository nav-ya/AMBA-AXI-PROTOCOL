// not extented from any uvm 
interface axi_interface(input bit aclk,aresetn);
// used to send data from sequncer to driver 
// driver to monitor monitor o coveragr,monitor to scoreboard
// to achieve randomization
	 logic[31:0] awaddr;//32bit it is fixed here ???????????
	 logic[7:0] awid;
	 logic awvalid;
	 logic[3:0] awlen;
         logic awready;
	 logic[3:0]awcache;
	 logic[3:0]awsize;
	 logic[1:0]awburst;
	 logic[1:0]awlock;
	 logic[3:0]awprot;

	//write data-6
	 logic wvalid;
	 logic wready;
         logic[7:0]wid;
         logic[31:0] wdata;//Q array//MAXIMUM SUPPORTDS 1024 bits for evry clock cycle we ned to randomize data
         logic[3:0] wstrb;//4bytes in wdata 4 bits in srtb
         logic wlast;


	// write response-4
        logic bvalid;
	 logic bready;
        logic[7:0]bid;
        logic[1:0] bresp;




	//read adress channel-10
	 logic[31:0] araddr;//32bit it is fixed here ???????????
	 logic[7:0] arid;
	 logic arvalid;
	 logic[3:0] arlen;
         logic  arready;
	 logic[3:0]arcache;
	 logic[3:0]arsize;
	 logic[1:0]arburst;
	 logic[1:0]arlock;
	 logic[3:0]arprot;         

	
	//read data channel-6
	 logic rvalid;
	 logic rready;
        logic[7:0]rid;
        logic[31:0] rdata;
         //logic[3:0] rstrobe;
	 logic rlast;
	 logic[1:0] rresp;
 endinterface
