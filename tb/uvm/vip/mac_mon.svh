`ifndef MAC_MON_SVH
`define MAC_MON_SVH

class mac_monitor extends uvm_monitor;

  uvm_analysis_port #(monitor_item) ap;
  `uvm_component_utils(mac_monitor)

  virtual mac_if mif;

  function new(string name= "mac_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
    
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db #(virtual mac_if)::get(this, "", "vif", mif)) begin
      `uvm_fatal(get_full_name(), "No virtual interface found");
    end
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info("MON","Monitor data",UVM_HIGH)
    forever begin    
      monitor_item tr = monitor_item::type_id::create("tr", this);
      @(mif.pck);
      tr.a = mif.pck.a;
      tr.b = mif.pck.b;
      tr.c = mif.pck.c;
      tr.en = mif.pck.en;
      tr.vld = mif.pck.vld;
      tr.rd = mif.pck.rd;
      tr.mode = mif.pck.mode;
      tr.cfg = mif.pck.cfg;
      ap.write(tr);
    end
  endtask

endclass

`endif  /* MAC_MON_SVH */
