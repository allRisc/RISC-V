from filelist_builders_pkg.compile_node import CompileNode

import logging

class VivadoFilelistGen :

  def __init__(self, filelist="filelist.tcl", nodelist="node_json_list.mk") :
    self.filelist = filelist
    self.nodelist = nodelist

  def generate(self, root_compile, board):
    compTree = CompileNode(root_compile, board)
    
    logging.info("=== NODE LIST ===")
    compTree.disp_node_list()

    node_list = CompileNode.get_node_list()

    self.gen_filelist(node_list)
    self.gen_node_json_list(node_list)

  def gen_filelist(self, node_list):
    fileLines =  []
    
    for node in node_list :
      opts = node_list[node].get_options()
      if "src" in opts :
        for srcFile in opts["src"] :
          fileLines.append(VivadoFilelistGen.gen_file_cmd(srcFile))

    with open(self.filelist, "w") as f :
      f.writelines(fileLines)

  def gen_node_json_list(self, node_list):
    nodeJsonList = f"node_json_list="
    for node in node_list :
      nodeJsonList += f"{node} "
    
    with open(self.nodelist, "w") as f :
      f.write(nodeJsonList[:-1])


  @staticmethod
  def gen_file_cmd(filename) :
    root_ext = os.path.splittext(filename)

    if (root_ext[1] == ".sv") :
      return f"read_verilog -sv {filename}"
    elif (root_ext[1] == ".v") :
      return f"read_verilog {filename}"
    elif (root_ext[1] == ".vhdl") :
      return f"read_vhdl {filename}"
    elif (root_ext[1] == ".xdc") :
      return f"read_xdc {filename}"
    elif (root_ext[1] == ".xci") :
      return f"read_ip {filename}"
    else :
      logging.error(f"Unsupported filetype: {root_ext} for {filename}")
    
    return None
    
