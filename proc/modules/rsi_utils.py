import logging
import os.path

# Check if the path is a child or subchild of the parent
def path_is_parent(parentPath, childPath) :
  parentPath = os.path.abspath(parentPath)
  childPath = os.path.abspath(childPath)

  return os.path.commonpath([parentPath]) == os.path.commonpath([parentPath, childPath])

# Sets up the logger
def init_logger(debug, logFile) :
  logger = logging.getLogger()
  if (debug) :
    logLevel = logging.DEBUG
  else :
    logLevel = logging.INFO

  logger.setLevel(logLevel)

  formatter = logging.Formatter("%(levelname)s - %(message)s")

  consoleHandler = logging.StreamHandler()
  consoleHandler.setLevel(logLevel)
  consoleHandler.setFormatter(formatter)
  logger.addHandler(consoleHandler)

  fileHandler = logging.FileHandler(os.path.join('.', logFile), "w", encoding=None)
  fileHandler.setLevel(logLevel)
  fileHandler.setFormatter(formatter)
  logger.addHandler(fileHandler)

  logging.debug("DEBUG Logging Enabled!")

