method writeImpl(self: OsFs, absolutePath: Path, content: varargs[string, `$`]) =
  var text = ""
  for value in content:
    text.add value 
  try:
    writeFile(absolutePath.string, text)
  except IOError as e:
    raise newException(FileSystemError, e.msg, e)