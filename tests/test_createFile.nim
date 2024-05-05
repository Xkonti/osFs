import std/unittest
import std/paths
import std/dirs
import commonFs
from osFs import newOsFs

suite "OsFs.createFile":
  let testDirPath = getCurrentDir() / "./temp/testDirs/createFileTests".Path
  var fs: FileSystem

  setup:
    createDir(testDirPath)
    fs = newOsFs()

  teardown:
    removeDir(testDirPath, false)

  test "should create a file with the given absolute path":
    let pathRelative = "testFile1.txt".Path
    let pathAbsolute = testDirPath / pathRelative
    let file = fs.createFile pathAbsolute
    check fs.fileExists pathAbsolute
    check file.absolutePath == pathAbsolute
    check file.exists

  test "should create a file with the given relative path":
    let pathRelative = "testFile2.txt".Path
    let pathAbsolute = testDirPath / pathRelative
    fs.currentDir = testDirPath
    let file = fs.createFile pathRelative
    check fs.fileExists pathAbsolute
    check file.absolutePath == pathAbsolute
    check file.exists

  test "should throw an error if a directory with the same name exists":
    let pathRelative = "testFile3".Path
    let pathAbsolute = testDirPath / pathRelative
    createDir(pathAbsolute)
    expect CatchableError:
      fs.createFile(pathAbsolute)

  test "should not throw an error if a file with the same name exists":
    let pathRelative = "testFile4.txt".Path
    let pathAbsolute = testDirPath / pathRelative
    open(pathAbsolute.string, fmWrite).close()
    let file = fs.createFile(pathAbsolute)
    check fs.fileExists(pathAbsolute)
    check file.absolutePath == pathAbsolute

  test "should throw an error if parent directory does not exist":
    let pathRelative = "/missin/testFile5.txt".Path
    let pathAbsolute = testDirPath / pathRelative
    expect CatchableError:
      fs.createFile(pathAbsolute)