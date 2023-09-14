class f_monitor extends uvm_monitor;
  virtual f_interface vif;
  seq_item item_got;
  uvm_analysis_port#(seq_item) item_got_port;
  `uvm_component_utils(f_monitor)
  
  function new(string name = "f_monitor", uvm_component parent);
    super.new(name, parent);
    item_got_port = new("item_got_port", this);
  endfunction
  

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_got = seq_item::type_id::create("item_got");
    if(!uvm_config_db#(virtual f_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Monitor: ", "No vif is found!")
  endfunction
      
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.m_mp.clk)
      if(vif.m_mp.m_cb.i_wren == 1)begin
        $display("\nWR is high");
        item_got.i_wrdata = vif.m_mp.m_cb.i_wrdata;
        item_got.i_wren = 'b1;
        item_got.i_rden = 'b0;
        item_got.o_full = vif.m_mp.m_cb.o_full;
        item_got.o_alm_full=vif.m_mp.m_cb.o_alm_full;
        item_got_port.write(item_got);
      end
      else if(vif.m_mp.m_cb.i_rden == 1)begin
        @(posedge vif.m_mp.clk)
        $display("\nRD is high");
        item_got.o_rddata = vif.m_mp.m_cb.o_rddata;
        item_got.i_rden = 'b1;
        item_got.i_wren = 'b0;
        item_got.o_empty = vif.m_mp.m_cb.o_empty;
        item_got.o_alm_empty=vif.m_mp.m_cb.o_alm_empty;
        item_got_port.write(item_got);
      end
    end
  endtask
endclass

    