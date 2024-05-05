import std/paths
from std/dirs import createDir, dirExists, removeDir
from std/files import fileExists, removeFile
import commonFs

type
  OsFs {.final.} = ref object of FileSystem

proc newOsFs*(): FileSystem =
  result = new(OsFs)

method createDirImpl(self: OsFs, absolutePath: Path): Dir =
  try:
    createDir(absolutePath)
    return self.getDirHandle(absolutePath)
  except ValueError as e:
    raise newException(InvalidPathError, "couldn't create directory handle due to invalid path: " & e.msg, e)
  except OSError as e:
    raise newException(FileSystemError, e.msg, e)
  except IOError as e:
    raise newException(FileSystemError, e.msg, e)

method dirExistsImpl(self: OsFs, absolutePath: Path): bool =
  return dirExists(absolutePath)

method removeDirImpl(self: OsFs, absolutePath: Path) =
  try:
    removeDir(absolutePath)
  except OSError as e:
    raise newException(FileSystemError, e.msg, e)

method createFileImpl(self: OsFs, absolutePath: Path): commonFs.File =
  try:
    open(absolutePath.string, fmWrite).close()
    return self.getFileHandle(absolutePath)
  except ValueError as e:
    raise newException(InvalidPathError, "couldn't create file handle due to invalid path: " & e.msg, e)
  except OSError as e:
    raise newException(FileSystemError, e.msg, e)
  except IOError as e:
    raise newException(FileSystemError, e.msg, e)

method fileExistsImpl(self: OsFs, absolutePath: Path): bool =
  return fileExists(absolutePath)

method removeFileImpl(self: OsFs, absolutePath: Path) =
  try:
    removeFile(absolutePath)
  except OSError as e:
    raise newException(FileSystemError, e.msg, e)