import os
import json
import logging
import sys

class CompileNode :
  
  node_list = {}

  def __init__(self, root_compile, board) :
    root_path = os.path.abspath(root_compile)

    self.board = board
    self.options = {}
    self.node_info = {}
    self.root_path = root_path

    logging.info(f"Parsing compile node: {root_path}")

    if (root_path in CompileNode.node_list) :
      logging.debug(f"Compile Node: {root_path} already generated")
    else :
      CompileNode.node_list[root_path] = self.parse_node()
      logging.debug(f"Node: {self}")

  def parse_node(self) :
    with open(self.root_path, "r") as f :
      node_data = json.load(f)
      logging.debug(f"Analyzing Compile Node: {self.root_path}")

    # Check the node is a fileset
    if (node_data["type"] != "fileset") :
      logging.error(f"Trying to add compile file with type: {node_data['type']}")

    # Check if the board specific values should be used
    #   if not check that the generic setting exists
    if (self.board in node_data) :
      compileGroup = [self.board]
    elif ("generic" in node_data) :
      compileGroup = node_data["generic"]
    else :
      logging.error(f"Unable to parse node {self}, does not contain generic compileGroup")

    # Parse over the needs option if present
    if ("needs" in compileGroup) :
      self.options["nodes"] = []
      for needPth in compileGroup["needs"] :
        # Set the path to the needs compile file
        needPth = CompileNode.normalize_path(needPth, self.root_path)
        
        # Create the new needed node
        tNode = CompileNode(needPth, self.board)

        # Add the new node to the current node's need list if not already present
        if (tNode.get_root_path() in self.options["nodes"]) :
          logging.warning(f"{tNode.get_root_path()} present twice in needs list of {self.root_path}")
        else :
          self.options["nodes"].append(tNode.get_root_path())
  
    # Parse over the source option if present
    if ("src" in compileGroup) :
      self.options["src"] = []
      for srcPth in compileGroup["src"] :
        # Set the path to the source file
        srcPth = CompileNode.normalize_path(srcPth, self.root_path)

        # Add the source to the current node's src list if not already present
        if (srcPth in self.options["src"]) :
          logging.warning(f"{srcPth} present twice in src list of {self.root_path}")
        else :
          self.options["src"].insert(0, srcPth)

    return self

  # Get the root path
  def get_root_path(self) :
    return self.root_path

  # Get the options of the node
  def get_options(self) :
    return self.options

  # Displays a list of the nodes
  def disp_node_list(self) :
    for key in CompileNode.node_list :
      logging.info(CompileNode.node_list[key])

  # Get the dictionary containing the compileNodes
  @staticmethod
  def get_node_list() :
    return CompileNode.node_list

  # Return string representation
  def __str__(self) :
    retStr = ""
    retStr += f"CompileNode: {self.root_path}\n"
    for key in self.options :
      retStr += f"\t{{{key}}}: {self.options[key]}\n"
    return retStr

  def __repr__(self) :
    return f"{self.root_path}: {self.options}"

  @staticmethod
  def normalize_path(path, root) :
    """
    Normalizes the path within the project environment and with repsect to the current node
    """
    if (path.startswith("$(BASE_DIR)")):
      path = path.replace("$(BASE_DIR)", os.environ['BASE_DIR'])
    elif (path.startswith("./")) :
      path =  os.path.dirname(root) + "/" + path[2:]
    elif (not path.startswith("/")) :
      path = os.path.dirname(root) + "/" + path
    
    return path
