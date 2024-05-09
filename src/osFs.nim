import std/paths
from std/dirs import createDir, dirExists, removeDir
from std/files import fileExists, removeFile
import commonFs
from std/syncio import readBytes, open, close

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

method readAllImpl(self: OsFs, absolutePath: Path): string =
  try:
    return readFile(absolutePath.string)
  except IOError as e:
    raise newException(FileSystemError, e.msg, e)

method readBytesImpl(self: OsFs, absolutePath: Path): seq[byte] =
  try:
    let file = open(absolutePath.string, fmRead)
    defer: close(file)
    const bufferSize = 1024
    var buffer: array[bufferSize, byte]
    var cursor: Natural = 0

    # Read the file in chunks into the result sequence
    while true:
      let bytesRead = readBytes(file, buffer, cursor, bufferSize)
      result.add(buffer[0 ..< bytesRead])
      if bytesRead != bufferSize:
        break
      cursor += bufferSize
  except IOError as e:
    raise newException(FileSystemError, e.msg, e)

method writeImpl(self: OsFs, absolutePath: Path, content: varargs[string, `$`]) =
  var text = ""
  for value in content:
    text.add value 
  try:
    writeFile(absolutePath.string, text)
  except IOError as e:
    raise newException(FileSystemError, e.msg, e)