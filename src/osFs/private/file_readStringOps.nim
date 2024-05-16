method readStringAllImpl(self: OsFs, absolutePath: Path): string =
  try:
    return readFile(absolutePath.string)
  except IOError as e:
    raise newException(FileSystemError, e.msg, e)


method readStringBufferImpl(self: OsFs, absolutePath: Path, buffer: var string, start: int64, length: int64): int =
  try:
    let file = open(absolutePath.string, fmRead)
    defer: close(file)
    file.setFilePos start, fspSet
    var bytesBuffer = newSeq[byte](length)
    let bytesRead = readBytes(file, bytesBuffer, 0, length)
    buffer.setLen 0
    for i in 0 ..< bytesRead:
      buffer.add char bytesBuffer[i]
    return bytesRead
  except IOError as e:
    raise newException(FileSystemError, e.msg, e)


method getStringBufferedIteratorImpl(self: OsFs, absolutePath: Path, buffer: var string, start: int64, length: int64): StringBufferedIterator =
  iterator buffIterator(buffer: var string): int {.closure.} =
    try:
      let file = open(absolutePath.string, fmRead)
      defer: close(file)
      file.setFilePos start, fspSet
      # TODO: How to get rid of the buffer allocation here?
      var bytesBuffer = newSeq[byte](length)
      while true:
        let bytesRead = readBytes(file, bytesBuffer, 0, length)
        buffer.setLen 0
        if bytesRead == 0:
          break
        for i in 0 ..< bytesRead:
          buffer.add char bytesBuffer[i]
        yield bytesRead
    except IOError as e:
      raise newException(FileSystemError, e.msg, e)

  return buffIterator