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