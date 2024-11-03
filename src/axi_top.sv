module axi_top;

bit aclk,aresetn;
initial begin
	forever #5 aclk=~aclk;
end
initial begin
	aresetn=0;
	repeat(2)@(posedge aclk);
	aresetn=1;
end
	axi_interface intf(aclk,aresetn);
	initial begin
	uvm_config_db#(virtual axi_interface)::set(null,"*","vif",intf);
end
initial begin 
	$display("top");
	run_test("axi_multiple_wr_rd_test");
end
endmodule 
