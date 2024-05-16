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