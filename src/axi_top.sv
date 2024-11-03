module axi_top;
// include axi_test clss
//clock geengertaion
bit aclk,aresetn;
//50%duty cycle 
initial begin
//	aclk=0; by default it is zero
	forever #5 aclk=~aclk;
end
initial begin
	aresetn=0;
	repeat(2)@(posedge aclk);
	aresetn=1;
end
	axi_interface intf(aclk,aresetn);//include physical interface
	// pointing pI TO vIRTUAL INTERFACE WITH CONFIG DB METHOD
	initial begin
	uvm_config_db#(virtual axi_interface)::set(null,"*","vif",intf);
	//virtual interface handle name vif and physical interface handle name
	//intf , we are pointing memonry
end
initial begin 
	$display("top");
	run_test("axi_multiple_wr_rd_test");
	
	$display("top3");

end
endmodule 
