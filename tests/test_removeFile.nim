import std/unittest
import std/paths
import std/dirs
import commonFs
from osFs import newOsFs

suite "OsFs.removeFile":
  let testDirPath = getCurrentDir() / "./temp/testDirs/removeFileTests".Path
  var fs: FileSystem

  setup:
    createDir(testDirPath)
    fs = newOsFs()

  teardown:
    removeDir(testDirPath, false)

  test "should remove a file using an absolute path":
    let pathRelative = "testFile1.jpg".Path
    let pathAbsolute = testDirPath / pathRelative
    let file1 = fs.createFile pathAbsolute
    check file1.exists
    fs.removeFile pathAbsolute
    check not file1.exists

    let file2 = fs.createFile pathAbsolute
    check file2.exists
    file2.remove
    check not file2.exists

  test "should remove a file using a relative path":
    let pathRelative = "testFile2.jpg".Path
    let pathAbsolute = testDirPath / pathRelative
    fs.currentDir = testDirPath
    let file1 = fs.createFile pathRelative
    check file1.exists
    fs.removeFile pathRelative
    check not file1.exists

    let file2 = fs.createFile pathRelative
    check file2.exists
    file2.remove
    check not file2.exists

  test "should not throw an error if the file does not exist":
    let pathRelative = "testFile3.jpg".Path
    let pathAbsolute = testDirPath / pathRelative
    fs.removeFile pathAbsolute
    fs.currentDir = testDirPath
    fs.removeFile pathRelative
    let file = fs.getFileHandle pathAbsolute
    file.remove

  test "should throw an error if the path points to a directory":
    let pathRelative = "testDir1".Path
    let pathAbsolute = testDirPath / pathRelative
    fs.createDir pathAbsolute
    
    expect CatchableError:
      fs.removeFile pathAbsolute
    
    let file = fs.getFileHandle pathAbsolute
    expect CatchableError:
      file.remove