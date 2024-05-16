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