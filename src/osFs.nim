import std/paths
from std/dirs import createDir, dirExists, removeDir
from std/files import fileExists, removeFile
from std/syncio import readBytes, open, close, setFilePos, FileSeekPos

import commonFs

type
  OsFs {.final.} = ref object of FileSystem

proc newOsFs*(): FileSystem =
  result = new(OsFs)

#[
  DIRECTORY OPERATIONS
]#
include osFs/private/dir_basicOps

#[
  FILE OPERATIONS
]#

include osFs/private/file_basicOps
include osFs/private/file_readStringOps
include osFs/private/file_readBytesOps
include osFs/private/file_writeStringOps
include osFs/private/file_writeBytesOps