class f_sequencer extends uvm_sequencer#(seq_item);
  `uvm_component_utils(f_sequencer)
  
  function new(string name = "f_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass