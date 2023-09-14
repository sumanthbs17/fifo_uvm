class f_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(seq_item, f_scoreboard) item_got_export;
  `uvm_component_utils(f_scoreboard)
  
  function new(string name = "f_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  bit [127:0] queue[$];
  
  function void write(input seq_item item_got);
    bit [127:0] examdata;
    if(item_got.i_wren == 'b1)begin
      queue.push_back(item_got.i_wrdata);
      `uvm_info("write Data", $sformatf("wr: %0b rd: %0b data_in: %0d full: %0b",item_got.i_wren, item_got.i_rden,item_got.i_wrdata, item_got.o_full), UVM_LOW);
    end
    else if (item_got.i_rden == 'b1)begin
      if(queue.size() >= 'd1)begin
        examdata = queue.pop_front();
        `uvm_info("Read Data", $sformatf("examdata: %0d data_out: %0d empty: %0b", examdata, item_got.o_rddata, item_got.o_empty), UVM_LOW);
        if(examdata == item_got.o_rddata)begin
          $display("-------- 		Pass! 		--------");
        end
        else begin
          $display("--------		Fail!		--------");
          $display("--------		Check empty	--------");
        end
      end
    end
  endfunction
endclass
       